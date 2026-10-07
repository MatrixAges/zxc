const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
const Self = @This();

storage: ir.TypeStorage = .{},
ids: struct { optional: usize, list: usize, tuple: usize, object: usize, errors: usize, enumeration: usize, native: usize, task: usize } = undefined,
pub fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(value)));
}

pub fn id(value: usize) ir.TypeId {
    return @fromBackingInt(@intCast(value));
}

pub fn init() !Self {
    var self: Self = .{};

    errdefer self.deinit();

    for (std.enums.values(ir.Scalar)) |value| _ = try self.add(.{ .scalar = value });

    self.ids.optional = try self.add(.{ .optional = scalar(.u64) });
    self.ids.list = try self.add(.{ .list = scalar(.u64) });
    self.ids.tuple = try self.add(.{ .tuple = &.{ scalar(.bool), scalar(.u64) } });
    self.ids.object = try self.add(.{ .object = .{ .names = &.{ "alpha", "omega" }, .types = &.{ @intCast(self.ids.optional), @intCast(self.ids.list) }, .len = 2 } });
    self.ids.errors = try self.add(.{ .error_set = &.{ "Alpha", "Zeta" } });
    self.ids.enumeration = try self.add(.{ .enumeration = .{ .name = "Mode", .members = &.{ "Zeta", "Alpha", "Middle" } } });
    self.ids.native = try self.add(.{ .native_reference = "Node" });
    self.ids.task = try self.add(.{ .task = .{ .result = id(self.ids.object), .errors = id(self.ids.errors) } });

    return self;
}

pub fn add(self: *Self, value: ir.TypeValue) !usize {
    const index = self.storage.count();

    try self.storage.append(std.testing.allocator, value);

    return index;
}

pub fn deinit(self: *Self) void {
    self.storage.deinit(std.testing.allocator);
}

pub fn check(self: *Self, accepted: bool, structural: bool) !void {
    try self.checkTable(self.storage.view(), accepted, structural);
}

pub fn checkTable(self: *Self, table: ir.TypeTable, accepted: bool, structural: bool) !void {
    try std.testing.expectEqual(structural, table.validStructure());

    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    var snapshot: ir.TypeTable = .{};

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        const column = @field(table, name);

        @field(snapshot, name) = try memory.allocator().dupe(@typeInfo(@TypeOf(column)).pointer.child, column);
    }

    const has_native = self.ids.native < table.kinds.len and self.ids.native < table.labels.len and table.kinds[self.ids.native] == @backingInt(std.meta.Tag(ir.TypeValue).native_reference);
    const binding: ir.Export = .{ .name = if (has_native) table.labels[self.ids.native] else "Node", .type_id = id(self.ids.native) };
    const modules = try ir.NativeModuleTable.fromValues(memory.allocator(), &.{.{ .specifier = "zig:fixture", .import_name = "fixture", .types = .{ .names = &.{binding.name}, .type_ids = &.{@backingInt(binding.type_id)} } }});

    const program: ir.Program = .{
        .file_name = "type_validation.zx",
        .types = table,
        .symbols = .{},
        .expressions = .{},
        .input_type = scalar(.void),
        .output_type = scalar(.void),
        .body = .{},
        .type_only = true,
        .native_modules = if (has_native) modules else .{},
    };

    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    const issue = try compiler.validateIr(failing.allocator(), program);

    try std.testing.expectEqual(accepted, issue == null);
    try std.testing.expect(!failing.has_induced_failure);

    if (issue) |diagnostic| {
        try std.testing.expectEqual(.contract, diagnostic.code);
        try std.testing.expectEqual(@as(u32, 0), diagnostic.span.start);
        try std.testing.expectEqual(@as(u32, 0), diagnostic.span.end);
        try std.testing.expectEqualStrings("invalid ZX IR version, structure, types or bindings", diagnostic.message);
    }

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        const before = @field(snapshot, name);
        const after = @field(table, name);

        if (@typeInfo(@TypeOf(before)).pointer.child == []const u8) {
            try std.testing.expectEqual(before.len, after.len);
            for (before, after) |a, b| try std.testing.expectEqualStrings(a, b);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(before)).pointer.child, before, after);
    }
}
