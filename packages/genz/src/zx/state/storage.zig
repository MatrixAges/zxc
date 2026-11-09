const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;

pub fn writable(objects: []const Object) bool {
    if (@import("genz_options").generated_analysis) return policy(objects) != .ReadOnly;
    for (objects) |object| if (object.writable) return true;

    return false;
}

pub fn reclaimable(objects: []const Object) bool {
    if (@import("genz_options").generated_analysis) return policy(objects) == .Independent;
    for (objects) |object| if (object.writable and !object.independent) return false;

    return writable(objects);
}

fn policy(objects: []const Object) @typeInfo(@typeInfo(@TypeOf(@import("generated_store_lifecycle_policy").executeValue)).@"fn".return_type.?).error_union.payload {
    const entry = @import("generated_store_lifecycle_policy");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .objects = @import("zx").columns.slice(@FieldType(Input, "objects"), objects),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return entry.executeValue(memory.allocator(), if (indirect) &input else input) catch unreachable;
}

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const Object) std.mem.Allocator.Error!void {
    const allocator = builder.allocator;

    for ([_][]const u8{ "std", "application" }) |name| {
        try declarations.append(allocator, .{ .constant = .{ .name = name, .value = try builder.builtin(.import, &.{try builder.string(name)}) } });
    }

    try declarations.append(allocator, .{ .constant = .{ .name = "Self", .value = try builder.builtin(.This, &.{}) } });

    for (objects, 0..) |object, index| {
        try declarations.append(allocator, .{ .constant = .{ .name = try std.fmt.allocPrint(allocator, "initial_{d}", .{index}), .value = try builder.builtin(.import, &.{try builder.string(object.module_name)}) } });
    }

    const enabled = reclaimable(objects);

    try declarations.append(allocator, .{ .constant = .{ .name = "can_release_retired", .value = try builder.expression(.{ .boolean = enabled }), .exported = true } });
    if (enabled) try declarations.append(allocator, .{ .field = .{ .name = "release_disabled", .value = try builder.expression(.{ .primitive = .bool }), .default_value = try builder.expression(.{ .boolean = false }) } });
    try declarations.append(allocator, .{ .field = .{ .name = "arena", .value = try builder.expression(.{ .pointer = try builder.path(&.{ "std", "heap", "ArenaAllocator" }) }) } });

    const region = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.identifier("Region") }) });
    const nil = try builder.expression(.null_value);

    if (writable(objects)) try declarations.append(allocator, .{ .field = .{ .name = "retained", .value = region, .default_value = nil } });

    for (objects, 0..) |object, index| {
        if (enabled and object.writable) try declarations.append(allocator, .{ .field = .{ .name = try std.fmt.allocPrint(allocator, "owner_{d}", .{index}), .value = region, .default_value = nil } });

        const output = try builder.field(try builder.identifier(try std.fmt.allocPrint(allocator, "initial_{d}", .{index})), "Output");
        const undefined_value = try builder.expression(.undefined_value);

        try declarations.append(allocator, .{ .field = .{ .name = try std.fmt.allocPrint(allocator, "value_{d}", .{index}), .value = output, .default_value = undefined_value } });
        try declarations.append(allocator, .{ .field = .{ .name = try std.fmt.allocPrint(allocator, "store_{d}", .{index}), .value = try builder.expression(.{ .pointer = output }), .default_value = undefined_value } });
    }
}
