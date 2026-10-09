const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");
const source = @embedFile("graph.zx");

fn valid(result: f.compiler.AnalysisResult) !void {
    if (result.value == .diagnostic) std.debug.print("resolution view diagnostic: {s} at {d}:{d}\n", .{ result.value.diagnostic.message, result.value.diagnostic.span.start, result.value.diagnostic.span.end });
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try f.frontend.validateIr(std.testing.allocator, result.value.ir));
}

test "native AST parser output resolves the full declaration graph" {
    var parsed = try f.frontend.parse(std.testing.allocator, source, "types.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var result = try f.frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer result.deinit();

    try valid(result);
    try graph.declarations(result.value.ir.types, result.value.ir.exports);
}

test "indexed Program output resolves the full declaration graph" {
    var parsed = try f.frontend.parseModule(std.testing.allocator, source, "types.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed == .indexed);
    try std.testing.expect(parsed.diagnostic() == null);

    var result = try f.frontend.analyzeModule(std.testing.allocator, &parsed, .{});

    defer result.deinit();

    try valid(result);
    try graph.declarations(result.value.ir.types, result.value.ir.exports);
}

test "indexed Expression annotations resolve tuple object optional and Array" {
    var parsed = try f.frontend.parseExpressionInput(std.testing.allocator, @embedFile("expression.zx"), "expression.zx");

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| std.debug.print("expression fixture parse diagnostic: {s} at {d}:{d}\n", .{ issue.message, issue.span.start, issue.span.end });

    try std.testing.expect(parsed == .indexed);

    var result = try f.frontend.expressions.compileInput(std.testing.allocator, &parsed, .{}, false);

    defer result.deinit();

    try valid(result);
    try graph.expression(result.value.ir);
}

fn expressionRejected(expression: []const u8, code: @FieldType(f.zx.Diagnostic, "code"), message: []const u8, token: []const u8, name_length: usize) !void {
    var parsed = try f.frontend.parseExpressionInput(std.testing.allocator, expression, "expression.zx");

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| std.debug.print("expression fixture parse diagnostic: {s} at {d}:{d}\n", .{ issue.message, issue.span.start, issue.span.end });

    try std.testing.expect(parsed == .indexed);

    var result = try f.frontend.expressions.compileInput(std.testing.allocator, &parsed, .{}, false);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const position = std.mem.indexOf(u8, expression, token).?;
    const reporter = f.zx.Reporter{ .diagnostic = result.value.diagnostic };

    try f.diagnostic(reporter, code, message, .{ .start = position, .end = position + name_length });
}

test "indexed Expression generic annotation rejects name before unknown argument" {
    try expressionRejected("loop(1, { while: current => current > 0, next: current => { const bad: Box<Missing> = 1\n current -= bad\n } })", .unsupported, "generic and database types are not enabled", "Box", 3);
}

test "indexed Expression duplicate annotation field precedes its unknown value" {
    try expressionRejected("loop(1, { while: current => current > 0, next: current => { const bad: { field: u64, field: Missing } = { field: 1 }\n current -= bad.field\n } })", .name, "duplicate object field", "field: Missing", 5);
}

fn programDepth(count: usize, rejected: bool) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();
    var text: std.ArrayList(u8) = .empty;

    for (0..count) |index| {
        const line = if (index + 1 == count) try std.fmt.allocPrint(memory, "export type Alias{d} = u64\n\n", .{index}) else try std.fmt.allocPrint(memory, "export type Alias{d} = Alias{d}\n\n", .{ index, index + 1 });

        try text.appendSlice(memory, line);
    }

    var parsed = try f.frontend.parseModule(std.testing.allocator, text.items, "depth.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed == .indexed);

    var result = try f.frontend.analyzeModule(std.testing.allocator, &parsed, .{});

    defer result.deinit();

    if (rejected) {
        try std.testing.expect(result.value == .diagnostic);

        const position = std.mem.indexOf(u8, text.items, "= Alias256").? + 2;

        try f.diagnostic(.{ .diagnostic = result.value.diagnostic }, .unsupported, "type alias nesting exceeds 256 levels", .{ .start = position, .end = position + "Alias256".len });
    } else {
        try valid(result);
        try std.testing.expectEqual(count, result.value.ir.exports.len);
        for (result.value.ir.exports) |item| try std.testing.expectEqual(f.scalar(.u64), item.type_id);
    }
}

test "indexed Program accepts 255 forward aliases" {
    try programDepth(255, false);
}

test "indexed Program accepts the exact 256 forward alias limit" {
    try programDepth(256, false);
}

test "indexed Program rejects the 257th forward alias token" {
    try programDepth(257, true);
}

test "native interface output resolves containers enum and opaque declaration" {
    const main = "import type { Payload, Mirror, Leaf, Row, Mode, Node } from \"zig:host\"\n\nexport type Input = Payload\n\nexport type Output = Mirror\n\nexport default function (in: Input): Output { return in }\n";
    var result = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = main }}, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = source ++ "\nexport type Node = opaque\n", .module = "host", .identity = "resolution@1" }} });

    defer result.deinit();

    try valid(result);
    try std.testing.expectEqual(@as(usize, 1), result.value.ir.native_modules.count());

    const module = result.value.ir.native_modules.at(0);
    const exports = try std.testing.allocator.alloc(f.ir.Export, module.types.count());

    defer std.testing.allocator.free(exports);

    for (exports, 0..) |*item, index| item.* = module.types.at(index);
    try std.testing.expectEqualStrings("resolution@1", module.key());
    try graph.declarations(result.value.ir.types, exports);

    const node = result.value.ir.types.get(try graph.exported(exports, "Node"));

    try std.testing.expectEqual(.native_reference, std.meta.activeTag(node));
    try std.testing.expectEqualStrings("Node", node.native_reference);
}
