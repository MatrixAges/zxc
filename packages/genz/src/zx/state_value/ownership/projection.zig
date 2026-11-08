const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const rows = @import("../../../node/import_rows.zig");
const view = @import("../../../node/view.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!node.ExpressionId {
    const planner = @import("generated_ownership_projection_plan");
    const PlanInput = std.meta.Child(planner.Input);
    const Outline = std.meta.Child(@FieldType(PlanInput, "source"));
    const Query = std.meta.Child(@FieldType(Outline, "source"));
    const Facts = std.meta.Child(@FieldType(Query, "facts"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);

    const facts: Facts = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .counts = self.slot_counts,
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
    };

    const query: Query = .{ .facts = &facts, .node = @backingInt(id), .type_id = @backingInt(type_id), .slot = slot };
    const outline: Outline = .{ .source = &query, .referenced = self.state_plan.borrowed };
    var hash: zx.Sha256 = undefined;

    const plan_input: PlanInput = .{
        .source = &outline,
        .hash = @ptrCast(&hash),
        .names = self.type_names,
        .key = &self.state_plan.keys[@backingInt(type_id)],
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = buffered.allocator();
    const request = (planner.executeIn(temporary, &plan_input) catch |err| return failure(err)) orelse return value;
    const name = try self.allocator.dupe(u8, request.qualified.name);
    const helper_name = if (request.helper_name) |text| try self.allocator.dupe(u8, text) else null;

    self.serial = @intCast(request.qualified.serial);

    const type_expr = try @import("../../types.zig").get(self, self.state_types, type_id);
    const layouts = try temporary.alloc(u32, if (request.clear_plan) |plan| plan.types.len else 0);

    if (request.clear_plan) |plan| {
        for (plan.types, plan.kinds, layouts) |selected, operation, *layout| {
            layout.* = if (operation == .Reference)
                @backingInt(try @import("../../types.zig").get(self, self.state_layouts, @fromBackingInt(selected)))
            else
                0;
        }
    }

    const emitter = @import("generated_ownership_projection");
    const Input = std.meta.Child(emitter.Input);
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../list_emission.zig").borrow(self));

    const input: Input = .{
        .source = &outline,
        .name = name,
        .helper_name = helper_name,
        .clear_plan = request.clear_plan,
        .layouts = layouts,
        .existing_names = self.task_declarations.functionNames(),
        .type_expr = @backingInt(type_expr),
        .value = @backingInt(value),
        .ast = &ast,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .declaration_base = @intCast(self.task_declarations.count()),
        .serial = self.serial,
    };

    const output = emitter.executeIn(temporary, &input) catch |err| return failure(err);
    const result = output.result;

    if (!result.valid) return error.OutOfMemory;

    for (result.segments) |segment| {
        const expressions = view.join(segment.expressions.*, segment.forms.*);

        if (segment.borrow_text) {
            rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
        } else {
            rows.append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
        }
    }

    try appendBody(self, body, output.binding);

    const statements = view.join(result.statements.*, result.variables.*);
    const storage = view.join(result.storage.*, result.variables.*);
    @import("../../../node/import_statements.zig").appendSelected(self.allocator, &self.reference_storage, &storage) catch |err| return imported(err);
    @import("../../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return imported(err);

    if (result.declaration) |declaration| {
        const parameters = @import("../../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, declaration.parameters) catch |err| return imported(err);

        try self.task_declarations.appendFunction(self.allocator, declaration.columns, parameters.start);
    }

    try appendBody(self, body, output.body);

    self.serial = @intCast(result.serial);

    return @fromBackingInt(output.root);
}

fn appendBody(self: *Lower, target: *std.ArrayList(node.Statement), source: anytype) Lower.Error!void {
    const statements = view.join(source.statements.*, source.variables.*);
    const importing = @import("../../../node/import_statements.zig");

    if (source.borrow_text) {
        importing.appendSelectedBorrowingText(self.allocator, target, &statements) catch |err| return imported(err);
    } else {
        importing.appendSelected(self.allocator, target, &statements) catch |err| return imported(err);
    }
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid ownership projection generation"),
    };
}

fn imported(err: rows.Error) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.InvalidAst => @panic("invalid ownership projection AST"),
    };
}
