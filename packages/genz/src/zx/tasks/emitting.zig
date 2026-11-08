const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn fresh(self: *Lower, kind: anytype) Lower.Error![]const u8 {
    const entry = @import("generated_task_future_label");
    const input: std.meta.Child(entry.Input) = .{ .serial = self.serial, .kind = kind };
    const output = zx.columns.invoke(entry.executeValue, self.allocator, &input) catch |err| return failure(err);

    self.serial = @intCast(output.serial);

    return output.name;
}

pub fn start(self: *Lower, worker: node.ExpressionId, process: bool, concurrent: bool, names: []const []const u8, addresses: []const bool) Lower.Error!node.ExpressionId {
    const entry = @import("generated_task_start");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .worker = @backingInt(worker), .process = process, .concurrent = concurrent, .names = names, .addresses = addresses, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);

    return @fromBackingInt(result.root);
}

pub fn bind(self: *Lower, output: *std.ArrayList(node.Statement), name: []const u8, value: node.ExpressionId) Lower.Error!void {
    const entry = @import("generated_task_future_bind");
    const Input = std.meta.Child(entry.Input);
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .name = name, .value = @backingInt(value), .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    try append(self, &self.builder.nodes.expressions, result.expressions);

    var children = result.statements.*;

    children.tags = children.tags[0..1];
    children.offsets = children.offsets[0..1];
    @import("../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &children) catch |err| return failure(err);

    var outer = result.statements.*;

    outer.tags = outer.tags[1..];
    outer.offsets = outer.offsets[1..];

    @import("../../node/import_statements.zig").appendSelectedBorrowingText(self.allocator, output, &outer) catch |err| return failure(err);
}

pub fn call(self: *Lower, value: ?node.ExpressionId, name: ?[]const u8, method: anytype, fallible: bool) Lower.Error!node.ExpressionId {
    const entry = @import("generated_task_future_call");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .value = if (value) |id| @backingInt(id) else null, .name = name, .method = method, .fallible = fallible, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;
    try append(self, &self.builder.nodes.expressions, result.expressions);

    return @fromBackingInt(result.root);
}

pub fn cancel(self: *Lower, output: *std.ArrayList(node.Statement), value: ?node.ExpressionId, name: ?[]const u8) Lower.Error!node.ExpressionId {
    const entry = @import("generated_task_future_cancel");
    const Input = std.meta.Child(entry.Input);
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .value = if (value) |id| @backingInt(id) else null, .name = name, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;
    try append(self, &self.builder.nodes.expressions, result.expressions);
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, output, result.statements) catch |err| return failure(err);

    return @fromBackingInt(result.root);
}

pub fn context(comptime Bases: type, self: *const Lower) Bases {
    return .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };
}

pub fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, target, source) catch |err| return failure(err);
}

pub fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
