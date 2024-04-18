const mach = @import("mach");

pub const modules = .{
    mach.Core,
    @import("Object.zig"),
    @import("Light.zig"),
    @import("Game.zig"),
};

pub fn main() !void {
    try mach.core.initModule();
    while (try mach.core.tick()) {}
}
