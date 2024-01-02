const mach = @import("mach");
const Game = @import("Game.zig");
const Object = @import("Object.zig");

pub const modules = .{
    mach.Engine,
    Object,
    Game,
};

pub const App = mach.App;
