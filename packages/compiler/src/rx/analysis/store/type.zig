const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("../call/target.zig");
const Diagnostic = @import("../expression.zig").Diagnostic;
pub const Field = struct { object: []const u8, node: rx.ast.Node, type_id: zx.ir.TypeId };
pub const Value = union(enum) { resolved: struct { types: zx.ir.TypeTable, fields: []const Field }, diagnostic: Diagnostic };
const Entry = struct { object: []const u8, node: rx.ast.Node, attribute: rx.ast.Attribute, start: usize, end: usize, name_start: usize };

pub fn resolve(allocator: std.mem.Allocator, owner: []const u8, node: rx.ast.Node, context: frontend.Context, aliases: []const zx.ir.Export) std.mem.Allocator.Error!Value {
    var source: std.ArrayList(u8) = .empty;
    var entries: std.ArrayList(Entry) = .empty;

    for (node.children) |object| {
        if (!std.mem.eql(u8, object.name, "Object")) continue;

        for (object.children) |field| {
            const attribute = target.attribute(field, "type");
            const prefix = try std.fmt.allocPrint(allocator, "export type StoreValue{d} = ", .{entries.items.len});
            const name_start = source.items.len + "export type ".len;

            try source.appendSlice(allocator, prefix);

            const start = source.items.len;

            try source.appendSlice(allocator, attribute.value);

            const end = source.items.len;

            try source.append(allocator, '\n');
            try entries.append(allocator, .{ .object = target.attribute(object, "name").value, .node = field, .attribute = attribute, .start = start, .end = end, .name_start = name_start });
        }
    }

    if (context.types.count() != 0 and !frontend.validateTypes(context.types)) return .{ .diagnostic = try mapped(allocator, entries.items, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared Store type table" }) };
    if (!frontend.native_context.valid(context.types, context.native_modules)) return .{ .diagnostic = try mapped(allocator, entries.items, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared native module table" }) };

    var origins: @FieldType(frontend.project.artifact.type_link.Table, "origins") = .{ .allocator = allocator };

    origins.seed(context.types, context.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = try mapped(allocator, entries.items, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared nominal type table" }) };
    };

    for (aliases) |alias| {
        if (@backingInt(alias.type_id) >= context.types.count()) return .{ .diagnostic = try mapped(allocator, entries.items, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "Store type alias is missing from the shared type table" }) };
    }

    var parsed = try frontend.parseModule(allocator, source.items, owner);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| return .{ .diagnostic = try mapped(allocator, entries.items, issue) };

    return switch (parsed) {
        .native => |native| native: {
            const program = native.value.parsed.ast;

            if (program.imports.len != 0 or program.body != null or program.contracts.len != 0 or program.has_store) break :native invalid(allocator, entries.items);

            break :native resolveDeclarations(allocator, entries.items, context, aliases, frontend.type_views.Native{ .items = program.declarations });
        },
        .indexed => |indexed| if (comptime @TypeOf(indexed) != void) indexed: {
            const output = indexed.output;

            if (output.imports.len != 0 or output.body != null or output.contracts.len != 0 or output.has_store) break :indexed invalid(allocator, entries.items);

            break :indexed resolveDeclarations(allocator, entries.items, context, aliases, frontend.type_views.Indexed(@TypeOf(output)){ .source = indexed.source, .storage = output });
        } else unreachable,
    };
}

fn resolveDeclarations(allocator: std.mem.Allocator, entries: []const Entry, context: frontend.Context, aliases: []const zx.ir.Export, view: anytype) std.mem.Allocator.Error!Value {
    if (view.declarations().count() != entries.len) return invalid(allocator, entries);

    const storage = if (comptime @hasField(@TypeOf(view), "storage")) .{ .types = view.storage.types, .type_order = view.storage.type_order } else .{};
    const resolving = if (comptime @hasField(@TypeOf(view), "storage")) frontend.type_views.Indexed(@TypeOf(storage)){ .source = view.source, .storage = storage } else frontend.type_views.Native{ .items = &.{} };
    var reporter: zx.Reporter = .{};
    var types = frontend.types{ .allocator = allocator, .reporter = &reporter, .declarations = &.{}, .aliases = aliases };

    try types.items.appendDelta(allocator, try frontend.type_table.copy(allocator, context.types));

    types.initialize() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = try mapped(allocator, entries, reporter.diagnostic.?) };
    };

    const fields = try allocator.alloc(Field, entries.len);
    var declarations = view.declarations().iterator();

    for (entries, fields, 0..) |entry, *field, index| {
        const declaration = declarations.next().?;
        const name = try std.fmt.allocPrint(allocator, "StoreValue{d}", .{index});

        if (declaration.name.span.start != entry.name_start or !std.mem.eql(u8, declaration.name.text, name)) return invalid(allocator, entries);

        const id = types.resolveView(resolving, declaration.value) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return .{ .diagnostic = try mapped(allocator, entries, reporter.diagnostic.?) };
        };

        if (id == frontend.types.scalarId(.void)) return .{ .diagnostic = try mapped(allocator, entries, .{ .code = .type_mismatch, .span = .{ .start = entry.start, .end = entry.start }, .message = "Store fields cannot have void type" }) };

        field.* = .{ .object = entry.object, .node = entry.node, .type_id = id };
    }

    return .{ .resolved = .{ .types = types.items.view(), .fields = fields } };
}

fn invalid(allocator: std.mem.Allocator, entries: []const Entry) std.mem.Allocator.Error!Value {
    return .{ .diagnostic = try mapped(allocator, entries, .{ .code = .syntax, .span = .{ .start = entries[0].start, .end = entries[0].start }, .message = "Field.type must contain exactly one ZX type expression" }) };
}

fn mapped(allocator: std.mem.Allocator, entries: []const Entry, issue: zx.Diagnostic) std.mem.Allocator.Error!Diagnostic {
    var entry = entries[0];

    for (entries) |candidate| {
        if (candidate.start > issue.span.start) break;

        entry = candidate;
    }

    const offset = @min(issue.span.start -| entry.start, entry.end - entry.start);
    const location = rx.attributeLocation(entry.attribute, offset) orelse entry.attribute.value_location;

    return .{ .location = location, .issue = .{ .code = issue.code, .span = .{ .start = location.offset, .end = location.offset }, .message = try allocator.dupe(u8, issue.message) } };
}
