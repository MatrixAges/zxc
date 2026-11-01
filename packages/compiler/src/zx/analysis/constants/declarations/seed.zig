const std = @import("std");
const zx = @import("zx");
const Types = @import("../../types.zig");
const Analyzer = @import("../../analyzer.zig");

pub fn apply(types: *Types, declarations: []const zx.ast.Constant, imports: []const zx.ir.Constant) zx.Error![]const zx.ir.Constant {
    if (declarations.len == 0 and imports.len == 0) return &.{};
    if (!@import("../input.zig").nativeValid(types.items.view(), imports)) return types.reporter.fail(.contract, .{ .start = 0, .end = 0 }, "invalid typed constant bindings");
    if (declarations.len == 0) return &.{};

    var scope: std.ArrayList(zx.ir.Constant) = .empty;

    try scope.appendSlice(types.allocator, imports);

    for (declarations) |declaration| {
        for (scope.items) |previous| {
            if (std.mem.eql(u8, previous.name, declaration.name.text)) return types.reporter.fail(.name, declaration.name.span, "duplicate constant binding");
        }

        try scope.append(types.allocator, try evaluate(types, declaration, scope.items));
    }

    return scope.items[imports.len..];
}

fn evaluate(types: *Types, declaration: zx.ast.Constant, scope: []const zx.ir.Constant) zx.Error!zx.ir.Constant {
    const expected = try types.resolve(declaration.annotation);

    var analyzer = Analyzer{
        .allocator = types.allocator,
        .reporter = types.reporter,
        .types = types.*,
        .constants = scope,
        .output_type = expected,
    };

    defer types.* = analyzer.types;
    _ = try analyzer.bind(.{ .text = "@constant", .span = declaration.span }, Types.scalarId(.void), 0);

    const root = try analyzer.expression(declaration.value, expected);

    const program = zx.ir.Program{
        .file_name = declaration.name.text,
        .types = analyzer.types.items.view(),
        .symbols = analyzer.symbols.view(),
        .expressions = analyzer.nodes.view(),
        .input_type = Types.scalarId(.void),
        .output_type = expected,
        .body = try zx.ir.ControlBody.fromValues(types.allocator, &.{.{ .result = root }}),
    };

    var folded = try @import("../host.zig").evaluate(types.allocator, program, root);

    defer folded.deinit();

    if (folded.value == .diagnostic) {
        if (types.reporter.diagnostic == null) types.reporter.diagnostic = try folded.value.diagnostic.clone(types.allocator);

        return error.InvalidSource;
    }

    var value = folded.value.constant.value;

    if (value == .string) value.string = try types.allocator.dupe(u8, value.string);

    return .{
        .name = try types.allocator.dupe(u8, declaration.name.text),
        .type_id = folded.value.constant.type_id,
        .value = value,
    };
}
