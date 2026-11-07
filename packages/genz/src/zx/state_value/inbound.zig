const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Mode = @import("conversion.zig").Mode;
const view = @import("../../node/view.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, mode: Mode) Lower.Error!node.ExpressionId {
    const planner = @import("generated_state_inbound_plan");
    const PlanInput = std.meta.Child(planner.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(PlanInput, "types")), self.program.types);

    const request: PlanInput = .{
        .types = &types,
        .queries = zx.columns.slice(@FieldType(PlanInput, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .root = @backingInt(id),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = buffered.allocator();
    const plan = planner.executeIn(temporary, &request) catch |err| return failure(err);
    const layouts = try temporary.alloc(u32, plan.types.len);
    const targets = try temporary.alloc(u32, plan.types.len);
    const elements = try temporary.alloc(u32, plan.types.len);
    const origins = try temporary.alloc([]const u8, plan.types.len);
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const type_expression = @import("../types.zig");

    for (plan.types, plan.kinds, layouts, targets, elements, origins, 0..) |type_id, kind, *layout, *target, *element, *origin, index| {
        const selected: ir.TypeId = @fromBackingInt(type_id);
        layout.* = if (kind == .Value) 0 else @backingInt(try type_expression.get(self, self.state_layouts, selected));
        target.* = if (kind == .Optional) @backingInt(try type_expression.get(self, self.state_types, selected)) else layout.*;
        element.* = if (kind == .Rows) @backingInt(try type_expression.get(self, if (plan.count[index] == 0) self.abi_layouts else self.state_types, self.program.typeOf(selected).list)) else 0;
        origin.* = if (kind == .Object) try @import("origin.zig").name(self, selected) else &.{};
    }

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());

    const emitter = @import("generated_state_inbound_emit");
    const Input = std.meta.Child(emitter.Input);
    const Capture = std.meta.Child(@typeInfo(@FieldType(Input, "capture")).optional.child);
    var boundary: Capture = undefined;

    const input: Input = .{
        .plan = plan,
        .layouts = layouts,
        .targets = targets,
        .elements = elements,
        .origins = origins,
        .referenced = self.state_plan.borrowed,
        .mode = switch (mode) {
            .value => .Value,
            .value_layout => .Layout,
            .row_value => .Row,
            else => unreachable,
        },
        .value = @backingInt(value),
        .shared = self.shared_types,
        .capture = if (self.capture) |capture| capture: {
            boundary = .{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) };

            break :capture &boundary;
        } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const output = emitter.executeIn(temporary, &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const statements = view.join(output.statements.*, output.variables.*);
    const storage = view.join(output.storage.*, output.variables.*);
    const flat = view.join(output.body.*, output.variables.*);
    @import("../../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
    @import("../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return imported(err);
    @import("../../node/import_statements.zig").appendSelected(self.allocator, &self.reference_storage, &storage) catch |err| return imported(err);
    @import("../../node/import_statements.zig").appendSelected(self.allocator, body, &flat) catch |err| return imported(err);
    try self.builder.nodes.field_columns.reserve(self.allocator, output.fields.len);

    for (output.fields) |field| self.builder.nodes.field_columns.append(.{
        .name = field.name,
        .value = @fromBackingInt(field.value),
        .default_value = if (field.default_value) |item| @fromBackingInt(item) else null,
        .comptime_parameter = field.comptime_parameter,
    });

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid inbound conversion"),
    };
}

fn imported(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.InvalidAst => @panic("invalid inbound conversion AST"),
        else => unreachable,
    };
}
