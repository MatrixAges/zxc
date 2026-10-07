const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const link = compiler.project.artifact.type_link;
pub const Origins = @FieldType(link.Table, "origins");
pub const Origin = Origins.Origin;
pub const Ids = struct { plain: ir.TypeId, mode: ir.TypeId, node: ir.TypeId, errors: ir.TypeId, pair: ir.TypeId, saved: ir.TypeId, list: ir.TypeId, record: ir.TypeId, task: ir.TypeId };
pub const Change = enum { none, tuple_tail, object_name, object_type, errors, task_result, task_errors, plain_kind };

pub const Options = struct {
    noise: bool = false,
    aliases: bool = false,
    mode_native: bool = false,
    mode_name: []const u8 = "Mode",
    members: []const []const u8 = &.{ "First", "Second" },
    mode_origin: Origin = .{ .source = "/source/types.zx" },
    native_name: []const u8 = "Node",
    native_owner: []const u8 = "zig:fixture",
    change: Change = .none,
};

pub const Source = struct {
    table: link.Table,
    ids: Ids,
    aliases: ?Ids,
    options: Options,
    module: compiler.project.artifact.Module,
    pub fn poison(self: *Source) void {
        inline for (@typeInfo(ir.TypeStorage).@"struct".field_names) |name| {
            const column = @field(self.table.items, name).items;

            if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
                for (column) |value| if (value.len != 0) @memset(@constCast(value), '?');
            } else @memset(column, 255);
        }

        inline for (@typeInfo(@TypeOf(self.table.origins.items)).@"struct".field_names) |name| {
            const column = @field(self.table.origins.items, name).items;

            if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
                for (column) |value| if (value.len != 0) @memset(@constCast(value), '?');
            } else @memset(column, 255);
        }
    }
};

pub fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(value)));
}

fn word(memory: std.mem.Allocator, value: []const u8) ![]const u8 {
    return memory.dupe(u8, value);
}

fn origin(memory: std.mem.Allocator, value: Origin) !Origin {
    return switch (value) {
        .source => |owner| .{ .source = try word(memory, owner) },
        .native => |owner| .{ .native = try word(memory, owner) },
        .external => |entry| .{ .external = .{ .module = try word(memory, entry.module), .member = try word(memory, entry.member) } },
    };
}

fn strings(memory: std.mem.Allocator, values: []const []const u8) ![]const []const u8 {
    const result = try memory.alloc([]const u8, values.len);

    for (values, result) |value, *item| item.* = try word(memory, value);

    return result;
}

fn add(table: *link.Table, value: ir.TypeValue, owner: ?Origin) !ir.TypeId {
    const id: ir.TypeId = @fromBackingInt(@intCast(table.items.count()));

    try table.items.append(table.allocator, value);
    if (owner) |item| try table.origins.items.append(table.allocator, .{ .type_id = id, .origin = try origin(table.allocator, item), .name = value.nominalName().? });

    return id;
}

fn family(table: *link.Table, options: Options, shared_node: ?ir.TypeId) !Ids {
    const memory = table.allocator;
    const plain = try add(table, if (options.change == .plain_kind) .{ .list = scalar(.u64) } else .{ .optional = scalar(.u64) }, null);
    const mode = try add(table, if (options.mode_native) .{ .native_reference = try word(memory, options.mode_name) } else .{ .enumeration = .{ .name = try word(memory, options.mode_name), .members = try strings(memory, options.members) } }, options.mode_origin);
    const node = shared_node orelse try add(table, .{ .native_reference = try word(memory, options.native_name) }, .{ .native = options.native_owner });
    const errors = try add(table, .{ .error_set = try strings(memory, if (options.change == .errors) &.{ "Read", "Zero" } else &.{ "Read", "Write" }) }, null);
    const pair = try add(table, .{ .tuple = &.{ mode, node, scalar(if (options.change == .tuple_tail) .bool else .u64) } }, null);
    const saved = try add(table, .{ .optional = pair }, null);
    const list = try add(table, .{ .list = saved }, null);
    const record = try add(table, .{ .object = .{ .names = try strings(memory, if (options.change == .object_name) &.{ "items", "mode", "node", "stored" } else &.{ "items", "mode", "node", "saved" }), .types = &.{ @backingInt(list), @backingInt(mode), @backingInt(node), @backingInt(if (options.change == .object_type) saved else plain) }, .len = 4 } }, null);
    const task_errors = if (options.change == .task_errors) try add(table, .{ .error_set = try strings(memory, &.{"Alpha"}) }, null) else errors;
    const task = try add(table, .{ .task = .{ .result = if (options.change == .task_result) pair else record, .errors = task_errors } }, null);

    return .{ .plain = plain, .mode = mode, .node = node, .errors = errors, .pair = pair, .saved = saved, .list = list, .record = record, .task = task };
}

