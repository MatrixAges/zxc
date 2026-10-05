const std = @import("std");
const rx = @import("rx");
const target = @import("call/target.zig");

pub const Result = struct { name: []const u8, attribute: rx.ast.Attribute };

pub fn resolve(node: rx.ast.Node) Result {
    if (target.optionalAttribute(node, "name")) |attribute| return .{ .name = attribute.value, .attribute = attribute };

    const attribute = target.optionalAttribute(node, "fn") orelse target.optionalAttribute(node, "service") orelse target.attribute(node, "module");
    const separator = std.mem.lastIndexOfAny(u8, attribute.value, "/\\");
    var name = attribute.value[if (separator) |index| index + 1 else 0..];

    for ([_][]const u8{ ".zx", ".rx", ".zig" }) |suffix| {
        if (std.mem.endsWith(u8, name, suffix)) {
            name = name[0 .. name.len - suffix.len];

            break;
        }
    }

    return .{ .name = name, .attribute = attribute };
}
