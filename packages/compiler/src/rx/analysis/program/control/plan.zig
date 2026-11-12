const std = @import("std");
const zx = @import("zx");
const Shape = @import("shape.zig");
const Error = @import("../builder.zig").Error;
const enabled = @import("rx_options").generated_graph;
const Self = @This();

// The packed planning rows use the lane order in const.zx.
pub const Counts = extern struct {
    evaluations: u32 = 0,
    constants: u32 = 0,
    parallels: u32 = 0,
    invocations: u32 = 0,
    selections: u32 = 0,
    cases: u32 = 0,
    results: u32 = 0,
    pub fn statements(self: Counts) u64 {
        return @as(u64, self.evaluations) + self.constants + self.parallels + self.selections + self.results;
    }
    pub fn plus(self: Counts, other: Counts) std.mem.Allocator.Error!Counts {
        var result: Counts = undefined;

        inline for (@typeInfo(Counts).@"struct".field_names) |name| {
            @field(result, name) = std.math.add(u32, @field(self, name), @field(other, name)) catch return error.OutOfMemory;
        }

        return result;
    }
};

pub const Row = extern struct {
    first: Counts,
    tag: u32,
};

const no_block = std.math.maxInt(u32);

rows: []const Row,
size: Counts,
blocks: u32,
implicit_return: bool,
pub fn make(allocator: std.mem.Allocator, shape: *const Shape, capture_count: usize, void_output: bool) Error!Self {
    const rows = try allocator.alloc(Row, shape.units.len);

    if (comptime !enabled) return @import("seed.zig").plan(shape, rows, capture_count, void_output);

    const rule = @import("generated_rx_control_layout");
    const Input = std.meta.Child(rule.Input);
    const Columns = std.meta.Child(@FieldType(Input, "shape"));
    const Steps = std.meta.Child(@FieldType(Columns, "steps"));
    const items: []u32 = @as([*]u32, @ptrCast(rows.ptr))[0 .. rows.len * (@sizeOf(Row) / @sizeOf(u32))];

    const input: Input = .{
        .shape = &.{
            .steps = &.{
                .kinds = zx.columns.slice(@FieldType(Steps, "kinds"), @as([]const Shape.Kind, shape.steps.items(.kind))),
                .outputs = zx.columns.slice(@FieldType(Steps, "outputs"), @as([]const Shape.Publish, shape.steps.items(.output))),
                .getters = shape.steps.items(.getters),
                .firsts = shape.steps.items(.first),
                .counts = shape.steps.items(.count),
                .exhaustive = shape.steps.items(.exhaustive),
            },
            .units = &.{ .firsts = shape.units.items(.first), .counts = shape.units.items(.count), .blocks = shape.units.items(.block) },
            .cases = shape.cases.items,
        },
        .layout = @ptrCast(&items),
        .capture_count = capture_count,
        .void_output = void_output,
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = rule.executeValue(empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.IndexOutOfBounds => return error.InvalidModule,
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    switch (result.status) {
        .Ready => {},
        .Unreachable => return error.UnreachableFlow,
        .Incomplete => return error.IncompleteFlow,
    }

    var size: Counts = undefined;

    inline for (@typeInfo(Counts).@"struct".field_names) |name| {
        @field(size, name) = std.math.cast(u32, @field(result, name)) orelse return error.OutOfMemory;
    }

    if (size.statements() > no_block) return error.OutOfMemory;

    return .{ .rows = rows, .size = size, .blocks = @intCast(result.block_count), .implicit_return = result.implicit_return };
}

pub fn root(self: Self) u32 {
    return @intCast(self.rows.len - 1);
}

pub fn end(self: Self, unit: u32) Counts {
    for (self.rows[@as(usize, unit) + 1 ..]) |*row| {
        if (row.tag != no_block) return row.first;
    }

    return self.size;
}
