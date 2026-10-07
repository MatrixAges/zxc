const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();

files: []const []const u8 = &.{},
input_types: []const u32 = &.{},
output_types: []const u32 = &.{},
ownership: []const ir.SymbolTable.Ownership = &.{},
store_modes: []const ir.StoreMode = &.{},
contracts: []const []const ir.Contract = &.{},
native_inputs: []const ?ir.NativeType = &.{},
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
symbols: []const *const ir.SymbolTable = &.{},
expressions: []const *const ir.ExpressionTable = &.{},
control: []const *const ir.ControlTable = &.{},
roots: []const ?u32 = &.{},
stores: []const *const ir.StoreTable = &.{},
pub fn count(self: Self) usize {
    return self.files.len;
}

pub fn at(self: Self, index: usize) ir.Function {
    return .{
        .file_name = self.files[index],
        .input_type = @fromBackingInt(self.input_types[index]),
        .output_type = @fromBackingInt(self.output_types[index]),
        .output_ownership = switch (self.ownership[index]) {
            .Copy => .copy,
            .Borrowed => .borrowed,
            .Owned => .owned,
        },
        .store_mode = self.store_modes[index],
        .contracts = self.contracts[index],
        .external = if (self.native_modules[index]) |module| .{
            .module = @fromBackingInt(module),
            .input = self.native_inputs[index],
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
        .symbols = self.symbols[index].*,
        .expressions = self.expressions[index].*,
        .body = .{ .control = self.control[index], .root = if (self.roots[index]) |id| @fromBackingInt(id) else null },
        .stores = self.stores[index].*,
    };
}

pub fn prefix(self: Self, len: usize) Self {
    var result: Self = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name)[0..len];

    return result;
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

pub fn snapshot(self: Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    var result: Self = .{};

    errdefer {
        inline for (@typeInfo(Self).@"struct".field_names) |name| allocator.free(@field(result, name));
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| {
        const source = @field(self, name);

        @field(result, name) = try allocator.dupe(std.meta.Elem(@TypeOf(source)), source);
    }

    return result;
}

pub fn get(self: Self, id: ir.FunctionId) ir.Function {
    return self.at(@backingInt(id));
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.Function) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    for (values) |value| try storage.append(allocator, value);

    return storage.finish(allocator);
}
