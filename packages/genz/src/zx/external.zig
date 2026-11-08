const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("external_seed.zig");

pub fn lower(self: *Lower, function: ir.Function, index: usize) Lower.Error!node.Declaration {
    if (!generated) return seed.lower(self, function, index);

    const entry = @import("generated_external_body");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const implementation = function.external.?;
    const row = @backingInt(function.input_type);
    var bases = context(Bases, self);

    bases.capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null;

    const input: Input = .{
        .native = self.native_names[@backingInt(implementation.module)],
        .member = implementation.member,
        .allocator_argument = implementation.allocator_argument,
        .io_argument = implementation.io_argument,
        .process_argument = implementation.process_argument,
        .expand_tuple = implementation.expand_tuple,
        .fallible = implementation.fallible,
        .input_kind = self.program.types.kinds[row],
        .input_scalar = self.program.types.first[row],
        .input_count = self.program.types.second[row],
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    @import("../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, result.expressions) catch |err| return failure(err);
    var body: std.ArrayList(node.Statement) = .empty;

    @import("../node/import_statements.zig").appendBorrowingText(self.allocator, &body, result.statements) catch |err| return failure(err);
    self.uses_allocator = result.uses_allocator;

    var declaration = try prototype(self, function, index);

    declaration.body = try self.builder.statements(body.items);

    return .{ .function = declaration };
}

pub fn prototype(self: *Lower, function: ir.Function, index: usize) Lower.Error!node.Function {
    if (!generated) return seed.prototype(self, function, index);

    const entry = @import("generated_external_prototype");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const implementation = function.external.?;
    const input_type = try self.typeExpr(function.input_type);
    const output_type = try self.typeExpr(function.output_type);
    var bases = context(Bases, self);

    bases.capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null;

    const input: Input = .{
        .index = @intCast(index),
        .input_type = @backingInt(input_type),
        .output_type = @backingInt(output_type),
        .io_argument = implementation.io_argument,
        .process_argument = implementation.process_argument,
        .fallible = implementation.fallible,
        .errors = implementation.errors,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(result.expressions.*, result.extra.*);

    @import("../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    return .{
        .name = try self.allocator.dupe(u8, result.name),
        .parameters = @import("../node/import_fields.zig").materializeBorrowingText(self.allocator, result.parameters) catch |err| return failure(err),
        .return_type = @fromBackingInt(result.return_type),
        .body = .{},
    };
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

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
