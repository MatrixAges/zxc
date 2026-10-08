const std = @import("std");
const ir = @import("zx").ir;
const Native = @import("../interface.zig").Native;
const Self = @This();
pub const Member = struct { name: []const u8, function: ir.Function };

allocator: std.mem.Allocator,
file_name: []const u8,
namespace: []const []const u8,
module: ir.NativeModuleId,
pub fn init(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId) std.mem.Allocator.Error!Self {
    const namespace = try allocator.alloc([]const u8, entry.namespace.len);

    for (entry.namespace, namespace) |part, *owned| owned.* = try allocator.dupe(u8, part);

    return .{ .allocator = allocator, .file_name = try allocator.dupe(u8, entry.path), .namespace = namespace, .module = module };
}

pub fn create(self: Self, value: anytype, native_input: ir.NativeType) std.mem.Allocator.Error!Member {
    const allocator = self.allocator;
    const name = try allocator.dupe(u8, value.name);
    const path = try allocator.alloc([]const u8, self.namespace.len + 1);

    @memcpy(path[0..self.namespace.len], self.namespace);

    path[self.namespace.len] = name;

    const errors = if (value.errors) |items| blk: {
        const owned = try allocator.alloc([]const u8, items.len);

        for (items, owned) |item, *output| output.* = try allocator.dupe(u8, item);

        break :blk owned;
    } else null;

    return .{ .name = name, .function = .{
        .file_name = self.file_name,
        .input_type = @fromBackingInt(value.signature.input),
        .output_type = @fromBackingInt(value.signature.output),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .external = .{ .input = native_input, .module = self.module, .member = path, .export_name = name, .allocator_argument = value.allocator_argument, .io_argument = value.io_argument, .process_argument = value.process_argument, .expand_tuple = value.expand_tuple, .fallible = value.fallible, .errors = errors, .concurrent = value.concurrent },
    } };
}
