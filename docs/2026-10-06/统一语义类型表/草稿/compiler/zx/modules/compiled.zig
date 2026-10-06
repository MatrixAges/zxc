const ir = @import("zx").ir;
const std = @import("std");
const Origins = @import("nominal_origins.zig");
pub const Target = struct { instance: []const u8, artifact: []const u8, name: []const u8 };
pub const Export = struct { name: []const u8, path: []const u8, function: ?ir.FunctionId, types: []const ir.Export };
pub const StoreInitializer = struct { identity: []const u8, schema_version: u32, function: ir.FunctionId };
pub const Graph = struct { program: ir.Program, exports: []const Export, nominal_types: Origins.Table, store_initializers: []const StoreInitializer = &.{} };

pub const Library = struct {
    instance: []const u8,
    artifact: []const u8,
    program: ir.Program,
    exports: []const Export,
    nominal_types: Origins.Table,
    store_initializers: []const StoreInitializer = &.{},
};

pub const Loaded = struct { types: ir.TypeTable, nominal_types: Origins.Table, exports: []const Export, store_initializers: []const StoreInitializer = &.{} };
pub const identity = @import("compiled/identity.zig");
pub const load = @import("compiled/load.zig").load;
pub const validate = @import("compiled/validate.zig").validate;

pub fn copyTarget(allocator: std.mem.Allocator, value: Target) std.mem.Allocator.Error!Target {
    return .{
        .instance = try allocator.dupe(u8, value.instance),
        .artifact = try allocator.dupe(u8, value.artifact),
        .name = try allocator.dupe(u8, value.name),
    };
}
