const std = @import("std");
const zx = @import("zx");
const node = @import("../../../node.zig");
const view = @import("../../../node/view.zig");
const Lower = @import("../../lower.zig");

pub const Flags = struct { exported: bool, io: bool, process: bool };

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), flags: Flags) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("seed.zig").append(self, body, flags);

    const required = @import("generated_function_task_allocator");
    const Request = std.meta.Child(required.Input);
    const request: Request = .{ .exported = flags.exported, .uses_allocator = self.uses_allocator, .tasks = self.entry_flags.tasks };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const needs_task = zx.columns.invoke(required.executeValue, fixed.allocator(), &request) catch unreachable;
    const task_type = if (needs_task) try @import("../../allocator.zig").lower(self, true) else null;
    const entry = @import("generated_function_prelude");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .exported = flags.exported,
        .uses_allocator = self.uses_allocator,
        .tasks = self.entry_flags.tasks,
        .needs_io = flags.io,
        .uses_io = self.uses_io,
        .needs_process = flags.process,
        .uses_process = self.uses_process,
        .uses_context = self.uses_context,
        .used_input = self.used[0],
        .store_count = self.program.stores.count(),
        .store_mode = @fromBackingInt(@backingInt(self.program.store_mode)),
        .task_type = if (task_type) |id| @backingInt(id) else null,
        .auxiliary_base = @intCast(self.task_declarations.count()),
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.forms.*);
    const statements = view.join(result.statements.*, result.variables.*);
    @import("../../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    _ = @import("../../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);
    @import("../../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);

    var auxiliary_storage: [1]node.Declaration = undefined;
    var auxiliary = std.ArrayList(node.Declaration).initBuffer(&auxiliary_storage);

    @import("../../../node/import_constants.zig").appendBorrowingText(self.allocator, &auxiliary, result.declarations) catch |err| return failure(err);
    for (auxiliary.items) |declaration| try self.task_declarations.append(self.allocator, declaration);

    self.uses_io = result.uses_io;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
