const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("graph.zig");
const Trace = @import("allocation/trace.zig");

pub fn functions(allocator: std.mem.Allocator, program: ir.Program, pure: []const bool) std.mem.Allocator.Error![]const bool {
    const result = try allocator.alloc(bool, program.functions.count());

    @memset(result, false);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        if (function.external != null or !pure[index] or program.typeOf(function.output_type) != .list) continue;

        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        var selected = program;
        selected.input_type = function.input_type;
        selected.output_type = function.output_type;
        selected.symbols = function.symbols;
        selected.expressions = function.expressions;
        selected.body = function.body;
        const graph = try Graph.create(arena.allocator(), selected);
        var trace = Trace{ .allocator = arena.allocator(), .program = selected, .bindings = graph.bindings, .functions = result[0..index] };
        const returns = function.body.control.results;
        var valid = returns.len != 0;

        for (returns) |returned| {
            if (returned) |id| {
                if (!try trace.check(@fromBackingInt(id), &.{}, 0)) valid = false;
            } else valid = false;
        }

        result[index] = valid;
    }

    return result;
}
