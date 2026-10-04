const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

const Case = struct {
    source: []const u8,
    input: compiler.ir.Scalar = .u64,
    input_optional: bool = false,
    output: compiler.ir.Scalar = .void,
    output_optional: bool = false,
    rejected: bool = false,
};

fn run(case: Case) !void {
    var parsed = try rx.parseXml(std.testing.allocator, case.source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(std.testing.allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
            .{ .path = "number.zx", .source = @embedFile("fixtures/number.zx") },
            .{ .path = "optional.zx", .source = @embedFile("fixtures/optional.zx") },
            .{ .path = "text.zx", .source = @embedFile("fixtures/text.zx") },
        },
    });

    defer result.deinit();

    if (case.rejected) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings("type_mismatch", result.value.diagnostic.code);

        return;
    }

    if (result.value == .diagnostic) {
        std.debug.print("RX diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;
    const input = contract.types[@intFromEnum(contract.input_type)];
    const output = contract.types[@intFromEnum(contract.output_type)];

    if (case.input_optional) {
        try std.testing.expect(input == .optional);
        try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.input }, contract.types[@intFromEnum(input.optional)]);
    } else try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.input }, input);

    if (case.output_optional) {
        try std.testing.expect(output == .optional);
        try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.output }, contract.types[@intFromEnum(output.optional)]);
    } else try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.output }, output);

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, contract.program) == null);
}

test "optional signature alone retains optional input" {
    try run(.{ .source = "<Module><Call fn='optional' in='$in'/></Module>", .input_optional = true });
}

test "required before optional infers required input" {
    try run(.{ .source = "<Module><Call fn='number' in='$in'/><Call fn='optional' in='$in'/></Module>" });
}

test "optional before required infers required input" {
    try run(.{ .source = "<Module><Call fn='optional' in='$in'/><Call fn='number' in='$in'/></Module>" });
}

test "literal can be wrapped for optional parameter" {
    try run(.{ .source = "<Module><Call fn='optional' in='7'/></Module>", .input = .void });
}

test "optional result is preserved in return" {
    try run(.{ .source = "<Module><Call fn='optional' in='$in' out='ctx.value'/><Return value='ctx.value'/></Module>", .input_optional = true, .output = .u64, .output_optional = true });
}

test "coalesced result removes one optional layer" {
    try run(.{ .source = "<Module><Call fn='optional' in='$in' out='ctx.value'/><Return value='ctx.value ?? 7'/></Module>", .input_optional = true, .output = .u64 });
}

test "optional wrappers do not merge incompatible base types" {
    try run(.{ .source = "<Module><Call fn='optional' in='$in'/><Call fn='text' in='$in'/></Module>", .rejected = true });
}
