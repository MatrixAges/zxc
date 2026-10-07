const std = @import("std");
const ir = @import("core").ir;
const Self = @This();

files: []const []const u8 = &.{},
input_types: []const u32 = &.{},
output_types: []const u32 = &.{},
ownership: []const ir.SymbolTable.Ownership = &.{},
store_modes: []const ir.StoreMode = &.{},
contracts: []const []const ir.Contract = &.{},
external: []const ?ir.External = &.{},
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
        .output_ownership = switch (self.ownership[index]) { .Copy => .copy, .Borrowed => .borrowed, .Owned => .owned },
        .store_mode = self.store_modes[index],
        .contracts = self.contracts[index],
        .external = self.external[index],
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
