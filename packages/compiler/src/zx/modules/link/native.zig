const std = @import("std");
const ir = @import("zx").ir;
const Nodes = @import("../artifact/nodes.zig");
const Error = @import("../artifact/model.zig").Error || error{ConflictingInterface};

pub fn append(allocator: std.mem.Allocator, modules: *ir.NativeModuleStorage, value: ir.NativeModule, nodes: *Nodes) Error!ir.NativeModuleId {
    const names = try allocator.alloc([]const u8, value.types.count());
    const ids = try allocator.alloc(u32, value.types.count());

    for (value.types.names, value.types.type_ids, names, ids) |name, id, *mapped_name, *mapped_id| {
        mapped_name.* = try allocator.dupe(u8, name);
        mapped_id.* = @backingInt(try nodes.types.include(@fromBackingInt(id)));
    }

    for (0..modules.count()) |index| {
        const existing = modules.at(index);

        if (!std.mem.eql(u8, existing.key(), value.key()) or !std.mem.eql(u8, existing.import_name, value.import_name)) continue;
        if (!stringsEqual(existing.type_namespace, value.type_namespace) or existing.types.count() != names.len) return error.ConflictingInterface;

        for (existing.types.names, existing.types.type_ids, names, ids) |left_name, left_id, right_name, right_id| {
            if (left_id != right_id or !std.mem.eql(u8, left_name, right_name)) return error.ConflictingInterface;
        }

        return @fromBackingInt(@intCast(index));
    }

    const id: ir.NativeModuleId = @fromBackingInt(@intCast(modules.count()));

    try modules.append(allocator, .{
        .specifier = try allocator.dupe(u8, value.specifier),
        .identity = if (value.identity) |key| try allocator.dupe(u8, key) else null,
        .import_name = try allocator.dupe(u8, value.import_name),
        .type_namespace = try nodes.strings(value.type_namespace),
        .types = .{ .names = names, .type_ids = ids },
    });

    return id;
}

pub fn sameExternal(left: ir.External, right: ir.External) bool {
    if (left.module != right.module or left.allocator_argument != right.allocator_argument or left.io_argument != right.io_argument or left.process_argument != right.process_argument or left.expand_tuple != right.expand_tuple or left.fallible != right.fallible) return false;
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

pub fn stringsEqual(left: []const []const u8, right: []const []const u8) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a, b)) return false;
    }

    return true;
}
