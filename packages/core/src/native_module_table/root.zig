const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();

identities: []const ?[]const u8 = &.{},
import_names: []const []const u8 = &.{},
specifiers: []const []const u8 = &.{},
type_ids: []const []const u32 = &.{},
type_names: []const []const []const u8 = &.{},
type_namespaces: []const []const []const u8 = &.{},
pub fn count(self: Self) usize {
    return self.specifiers.len;
}

pub fn at(self: Self, index: usize) ir.NativeModule {
    return .{
        .specifier = self.specifiers[index],
        .import_name = self.import_names[index],
        .identity = self.identities[index],
        .type_namespace = self.type_namespaces[index],
        .types = .{ .names = self.type_names[index], .type_ids = self.type_ids[index] },
    };
}

pub fn validStructure(self: Self) bool {
    if (self.count() > std.math.maxInt(u32)) return false;

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        if (@field(self, name).len != self.count()) return false;
    }

    for (self.type_names, self.type_ids) |names, ids| {
        if (names.len != ids.len or names.len > std.math.maxInt(u32)) return false;
    }

    return true;
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.NativeModule) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    for (values) |value| try storage.append(allocator, value);

    return storage.finish(allocator);
}

pub fn jsonRows(self: Self) @import("rows.zig") {
    return .{ .table = self };
}
