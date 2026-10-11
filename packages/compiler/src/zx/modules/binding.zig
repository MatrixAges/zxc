const std = @import("std");
const zx = @import("zx");
const Context = @import("binding/context.zig");
const FunctionImport = @import("function_import.zig");

pub fn apply(allocator: std.mem.Allocator, item: anytype, context: Context, reporter: *zx.Reporter, aliases: *std.ArrayList(zx.ir.Export), imports: *std.ArrayList(FunctionImport)) zx.Error!void {
    if (!@import("parser_options").generated_parser) return @import("binding/seed.zig").apply(allocator, item, context, reporter, aliases, imports);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input = try @import("binding/input.zig").init(arena.allocator(), item, context);

    const output = @import("generated_project_binding").executeValue(arena.allocator(), input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, item.span, try std.fmt.allocPrint(allocator, "internal compiler error: generated import binding failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return reporter.fail(
        .module,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try allocator.dupe(u8, output.diagnostic.message),
    );

    for (output.aliases.names, output.aliases.ids) |name, id| {
        try aliases.append(allocator, .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(id) });
    }

    for (output.imports.names, 0..) |name, index| {
        try imports.append(allocator, .{
            .namespace = if (output.imports.namespaces[index]) |namespace| try allocator.dupe(u8, namespace) else null,
            .name = if (context.target == .native) name else try allocator.dupe(u8, name),
            .id = @fromBackingInt(output.imports.ids[index]),
            .input_type = @fromBackingInt(output.imports.input_types[index]),
            .output_type = @fromBackingInt(output.imports.output_types[index]),
        });
    }
}
