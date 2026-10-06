pub const TypeId = enum(u32) { _ };
pub const Scalar = enum { void, bool, u8, u16, u32, u64, i32, i64, f32, f64, string };

pub const Kind = enum(u8) {
    scalar = 0,
    object = 1,
    optional = 2,
    list = 3,
    tuple = 4,
    error_set = 5,
    task = 6,
    enumeration = 7,
    native_reference = 8,
};

pub const Field = struct { name: []const u8, type_id: TypeId };

pub const Ids = struct {
    values: []const u32,
    len: usize,
    pub fn at(self: Ids, index: usize) TypeId {
        return @fromBackingInt(@intCast(self.values[index]));
    }
};

pub const Fields = struct {
    names: []const []const u8,
    types: []const u32,
    len: usize,
    pub fn at(self: Fields, index: usize) Field {
        return .{ .name = self.names[index], .type_id = @fromBackingInt(@intCast(self.types[index])) };
    }
};

pub const Type = union(Kind) {
    scalar: Scalar,
    object: Fields,
    optional: TypeId,
    list: TypeId,
    tuple: Ids,
    error_set: []const []const u8,
    task: struct { result: TypeId, errors: TypeId },
    enumeration: struct { name: []const u8, members: []const []const u8 },
    native_reference: []const u8,
    pub fn nominalName(self: Type) ?[]const u8 {
        return switch (self) {
            .enumeration => |value| value.name,
            .native_reference => |name| name,
            else => null,
        };
    }
};
