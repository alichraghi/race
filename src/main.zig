const std = @import("std");
const mach = @import("mach");
const build_options = @import("build_options");

pub const mach_core_options = mach.core.ComptimeOptions{
    .use_wgpu = !build_options.use_sysgpu,
    .use_sysgpu = build_options.use_sysgpu,
};

pub const SYSGPUInterface = mach.sysgpu.Impl;

pub const modules = .{
    mach.Core,
    @import("Object.zig"),
    @import("Light.zig"),
    @import("Game.zig"),
};

pub fn main() !void {
    if (build_options.use_sysgpu) {
        // TODO: Remove this line.
        // in Core.zig, sysgpu is initialized with an unitialized allocator
        mach.core.allocator = std.heap.page_allocator;
    }

    try mach.core.initModule();
    while (try mach.core.tick()) {}
}
