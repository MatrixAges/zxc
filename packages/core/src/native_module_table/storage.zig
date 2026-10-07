const std = @import("std");
const ir = @import("../ir.zig");
const Table = @import("root.zig");
const Self = @This();

identities: std.ArrayList(?[]const u8) = .empty,
import_names: std.ArrayList([]const u8) = .empty,
specifiers: std.ArrayList([]const u8) = .empty,
type_ids: std.ArrayList([]const u32) = .empty,
type_names: std.ArrayList([]const []const u8) = .empty,
type_namespaces: std.ArrayList([]const []const u8) = .empty,
pub fn count(self: *const Self) usize {
    return self.specifiers.items.len;
}

pub fn at(self: *const Self, index: usize) ir.NativeModule {
    return self.view().at(index);
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: ir.NativeModule) std.mem.Allocator.Error!void {
    if (self.count() == std.math.maxInt(u32)) return error.OutOfMemory;

    inline for (@typeInfo(Self).@"struct".field_names) |name| try @field(self, name).ensureUnusedCapacity(allocator, 1);
    self.identities.appendAssumeCapacity(value.identity);
    self.import_names.appendAssumeCapacity(value.import_name);
    self.specifiers.appendAssumeCapacity(value.specifier);
    self.type_ids.appendAssumeCapacity(value.types.type_ids);
    self.type_names.appendAssumeCapacity(value.types.names);
    self.type_namespaces.appendAssumeCapacity(value.type_namespace);
}

pub fn view(self: *const Self) Table {
    var result: Table = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Table {
    var result: Table = .{};

    errdefer {
        inline for (@typeInfo(Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = try @field(self, name).toOwnedSlice(allocator);

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
