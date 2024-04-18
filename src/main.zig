const mach = @import("mach");
const Game = @import("Game.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");

pub const modules = .{
    mach.Core,
    Camera,
    Object,
    Light,
    Game,
};

pub fn main() !void {
    // Initialize mach.Core
    try mach.core.initModule();

    // Main loop
    while (try mach.core.tick()) {}
}
