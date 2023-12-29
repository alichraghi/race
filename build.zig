const std = @import("std");
const mach = @import("mach");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // const mach_dep = b.dependency("mach", .{ .target = target, .optimize = optimize });
    // const mach_core_dep = b.dependency("mach_core", .{ .target = target, .optimize = optimize });
    // const app = try mach_core.App.init(b, mach_core_dep.builder, .{
    //     .name = "myapp",
    //     .src = "src/main.zig",
    //     .target = target,
    //     .optimize = optimize,
    //     .deps = &[_]std.build.ModuleDependency{
    //         .{ .name = "mach", .module = mach_dep.module("mach") },
    //     },
    // });

    const app = try mach.App.init(
        b,
        .{
            .name = "car_race",
            .src = "src/main.zig",
            .target = target,
            .optimize = optimize,
            .deps = &.{},
        },
    );
    try app.link();
    if (b.args) |args| app.run.addArgs(args);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&app.run.step);
}
