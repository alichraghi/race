const mach = @import("mach");
const Game = @import("Game.zig");
const Object = @import("Object.zig");

pub const modules = .{
    mach.Engine,
    Game,
    Object,
};

pub const App = mach.App;
