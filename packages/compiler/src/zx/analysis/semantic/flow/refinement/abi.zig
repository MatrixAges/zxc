const std = @import("std");
const ir = @import("zx").ir;
const borrow = @import("../../../../ir/canonical/borrow.zig");

pub fn Input(comptime generated: type) type {
    return @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
}

pub fn Output(comptime generated: type) type {
    return @typeInfo(@typeInfo(@TypeOf(generated.executeValue)).@"fn".return_type.?).error_union.payload;
}

pub fn facts(comptime Target: type, source: anytype) Target {
    return .{ .nonnull = source.nonnull, .projected = source.projected, .capture_errors = source.capture_errors, .capture_results = source.capture_results };
}

pub fn expressions(comptime generated: type, source: *const ir.ExpressionTable) @FieldType(Input(generated), "expressions") {
    const Plain = std.meta.Child(generated.Input);
    const columns = borrow.pointer(@FieldType(Plain, "expressions"), source);
    const Target = @FieldType(Input(generated), "expressions");

    if (@typeInfo(Target) == .pointer) return columns;

    var result: Target = undefined;

    inline for (@typeInfo(Target).@"struct".field_names) |name| {
        @field(result, name) = if (comptime std.mem.eql(u8, name, "zx_origin")) columns else @field(columns.*, name);
    }

    return result;
}

pub fn read(comptime generated: type, input: Input(generated)) Output(generated) {
    var storage: [0]u8 = .{};
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    return generated.executeValue(fixed.allocator(), input) catch unreachable;
}
