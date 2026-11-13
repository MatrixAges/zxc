const std = @import("std");
const zx = @import("zx");
const Context = @import("binding/context.zig");
const FunctionImport = @import("function_import.zig");
pub const Members = @import("binding/members.zig");
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
    const members: Members = .{ .default = if (context.default_member) |*member| member else null, .named = context.members };
    const functions = if (item.kind == .type_only) &.{} else try members.names(temporary);
    const symbols = Symbols{ .target = context.target, .types = context.types, .exports = context.exports, .constants = context.constant_exports, .functions = functions };
    const selected = try select(temporary, allocator, item, &symbols, reporter);

    try publishTypes(allocator, selected, context.exports, context.constant_exports, aliases, constants);
    try publishFunctions(allocator, selected, members, imports);
}

pub fn publishTypes(allocator: std.mem.Allocator, selected: Selection, exports: []const zx.ir.Export, values: []const zx.ir.Constant, aliases: *std.ArrayList(zx.ir.Export), constants: *std.ArrayList(zx.ir.Constant)) std.mem.Allocator.Error!void {
    try aliases.ensureUnusedCapacity(allocator, selected.aliases.names.len);

    for (selected.aliases.names, selected.aliases.indices) |name, index| {
        aliases.appendAssumeCapacity(.{ .name = try allocator.dupe(u8, name), .type_id = exports[@intCast(index)].type_id });
    }

    try constants.ensureUnusedCapacity(allocator, selected.constants.names.len);

    for (selected.constants.names, selected.constants.indices) |name, index| {
        var constant = values[@intCast(index)];

        constant.name = try allocator.dupe(u8, name);

        if (constant.value == .string) constant.value.string = try allocator.dupe(u8, constant.value.string);

        constants.appendAssumeCapacity(constant);
    }
}

pub fn publishFunctions(allocator: std.mem.Allocator, selected: Selection, members: Members, imports: *std.ArrayList(FunctionImport)) std.mem.Allocator.Error!void {
    const namespace = if (selected.functions.names.len != 0 and selected.namespace != null) try allocator.dupe(u8, selected.namespace.?) else null;

    try imports.ensureUnusedCapacity(allocator, selected.functions.names.len);

    for (selected.functions.names, selected.functions.indices) |name, index| {
        var imported = members.at(@intCast(index)).*;
        imported.name = try allocator.dupe(u8, name);
        imported.namespace = namespace;

        imports.appendAssumeCapacity(imported);
    }
}
