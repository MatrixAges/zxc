const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const Trace = @import("../../iteration_buffer/ownership/allocation/trace.zig");
const flow = @import("../analysis/flow.zig");
pub const Paths = []const []const u32;

pub const Facts = struct {
    program: ir.Program,
    pure: []const bool,
    allocated: []const bool,
};

pub fn outputs(allocator: std.mem.Allocator, program: ir.Program, pure: []const bool) std.mem.Allocator.Error![]const Paths {
    const allocated = try @import("../../iteration_buffer/ownership/allocation.zig").functions(allocator, program, pure);
    const facts = Facts{ .program = program, .pure = pure, .allocated = allocated };
    const result = try allocator.alloc(Paths, program.functions.count());

    for (result, 0..) |*selected, index| {
        selected.* = try paths(facts, allocator, @fromBackingInt(@intCast(index)));
    }

    return result;
}

pub fn paths(facts: Facts, allocator: std.mem.Allocator, id: ir.FunctionId) std.mem.Allocator.Error!Paths {
    const index = @backingInt(id);
    const function = facts.program.functions.at(index);

    if (!facts.pure[index] or function.external != null or function.contracts.count() != 0) return &.{};
    if (!product(facts.program, function.output_type)) return &.{};

    var fields: std.ArrayList([]const u32) = .empty;

    try flow.leaves(allocator, facts.program, function.output_type, &.{}, false, &fields);
    if (fields.items.len == 0) return &.{};

    var program = facts.program;

    program.symbols = function.symbols;
    program.expressions = function.expressions;
    program.body = function.body;
    const results = function.body.control.results;

    if (results.len == 0) return &.{};

    const graph = try Graph.create(allocator, program);
    var used: std.AutoHashMapUnmanaged(ir.ExprId, void) = .empty;

    for (fields.items) |field| {
        const path = try allocator.alloc(usize, field.len);

        for (field, path) |part, *wide| wide.* = part;

        var origins: std.AutoHashMapUnmanaged(ir.ExprId, void) = .empty;
        var trace = Trace{ .allocator = allocator, .program = program, .bindings = graph.bindings, .functions = facts.allocated, .allocations = &origins };

        for (results) |result| {
            const returned = result orelse return &.{};

            if (!try trace.check(@fromBackingInt(returned), path, 0)) return &.{};
        }

        if (origins.count() == 0) return &.{};

        var allocations = origins.keyIterator();

        while (allocations.next()) |allocation| {
            if (used.contains(allocation.*)) return &.{};
            try used.put(allocator, allocation.*, {});
        }
    }

    return fields.items;
}

pub fn product(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list => |child| flow.detached(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!product(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!product(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => flow.detached(program, id),
    };
}
