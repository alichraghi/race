const mach = @import("mach");
const Game = @import("Game.zig");

pub const modules = .{
    mach.Engine,
    Game,
};

pub const App = mach.App;
