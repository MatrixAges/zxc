const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Builder = @import("../program/builder.zig");
const inlineValue = @import("../program/expression.zig").inlineValue;
pub const Field = struct { name: []const u8, type_id: zx.ir.TypeId, initial: zx.ir.Program };

pub fn build(allocator: std.mem.Allocator, owner: []const u8, source: []const Field, types: []const zx.ir.Type, reporter: *zx.Reporter) zx.Error!zx.ir.Program {
    var table = frontend.types{ .allocator = allocator, .reporter = reporter, .declarations = &.{} };

    try table.items.appendSlice(allocator, types);

    const fields = try allocator.alloc(zx.ir.TypeField, source.len);

    for (source, fields) |field, *item| item.* = .{ .name = try allocator.dupe(u8, field.name), .type_id = field.type_id };

    const output = try table.object(fields);
    var builder = Builder{ .allocator = allocator, .types = table.items.items, .native_modules = &.{} };
    const span = zx.Span{ .start = 0, .end = 0 };
    const input: zx.ir.TypeId = @enumFromInt(@intFromEnum(zx.ir.Scalar.void));

    _ = try builder.symbol("in", input, span);
    const evaluation = try allocator.alloc(zx.ir.ExprId, source.len);
    const values = try allocator.alloc(zx.ir.ObjectField, source.len);

    for (source, evaluation, values) |field, *evaluated, *value| {
        const id = inlineValue(&builder, field.initial) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return reporter.fail(.contract, span, "Store initializer expression cannot be linked");
        };

        const members = table.get(output).object;

        for (members, 0..) |member, index| {
            if (std.mem.eql(u8, member.name, field.name)) {
                value.* = .{ .index = @intCast(index), .value = id };

                break;
            }
        }

        evaluated.* = id;
    }

    const object = try builder.expression(.{ .type_id = output, .span = span, .value = .{ .object = .{ .fields = values, .evaluation = evaluation } } });

    var program = zx.ir.Program{
        .file_name = try allocator.dupe(u8, owner),
        .types = table.items.items,
        .symbols = builder.symbols.items,
        .expressions = builder.expressions.items,
        .input_type = input,
        .output_type = output,
        .body = try allocator.dupe(zx.ir.Statement, &.{.{ .result = object }}),
    };

    program.output_ownership = try frontend.analyzeOwnership(allocator, program, reporter);

    if (try frontend.validateIr(allocator, program)) |issue| return reporter.fail(issue.code, issue.span, issue.message);

    return program;
}
