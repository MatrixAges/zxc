const std = @import("std");
const ir = @import("../ir.zig");
const Table = @import("root.zig");
const Self = @This();

files: std.ArrayList([]const u8) = .empty,
input_types: std.ArrayList(u32) = .empty,
output_types: std.ArrayList(u32) = .empty,
ownership: std.ArrayList(ir.SymbolTable.Ownership) = .empty,
native_inputs: std.ArrayList(?[]const ?[]const u8) = .empty,
native_modules: std.ArrayList(?u32) = .empty,
native_members: std.ArrayList([]const []const u8) = .empty,
native_exports: std.ArrayList(?[]const u8) = .empty,
native_allocators: std.ArrayList(bool) = .empty,
native_io: std.ArrayList(bool) = .empty,
native_process: std.ArrayList(bool) = .empty,
native_tuples: std.ArrayList(bool) = .empty,
native_fallible: std.ArrayList(bool) = .empty,
native_errors: std.ArrayList(?[]const []const u8) = .empty,
native_concurrent: std.ArrayList(bool) = .empty,
pub fn count(self: *const Self) usize {
    return self.files.items.len;
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: ir.Signature) std.mem.Allocator.Error!void {
    if (self.count() == std.math.maxInt(u32)) return error.OutOfMemory;

    inline for (@typeInfo(Self).@"struct".field_names) |name| try @field(self, name).ensureUnusedCapacity(allocator, 1);
    self.files.appendAssumeCapacity(value.file_name);
    self.input_types.appendAssumeCapacity(@backingInt(value.input_type));
    self.output_types.appendAssumeCapacity(@backingInt(value.output_type));

    self.ownership.appendAssumeCapacity(switch (value.output_ownership) {
        .copy => .Copy,
        .borrowed => .Borrowed,
        .owned => .Owned,
    });

    self.native_inputs.appendAssumeCapacity(if (value.external) |external| if (external.input) |input| input.names else null else null);
    self.native_modules.appendAssumeCapacity(if (value.external) |external| @backingInt(external.module) else null);
    self.native_members.appendAssumeCapacity(if (value.external) |external| external.member else &.{});
    self.native_exports.appendAssumeCapacity(if (value.external) |external| external.export_name else null);
    self.native_allocators.appendAssumeCapacity(if (value.external) |external| external.allocator_argument else false);
    self.native_io.appendAssumeCapacity(if (value.external) |external| external.io_argument else false);
    self.native_process.appendAssumeCapacity(if (value.external) |external| external.process_argument else false);
    self.native_tuples.appendAssumeCapacity(if (value.external) |external| external.expand_tuple else false);
    self.native_fallible.appendAssumeCapacity(if (value.external) |external| external.fallible else false);
    self.native_errors.appendAssumeCapacity(if (value.external) |external| external.errors else null);
    self.native_concurrent.appendAssumeCapacity(if (value.external) |external| external.concurrent else false);
}

pub fn view(self: *const Self) Table {
    var result: Table = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
