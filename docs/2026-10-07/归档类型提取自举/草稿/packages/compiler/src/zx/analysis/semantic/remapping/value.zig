const ir = @import("zx").ir;

pub fn borrow(source: ir.Type, target: []const u32) ir.TypeValue {
    return switch (source) {
        .scalar => |item| .{ .scalar = item },
        .enumeration => |item| .{ .enumeration = .{ .name = item.name, .members = item.members } },
        .error_set => |names| .{ .error_set = names },
        .native_reference => |name| .{ .native_reference = name },
        .optional => .{ .optional = @fromBackingInt(target[0]) },
        .list => .{ .list = @fromBackingInt(target[0]) },
        .task => .{ .task = .{ .result = @fromBackingInt(target[0]), .errors = @fromBackingInt(target[1]) } },
        .tuple => .{ .tuple = @as([*]const ir.TypeId, @ptrCast(target.ptr))[0..target.len] },
        .object => |fields| .{ .object = .{ .names = fields.names, .types = target, .len = fields.len } },
    };
}
