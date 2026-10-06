const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Native = @import("root.zig").Native;

pub fn create(builder: Builder, path: []const u8, public_name: ?[]const u8, link_libc: ?bool) std.mem.Allocator.Error!*const node.Expression {
    var fields: std.ArrayList(node.Field) = .empty;

    try fields.appendSlice(builder.allocator, &.{
        .{ .name = "root_source_file", .value = try buildPath(builder, path) },
        .{ .name = "target", .value = try builder.identifier("target") },
        .{ .name = "optimize", .value = try builder.identifier("optimize") },
    });

    if (link_libc) |enabled| try fields.append(builder.allocator, .{ .name = "link_libc", .value = try builder.expression(.{ .boolean = enabled }) });

    const options = try builder.object(fields.items);

    if (public_name) |name| return builder.call(try builder.path(&.{ "b", "addModule" }), &.{ try builder.string(name), options });

    return builder.call(try builder.path(&.{ "b", "createModule" }), &.{options});
}

pub fn native(builder: Builder, body: *std.ArrayList(node.Statement), value: Native, index: usize, module: *const node.Expression, abi: *const node.Expression) std.mem.Allocator.Error!void {
    const allocator = builder.allocator;

    if (value.header != null and value.path == null) {
        const name = try std.fmt.allocPrint(allocator, "translated_{d}", .{index});
        const translated = try builder.identifier(name);
        const header = try std.fmt.allocPrint(allocator, "native/{s}.h", .{value.name});

        const options = try builder.object(&.{
            .{ .name = "root_source_file", .value = try buildPath(builder, header) },
            .{ .name = "target", .value = try builder.identifier("target") },
            .{ .name = "optimize", .value = try builder.identifier("optimize") },
        });

        try body.append(allocator, .{ .constant = .{ .name = name, .value = try builder.call(try builder.path(&.{ "b", "addTranslateC" }), &.{options}) } });
        try includes(builder, body, translated, value.include_paths);
        try body.append(allocator, try addImport(builder, module, "zxc_c", try builder.call(try builder.field(translated, "createModule"), &.{})));
    }

    if (value.abi_view) |path| {
        const name = try std.fmt.allocPrint(allocator, "view_{d}", .{index});
        const view = try builder.identifier(name);

        try body.append(allocator, .{ .constant = .{ .name = name, .value = try create(builder, path, null, null) } });
        try body.append(allocator, try addImport(builder, view, "zxc_abi_canonical", abi));
        try body.append(allocator, try addImport(builder, module, "zxc_abi", view));
    } else try body.append(allocator, try addImport(builder, module, "zxc_abi", abi));

    try includes(builder, body, module, value.include_paths);
}

pub fn addImport(builder: Builder, module: *const node.Expression, name: []const u8, target: *const node.Expression) std.mem.Allocator.Error!node.Statement {
    return .{ .expression = try builder.call(try builder.field(module, "addImport"), &.{ try builder.string(name), target }) };
}

fn buildPath(builder: Builder, path: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return builder.call(try builder.path(&.{ "b", "path" }), &.{try builder.string(path)});
}

fn includes(builder: Builder, body: *std.ArrayList(node.Statement), module: *const node.Expression, paths: []const []const u8) std.mem.Allocator.Error!void {
    for (paths) |path| {
        const value = if (std.fs.path.isAbsolute(path)) try builder.object(&.{.{ .name = "cwd_relative", .value = try builder.string(path) }}) else try buildPath(builder, path);

        try body.append(builder.allocator, .{ .expression = try builder.call(try builder.field(module, "addIncludePath"), &.{value}) });
    }
}
