import sys
import struct

from elftools.elf.elffile import ELFFile
from elftools.elf.relocation import RelocationSection
from elftools.elf.enums import ENUM_RELOC_TYPE_ARM

def process_file(filename):
    print('Processing file:', filename)
    with open(filename, 'rb') as f:
        elffile = ELFFile(f)

        # The provided linkerscript sorts the sections in the appropriate order
        assert(elffile.num_segments() == 1)
        segment = elffile.get_segment(0)

        symtab = elffile.get_section_by_name('.symtab')

        # A table of exported callbacks where each entry is made of two u32
        # values, the first is the event ID and the second is the address of the
        # callback function
        exports_sym = symtab.get_symbol_by_name('Exports')[0]

        exports_addr = exports_sym['st_value']
        exports_size = exports_sym['st_size']
        assert((exports_addr & 3) == 0)
        assert((exports_size & 7) == 0)

        # The text and data sections are merged together, the bss is allocated
        # and zeroed by the loader. The 4 takes into account the extra pointer
        # to the application class that's inserted by the loader.
        code_size = segment['p_filesz'] - 4
        bss_size = segment['p_memsz'] - code_size

        # Address of the funalizer function
        finish_sym = symtab.get_symbol_by_name('_finish')[0]
        finish_addr = finish_sym['st_value']

        asset0 = struct.pack('<16I',
                0x1000,             # Fixed?
                1,                  # Version
                code_size,          # Code + Data size
                0,                  # Same but for libs
                4,                  # Space for the Klass pointer
                bss_size,           # Size of the zeroed area
                code_size,          # Offset for the Klass pointer
                exports_addr,       # Offset for the exports array
                0xffffffff,         # Same but for libs
                0xffffffff,         # Init array start
                0xffffffff,         # Fini array start
                0,                  # Init array len (in words)
                0,                  # Fini array len (in words)
                elffile['e_entry'], # Entry point
                finish_addr,        # Exit point
                0x2B0B3ED5)         # Used to check if the .sig file is valid

        # Make it writable, we may perform some modification later
        asset1 = bytearray(segment.data())

        reloc_offsets = []
        reloc_sections = [sect for sect in elffile.iter_sections()
                if isinstance(sect, RelocationSection)]

        # The only relocation performed by the loader is adding the address
        # where the app is loaded to a whole u32
        for rel_section in reloc_sections:
            for reloc in rel_section.iter_relocations():
                ty = reloc['r_info_type']
                # Make sure it's not STN_UNDEF
                assert(reloc['r_info_sym'] != 0)

                if ty == ENUM_RELOC_TYPE_ARM['R_ARM_ABS32']:
                    reloc_offsets.append(reloc['r_offset'])
                elif ty == ENUM_RELOC_TYPE_ARM['R_ARM_REL32'] or \
                        ty == ENUM_RELOC_TYPE_ARM['R_ARM_CALL']:
                    # Already PC-independent
                    pass
                else:
                    raise RuntimeError('Unknown relocation type!')

        # Terminates the list
        reloc_offsets.append(0xffffffff)

        asset2 = struct.pack('<IIII', 1, len(reloc_offsets) - 1,
                16 + len(reloc_offsets) * 4, 0xf0123456)
        for off in reloc_offsets:
            asset2 += struct.pack('<I', off)

        # The key file is simply chopped, shuffled and hashed with SHA1 together
        # with the "magic" word at 0x3c in the asset0.
        with open(filename + '.sig', 'w+b') as out:
            header = struct.pack('<II',
                            0x1000, # Fixed ?
                            8)      # Key slot
            out.write(header)
            out.write(b'\x63\x9a\x83\xa1\x99\x4b\xfb\x42\x56\xd4\x5e\x44\x2a\x90\x2a\x35')
            out.write(b'\xf5\xd5\xdc\xef\xb9\x80\x90\x3d\x80\x33\x94\x5f\x54\x6c\xcc\x9a')
            out.write(b'\xe8\xa7\xad\xf7\xe0\x22\x3d\x1e\x59\x30\x38\x3a\x4d\x30\x39\x3a')
            out.write(b'\x44\x30\x31\x3a\x54\x30\x39\x3a\x30\x30\xe3\xd1\xa5\xca\xbc\x94')
            out.write(b'\x75\xd1\x0c\x79\x70\x03\x1b\x10\x33\x50\x31\xad\x79\xbc')

        with open(filename + '.aab', 'w+b') as out:
            out.write(b'ABHS')
            header = struct.pack('<3I',
                    0x1000, # Fixed ?
                    0x10,   # Application type
                    3)      # Number of assets
            out.write(header)

            off = 16 + 3 * 12
            for i, asset in enumerate([asset0, asset1, asset2]):
                entry = struct.pack('<3I', i, len(asset), off)
                off += len(asset)
                out.write(entry)

            out.write(asset0)
            out.write(asset1)
            out.write(asset2)

if __name__ == '__main__':
    for filename in sys.argv[1:]:
        process_file(filename)
