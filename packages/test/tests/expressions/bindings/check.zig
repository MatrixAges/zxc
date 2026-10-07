const std = @import("std");
const compiler = @import("compiler");
const ir = compiler.ir;
const Binding = compiler.expressions.Binding;
const Code = @FieldType(compiler.Diagnostic, "code");
pub const Case = struct { source: []const u8 = "7", bindings: []const Binding, expected: ?ir.TypeId = null, code: ?Code = null, output: ir.TypeId = @fromBackingInt(@intCast(5)) };
pub const number: ir.TypeId = @fromBackingInt(@intCast(5));
pub const boolean: ir.TypeId = @fromBackingInt(@intCast(1));

pub fn run(allocator: std.mem.Allocator, compiled: bool, case: Case) !void {
    var parsed = try compiler.parseExpression(allocator, case.source, "call.rx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    const options: compiler.expressions.Options = .{ .bindings = case.bindings, .expected = case.expected };

    if (compiled) {
        var result = try compiler.expressions.compile(allocator, parsed.value.parsed, options);

        defer result.deinit();

        if (case.code) |code| {
            try std.testing.expect(result.value == .diagnostic);
            try std.testing.expectEqual(code, result.value.diagnostic.code);

            return;
        }

        try std.testing.expect(result.value == .ir);

        const program = result.value.ir;

        try std.testing.expect(try compiler.validateIr(allocator, program) == null);
        try std.testing.expectEqual(case.output, program.output_type);

        if (case.bindings.len == 0) {
            try std.testing.expectEqual(@as(ir.TypeId, @fromBackingInt(@intCast(0))), program.input_type);
        } else {
            const children = program.types.get(program.input_type).tuple;

            try std.testing.expectEqual(case.bindings.len, children.len);
            for (case.bindings, 0..) |binding, index| try std.testing.expectEqual(binding.type_id, children.at(index));
        }

        return;
    }

    var result = try compiler.expressions.analyze(allocator, parsed.value.parsed, options);

    defer result.deinit();

    if (case.code) |code| {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(code, result.value.diagnostic.code);

        return;
    }

    try std.testing.expect(result.value == .expression);

    const expression = result.value.expression;

    try std.testing.expectEqual(case.output, expression.expressions.at(@backingInt(expression.value)).type_id);
    try std.testing.expectEqual(case.bindings.len, expression.symbols.count());

    for (case.bindings, 0..) |binding, symbol_index| {
        const symbol = expression.symbols.at(symbol_index);

        try std.testing.expectEqualStrings(binding.name, symbol.name);
        try std.testing.expectEqual(binding.type_id, symbol.type_id);
    }
}
