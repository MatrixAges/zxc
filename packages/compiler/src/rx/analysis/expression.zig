const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");

pub const Diagnostic = struct { issue: zx.Diagnostic, location: rx.ast.Location };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { ir: zx.ir.Program, diagnostic: Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn compile(allocator: std.mem.Allocator, path: []const u8, attribute: rx.ast.Attribute, options: frontend.expressions.Options) std.mem.Allocator.Error!Result {
    var parsed = try frontend.parseExpression(allocator, attribute.value, path);

    if (parsed.value == .diagnostic) return .{ .arena = parsed.arena, .value = .{ .diagnostic = diagnostic(attribute, parsed.value.diagnostic) } };

    defer parsed.deinit();

    var analyzed = try frontend.expressions.compile(allocator, parsed.value.parsed, options);

    errdefer analyzed.deinit();

    if (analyzed.value == .diagnostic) return .{ .arena = analyzed.arena, .value = .{ .diagnostic = diagnostic(attribute, analyzed.value.diagnostic) } };

    var program = analyzed.value.ir;
    const temporary = analyzed.arena.allocator();
    const expressions = try temporary.dupe(zx.ir.Expression, program.expressions);
    const symbols = try temporary.dupe(zx.ir.Symbol, program.symbols);

    for (expressions) |*expression| expression.span = sourceSpan(attribute, expression.span);
    for (symbols) |*symbol| symbol.span = sourceSpan(attribute, symbol.span);

    program.expressions = expressions;
    program.symbols = symbols;

    return .{ .arena = analyzed.arena, .value = .{ .ir = program } };
}

fn diagnostic(attribute: rx.ast.Attribute, issue: zx.Diagnostic) Diagnostic {
    var mapped = issue;

    mapped.span = sourceSpan(attribute, issue.span);

    return .{ .issue = mapped, .location = rx.attributeLocation(attribute, issue.span.start) orelse attribute.value_location };
}

fn sourceSpan(attribute: rx.ast.Attribute, span: zx.Span) zx.Span {
    const start = (rx.attributeLocation(attribute, span.start) orelse attribute.value_location).offset;

    return .{
        .start = start,
        .end = if (span.start == span.end) start else (rx.attributeEndLocation(attribute, span.end) orelse attribute.value_location).offset,
    };
}
