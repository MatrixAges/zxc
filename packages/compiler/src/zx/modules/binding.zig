const std = @import("std");
const zx = @import("zx");
const Context = @import("binding/context.zig");
const FunctionImport = @import("function_import.zig");
pub const Symbols = @import("binding/symbols.zig").Symbols;
pub const Selection = @import("binding/symbols.zig").Selection;

pub fn select(allocator: std.mem.Allocator, diagnostics: std.mem.Allocator, item: anytype, symbols: *const Symbols, reporter: *zx.Reporter) zx.Error!Selection {
    if (!@import("parser_options").generated_parser) return @import("binding/seed.zig").select(allocator, item, symbols, reporter);

    const input = try @import("binding/input.zig").init(allocator, item, symbols);

    const output = @import("generated_project_binding").executeValue(allocator, input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, item.span, try std.fmt.allocPrint(diagnostics, "internal compiler error: generated import binding failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return reporter.fail(
        .module,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try diagnostics.dupe(u8, output.diagnostic.message),
    );

    return .{
        .aliases = .{ .names = output.aliases.names, .indices = output.aliases.indices },
        .constants = .{ .names = output.constants.names, .indices = output.constants.indices },
        .functions = .{ .names = output.functions.names, .indices = output.functions.indices },
        .namespace = output.namespace,
    };
}

pub fn apply(allocator: std.mem.Allocator, temporary: std.mem.Allocator, item: anytype, context: Context, reporter: *zx.Reporter, aliases: *std.ArrayList(zx.ir.Export), imports: *std.ArrayList(FunctionImport), constants: *std.ArrayList(zx.ir.Constant)) zx.Error!void {
    const functions = try temporary.alloc([]const u8, context.members.len);

    for (context.members, functions) |value, *name| name.* = value.name;

    const symbols = Symbols{ .target = context.target, .types = context.types, .exports = context.exports, .constants = context.constant_exports, .functions = functions };
    const selected = try select(temporary, allocator, item, &symbols, reporter);

    for (selected.aliases.names, selected.aliases.indices) |name, index| {
        try aliases.append(allocator, .{ .name = try allocator.dupe(u8, name), .type_id = context.exports[@intCast(index)].type_id });
    }

    for (selected.functions.names, selected.functions.indices) |name, index| {
        var imported = context.members[@intCast(index)];
        imported.name = try allocator.dupe(u8, name);
        imported.namespace = if (selected.namespace) |namespace| try allocator.dupe(u8, namespace) else null;

        try imports.append(allocator, imported);
    }

    for (selected.constants.names, selected.constants.indices) |name, index| {
        var constant = try @import("../analysis/constants/copy.zig").copy(allocator, context.constant_exports[@intCast(index)]);

        constant.name = try allocator.dupe(u8, name);

        try constants.append(allocator, constant);
    }
}
