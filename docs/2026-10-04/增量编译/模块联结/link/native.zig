const std = @import("std");
const ir = @import("zx").ir;
const Nodes = @import("../artifact/nodes.zig");
const Error = @import("../artifact/model.zig").Error || error{ConflictingInterface};

pub fn append(allocator: std.mem.Allocator, modules: *std.ArrayList(ir.NativeModule), value: ir.NativeModule, nodes: *Nodes) Error!ir.NativeModuleId {
    const exports = try allocator.dupe(ir.Export, value.types);

    for (exports) |*item| {
        item.name = try allocator.dupe(u8, item.name);
        item.type_id = try nodes.types.include(item.type_id);
    }

    for (modules.items, 0..) |existing, index| {
        if (!std.mem.eql(u8, existing.specifier, value.specifier) or !std.mem.eql(u8, existing.import_name, value.import_name)) continue;
        if (!stringsEqual(existing.type_namespace, value.type_namespace) or existing.types.len != exports.len) return error.ConflictingInterface;

        for (existing.types, exports) |left, right| {
            if (left.type_id != right.type_id or !std.mem.eql(u8, left.name, right.name)) return error.ConflictingInterface;
        }

        return @enumFromInt(index);
    }

    const id: ir.NativeModuleId = @enumFromInt(modules.items.len);

    try modules.append(allocator, .{
        .specifier = try allocator.dupe(u8, value.specifier),
        .import_name = try allocator.dupe(u8, value.import_name),
        .type_namespace = try nodes.strings(value.type_namespace),
        .types = exports,
    });

    return id;
}

pub fn sameExternal(left: ir.External, right: ir.External) bool {
    if (left.module != right.module or left.allocator_argument != right.allocator_argument or left.expand_tuple != right.expand_tuple or left.fallible != right.fallible) return false;
    if (!stringsEqual(left.member, right.member)) return false;
    if (left.input) |input| return sameType(input, right.input orelse return false, 0);

    return right.input == null;
}

fn sameType(left: ir.NativeType, right: ir.NativeType, depth: usize) bool {
    if (depth >= 256 or left.children.len != right.children.len) return false;

    if (left.name) |name| {
        if (!std.mem.eql(u8, name, right.name orelse return false)) return false;
    } else if (right.name != null) return false;

    for (left.children, right.children) |a, b| {
        if (!sameType(a, b, depth + 1)) return false;
    }

    return true;
}

fn stringsEqual(left: []const []const u8, right: []const []const u8) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a, b)) return false;
    }

    return true;
}
