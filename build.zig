const std = @import("std");
const mach = @import("mach");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const model3d_dep = b.dependency("model3d", .{ .target = target, .optimize = optimize });
    const zigimg_dep = b.dependency("zigimg", .{ .target = target, .optimize = optimize });
    const ufbx_dep = b.dependency("ufbx", .{ .target = target, .optimize = optimize });

    const app = try mach.App.init(
        b,
        .{
            .name = "car_race",
            .src = "src/main.zig",
            .target = target,
            .optimize = optimize,
            .deps = &.{
                .{ .name = "model3d", .module = model3d_dep.module("mach-model3d") },
                .{ .name = "zigimg", .module = zigimg_dep.module("zigimg") },
            },
            .res_dirs = &.{"assets"},
        },
    );

    app.compile.addIncludePath(ufbx_dep.path(""));
    app.compile.addCSourceFile(.{ .file = ufbx_dep.path("ufbx.c"), .flags = &.{} });
    app.compile.linkLibrary(model3d_dep.artifact("mach-model3d"));
    try app.link();

    if (b.args) |args| app.run.addArgs(args);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&app.run.step);
}
