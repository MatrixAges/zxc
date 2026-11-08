const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const seed = @import("seed.zig");
const generated = @import("genz_options").generated_analysis;

pub fn standard(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!generated) return seed.standard(self, output);

    const entry = @import("generated_module_standard");
    const input = context(std.meta.Child(entry.Input), self);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    try publish(self, output, result);
}

pub fn exports(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!generated) return seed.exports(self, output);

    const entry = @import("generated_module_exports");
    const Input = std.meta.Child(entry.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const names = try exportNames(memory.allocator(), self);
    const values = try memory.allocator().alloc(u32, self.program.exports.len);

    for (self.program.exports, values) |item, *value| value.* = @backingInt(try self.typeExpr(item.type_id));

    const bases = context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .names = names, .values = values, .io = self.entry_flags.io, .process = self.entry_flags.process, .bases = &bases };
    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    try publish(self, output, result);
}

pub fn contracts(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!generated) return seed.contracts(self, output);

    const query = @import("generated_module_contracts");
    const Input = std.meta.Child(query.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const names = try exportNames(memory.allocator(), self);
    const input: Input = .{ .names = names };
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const missing = zx.columns.invoke(query.executeValue, empty.allocator(), &input) catch |err| return failure(err);
    const entry = @import("generated_module_aliases");
    const AliasInput = std.meta.Child(entry.Input);

    const aliases: AliasInput = .{
        .input_type = if (missing.input) @backingInt(try self.typeExpr(self.program.input_type)) else null,
        .output_type = if (missing.output) @backingInt(try self.typeExpr(self.program.output_type)) else null,
    };

    const result = entry.executeIn(memory.allocator(), &aliases) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    try appendDeclarations(self, output, result.table);
}

fn exportNames(allocator: std.mem.Allocator, self: *const Lower) Lower.Error![]const []const u8 {
    const names = try allocator.alloc([]const u8, self.program.exports.len);

    for (self.program.exports, names) |item, *name| name.* = item.name;

    return names;
}

fn context(comptime Bases: type, self: *const Lower) Bases {
    return .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };
}

fn publish(self: *Lower, output: *std.ArrayList(node.Declaration), result: anytype) Lower.Error!void {
    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.forms.*);
    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    try appendDeclarations(self, output, result.declarations);
}

fn appendDeclarations(self: *Lower, output: *std.ArrayList(node.Declaration), source: anytype) Lower.Error!void {
    @import("../../node/import_constants.zig").appendBorrowingText(self.allocator, output, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