pub fn source(memory: std.mem.Allocator, options: Options) !Source {
    var table = try link.Table.init(memory);

    if (options.noise) {
        _ = try add(&table, .{ .enumeration = .{ .name = try word(memory, "Noise"), .members = try strings(memory, &.{"Value"}) } }, .{ .source = "/source/noise.zx" });
        _ = try add(&table, .{ .tuple = &.{ scalar(.string), scalar(.bool) } }, null);
    }

    const ids = try family(&table, options, null);
    const aliases = if (options.aliases) try family(&table, options, ids.node) else null;
    var modules: std.ArrayList(ir.NativeModule) = .empty;

    for (0..table.items.count()) |index| {
        const value = table.items.view().at(index);

        if (value != .native_reference) continue;

        const native_origin = for (0..table.origins.items.view().count()) |position| {
            const item = table.origins.items.view().at(position);

            if (@backingInt(item.type_id) == index) break item.origin.native;
        } else return error.MissingFixtureOrigin;

        const bindings = try memory.alloc(ir.Export, 1);

        bindings[0] = .{ .name = value.native_reference, .type_id = @fromBackingInt(@intCast(index)) };

        try modules.append(memory, .{ .specifier = native_origin, .import_name = try std.fmt.allocPrint(memory, "native_{d}", .{index}), .types = bindings });
    }

    const module: compiler.project.artifact.Module = .{
        .path = try word(memory, "/source/module.zx"),
        .source_digest = @splat(7),
        .dependencies = &.{},
        .types = table.items.view(),
        .nominal_types = table.origins.items.view(),
        .exports = &.{},
        .type_imports = &.{},
        .function_imports = &.{},
        .functions = &.{},
        .native_modules = try modules.toOwnedSlice(memory),
        .function = null,
        .stores = .{},
    };

    try std.testing.expect(module.types.validStructure());
    try std.testing.expectEqual(null, try compiler.validateIr(memory, .{ .file_name = module.path, .types = module.types, .symbols = .{}, .expressions = .{}, .input_type = scalar(.void), .output_type = scalar(.void), .body = .{}, .type_only = true, .native_modules = module.native_modules }));

    return .{ .table = table, .ids = ids, .aliases = aliases, .options = options, .module = module };
}

pub fn copyColumns(memory: std.mem.Allocator, value: anytype) !@TypeOf(value) {
    var result: @TypeOf(value) = .{};

    inline for (@typeInfo(@TypeOf(value)).@"struct".field_names) |name| {
        const column = @field(value, name);
        const copied = try memory.dupe(@typeInfo(@TypeOf(column)).pointer.child, column);

        if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
            for (column, copied) |text, *item| item.* = try word(memory, text);
        }

        @field(result, name) = copied;
    }

    return result;
}

pub fn sameColumns(left: anytype, right: @TypeOf(left)) !void {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const before = @field(left, name);
        const after = @field(right, name);

        try std.testing.expectEqual(before.len, after.len);

        if (@typeInfo(@TypeOf(before)).pointer.child == []const u8) {
            for (before, after) |a, b| try std.testing.expectEqualStrings(a, b);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(before)).pointer.child, before, after);
    }
}
