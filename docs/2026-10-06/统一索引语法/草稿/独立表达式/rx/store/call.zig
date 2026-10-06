const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");
const syntax = @import("zx").syntax.borrow;
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

        if (parsed.diagnostic()) |issue| {
            return failure(allocator, owner, input, issue.span.start, @tagName(issue.code), issue.message);
        }

        switch (parsed) {
            .native => |result| try collectReads(allocator, &reads, result.value.parsed.expression, bindings),
            .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) {
                var scratch = std.heap.ArenaAllocator.init(allocator);

                defer scratch.deinit();

                const view = try result.view(scratch.allocator());

                try collectReads(allocator, &reads, view.expression(result.output.result), bindings);
            } else unreachable,
        }
    }

    var setter: ?target.Setter = null;

    for (node.attributes) |attribute| {
        if (!std.mem.eql(u8, attribute.name, "setter")) continue;

        var writes = try @import("../attribute.zig").parse(allocator, attribute, owner);

        defer writes.deinit();

        if (writes.diagnostic()) |issue| {
            return failure(allocator, owner, attribute, issue.span.start, @tagName(issue.code), issue.message);
        }

        const selected = switch (writes) {
            .native => |result| selectSetter(result.value.parsed.expression, bindings),
            .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) block: {
                var scratch = std.heap.ArenaAllocator.init(allocator);

                defer scratch.deinit();

                const view = try result.view(scratch.allocator());

                break :block selectSetter(view.expression(result.output.result), bindings);
            } else unreachable,
        };

        switch (selected) {
            .setter => |value| setter = value,
            .invalid => |issue| return failure(allocator, owner, attribute, issue.offset, "capability", issue.message),
        }
    }

    return .{ .authorized = .{ .getters = reads.items, .setter = setter } };
}

fn collectReads(allocator: std.mem.Allocator, reads: *std.ArrayList(Store.Binding), expression: anytype, bindings: []const Store.Binding) std.mem.Allocator.Error!void {
    for (bindings) |binding| if (getters.contains(expression, binding.name)) {
        try reads.append(allocator, binding);
    };
}

const SetterResult = union(enum) { setter: target.Setter, invalid: struct { offset: usize, message: []const u8 } };

fn selectSetter(expression: anytype, bindings: []const Store.Binding) SetterResult {
    const value = syntax.value(expression);

    if (value != .list or value.list.len != 1) return .{ .invalid = .{ .offset = 0, .message = "Call.setter must list exactly one complete Store Object" } };

    const path = syntax.item(value.list, 0);

    for (bindings) |binding| if (getters.matches(path, binding.name)) {
        return .{ .setter = .{ .name = binding.name, .path = binding.slot.path, .type_id = binding.slot.type_id } };
    };

    return .{ .invalid = .{ .offset = path.span.start, .message = "Call.setter must reference a complete Object declared by this module" } };
}

fn failure(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute, offset: usize, code: []const u8, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = owner, .location = rx.attributeLocation(attribute, offset) orelse attribute.value_location, .code = code, .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
