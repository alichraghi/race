const mach = @import("mach");
const Game = @import("Game.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");

pub const modules = .{
    mach.Engine,
    Object,
    Light,
    Game,
};

pub const App = mach.App;
