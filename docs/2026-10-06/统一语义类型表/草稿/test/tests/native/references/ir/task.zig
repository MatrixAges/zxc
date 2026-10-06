const std = @import("std");
const f = @import("fixture.zig");
const ir = f.ir;

pub const Mode = enum { result, capture };

pub fn analyze(allocator: std.mem.Allocator, mode: Mode) !f.compiler.AnalysisResult {
    const source = try std.fmt.allocPrint(allocator, "import type {{ Node }} from \"zig:host\"\n\nexport type Ref = Node?\n\nexport type Refs = Node[]\n\nexport type Input = {s}\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n  const work = async {s}\n\n  cancel work\n\n  return {s}\n}}\n", .{
        if (mode == .result) "u64" else "u64[]",
        if (mode == .result) "0" else "in.length",
        if (mode == .result) "in" else "0",
    });

    defer allocator.free(source);

    var result = try f.compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = "export type Node = opaque\n", .module = "host" }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected task diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try f.compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}

pub fn apply(allocator: std.mem.Allocator, original: ir.Program, mode: Mode) !ir.Program {
    var program = original;
    const expressions = try allocator.dupe(ir.Expression, original.expressions);

    program.expressions = expressions;

    var count: usize = 0;

    for (expressions) |expression| {
        if (expression.value != .task) continue;

        count += 1;
        const value = expression.value.task;

        if (mode == .result) {
            const first = try allocator.dupe(u32, original.types.first);
            const reference = try exported(original, "Ref");
            const body = &expressions[@backingInt(value.body)];

            try std.testing.expectEqual(@as(usize, 0), value.captures.len);
            try std.testing.expect(body.value == .integer);
            try std.testing.expect(@backingInt(reference) < @backingInt(expression.type_id));

            body.type_id = reference;
            body.value = .none;

            first[@backingInt(expression.type_id)] = @backingInt(reference);

            program.types.first = first;
        } else {
            const symbols = try allocator.dupe(ir.Symbol, original.symbols);
            const exports = try allocator.dupe(ir.Export, original.exports);
            const reference = try exported(original, "Refs");

            try std.testing.expectEqual(@as(usize, 1), value.captures.len);
            try std.testing.expectEqual(@as(ir.SymbolId, @fromBackingInt(0)), value.captures[0]);
            try std.testing.expectEqual(@as(ir.TypeId, @fromBackingInt(@backingInt(ir.Scalar.u64))), original.typeOf(expression.type_id).task.result);

            program.input_type = reference;
            symbols[0].type_id = reference;
            program.symbols = symbols;
            program.exports = exports;

            for (expressions) |*item| {
                if (item.value == .reference and item.value.reference == @as(ir.SymbolId, @fromBackingInt(0))) item.type_id = reference;
            }

            for (exports) |*item| {
                if (std.mem.eql(u8, item.name, "Input")) item.type_id = reference;
            }
        }
    }

    try std.testing.expectEqual(@as(usize, 1), count);

    return program;
}

fn exported(program: ir.Program, name: []const u8) !ir.TypeId {
    for (program.exports) |item| {
        if (std.mem.eql(u8, item.name, name)) return item.type_id;
    }

    return error.MissingReferenceExport;
}
