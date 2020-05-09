OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

PHDRS
{
    code PT_LOAD FLAGS(7) /* Read | Write | Execute */;
}

SECTIONS
{
    . = 0;

    .text ALIGN(0x4) :
    {
        *(.text*)
    } : code

    .data ALIGN(0x4) :
    {
        *(.data .data.*)
        *(.rodata .rodata.*)
    } : code

    /* This must be before the BSS */
    .ptr ALIGN(0x4) :
    {
        /* This word is recognized by the loader */
        LONG(0xdeadface)
    } : code

    .bss ALIGN(0x4) :
    {
        *(.bss .bss.*)
        *(COMMON)
    } : code

    /DISCARD/ : { *(.group .comment .note .debug_* .ARM.*) }
}
