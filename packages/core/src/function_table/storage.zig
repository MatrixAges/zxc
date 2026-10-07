const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();
const Table = @import("root.zig");

files: std.ArrayList([]const u8) = .empty,
input_types: std.ArrayList(u32) = .empty,
output_types: std.ArrayList(u32) = .empty,
ownership: std.ArrayList(ir.SymbolTable.Ownership) = .empty,
store_modes: std.ArrayList(ir.StoreMode) = .empty,
contracts: std.ArrayList([]const ir.Contract) = .empty,
external: std.ArrayList(?ir.External) = .empty,
symbols: std.ArrayList(*const ir.SymbolTable) = .empty,
expressions: std.ArrayList(*const ir.ExpressionTable) = .empty,
control: std.ArrayList(*const ir.ControlTable) = .empty,
roots: std.ArrayList(?u32) = .empty,
stores: std.ArrayList(*const ir.StoreTable) = .empty,
pub fn count(self: *const Self) usize {
    return self.files.items.len;
}

pub fn at(self: *const Self, index: usize) ir.Function {
    return self.view().at(index);
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: ir.Function) std.mem.Allocator.Error!void {
    if (self.count() == std.math.maxInt(u32)) return error.OutOfMemory;

    inline for (@typeInfo(Self).@"struct".field_names) |name| try @field(self, name).ensureUnusedCapacity(allocator, 1);

    const symbols = try descriptor(allocator, value.symbols);

    errdefer allocator.destroy(symbols);

    const expressions = try descriptor(allocator, value.expressions);

    errdefer allocator.destroy(expressions);

    const stores = try descriptor(allocator, value.stores);

    errdefer allocator.destroy(stores);
    self.files.appendAssumeCapacity(value.file_name);
    self.input_types.appendAssumeCapacity(@backingInt(value.input_type));
    self.output_types.appendAssumeCapacity(@backingInt(value.output_type));

    self.ownership.appendAssumeCapacity(switch (value.output_ownership) {
        .copy => .Copy,
        .borrowed => .Borrowed,
        .owned => .Owned,
    });

    self.store_modes.appendAssumeCapacity(value.store_mode);
    self.contracts.appendAssumeCapacity(value.contracts);
    self.external.appendAssumeCapacity(value.external);
    self.symbols.appendAssumeCapacity(symbols);
    self.expressions.appendAssumeCapacity(expressions);
    self.control.appendAssumeCapacity(value.body.control);
    self.roots.appendAssumeCapacity(if (value.body.root) |id| @backingInt(id) else null);
    self.stores.appendAssumeCapacity(stores);
}

pub fn view(self: *const Self) Table {
    var result: Table = .{};

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = @field(self, name).items;

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!Table {
    var result: Table = .{};

    errdefer {
        for (result.symbols) |value| allocator.destroy(value);
        for (result.expressions) |value| allocator.destroy(value);
        for (result.stores) |value| allocator.destroy(value);

        inline for (@typeInfo(Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(result, name) = try @field(self, name).toOwnedSlice(allocator);

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    for (self.symbols.items) |value| allocator.destroy(value);
    for (self.expressions.items) |value| allocator.destroy(value);
    for (self.stores.items) |value| allocator.destroy(value);

    inline for (@typeInfo(Self).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}

pub fn pop(self: *Self, allocator: std.mem.Allocator) ?ir.Function {
    if (self.count() == 0) return null;

    const index = self.count() - 1;
    const value = self.at(index);

    allocator.destroy(self.symbols.items[index]);
    allocator.destroy(self.expressions.items[index]);
    allocator.destroy(self.stores.items[index]);
    inline for (@typeInfo(Self).@"struct".field_names) |name| _ = @field(self, name).pop();

    return value;
}

fn descriptor(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!*const @TypeOf(value) {
    const result = try allocator.create(@TypeOf(value));

    result.* = value;

    return result;
}
