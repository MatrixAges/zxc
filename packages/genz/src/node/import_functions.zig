const std = @import("std");
const node = @import("../node.zig");
const Tag = std.meta.Tag(node.Declaration);
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

/// Declaration and parameter text must outlive the target; field records receive owned storage.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), source: anytype, parameters: anytype) Error!void {
    const count = source.tags.len;
    const Fields = std.meta.Child(@TypeOf(source));
    const parameter_count = parameters.name.len;

    if (parameters.value.len != parameter_count or parameters.default_value.len != parameter_count or parameters.comptime_parameter.len != parameter_count) return error.InvalidAst;

    inline for (@typeInfo(Fields).@"struct".field_names) |name| {
        if (@field(source, name).len != count) return error.InvalidAst;
    }

    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;

    for (source.tags, source.offsets) |tag, offset| {
        if (@backingInt(tag) != @backingInt(Tag.function) or offset >= count) return error.InvalidAst;

        const first = source.function_parameters_start[offset];
        const length = source.function_parameters_len[offset];

        if (first > parameter_count or length > parameter_count - first) return error.InvalidAst;
    }

    try target.ensureUnusedCapacity(allocator, count);

    for (source.offsets) |offset| {
        const first: usize = source.function_parameters_start[offset];
        const values = try allocator.alloc(node.Field, source.function_parameters_len[offset]);

        for (values, first..) |*value, index| value.* = .{
            .name = parameters.name[index],
            .value = @fromBackingInt(parameters.value[index]),
            .default_value = if (parameters.default_value[index]) |id| @fromBackingInt(id) else null,
            .comptime_parameter = parameters.comptime_parameter[index],
        };

        target.appendAssumeCapacity(.{ .function = .{
            .name = source.function_name[offset],
            .parameters = values,
            .return_type = @fromBackingInt(source.function_return_type[offset]),
            .body = .{ .start = source.function_body_start[offset], .len = source.function_body_len[offset] },
            .exported = source.function_exported[offset],
            .abi_export = source.function_abi_export[offset],
            .inlined = source.function_inlined[offset],
            .calling_convention = if (source.function_calling_convention[offset]) |id| @fromBackingInt(id) else null,
        } });
    }
}
