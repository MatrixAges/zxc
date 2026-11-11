const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("transaction_seed.zig");

pub fn active(self: *const Lower) bool {
    if (!generated) return seed.active(self);

    const entry = @import("generated_store_transaction");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .mode = @fromBackingInt(@backingInt(self.program.store_mode)),
        .count = self.program.stores.count(),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}

pub fn declaration(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!generated) return seed.declaration(self, output);

    const types = try self.allocator.alloc(node.ExpressionId, self.program.stores.count());

    for (self.program.stores.types, types) |type_id, *value| value.* = try self.typeExpr(@fromBackingInt(type_id));

    const entry = @import("generated_store_pending_type");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .types = view.slice(@FieldType(Input, "types"), types),
        .name = self.pending_name,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .declaration_base = @intCast(output.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = (entry.executeIn(memory.allocator(), &input) catch |err| return failure(err)) orelse return;

    if (!result.valid) return error.OutOfMemory;
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, result.expressions) catch |err| return failure(err);
    @import("../../node/import_fields.zig").append(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);
    @import("../../node/import_constants.zig").appendBorrowingText(self.allocator, output, result.declarations) catch |err| return failure(err);
}

pub fn initialize(self: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    if (!generated) return seed.initialize(self, body);

    const entry = @import("generated_store_pending_initial");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const block = self.program.body.block();

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .mode = @fromBackingInt(@backingInt(self.program.store_mode)),
        .store_count = self.program.stores.count(),
        .name = self.pending_name,
        .control = zx.columns.pointer(@FieldType(Input, "control"), block.control),
        .first = block.first,
        .count = block.len,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = (entry.executeIn(memory.allocator(), &input) catch |err| return failure(err)) orelse return;

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.forms.*);
    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    @import("../../node/import_fields.zig").append(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, result.statements) catch |err| return failure(err);
}

pub fn finish(self: *Lower, statements: *std.ArrayList(node.Statement)) Lower.Error!void {
    const body = self.program.body;

    if (!generated) {
        if (seed.active(self) and !zx.ir.terminates(body.block())) try statements.append(self.allocator, .{ .expression = try seed.commit(self) });

        return;
    }

    const entry = @import("generated_store_fallthrough");
    const Input = std.meta.Child(entry.Input);
    const Block = std.meta.Child(@FieldType(Input, "body"));

    const block: Block = .{
        .control = zx.columns.pointer(@FieldType(Block, "control"), body.control),
        .block = if (body.root) |root| @backingInt(root) else null,
    };

    const transaction: std.meta.Child(@FieldType(Input, "transaction")) = .{
        .mode = @fromBackingInt(@backingInt(self.program.store_mode)),
        .count = self.program.stores.count(),
    };

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .transaction = &transaction, .body = &block, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = (entry.executeIn(memory.allocator(), &input) catch |err| return failure(err)) orelse return;

    if (!result.valid) return error.OutOfMemory;

    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, result.expressions) catch |err| return failure(err);
    try statements.append(self.allocator, .{ .expression = @fromBackingInt(result.root) });
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
