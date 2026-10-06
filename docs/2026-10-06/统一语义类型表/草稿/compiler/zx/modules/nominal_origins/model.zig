const ir = @import("zx").ir;

pub const Origin = union(enum) {
    source: []const u8,
    native: []const u8,
    external: struct { module: []const u8, member: []const u8 },
};

pub const Item = struct { type_id: ir.TypeId, origin: Origin, name: []const u8 };
