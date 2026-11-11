const ir = @import("zx").ir;
const std = @import("std");
const Origins = @import("nominal_origins.zig");
pub const Target = struct { instance: []const u8, artifact: []const u8, name: []const u8 };
pub const Export = struct { name: []const u8, path: []const u8, function: ?ir.FunctionId, types: []const ir.Export, constants: []const ir.Constant = &.{}, members: []const @import("function_import.zig") = &.{} };
pub const PublicReference = struct { name: []const u8, module: []const u8 };

pub const StoreInitializer = struct {
    function: ir.FunctionId,
    identity: []const u8,
    schema_version: u32,
    pub fn jsonStringify(self: @This(), writer: anytype) !void {
        try writer.write(.{ .identity = self.identity, .schema_version = self.schema_version, .function = self.function });
    }
};

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
pub const loadInto = @import("compiled/load.zig").loadInto;
pub const validateHeader = @import("compiled/validate.zig").validateHeader;
pub const validate = @import("compiled/validate.zig").validate;

pub fn copyTarget(allocator: std.mem.Allocator, value: Target) std.mem.Allocator.Error!Target {
    return .{
        .instance = try allocator.dupe(u8, value.instance),
        .artifact = try allocator.dupe(u8, value.artifact),
        .name = try allocator.dupe(u8, value.name),
    };
}
