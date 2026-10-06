const std = @import("std");
const compiler = @import("compiler");
pub const Shape = enum { lists, objects, tuples, scalars, borrowed };
pub const Mutation = enum { none, duplicate_id, duplicate_path, swap };
pub const Case = struct { shape: Shape, mutation: Mutation, nested: bool = false };

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const element = switch (case.shape) {
        .lists, .borrowed => "u64[]",
        .objects => "{ values: u64[] }",
        .tuples => "[u64[], u64]",
        .scalars => "u64",
    };

    const initial = switch (case.shape) {
        .lists, .borrowed => "{ first: [1, 2], second: [3, 4] }",
        .objects => "{ first: {values: [1, 2]}, second: {values: [3, 4]} }",
        .tuples => "{ first: [[1, 2], 7], second: [[3, 4], 9] }",
        .scalars => "{ first: 7, second: 9 }",
    };

    const source = try std.fmt.allocPrint(allocator, "export type Output = {{ first: {s}, second: {s} }}\n\nexport type Input = {s}\n\nexport default function (in: Input): Output {{\n  const source: Output = {s}\n\n  return {s}\n}}\n", .{ element, element, if (case.shape == .borrowed) "Output" else "void", if (case.shape == .borrowed) "in" else initial, if (case.nested) "{...{...source}}" else "{...source}" });

    defer allocator.free(source);

    var parsed = try compiler.parse(allocator, source, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("analysis {t}: {s}\n", .{ analyzed.value.diagnostic.code, analyzed.value.diagnostic.message });

        return error.UnexpectedDiagnostic;
    }

    var program = analyzed.value.ir;
    const expressions = try allocator.dupe(compiler.ir.Expression, program.expressions);

    defer allocator.free(expressions);

    program.expressions = expressions;

    var selected: ?usize = null;

    for (expressions, 0..) |expression, index| {
        if (expression.value == .object and expression.value.object.evaluation.len == 1 and expression.value.object.fields.len == 2) selected = index;
    }

    const object = &expressions[selected orelse return error.MissingSpread].value.object;
    const fields = try allocator.dupe(@TypeOf(object.fields[0]), object.fields);

    defer allocator.free(fields);

    object.fields = fields;

    switch (case.mutation) {
        .none => {},
        .duplicate_id => fields[1].value = fields[0].value,
        .duplicate_path => {
            const first = program.expression(fields[0].value).value.field;
            const second = &expressions[@backingInt(fields[1].value)].value.field;

            second.* = first;
        },
        .swap => std.mem.swap(compiler.ir.ExprId, &fields[0].value, &fields[1].value),
    }

    const issue = try compiler.validateIr(allocator, program);

    if (issue) |diagnostic| {
        std.debug.print("validate {t}: {s}\n", .{ diagnostic.code, diagnostic.message });

        return error.UnexpectedDiagnostic;
    }

    const generated = try compiler.zig.emit(allocator, program);

    defer allocator.free(generated);

    try std.testing.expect(generated.len > 0);

    const original = analyzed.value.ir;
    defer analyzed.value.ir = original;
    analyzed.value.ir = program;

    try @import("gates.zig").check(allocator, &analyzed, false);
}
