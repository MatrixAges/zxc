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

pub fn checkValues(allocator: std.mem.Allocator, input: anytype, owner: []const u8) std.mem.Allocator.Error!?Diagnostic {
    const node = rx.ast.view(input);

    for (0..node.attributeCount()) |index| {
        const attribute = node.schemaAttribute(index);

        if (attribute.kind != .expression) continue;
        if (rx.isTypeAttribute(node.name(), attribute.name)) continue;

        var parsed = try @import("attribute.zig").parse(allocator, attribute, owner);

        defer parsed.deinit();

        if (parsed.diagnostic()) |issue| return diagnostic(attribute, try issue.clone(allocator));
        if (try @import("attribute.zig").checkStyle(allocator, &parsed)) |issue| return diagnostic(attribute, try issue.clone(allocator));
    }

    var children = node.children();

    while (children.next()) |child| {
        if (try checkValues(allocator, child, owner)) |issue| return issue;
    }

    return null;
}

pub fn compile(allocator: std.mem.Allocator, path: []const u8, attribute: rx.ast.Attribute, options: frontend.expressions.Options) std.mem.Allocator.Error!Result {
    var parsed = try @import("attribute.zig").parse(allocator, attribute, path);

    defer parsed.deinit();

    return compileParsed(allocator, &parsed, attribute, options, false);
}

pub fn compileParsed(allocator: std.mem.Allocator, parsed: *const frontend.ExpressionInput.Result, attribute: rx.ast.Attribute, options: frontend.expressions.Options, comptime linking: bool) std.mem.Allocator.Error!Result {
    if (parsed.diagnostic()) |issue| {
        var arena = std.heap.ArenaAllocator.init(allocator);

        errdefer arena.deinit();

        var owned = issue;
        owned.message = try arena.allocator().dupe(u8, issue.message);
        owned.message_allocator = null;

        return .{ .arena = arena, .value = .{ .diagnostic = diagnostic(attribute, owned) } };
    }

    var analyzed = try frontend.expressions.compileInput(allocator, parsed, options, linking);

    errdefer analyzed.deinit();

    if (analyzed.value == .diagnostic) return .{ .arena = analyzed.arena, .value = .{ .diagnostic = diagnostic(attribute, analyzed.value.diagnostic) } };

    var program = analyzed.value.ir;
    const temporary = analyzed.arena.allocator();
    var expressions = program.expressions;
    const expression_starts = try temporary.alloc(u64, expressions.count());
    const expression_ends = try temporary.alloc(u64, expressions.count());
    var symbols = program.symbols;
    const starts = try temporary.alloc(u64, symbols.count());
    const ends = try temporary.alloc(u64, symbols.count());

    for (expressions.span_start, expressions.span_end, expression_starts, expression_ends) |start, end, *mapped_start, *mapped_end| {
        const span = sourceSpan(attribute, .{ .start = @intCast(start), .end = @intCast(end) });

        mapped_start.* = span.start;
        mapped_end.* = span.end;
    }

    expressions.span_start = expression_starts;
    expressions.span_end = expression_ends;

    for (symbols.span_start, symbols.span_end, starts, ends) |start, end, *mapped_start, *mapped_end| {
        const span = sourceSpan(attribute, .{ .start = @intCast(start), .end = @intCast(end) });

        mapped_start.* = span.start;
        mapped_end.* = span.end;
    }

    symbols.span_start = starts;
    symbols.span_end = ends;
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
    const start = rx.attributeByteOffset(attribute, span.start, false) orelse attribute.value_location.offset;

    return .{
        .start = start,
        .end = if (span.start == span.end) start else rx.attributeByteOffset(attribute, span.end, true) orelse attribute.value_location.offset,
    };
}
