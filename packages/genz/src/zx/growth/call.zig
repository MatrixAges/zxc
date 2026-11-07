const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const generated = @import("generated_growth_call");
const Input = std.meta.Child(generated.Input);

const Request = struct {
    element: node.ExpressionId,
    value: node.ExpressionId,
    count: node.ExpressionId = @fromBackingInt(0),
    minimum: node.ExpressionId = @fromBackingInt(0),
    flag: bool = false,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), operation: @FieldType(Input, "operation"), request: Request) Lower.Error!node.ExpressionId {
    const input = prepare(self, operation, request);

    return execute(self, body, generated, &input, .{});
}

pub fn stateList(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const serial = self.serial;
    const statements = body.items.len;
    const element = try @import("../state_value/elements.zig").typeExpr(self, id);

    std.debug.assert(serial == self.serial and statements == body.items.len);

    const input = prepare(self, .Reserve, .{ .element = element, .value = value, .count = count, .flag = frontier });

    return execute(self, body, @import("generated_growth_reserve"), &input, .{});
}

const Normalization = struct {
    selected: bool = false,
    layout: u32 = 0,
    field_base: u32 = 0,
};

pub fn normalize(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, value: node.ExpressionId, selected: bool, layout: ?node.ExpressionId) Lower.Error!node.ExpressionId {
    const input = prepare(self, .Reserve, .{ .element = element, .value = value });

    return execute(self, body, @import("generated_growth_normalize"), &input, .{
        .selected = selected,
        .layout = if (layout) |expression| @backingInt(expression) else 0,
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
    });
}

fn prepare(self: *const Lower, operation: @FieldType(Input, "operation"), request: Request) Input {
    return .{
        .operation = operation,
        .element = @backingInt(request.element),
        .value = @backingInt(request.value),
        .count = @backingInt(request.count),
        .minimum = @backingInt(request.minimum),
        .flag = request.flag,
        .shared = self.shared_types,
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };
}

fn execute(self: *Lower, body: *std.ArrayList(node.Statement), comptime module: type, input: *const Input, normalization: Normalization) Lower.Error!node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const Capture = std.meta.Child(@typeInfo(@FieldType(Input, "capture")).optional.child);
    var boundary: Capture = undefined;
    var prepared = input.*;

    if (self.capture) |capture| {
        boundary = .{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) };
        prepared.capture = &boundary;
    }

    const Parameter = std.meta.Child(module.Input);

    const payload: Parameter = if (@hasField(Parameter, "source")) .{
        .source = &prepared,
        .selected = normalization.selected,
        .layout = normalization.layout,
        .field_base = normalization.field_base,
    } else prepared;

    const emitted = module.executeIn(buffered.allocator(), &payload) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const wrapped = @hasField(std.meta.Child(@TypeOf(emitted)), "result");
    const output = if (wrapped) emitted.result else emitted;

    if (!output.valid) return error.OutOfMemory;

    const apply = @import("../construction/apply.zig");

    try apply.expressions(self, output);
    try apply.rows(self, &self.builder.nodes.statements, output.statements);
    try apply.flat(self, body, output.body);

    if (wrapped) {
        try self.builder.nodes.field_columns.reserve(self.allocator, emitted.fields.len);

        for (emitted.fields) |field| self.builder.nodes.field_columns.append(.{
            .name = try self.allocator.dupe(u8, field.name),
            .value = @fromBackingInt(field.value),
            .default_value = if (field.default_value) |value| @fromBackingInt(value) else null,
            .comptime_parameter = field.comptime_parameter,
        });
    }

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}
