const std = @import("std");
const ir = @import("zx").ir;
const Order = @import("../order.zig");
const Seed = @import("seed.zig");

pub fn build(allocator: std.mem.Allocator, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.Block) std.mem.Allocator.Error!Order {
    const seed = try Seed.create(allocator, symbols, expressions, body);

    return .{
        .nodes = {},
        .regions = {},
        .edges = {},
        .definitions = {},
        .def_loop = {},
        .results = seed.results.items,
        .repeated = seed.repeated.items,
        .repeated_parent = seed.repeated_parent.items,
        .concurrent = seed.concurrent.items,
        .seed = seed,
    };
}
