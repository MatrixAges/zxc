const std = @import("std");
const zx = @import("zx");
const NativeParsed = @import("../../../frontend/parse_expression.zig").Parsed;
const Expression = @import("../../expression.zig");
const Options = Expression.Options;
const Result = @import("../../analyze.zig").Result;
const generated = @import("generated_expression_analysis");
const borrow = @import("../../../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);
const Mode = @FieldType(Input, "mode");

pub fn compile(allocator: std.mem.Allocator, parsed: anytype, options: Options, comptime linking: bool) std.mem.Allocator.Error!Result {
    return run(if (linking) .Linking else .Program, allocator, parsed, options);
}

pub fn analyze(allocator: std.mem.Allocator, parsed: NativeParsed, options: Options) std.mem.Allocator.Error!Expression.Result {
    return run(.Expression, allocator, parsed, options);
}

fn run(comptime mode: Mode, allocator: std.mem.Allocator, parsed: anytype, options: Options) std.mem.Allocator.Error!(if (mode == .Expression) Expression.Result else Result) {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    var reporter: zx.Reporter = .{};

    const output = execute(mode, &scratch, arena.allocator(), parsed, options, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    const publish = @import("publish.zig");

    if (mode == .Expression) {
        const value = try publish.expression(arena.allocator(), output, options);

        return .{ .arena = arena, .value = .{ .expression = value } };
    }

    const value = try publish.apply(arena.allocator(), output, options, parsed.file_name);

    return .{ .arena = arena, .value = .{ .ir = value } };
}

fn execute(comptime mode: Mode, scratch: *std.heap.ArenaAllocator, allocator: std.mem.Allocator, parsed: anytype, options: Options, reporter: *zx.Reporter) zx.Error!generated.Output {
    const names = try scratch.allocator().alloc([]const u8, options.bindings.len);
    const ids = try scratch.allocator().alloc(u32, options.bindings.len);

    for (options.bindings, names, ids) |binding, *name, *id| {
        name.* = binding.name;
        id.* = @backingInt(binding.type_id);
    }

    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "type_base")), options.types);

    const source = if (@TypeOf(parsed) == NativeParsed)
        try @import("../../analyzer/host/native/expression.zig").convert(scratch.allocator(), parsed.expression)

    else
        .{ .syntax = borrow.pointer(@FieldType(Input, "syntax"), parsed.output), .native = @as(@FieldType(Input, "native"), null) };

    const input = Input{
        .bytes = parsed.source,
        .syntax = source.syntax,
        .native = source.native,
        .type_base = &types,
        .binding_names = names,
        .binding_types = ids,
        .unit_bindings = options.unit_bindings,
        .nonnull_bindings = options.nonnull_bindings,
        .expected = if (options.expected) |expected| @backingInt(expected) else null,
        .mode = mode,
        .scalar_count = std.enums.values(zx.ir.Scalar).len,
        .maximum_type_count = std.math.maxInt(u32),
    };

    const output = generated.execute(scratch, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated expression analysis failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try allocator.dupe(u8, output.diagnostic.message),
    );

    return output;
}
