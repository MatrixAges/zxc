const model = @import("model.zig");
const Scalar = model.Scalar;
const TypeId = model.TypeId;
const TypeFields = model.Fields;

pub const Value = union(model.Kind) {
    scalar: Scalar,
    object: TypeFields,
    optional: TypeId,
    list: TypeId,
    tuple: []const TypeId,
    error_set: []const []const u8,
    task: struct { result: TypeId, errors: TypeId },
    enumeration: struct { name: []const u8, members: []const []const u8 },
    native_reference: []const u8,
    pub fn nominalName(self: Value) ?[]const u8 {
        return switch (self) {
            .enumeration => |value| value.name,
            .native_reference => |name| name,
            else => null,
        };
    }
};
