const mach = @import("mach");
const Game = @import("Game.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");

pub const modules = .{
    mach.Engine,
    Camera,
    Object,
    Light,
    Game,
};

pub const App = mach.App;
