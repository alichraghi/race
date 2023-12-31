const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const zm = @import("zmath.zig");
const Vec = zm.Vec;
const Mat = zm.Mat;
const Quat = zm.Quat;

pub const name = .object;
pub const Mod = mach.Mod(@This());

pub const components = struct {
    pub const transform = Mat;
};
