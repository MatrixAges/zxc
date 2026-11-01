const TypeId = @import("type_table/model.zig").TypeId;

pub const Value = union(enum) {
    integer: u64,
    negative_integer: u64,
    float: f64,
    string: []const u8,
    boolean: bool,
    enumeration: u32,
};

pub const Constant = struct {
    name: []const u8,
    type_id: TypeId,
    value: Value,
};
