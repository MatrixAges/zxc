const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Object = @import("Object.zig").Object;

const StoreBase = dsl.element("Store", struct {
    name: []const u8,
    version: u32,
}, dsl.list(Object, .{ .min = 1 }));

pub const Store = dsl.refine(StoreBase, checkStore);

fn checkStore(_: StoreBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    for (node.children, 0..) |object, index| {
        for (node.children[0..index]) |previous| {
            if (!std.mem.eql(u8, checks.attribute(object, "name").?, checks.attribute(previous, "name").?)) continue;

            for (object.children) |field| {
                for (previous.children) |previous_field| {
                    if (std.mem.eql(u8, checks.attribute(field, "name").?, checks.attribute(previous_field, "name").?)) {
                        return checks.fail(field, "name", "Store object field path is already declared", reporter);
                    }
                }
            }
        }
    }
}
