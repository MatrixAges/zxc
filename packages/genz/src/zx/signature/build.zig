const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn build(self: *Lower, name: []const u8, exported: bool, errors: ?[]const []const u8) Lower.Error!node.Function {
    if (!@import("genz_options").generated_analysis) return @import("seed.zig").build(self, name, exported, errors);

    const selection = @import("generated_function_signature_mode");
    const ModeInput = std.meta.Child(selection.Input);
    const mode_input: ModeInput = .{ .public_value = self.public_value_output, .value = self.value_output };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const mode = zx.columns.invoke(selection.executeValue, fixed.allocator(), &mode_input) catch unreachable;
    const input_type = try typeExpression(self, self.program.input_type, mode.input);
    const output_type = try typeExpression(self, self.program.output_type, mode.output);
    const entry = @import("generated_function_signature");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .name = name,
        .input_type = @backingInt(input_type),
        .output_type = @backingInt(output_type),
        .store_count = self.program.stores.count(),
        .io = self.entry_flags.io,
        .process = self.entry_flags.process,
        .errors = errors,
        .exported = exported,
        .inlined = self.entry_flags.inlined,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const values = view.join(result.expressions.*, result.forms.*);
    const expressions = view.join(values, result.extra.*);

    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    return .{
        .name = result.name,
        .parameters = @import("../../node/import_fields.zig").materializeBorrowingText(self.allocator, result.parameters) catch |err| return failure(err),
        .return_type = @fromBackingInt(result.return_type),
        .body = .{},
        .exported = result.exported,
        .inlined = result.inlined,
    };
}

fn typeExpression(self: *Lower, id: ir.TypeId, representation: anytype) Lower.Error!node.ExpressionId {
    return switch (representation) {
        .Abi => self.typeExpr(id),
        .Layout => self.layoutExpr(id),
        .View => @import("../types.zig").get(self, self.view_types, id),
    };
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
