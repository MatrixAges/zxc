const std = @import("std");
const genz = @import("genz");
const node = genz.node;
const Module = @import("partition.zig").Module;

pub fn root(allocator: std.mem.Allocator, modules: []const Module, panic_handler: bool) ![]const u8 {
    const builder = try genz.Builder.init(allocator);
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for (modules) |module| try declarations.append(allocator, .{ .constant = .{
        .name = module.name,
        .exported = true,
        .value = try builder.builtin(.import, &.{try builder.string(module.file)}),
    } });

    if (panic_handler) try declarations.append(allocator, .{ .comptime_scope = try builder.statements(&.{.{
        .expression = try builder.call(try builder.field(try builder.builtin(.import, &.{try builder.string("zxc_bridge")}), "exportPanic"), &.{}),
    }}) });

    return genz.render(allocator, builder.nodes, declarations.items);
}

pub fn stub(allocator: std.mem.Allocator, file: []const u8, variants: []const []const u8, comptime_entry: bool) ![]const u8 {
    const builder = try genz.Builder.init(allocator);
    var declarations: std.ArrayList(node.Declaration) = .empty;
    const bridge = try builder.identifier("bridge");
    const signatures = try builder.identifier("signatures");
    const function_name = std.fs.path.stem(file);

    try declarations.appendSlice(allocator, &.{
        .{ .constant = .{ .name = "bridge", .value = try builder.builtin(.import, &.{try builder.string("zxc_bridge")}) } },
        .{ .constant = .{ .name = "signatures", .value = try builder.builtin(.import, &.{try builder.string(if (comptime_entry) "zxc_comptime" else "zxc_signatures")}) } },
    });

    for (variants) |variant| try declarations.append(allocator, .{ .constant = .{
        .name = variant,
        .exported = true,
        .value = try builder.call(try builder.field(bridge, if (comptime_entry) "importComptime" else "import"), &.{
            try builder.field(try builder.field(signatures, function_name), variant),
            try builder.string(try symbol(allocator, file, variant)),
        }),
    } });

    return genz.render(allocator, builder.nodes, declarations.items);
}

fn symbol(allocator: std.mem.Allocator, file: []const u8, variant: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}_{s}", .{ std.fs.path.stem(file), variant });
}

pub fn exports(allocator: std.mem.Allocator, entries: []const @import("partition.zig").Export) ![]const u8 {
    const builder = try genz.Builder.init(allocator);
    const bridge = try builder.identifier("bridge");
    const functions = try builder.identifier("functions");
    var statements: std.ArrayList(node.Statement) = .empty;

    for (entries) |entry| {
        const imported = try builder.field(functions, std.fs.path.stem(entry.file));
        const symbol_name = try symbol(allocator, entry.file, entry.variant);

        try statements.append(allocator, .{ .expression = try builder.call(try builder.field(bridge, "exportAs"), &.{
            try builder.field(imported, entry.variant),
            try builder.string(symbol_name),
        }) });
    }

    return genz.render(allocator, builder.nodes, &.{
        .{ .constant = .{ .name = "bridge", .value = try builder.builtin(.import, &.{try builder.string("zxc_bridge")}) } },
        .{ .constant = .{ .name = "functions", .value = try builder.builtin(.import, &.{try builder.string("zxc_functions")}) } },
        .{ .constant = .{ .name = "panic", .exported = true, .value = try builder.field(bridge, "Panic") } },
        .{ .comptime_scope = try builder.statements(statements.items) },
    });
}
