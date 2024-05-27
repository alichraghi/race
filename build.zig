const std = @import("std");
const mach = @import("mach");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mach_dep = b.dependency("mach", .{ .target = target, .optimize = optimize });
    const model3d_dep = b.dependency("model3d", .{ .target = target, .optimize = optimize });
    const zigimg_dep = b.dependency("zigimg", .{ .target = target, .optimize = optimize });

    const use_sysgpu = b.option(bool, "use_sysgpu", "Use sysgpu") orelse false;
    const build_options = b.addOptions();
    build_options.addOption(bool, "use_sysgpu", use_sysgpu);

    const exe = b.addExecutable(.{
        .name = "car_race",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("build_options", build_options.createModule());
    exe.root_module.addImport("mach", mach_dep.module("mach"));
    exe.root_module.addImport("model3d", model3d_dep.module("mach-model3d"));
    exe.root_module.addImport("zigimg", zigimg_dep.module("zigimg"));
    b.installArtifact(exe);

    exe.linkLibrary(model3d_dep.artifact("mach-model3d"));
    mach.link(b, exe);
    mach.addPaths(&exe.root_module);

    const run = b.addRunArtifact(exe);
    if (b.args) |args| run.addArgs(args);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run.step);
}
