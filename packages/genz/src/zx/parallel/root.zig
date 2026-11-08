const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, invocations: @FieldType(ir.StatementRow, "parallel")) Lower.Error![]const node.Statement {
    if (!@import("genz_options").generated_analysis) return @import("root_seed.zig").lower(self, invocations);

    self.uses_parallel = true;
    self.uses_allocator = true;

    const entry = @import("generated_parallel_emit");
    const Input = std.meta.Child(entry.Input);
    const RecordRef = std.meta.Child(@FieldType(Input, "records"));
    const Record = if (@typeInfo(RecordRef) == .pointer) std.meta.Child(RecordRef) else RecordRef;
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const references = try memory.allocator().alloc(RecordRef, invocations.len);
    const records = if (@typeInfo(RecordRef) == .pointer) try memory.allocator().alloc(Record, invocations.len) else references;
    const shared = try fresh(self, .Allocator);

    for (0..invocations.len) |index| {
        const invocation = invocations.at(index);
        const call = self.program.expression(invocation.value).value.call;
        const type_name = try fresh(self, .Type);
        const input_name = try fresh(self, .Input);
        const worker_name = try fresh(self, .Worker);
        const argument = try self.expr(call.argument);
        const worker_type = try @import("worker.zig").lower(self, call.function);
        const thread_name = try fresh(self, .Thread);

        records[index] = .{
            .argument = @backingInt(argument),
            .worker_type = @backingInt(worker_type),
            .type_name = type_name,
            .input_name = input_name,
            .worker_name = worker_name,
            .thread_name = thread_name,
            .symbol = if (invocation.symbol) |id| @backingInt(id) else null,
        };

        if (comptime @typeInfo(RecordRef) == .pointer) references[index] = &records[index];
    }

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .shared = shared, .records = references, .used = self.used, .names = self.names, .bases = &bases };
    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.forms.*);
    const statements = view.join(view.join(result.statements.*, result.variables.*), result.extra.*);
    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    _ = @import("../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);

    var children = statements;
    children.tags = statements.tags[0..result.inner_count];
    children.offsets = statements.offsets[0..result.inner_count];
    @import("../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &children) catch |err| return failure(err);

    var outer = statements;

    outer.tags = statements.tags[result.inner_count..];
    outer.offsets = statements.offsets[result.inner_count..];
    var output: std.ArrayList(node.Statement) = .empty;
    @import("../../node/import_statements.zig").appendSelectedBorrowingText(self.allocator, &output, &outer) catch |err| return failure(err);

    return output.toOwnedSlice(self.allocator);
}

fn fresh(self: *Lower, kind: anytype) Lower.Error![]const u8 {
    const entry = @import("generated_parallel_label");
    const input: std.meta.Child(entry.Input) = .{ .serial = self.serial, .kind = kind };
    const output = zx.columns.invoke(entry.executeValue, self.allocator, &input) catch |err| return failure(err);

    self.serial = @intCast(output.serial);

    return output.name;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
