const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const may = @import("may.zig");
const Error = std.mem.Allocator.Error;
pub const Proof = struct { iteration: ir.ExprId, origin: []const u32 };

pub fn parameter(trace: *Trace, symbol: ir.SymbolId, origin: []const u32) Error!bool {
    const id = trace.iterations[@backingInt(symbol)] orelse return false;

    for (trace.assumptions.items) |proof| {
        if (matches(proof, id, origin)) return true;
    }

    return prove(trace, id, origin);
}

pub fn prove(trace: *Trace, id: ir.ExprId, origin: []const u32) Error!bool {
    for (trace.proven.items) |proof| {
        if (matches(proof, id, origin)) return true;
    }

    const iteration = trace.function.expressions.at(@backingInt(id)).value.iteration;

    if (try may.contains(trace, iteration.initial, &.{}, origin)) return false;

    const depth = trace.assumptions.items.len;

    try trace.assumptions.append(trace.allocator, .{ .iteration = id, .origin = origin });

    defer trace.assumptions.shrinkRetainingCapacity(depth);

    if (try may.contains(trace, iteration.body, &.{}, origin)) return false;

    if (depth == 0) try trace.proven.append(trace.allocator, .{
        .iteration = id,
        .origin = try trace.allocator.dupe(u32, origin),
    });

    return true;
}

fn matches(proof: Proof, id: ir.ExprId, origin: []const u32) bool {
    return proof.iteration == id and std.mem.eql(u32, proof.origin, origin);
}
