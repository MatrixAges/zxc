const std = @import("std");
const compiler = @import("compiler");
const Mutation = enum { order, predicate, symbol_count, input_name, input_type, output_name, output_type, predicate_type };

test "invalid contract IR cannot reach code generation" {
    const allocator = std.testing.allocator;
    const source = "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output requires(in > 0) ensures(out >= in) { return in }";
    var parsed = try compiler.parse(allocator, source, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    for (std.enums.values(Mutation)) |mutation| {
        var program = analyzed.value.ir;
        const contracts = try allocator.dupe(compiler.ir.Contract, program.contracts);

        defer allocator.free(contracts);

        const input_names = try allocator.dupe([]const u8, contracts[0].symbols.names);

        defer allocator.free(input_names);

        const input_types = try allocator.dupe(u32, contracts[0].symbols.types);

        defer allocator.free(input_types);

        const output_names = try allocator.dupe([]const u8, contracts[1].symbols.names);

        defer allocator.free(output_names);

        const output_types = try allocator.dupe(u32, contracts[1].symbols.types);

        defer allocator.free(output_types);

        const expressions = try allocator.dupe(compiler.ir.Expression, contracts[0].expressions);

        defer allocator.free(expressions);

        contracts[0].symbols.names = input_names;
        contracts[0].symbols.types = input_types;
        contracts[1].symbols.names = output_names;
        contracts[1].symbols.types = output_types;
        contracts[0].expressions = expressions;
        program.contracts = contracts;
        const predicate: usize = @backingInt(contracts[0].predicate);
        const bool_type = expressions[predicate].type_id;

        switch (mutation) {
            .order => std.mem.swap(compiler.ir.Contract, &contracts[0], &contracts[1]),
            .predicate => contracts[0].predicate = @fromBackingInt(@intCast(expressions.len)),
            .symbol_count => contracts[0].symbols = .{},
            .input_name => input_names[0] = "wrong",
            .input_type => input_types[0] = @backingInt(bool_type),
            .output_name => output_names[1] = "wrong",
            .output_type => output_types[1] = @backingInt(bool_type),
            .predicate_type => expressions[predicate].type_id = program.input_type,
        }

        errdefer std.debug.print("Contract mutation: {t}\n", .{mutation});

        try std.testing.expect(try compiler.validateIr(allocator, program) != null);
        try std.testing.expectError(error.InvalidIr, compiler.zig.emit(allocator, program));
    }
}
