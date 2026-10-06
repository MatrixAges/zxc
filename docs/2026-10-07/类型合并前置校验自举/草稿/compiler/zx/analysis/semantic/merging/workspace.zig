const std = @import("std");
const ir = @import("zx").ir;

pub const Result = struct {
    origins: []?usize = &.{},
    mapping: []ir.TypeId = &.{},
};

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
result: Result = .{},
