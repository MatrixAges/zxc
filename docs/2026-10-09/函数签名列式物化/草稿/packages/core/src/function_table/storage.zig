const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();
const Table = @import("root.zig");

files: std.ArrayList([]const u8) = .empty,
input_types: std.ArrayList(u32) = .empty,
output_types: std.ArrayList(u32) = .empty,
ownership: std.ArrayList(ir.SymbolTable.Ownership) = .empty,
store_modes: std.ArrayList(ir.StoreMode) = .empty,
contracts: std.ArrayList(*const ir.ContractTable) = .empty,
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

    const contracts = try descriptor(allocator, value.contracts);

    errdefer allocator.destroy(contracts);
    self.files.appendAssumeCapacity(value.file_name);
    self.input_types.appendAssumeCapacity(@backingInt(value.input_type));
    self.output_types.appendAssumeCapacity(@backingInt(value.output_type));

    self.ownership.appendAssumeCapacity(switch (value.output_ownership) {
        .copy => .Copy,
        .borrowed => .Borrowed,
        .owned => .Owned,
    });

    self.store_modes.appendAssumeCapacity(value.store_mode);
    self.contracts.appendAssumeCapacity(contracts);
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
        for (result.contracts) |value| allocator.destroy(value);

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
    for (self.contracts.items) |value| allocator.destroy(value);

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
    allocator.destroy(self.contracts.items[index]);
    inline for (@typeInfo(Self).@"struct".field_names) |name| _ = @field(self, name).pop();

    return value;
}

fn descriptor(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!*const @TypeOf(value) {
    const result = try allocator.create(@TypeOf(value));

    result.* = value;

    return result;
}
