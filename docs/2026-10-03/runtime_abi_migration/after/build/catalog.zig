const std = @import("std");

pub const RuntimeSuite = struct {
    name: []const u8,
    path: []const u8,
    shared_abi: bool = false,
    kind: enum { floating, floating_unary, floating_comparison, floating_ternary, control, collections },
};

pub const Suites = struct {
    frontend: []const []const u8,
    runtime: []const RuntimeSuite,
    safety: []const []const u8,
    module_graphs: []const []const u8,
    stores: []const []const u8,
};

pub fn load(b: *std.Build) Suites {
    const parsed = std.json.parseFromSlice(Suites, b.allocator, @embedFile("../suites.json"), .{}) catch @panic("invalid conformance suite catalog");

    return parsed.value;
}
