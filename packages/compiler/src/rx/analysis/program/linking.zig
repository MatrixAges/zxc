const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("builder.zig");
const enabled = @import("rx_options").generated_graph;
pub const missing = std.math.maxInt(u32);

pub const Plan = struct {
    returned: ir.ExprId,
    rows: []const u32,
    bindings: []const u32,
};

pub fn plan(allocator: std.mem.Allocator, builder: *const Builder, program: ir.Program) Builder.Error!Plan {
    const block = program.body.block();

    if (block.len == 0 or program.symbols.count() < block.len) return error.InvalidModule;
    if (program.functions.count() != 0 or program.stores.count() != 0) return error.InvalidModule;
    if (program.expressions.count() > missing - builder.expressions.count()) return error.OutOfMemory;
    if (comptime !enabled) return @import("linking/seed.zig").plan(allocator, builder, program);

    const rule = @import("generated_rx_expression_link_plan");
    const Input = std.meta.Child(rule.Input);
    const Body = std.meta.Child(@FieldType(Input, "body"));
    const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
    const target = builder.symbols.view();
    const table = program.expressions;
    const control = block.control;

    const input: Input = .{
        .body = &.{
            .statement_kinds = zx.columns.slice(@FieldType(Body, "statement_kinds"), control.statement_kinds[block.first..][0..block.len]),
            .statement_payloads = control.statement_payloads[block.first..][0..block.len],
            .constant_symbols = control.constant_symbols,
            .constant_values = control.constant_values,
            .results = control.results,
        },
        .expressions = &.{
            .kinds = zx.columns.slice(@FieldType(Expressions, "kinds"), table.kinds),
            .payloads = table.payloads,
            .references = table.references,
            .projection_indices = table.projection_indices,
            .projection_targets = table.projection_targets,
        },
        .scope = &.{
            .names = program.symbols.names[1..block.len],
            .types = program.symbols.types[1..block.len],
            .active = @ptrCast(builder.bindings.items),
            .target_names = target.names,
            .target_types = target.types,
        },
        .base = builder.expressions.count(),
    };

    const result = rule.executeValue(allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => return error.InvalidModule,
        else => unreachable,
    };

    const returned = result.returned orelse return error.InvalidModule;

    return .{ .returned = @fromBackingInt(returned), .rows = result.rows, .bindings = result.bindings };
}
