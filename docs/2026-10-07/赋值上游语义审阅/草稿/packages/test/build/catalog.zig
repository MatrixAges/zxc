const std = @import("std");

pub const RuntimeSuite = struct {
    name: []const u8,
    path: []const u8,
    shared_abi: bool = false,
    sources: []const []const u8 = &.{},
    kind: enum { application_json, predicate_trace, state_update, floating, floating_unary, floating_comparison, floating_ternary, control, collections, optional_selection, string_storage, floating_optional },
};

pub const Suites = struct {
    frontend: []const []const u8,
    runtime: []const RuntimeSuite,
    safety: []const []const u8,
    module_graphs: []const []const u8,
    stores: []const []const u8,
    evaluation_order: []const []const u8,
};

pub fn load(b: *std.Build) Suites {
    const parsed = std.json.parseFromSlice(Suites, b.allocator, @embedFile("../suites.json"), .{}) catch @panic("invalid conformance suite catalog");

    return parsed.value;
}
