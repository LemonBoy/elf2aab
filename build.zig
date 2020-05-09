const std = @import("std");
const builtin = @import("builtin");
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    b.setPreferredReleaseMode(.Debug);
    const mode = b.standardReleaseOptions();

    const main = b.addExecutable("main.elf", "main.zig");
    // main.addPackagePath("common", "common/common.zig");
    // main.link_function_sections = true;
    main.force_pic = true;
    main.setBuildMode(mode);
    main.setOutputDir("zig-cache");
    main.setLinkerScriptPath("plugin.ld");
    main.setTarget(.{
        .cpu_arch = .arm,
        .os_tag = .freestanding,
        .abi = .none,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm9e },
    });

    const aab_file = b.addSystemCommand(&[_][]const u8{
        "python3",
        "elf2aab.py",
        main.getOutputPath(),
    });
    aab_file.step.dependOn(&main.step);

    b.default_step.dependOn(&aab_file.step);
}
