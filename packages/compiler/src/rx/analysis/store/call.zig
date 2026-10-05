const std = @import("std");
const rx = @import("rx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");
const getters = @import("getters.zig");
pub const Authorization = struct { getters: []const Store.Binding, setter: ?target.Setter = null };
pub const Value = union(enum) { authorized: Authorization, diagnostic: target.Diagnostic };

pub fn analyze(allocator: std.mem.Allocator, owner: []const u8, node: rx.ast.Node, bindings: []const Store.Binding) std.mem.Allocator.Error!Value {
    var reads: std.ArrayList(Store.Binding) = .empty;

    if (target.optionalAttribute(node, "in")) |input| {
        var parsed = try @import("../attribute.zig").parse(allocator, input, owner);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) {
            const issue = parsed.value.diagnostic;

            return failure(allocator, owner, input, issue.span.start, @tagName(issue.code), issue.message);
        }

        for (bindings) |binding| if (getters.contains(parsed.value.parsed.expression, binding.name)) {
            try reads.append(allocator, binding);
        };
    }

    var setter: ?target.Setter = null;

    for (node.attributes) |attribute| {
        if (!std.mem.eql(u8, attribute.name, "setter")) continue;

        var writes = try @import("../attribute.zig").parse(allocator, attribute, owner);

        defer writes.deinit();

        if (writes.value == .diagnostic) {
            const issue = writes.value.diagnostic;

            return failure(allocator, owner, attribute, issue.span.start, @tagName(issue.code), issue.message);
        }

        const expression = writes.value.parsed.expression;

        if (expression.value != .list or expression.value.list.len != 1) return failure(allocator, owner, attribute, 0, "capability", "Call.setter must list exactly one complete Store Object");

        const path = expression.value.list[0];

        for (bindings) |binding| if (getters.matches(path, binding.name)) {
            setter = .{ .name = binding.name, .path = binding.slot.path, .type_id = binding.slot.type_id };

            break;
        };

        if (setter == null) return failure(allocator, owner, attribute, path.span.start, "capability", "Call.setter must reference a complete Object declared by this module");
    }

    return .{ .authorized = .{ .getters = reads.items, .setter = setter } };
}

fn failure(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute, offset: usize, code: []const u8, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = owner, .location = rx.attributeLocation(attribute, offset) orelse attribute.value_location, .code = code, .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
