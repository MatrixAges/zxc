const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Field = @import("Field.zig").Field;
const ObjectBase = dsl.element("Object", struct { name: []const u8 }, dsl.list(Field, .{ .min = 1 }));
pub const Object = dsl.refineAlloc(ObjectBase, checkObject);

fn checkObject(allocator: std.mem.Allocator, data: ObjectBase.Data, node: anytype, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);
    if (comptime @import("rx_options").generated_rules) return @import("../schema/adapter.zig").uniqueFields(allocator, data.children, node, reporter);
    try checks.uniqueChildren(node, "Field", "name", reporter);
}
