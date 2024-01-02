const Model = @import("Model.zig");

pub const cube = [_]Model.Vertex{
    .{ .position = .{ 1, -1, 1 }, .color = .{ 0, 1, 0.7 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 1, 0.7 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 0, 1, 0.7 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 0, 1, 0.7 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 0, 1, 0.7 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 0, 1, 0.7 } },

    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },

    .{ .position = .{ -1, 1, 1 }, .color = .{ 0.7, 0.7, 1 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 0.7, 0.7, 1 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 0.7, 0.7, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0.7, 0.7, 1 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 0.7, 0.7, 1 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 0.7, 0.7, 1 } },

    .{ .position = .{ -1, -1, 1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 1, 1, 0 } },

    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 0, 1 } },

    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 1, 1, 1 } },
};
