const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn lower(context: *Context, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const root_layout = try self.layoutExpr(id);
    const planner = @import("generated_conversion_output_plan");
    const Prepare = std.meta.Child(planner.Input);
    const PlanInput = std.meta.Child(@FieldType(Prepare, "source"));
    const Facts = std.meta.Child(@FieldType(Prepare, "facts"));
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

    const temporary = buffered.allocator();

    const facts: Facts = .{
        .active = self.state_active,
        .selected = self.state_plan.selected,
        .borrowed = self.state_plan.borrowed,
    };

    const input_plan: Prepare = .{ .source = &request, .facts = &facts };

    const prepared = planner.executeIn(temporary, &input_plan) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const plan = prepared.plan;
    const generated = @import("generated_conversion_output");
    const Input = std.meta.Child(generated.Input);
    const Source = std.meta.Child(@FieldType(Input, "source"));
    const layouts = try temporary.alloc(u32, plan.types.len);
    const operands = try temporary.alloc(u32, plan.types.len);
    const serial = self.serial;
    const declarations = context.declarations.items.len;
    const storage = self.reference_storage.items.len;

    for (plan.types, prepared.requirements, layouts, operands, 0..) |raw, requirement, *layout, *operand, index| {
        const selected: ir.TypeId = @fromBackingInt(raw);
        const regular = if (index == 0) root_layout else try self.layoutExpr(selected);

        layout.* = @backingInt(if (requirement == .OptionalType) try self.typeExpr(selected) else regular);

        operand.* = switch (requirement) {
            .HeapType => @backingInt(try self.typeExpr(selected)),
            .ReferenceLayout => @backingInt(try @import("../types.zig").get(self, self.state_layouts, selected)),
            .Layout, .OptionalType, .Value => 0,
            .Unsupported => unreachable,
        };
    }

    std.debug.assert(serial == self.serial and declarations == context.declarations.items.len and storage == self.reference_storage.items.len);

    const ast = @import("../construction/ast.zig").borrow(std.meta.Child(@FieldType(Input, "ast")), self);

    const source: Source = .{
        .plan = plan,
        .layouts = layouts,
        .elements = &.{},
        .value = @backingInt(value),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .source = &source,
        .requirements = zx.columns.slice(@FieldType(Input, "requirements"), prepared.requirements),
        .ast = &ast,
        .operands = operands,
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.result.valid) return error.OutOfMemory;

    const result = try @import("conversion_emission.zig").apply(context, output.result);
    const view = @import("../../node/view.zig");
    const prefix = view.join(output.storage.*, output.result.variables.*);

    try @import("../construction/apply.zig").flat(self, &self.reference_storage, &prefix);

    return result;
}
