const ir = @import("zx").ir;
const std = @import("std");
const Origins = @import("nominal_origins.zig");
pub const Target = struct { instance: []const u8, artifact: []const u8, name: []const u8 };
pub const Export = struct { name: []const u8, path: []const u8, function: ?ir.FunctionId, types: []const ir.Export };
pub const Graph = struct { program: ir.Program, exports: []const Export, nominal_types: []const Origins.Item };

pub const Library = struct {
    instance: []const u8,
    artifact: []const u8,
    program: ir.Program,
    exports: []const Export,
    nominal_types: []const Origins.Item,
};

pub const Loaded = struct { types: []const ir.Type, nominal_types: []const Origins.Item, exports: []const Export };
pub const load = @import("compiled/load.zig").load;
pub const validate = @import("compiled/validate.zig").validate;

pub fn copyTarget(allocator: std.mem.Allocator, value: Target) std.mem.Allocator.Error!Target {
    return .{
        .instance = try allocator.dupe(u8, value.instance),
        .artifact = try allocator.dupe(u8, value.artifact),
        .name = try allocator.dupe(u8, value.name),
    };
}
