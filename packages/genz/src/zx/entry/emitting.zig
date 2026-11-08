const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const rows = @import("../../node/import_rows.zig");
const field_rows = @import("../../node/import_fields.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
pub const generated = @import("genz_options").generated_analysis;
pub const Prepared = struct { parameters: []const node.Field, arguments: []node.ExpressionId };
pub const Tail = struct { name: []const u8, return_type: node.ExpressionId, statements: []const node.Statement, inlined: bool };

pub fn arena(self: *Lower, inner: node.Function) Lower.Error!node.Declaration {
    const entry = @import("generated_public_entry_arena");
    const Input = std.meta.Child(entry.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const parameters = try fields(std.meta.Child(@FieldType(Input, "parameters")), memory.allocator(), inner.parameters);
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .name = inner.name, .parameters = &parameters, .return_type = @backingInt(inner.return_type), .bases = &bases };
    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);

    try append(self, &expressions);

    const body = try statements(self, output.statements);

    return .{ .function = .{
        .name = output.name,
        .parameters = field_rows.materializeBorrowingText(self.allocator, output.parameters) catch |err| return failure(err),
        .return_type = @fromBackingInt(output.return_type),
        .body = try self.builder.statements(body),
        .exported = true,
    } };
}

pub fn alias(self: *Lower, state: bool, target: ?node.ExpressionId) Lower.Error!node.Declaration {
    const entry = @import("generated_public_entry_alias");
    const Input = std.meta.Child(entry.Input);
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .state = state, .target = if (target) |id| @backingInt(id) else null, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    try append(self, output.expressions);

    var storage: [1]node.Declaration = undefined;
    var declarations = std.ArrayList(node.Declaration).initBuffer(&storage);
    @import("../../node/import_constants.zig").appendBorrowingText(self.allocator, &declarations, output.declarations) catch |err| return failure(err);

    return declarations.items[0];
}

pub fn prepare(self: *Lower, original: []const node.Field, input_type: node.ExpressionId) Lower.Error!Prepared {
    const entry = @import("generated_public_entry_prepare");
    const Input = std.meta.Child(entry.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const parameters = try fields(std.meta.Child(@FieldType(Input, "parameters")), memory.allocator(), original);
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .parameters = &parameters, .input_type = @backingInt(input_type), .bases = &bases };
    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    try append(self, output.expressions);

    const arguments = try self.allocator.alloc(node.ExpressionId, output.arguments.len);

    for (arguments, output.arguments) |*argument, id| argument.* = @fromBackingInt(id);

    return .{
        .parameters = field_rows.materializeBorrowingText(self.allocator, output.parameters) catch |err| return failure(err),
        .arguments = arguments,
    };
}

pub fn call(self: *Lower, name: []const u8, arguments: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const entry = @import("generated_public_entry_call");
    const Input = std.meta.Child(entry.Input);
    var bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    bases.capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null;

    const input: Input = .{ .name = name, .arguments = view.slice(@FieldType(Input, "arguments"), arguments), .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    try append(self, output.expressions);

    return @fromBackingInt(output.root);
}

pub fn finish(self: *Lower, state: node.Function, value: node.ExpressionId, output_type: node.ExpressionId) Lower.Error!Tail {
    const entry = @import("generated_public_entry_finish");
    const Input = std.meta.Child(entry.Input);
    const errors = self.builder.nodes.get(state.return_type).error_union;
    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .value = @backingInt(value), .output_type = @backingInt(output_type), .errors = errors.errors, .inferred = errors.inferred, .inlined = state.inlined, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.extra.*);

    try append(self, &expressions);

    return .{ .name = output.name, .return_type = @fromBackingInt(output.return_type), .statements = try statements(self, output.statements), .inlined = output.inlined };
}

fn fields(comptime Fields: type, allocator: std.mem.Allocator, original: []const node.Field) Lower.Error!Fields {
    const names = try allocator.alloc([]const u8, original.len);
    const values = try allocator.alloc(u32, original.len);
    const defaults = try allocator.alloc(?u32, original.len);
    const comptimes = try allocator.alloc(bool, original.len);

    for (original, 0..) |field, index| {
        names[index] = field.name;
        values[index] = @backingInt(field.value);
        defaults[index] = if (field.default_value) |id| @backingInt(id) else null;
        comptimes[index] = field.comptime_parameter;
    }

    return .{ .name = names, .value = values, .default_value = defaults, .comptime_parameter = comptimes };
}

fn context(comptime Bases: type, self: *const Lower) Bases {
    return .{ .capture = null, .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len), .statement_base = @intCast(self.builder.nodes.statements.tags.items.len), .field_base = @intCast(self.builder.nodes.field_columns.count()), .serial = self.serial };
}

fn append(self: *Lower, source: anytype) Lower.Error!void {
    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, source) catch |err| return failure(err);
}

fn statements(self: *Lower, source: anytype) Lower.Error![]const node.Statement {
    var output: std.ArrayList(node.Statement) = .empty;

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, &output, source) catch |err| return failure(err);

    return output.toOwnedSlice(self.allocator);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
