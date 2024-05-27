const std = @import("std");
const mach = @import("mach");
const build_options = @import("build_options");

pub const use_sysgpu = build_options.use_sysgpu;
pub const SYSGPUInterface = mach.sysgpu.Impl;

pub const modules = .{
    mach.Core,
    @import("Game.zig"),
    @import("Renderer.zig"),
    @import("Object.zig"),
    @import("Light.zig"),
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
