const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_constant_fold");
const borrow = @import("../../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);

pub const TypedValue = struct {
    type_id: zx.ir.TypeId,
    value: zx.ir.ConstantValue,
};

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { constant: TypedValue, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn evaluate(allocator: std.mem.Allocator, program: zx.ir.Program, root: zx.ir.ExprId) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();

    if (try @import("../../ir/validate.zig").validate(allocator, program)) |issue| {
        defer issue.deinit();

        return .{ .arena = arena, .value = .{ .diagnostic = try issue.clone(owned) } };
    }

    var scratch = zx.Arena.init(allocator);

    defer scratch.deinit();

    const expressions = borrow.columns(std.meta.Child(@FieldType(Input, "expressions")), program.expressions);
    const input = Input{ .expressions = &expressions, .root = @backingInt(root) };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return .{ .arena = arena, .value = .{ .diagnostic = .{
            .code = .contract,
            .span = .{ .start = 0, .end = 0 },
            .message = try std.fmt.allocPrint(owned, "internal compiler error: constant evaluation failed with {s}", .{@errorName(err)}),
        } } },
    };

    if (output.diagnostic.message.len != 0) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .span = .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        .message = try owned.dupe(u8, output.diagnostic.message),
    } } };

    const value = output.value orelse return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "internal compiler error: constant evaluation produced no value",
    } } };

    const literal: zx.ir.ConstantValue = switch (value.kind) {
        .Integer => if (value.negative) .{ .negative_integer = value.integer } else .{ .integer = value.integer },
        .Float => .{ .float = value.floating },
        .String => .{ .string = try owned.dupe(u8, value.text) },
        .Boolean => .{ .boolean = value.boolean },
        .EnumValue => .{ .enumeration = value.enumeration },
        else => unreachable,
    };

    return .{ .arena = arena, .value = .{ .constant = .{ .type_id = @fromBackingInt(value.type_id), .value = literal } } };
}
