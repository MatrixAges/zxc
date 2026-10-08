const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const Trace = @import("../../iteration_buffer/ownership/allocation/trace.zig");
const flow = @import("../analysis/flow.zig");

pub const Facts = struct {
    program: ir.Program,
    pure: []const bool,
    allocated: []const bool,
};

pub fn outputs(allocator: std.mem.Allocator, program: ir.Program, pure: []const bool) std.mem.Allocator.Error![]const ?u32 {
    const allocated = try @import("../../iteration_buffer/ownership/allocation.zig").functions(allocator, program, pure);
    const facts = Facts{ .program = program, .pure = pure, .allocated = allocated };
    const result = try allocator.alloc(?u32, program.functions.count());

    @memset(result, null);

    for (result, 0..) |*selected, index| {
        const function = program.functions.at(index);
        const output = program.typeOf(function.output_type);

        const count = switch (output) {
            .object => output.object.len,
            .tuple => output.tuple.len,
            else => continue,
        };

        for (0..count) |field| {
            const type_id = if (output == .object) output.object.at(field).type_id else output.tuple.at(field);

            if (program.typeOf(type_id) != .list) continue;
            if (!try check(facts, allocator, @fromBackingInt(@intCast(index)), field)) continue;

            selected.* = @intCast(field);

            break;
        }
    }

    return result;
}

pub fn check(facts: Facts, allocator: std.mem.Allocator, id: ir.FunctionId, field: usize) std.mem.Allocator.Error!bool {
    const index = @backingInt(id);
    const function = facts.program.functions.at(index);

    if (!facts.pure[index] or function.external != null or function.contracts.count() != 0) return false;

    const output = facts.program.typeOf(function.output_type);

    const count = switch (output) {
        .object => output.object.len,
        .tuple => output.tuple.len,
        else => return false,
    };

    for (0..count) |position| {
        const type_id = if (output == .object) output.object.at(position).type_id else output.tuple.at(position);

        if (position == field) {
            const selected = facts.program.typeOf(type_id);

            if (selected != .list or !flow.detached(facts.program, selected.list)) return false;
        } else if (!flow.detached(facts.program, type_id)) return false;
    }

    var program = facts.program;

    program.symbols = function.symbols;
    program.expressions = function.expressions;
    program.body = function.body;
    const graph = try Graph.create(allocator, program);
    var trace = Trace{ .allocator = allocator, .program = program, .bindings = graph.bindings, .functions = facts.allocated };
    const results = function.body.control.results;

    if (results.len == 0) return false;

    for (results) |result| {
        const returned = result orelse return false;

        if (!try trace.check(@fromBackingInt(returned), &.{field}, 0)) return false;
    }

    return true;
}
