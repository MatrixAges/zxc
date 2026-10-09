const ir = @import("zx").ir;
pub const borrow = @import("value.zig").borrow;

pub const Mapping = union(enum) {
    dense: []const ir.TypeId,
    sparse: []const ?ir.TypeId,
    pub fn at(self: Mapping, index: u32) ir.TypeId {
        return switch (self) {
            .dense => |values| values[index],
            .sparse => |values| values[index].?,
        };
    }
};
