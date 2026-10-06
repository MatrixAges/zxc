const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const modules = @import("modules.zig");
pub const Module = struct { name: []const u8, path: []const u8, dependencies: []const []const u8 };

pub const Native = struct {
    name: []const u8,
    path: ?[]const u8,
    header: ?[]const u8,
    dependencies: []const []const u8,
    include_paths: []const []const u8,
    abi_view: ?[]const u8,
};

pub const Options = struct {
    native: []const Native,
    generated: []const Module,
    public: []const Module,
    libraries: []const []const u8,
    library_paths: []const []const u8,
};

pub const Error = std.mem.Allocator.Error || error{UnknownModuleDependency};

pub fn render(allocator: std.mem.Allocator, options: Options) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const memory = builder.allocator;
    var body: std.ArrayList(node.Statement) = .empty;
    var names: std.StringHashMapUnmanaged(*const node.Expression) = .empty;
    const abi = try builder.identifier("abi");

    try body.appendSlice(memory, &.{
        .{ .constant = .{ .name = "target", .value = try builder.call(try builder.path(&.{ "b", "standardTargetOptions" }), &.{try builder.object(&.{})}) } },
        .{ .constant = .{ .name = "optimize", .value = try builder.call(try builder.path(&.{ "b", "standardOptimizeOption" }), &.{try builder.object(&.{})}) } },
        .{ .constant = .{ .name = "abi", .value = try modules.create(builder, "abi.zig", null, null) } },
    });

    for (options.native, 0..) |native, index| {
        const name = try std.fmt.allocPrint(memory, "native_{d}", .{index});
        const module = try builder.identifier(name);
        const path = native.path orelse try std.fmt.allocPrint(memory, "native/{s}.zig", .{native.name});

        try body.append(memory, .{ .constant = .{ .name = name, .value = try modules.create(builder, path, null, native.header != null) } });
        try names.put(memory, native.name, module);
        try modules.native(builder, &body, native, index, module, abi);
    }

    for (options.generated, 0..) |generated, index| {
        const name = try std.fmt.allocPrint(memory, "generated_{d}", .{index});
        const module = try builder.identifier(name);

        try body.append(memory, .{ .constant = .{ .name = name, .value = try modules.create(builder, generated.path, null, null) } });
        try body.append(memory, try modules.addImport(builder, module, "zxc_abi", abi));
        try names.put(memory, generated.name, module);
    }

    for (options.generated) |generated| try dependencies(builder, &body, names, names.get(generated.name).?, generated.dependencies, false);
    for (options.native) |native| try dependencies(builder, &body, names, names.get(native.name).?, native.dependencies, true);

    for (options.public, 0..) |public, index| {
        const name = try std.fmt.allocPrint(memory, "public_{d}", .{index});
        const module = try builder.identifier(name);

        try body.append(memory, .{ .constant = .{ .name = name, .value = try modules.create(builder, public.path, public.name, null) } });
        try body.append(memory, try modules.addImport(builder, module, "zxc_abi", abi));
        try dependencies(builder, &body, names, module, public.dependencies, false);
        for (options.libraries) |library| try body.append(memory, .{ .expression = try builder.call(try builder.field(module, "linkSystemLibrary"), &.{ try builder.string(library), try builder.object(&.{}) }) });
        for (options.library_paths) |path| try body.append(memory, .{ .expression = try builder.call(try builder.field(module, "addLibraryPath"), &.{try builder.object(&.{.{ .name = "cwd_relative", .value = try builder.string(path) }})}) });
    }

    return @import("../../render.zig").render(allocator, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .function = .{
            .name = "build",
            .parameters = try memory.dupe(node.Field, &.{.{ .name = "b", .value = try builder.expression(.{ .pointer = try builder.path(&.{ "std", "Build" }) }) }}),
            .return_type = try builder.expression(.{ .primitive = .void }),
            .body = try body.toOwnedSlice(memory),
            .exported = true,
        } },
    });
}

fn dependencies(builder: Builder, body: *std.ArrayList(node.Statement), names: std.StringHashMapUnmanaged(*const node.Expression), module: *const node.Expression, values: []const []const u8, aliases: bool) Error!void {
    for (values) |value| {
        const separator = if (aliases) std.mem.indexOfScalar(u8, value, '=') else null;
        const alias = if (separator) |index| value[0..index] else value;
        const target = if (separator) |index| value[index + 1 ..] else value;

        try body.append(builder.allocator, try modules.addImport(builder, module, alias, names.get(target) orelse return error.UnknownModuleDependency));
    }
}
