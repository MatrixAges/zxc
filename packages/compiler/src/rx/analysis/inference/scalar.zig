const std = @import("std");
const zx = @import("zx");
const seed = @import("scalar/seed.zig");
const enabled = @import("rx_options").generated_graph;
pub const Mask = std.enums.EnumSet(zx.ir.Scalar);
pub const Domain = enum { numeric, signed, floating };
pub const Shape = enum { open, scalar, concrete, structure };
pub const Issue = enum { none, empty, operator, structure };
pub const Route = enum { and_value, or_value, coalesce, compare, arithmetic };
pub const Number = struct { allowed: Mask, fallback: zx.ir.Scalar };
pub const Operator = struct { route: Route, allowed: ?Mask = null };
pub const Restriction = struct { allowed: Mask, issue: Issue };
pub const Constraints = struct { allowed: ?Mask, fallback: ?zx.ir.Scalar };

comptime {
    for (std.enums.values(zx.ir.Scalar)) |scalar| {
        if (Mask.Indexer.indexOf(scalar) != @backingInt(scalar)) @compileError("scalar mask indices must match the shared scalar codes");
    }
}

pub fn domain(kind: Domain) Mask {
    if (!enabled) return seed.domain(kind);

    const entry = @import("generated_rx_scalar_domain");

    return fromBits(call(entry, switch (kind) {
        .numeric => .Numeric,
        .signed => .Signed,
        .floating => .Floating,
    }));
}

pub fn literal(text: []const u8, negative: bool) Number {
    if (!enabled) return seed.literal(text, negative);

    const result = call(@import("generated_rx_scalar_literal"), &.{ .text = text, .negative = negative });

    return .{ .allowed = fromBits(result.allowed), .fallback = @fromBackingInt(@intCast(result.fallback)) };
}

pub fn operator(value: zx.syntax.Operator) Operator {
    if (!enabled) return seed.operator(value);

    const result = call(@import("generated_rx_scalar_operator"), switch (value) {
        .coalesce => .Coalesce,
        .add => .Add,
        .subtract => .Subtract,
        .multiply => .Multiply,
        .divide => .Divide,
        .remainder => .Remainder,
        .equal => .Equal,
        .not_equal => .NotEqual,
        .less => .Less,
        .less_equal => .LessEqual,
        .greater => .Greater,
        .greater_equal => .GreaterEqual,
        .logical_and => .LogicalAnd,
        .logical_or => .LogicalOr,
    });

    return .{
        .route = switch (result.route) {
            .And => .and_value,
            .Or => .or_value,
            .Coalesce => .coalesce,
            .Compare => .compare,
            .Arithmetic => .arithmetic,
        },
        .allowed = if (result.allowed) |value_bits| fromBits(value_bits) else null,
    };
}

pub fn default(allowed: ?Mask, fallback: zx.ir.Scalar) ?zx.ir.Scalar {
    if (!enabled) return seed.default(allowed, fallback);

    const result = call(@import("generated_rx_scalar_default"), &.{ .allowed = bits(allowed), .fallback = @backingInt(fallback) });

    return if (result) |value| @fromBackingInt(@intCast(value)) else null;
}

fn bits(value: ?Mask) ?u64 {
    return if (value) |mask| mask.bits.mask else null;
}

fn fromBits(value: u64) Mask {
    return .{ .bits = .{ .mask = @intCast(value) } };
}

fn Value(comptime Output: type) type {
    return if (@typeInfo(Output) == .pointer) @typeInfo(Output).pointer.child else Output;
}

fn call(comptime Entry: type, input: Entry.Input) Value(Entry.Output) {
    const Result = Value(Entry.Output);
    const capacity = if (@typeInfo(Entry.Output) == .pointer) @sizeOf(Result) + @alignOf(Result) else 0;
    var bytes: [capacity]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&bytes);
    const result = Entry.executeIn(scratch.allocator(), input) catch unreachable;

    return if (@typeInfo(Entry.Output) == .pointer) result.* else result;
}
