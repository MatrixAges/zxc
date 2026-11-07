const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn lower(context: *Context, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const root_layout = try @import("types.zig").get(context, id);
    const planner = @import("generated_conversion_plan");
    const PlanInput = std.meta.Child(planner.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(PlanInput, "types")), self.program.types);

    const request: PlanInput = .{
        .types = &types,
        .layouts = zx.columns.slice(@FieldType(PlanInput, "layouts"), self.layout_types),
        .root = @backingInt(id),
        .inline_lists = context.inline_lists,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const operation = zx.columns.invoke(@import("generated_conversion_operation").executeValue, fixed.allocator(), &request) catch unreachable;

    if (operation == .Value) return value;

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = planner.executeIn(buffered.allocator(), &request) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const layouts = try buffered.allocator().alloc(u32, plan.types.len);
    const elements = try buffered.allocator().alloc(u32, plan.types.len);
    const serial = self.serial;
    const declarations = context.declarations.items.len;

    for (plan.types, plan.kinds, layouts, elements, 0..) |type_id, kind, *layout, *element, index| {
        const selected: ir.TypeId = @fromBackingInt(type_id);
        layout.* = @backingInt(if (index == 0) root_layout else try @import("types.zig").get(context, selected));
        element.* = if (kind == .Buffer) @backingInt(try @import("types.zig").get(context, self.program.typeOf(selected).list)) else 0;
    }

    std.debug.assert(serial == self.serial and declarations == context.declarations.items.len);

    const emitter = @import("generated_conversion_emit");
    const Input = std.meta.Child(emitter.Input);

    const input: Input = .{
        .plan = plan,
        .layouts = layouts,
        .elements = elements,
        .value = @backingInt(value),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const output = emitter.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const result = try apply(context, output);
    const view = @import("../../node/view.zig");
    const prefix = view.join(output.declarations.*, output.variables.*);

    @import("../../node/import_statements.zig").append(self.allocator, context.declarations, &prefix) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return result;
}

pub fn apply(context: *Context, output: anytype) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const view = @import("../../node/view.zig");
    const expressions = view.join(output.expressions.*, output.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, output.statements);
    try self.builder.nodes.field_columns.reserve(self.allocator, output.fields.len);

    for (output.fields) |field| {
        self.builder.nodes.field_columns.append(.{
            .name = field.name,
            .value = @fromBackingInt(field.value),
            .default_value = if (field.default_value) |item| @fromBackingInt(item) else null,
            .comptime_parameter = field.comptime_parameter,
        });
    }

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
