const std = @import("std");
const zx = @import("zx");
const Parsed = @import("../../../frontend/expression_result.zig").Indexed;
const Options = @import("../../expression.zig").Options;
const Result = @import("../../analyze.zig").Result;
const generated = @import("generated_expression_analysis");
const borrow = @import("../../../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);

pub fn compile(allocator: std.mem.Allocator, parsed: Parsed, options: Options, comptime linking: bool) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: zx.Reporter = .{};

    const program = build(arena.allocator(), parsed, options, linking, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program } };
}

fn build(allocator: std.mem.Allocator, parsed: Parsed, options: Options, comptime linking: bool, reporter: *zx.Reporter) zx.Error!zx.ir.Program {
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const names = try scratch.allocator().alloc([]const u8, options.bindings.len);
    const ids = try scratch.allocator().alloc(u32, options.bindings.len);

    for (options.bindings, names, ids) |binding, *name, *id| {
        name.* = binding.name;
        id.* = @backingInt(binding.type_id);
    }

    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "type_base")), options.types);

    const input = Input{
        .bytes = parsed.source,
        .syntax = borrow.pointer(@FieldType(Input, "syntax"), parsed.output),
        .type_base = &types,
        .binding_names = names,
        .binding_types = ids,
        .unit_bindings = options.unit_bindings,
        .nonnull_bindings = options.nonnull_bindings,
        .expected = if (options.expected) |expected| @backingInt(expected) else null,
        .linking = linking,
        .scalar_count = std.enums.values(zx.ir.Scalar).len,
        .maximum_type_count = std.math.maxInt(u32),
    };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated expression analysis failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try allocator.dupe(u8, output.diagnostic.message),
    );

    return @import("publish.zig").apply(allocator, output, options, parsed.file_name);
}
