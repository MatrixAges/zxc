const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Object = @import("Object.zig").Object;
const Type = @import("../../../labels/Type.zig").Type;
const schema = @import("../schema/adapter.zig");
pub const Groups = schema.Groups;

const StoreBase = dsl.element("Store", struct {
    name: []const u8,
    version: u32,
}, dsl.list(dsl.choice(.{ .type = Type, .object = Object }), .{ .min = 1 }));

pub const Store = dsl.refineAlloc(StoreBase, checkStore);

fn checkStore(allocator: std.mem.Allocator, data: StoreBase.Data, node: anytype, context: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (comptime @import("rx_options").generated_rules) {
        const groups = try schema.validate(allocator, data.children, node, reporter);

        if (comptime @TypeOf(context) == *?Groups) context.* = groups;

        return;
    }

    return checkSeed(node, reporter);
}

fn checkSeed(node: dsl.ast.Node, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.uniqueChildren(node, "Type", "as", reporter);

    var has_objects = false;

    for (node.children) |child| {
        if (std.mem.eql(u8, child.name, "Type")) {
            if (has_objects) return checks.fail(child, "from", "Type declarations must precede Store objects", reporter);
        } else has_objects = true;
    }

    if (!has_objects) return checks.fail(node, "", "Store requires at least one Object", reporter);

    for (node.children, 0..) |object, index| {
        if (!std.mem.eql(u8, object.name, "Object")) continue;

        for (node.children[0..index]) |previous| {
            if (!std.mem.eql(u8, previous.name, "Object")) continue;
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
