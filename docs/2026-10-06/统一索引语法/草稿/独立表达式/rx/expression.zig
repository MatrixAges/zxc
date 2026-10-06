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
    return compileStage(allocator, path, attribute, options, false);
}

pub fn compileForLinking(allocator: std.mem.Allocator, path: []const u8, attribute: rx.ast.Attribute, options: frontend.expressions.Options) std.mem.Allocator.Error!Result {
    return compileStage(allocator, path, attribute, options, true);
}

fn compileStage(allocator: std.mem.Allocator, path: []const u8, attribute: rx.ast.Attribute, options: frontend.expressions.Options, comptime linking: bool) std.mem.Allocator.Error!Result {
    var parsed = try @import("attribute.zig").parse(allocator, attribute, path);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| {
        var arena = std.heap.ArenaAllocator.init(allocator);

        errdefer arena.deinit();

        var owned = issue;
        owned.message = try arena.allocator().dupe(u8, issue.message);
        owned.message_allocator = null;

        return .{ .arena = arena, .value = .{ .diagnostic = diagnostic(attribute, owned) } };
    }

    var analyzed = try frontend.expressions.compileInput(allocator, &parsed, options, linking);

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
