const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub fn lower(context: *Context, selected: Consumer, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const program: *const ir.Program = &self.program;
    const planner = @import("generated_projection_plan");
    const PlanInput = std.meta.Child(planner.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(PlanInput, "types")), self.program.types);

    const request: PlanInput = .{
        .types = &types,
        .table = zx.columns.pointer(@FieldType(PlanInput, "table"), &program.expressions),
        .root = @backingInt(id),
        .symbol = @backingInt(selected.symbol),
        .inline_lists = context.inline_lists,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = planner.executeIn(buffered.allocator(), &request) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!plan.valid) unreachable;
    if (plan.operations.len == 0) return value;

    const prepared = try buffered.allocator().alloc(u32, plan.operations.len);
    const serials = try buffered.allocator().alloc(u64, plan.operations.len);
    const history_count = try buffered.allocator().alloc(u64, plan.operations.len);

    for (plan.requirements, plan.values, plan.fresh, prepared, serials, history_count) |requirement, source, fresh, *target, *serial, *count| {
        const expression = switch (requirement) {
            .None => null,
            .IterationType => try @import("types.zig").get(context, @fromBackingInt(source)),
            .Expression => try self.expr(@fromBackingInt(source)),
            .NativeType => try self.typeExpr(@fromBackingInt(source)),
        };

        target.* = if (expression) |result| @backingInt(result) else 0;
        serial.* = self.serial;
        count.* = context.transfers.len();
        const reserved = std.math.cast(usize, fresh) orelse return error.OutOfMemory;

        self.serial = std.math.add(usize, self.serial, reserved) catch return error.OutOfMemory;
    }

    const emitter = @import("generated_projection_emit");
    const Input = std.meta.Child(emitter.Input);
    const history = context.transfers.view(std.meta.Child(@FieldType(Input, "history")));

    const input: Input = .{
        .plan = plan,
        .prepared = prepared,
        .serials = serials,
        .history_count = history_count,
        .history = &history,
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

    const expressions = @import("../../node/view.zig").join(output.expressions.*, output.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, output.statements);
    try self.builder.nodes.field_columns.reserve(self.allocator, output.fields.len);

    for (output.fields) |field| {
        self.builder.nodes.field_columns.append(.{
            .name = field.name,
            .value = @fromBackingInt(field.value),
            .default_value = if (field.default_value) |default| @fromBackingInt(default) else null,
            .comptime_parameter = field.comptime_parameter,
        });
    }

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
