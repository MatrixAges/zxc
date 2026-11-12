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

    const program = analyzed.value.ir;

    // The expression analyzer publishes its own span columns, even when borrowing types.
    relocate(attribute, @constCast(program.expressions.span_start), @constCast(program.expressions.span_end));
    relocate(attribute, @constCast(program.symbols.span_start), @constCast(program.symbols.span_end));

    return .{ .arena = analyzed.arena, .value = .{ .ir = program } };
}

fn relocate(attribute: rx.ast.Attribute, starts: []u64, ends: []u64) void {
    for (starts, ends) |*start, *end| {
        const span = sourceSpan(attribute, .{ .start = @intCast(start.*), .end = @intCast(end.*) });

        start.* = span.start;
        end.* = span.end;
    }
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
