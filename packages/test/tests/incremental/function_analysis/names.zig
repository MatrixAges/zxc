const std = @import("std");
const ir = @import("zx").ir;
const modules = @import("checks").modules;

pub fn create(allocator: std.mem.Allocator, program: ir.Program) !modules.Names {
    const functions = try allocator.alloc([]const u8, program.functions.count());
    const types = try allocator.alloc([]const u8, program.types.count());

    for (functions, 0..) |*name, index| name.* = try std.fmt.allocPrint(allocator, "function_{d}", .{index});
    for (types, 0..) |*name, index| name.* = try std.fmt.allocPrint(allocator, "type_{d}", .{index});

    return .{ .types = types, .functions = functions };
}
