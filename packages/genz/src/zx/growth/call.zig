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

    return execute(self, body, generated, &input);
}

pub fn stateList(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const serial = self.serial;
    const statements = body.items.len;
    const element = try @import("../state_value/elements.zig").typeExpr(self, id);

    std.debug.assert(serial == self.serial and statements == body.items.len);

    const input = prepare(self, .Reserve, .{ .element = element, .value = value, .count = count, .flag = frontier });

    return execute(self, body, @import("generated_growth_reserve"), &input);
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

fn execute(self: *Lower, body: *std.ArrayList(node.Statement), comptime module: type, input: *const Input) Lower.Error!node.ExpressionId {
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

    const output = module.executeIn(buffered.allocator(), &prepared) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const apply = @import("../construction/apply.zig");

    try apply.expressions(self, output);
    try apply.rows(self, &self.builder.nodes.statements, output.statements);
    try apply.flat(self, body, output.body);

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}
