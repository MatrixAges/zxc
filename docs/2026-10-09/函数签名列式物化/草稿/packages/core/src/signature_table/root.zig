const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();

files: []const []const u8 = &.{},
input_types: []const u32 = &.{},
output_types: []const u32 = &.{},
ownership: []const ir.SymbolTable.Ownership = &.{},
native_inputs: []const ?[]const ?[]const u8 = &.{},
native_modules: []const ?u32 = &.{},
native_members: []const []const []const u8 = &.{},
native_exports: []const ?[]const u8 = &.{},
native_allocators: []const bool = &.{},
native_io: []const bool = &.{},
native_process: []const bool = &.{},
native_tuples: []const bool = &.{},
native_fallible: []const bool = &.{},
native_errors: []const ?[]const []const u8 = &.{},
native_concurrent: []const bool = &.{},
pub fn count(self: Self) usize {
    return self.files.len;
}

pub fn at(self: Self, index: usize) ir.Signature {
    return .{
        .file_name = self.files[index],
        .input_type = @fromBackingInt(self.input_types[index]),
        .output_type = @fromBackingInt(self.output_types[index]),
        .output_ownership = switch (self.ownership[index]) {
            .Copy => .copy,
            .Borrowed => .borrowed,
            .Owned => .owned,
        },
        .external = if (self.native_modules[index]) |module| .{
            .module = @fromBackingInt(module),
            .input = if (self.native_inputs[index]) |names| .{ .names = names } else null,
            .member = self.native_members[index],
            .export_name = self.native_exports[index],
            .allocator_argument = self.native_allocators[index],
            .io_argument = self.native_io[index],
            .process_argument = self.native_process[index],
            .expand_tuple = self.native_tuples[index],
            .fallible = self.native_fallible[index],
            .errors = self.native_errors[index],
            .concurrent = self.native_concurrent[index],
        } else null,
    };
}

pub fn validStructure(self: Self) bool {
    if (self.count() > std.math.maxInt(u32)) return false;

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        if (@field(self, name).len != self.count()) return false;
    }

    for (self.native_modules, 0..) |module, index| {
        if (module != null) continue;
        if (self.native_inputs[index] != null or self.native_members[index].len != 0 or self.native_exports[index] != null or self.native_allocators[index] or self.native_io[index] or self.native_process[index] or self.native_tuples[index] or self.native_fallible[index] or self.native_errors[index] != null or self.native_concurrent[index]) return false;
    }

    return true;
}

pub fn fromFunctions(functions: ir.FunctionTable) Self {
    var result: Self = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(functions, name);

    return result;
}
