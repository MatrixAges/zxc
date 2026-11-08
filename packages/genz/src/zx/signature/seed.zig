const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn build(self: *Lower, name: []const u8, exported: bool, errors: ?[]const []const u8) Lower.Error!node.Function {
    const needs_io = self.entry_flags.io;
    const needs_process = self.entry_flags.process;
    const injected = self.program.stores.count() > 0;
    const parameters = try self.allocator.alloc(node.Field, 2 + @as(usize, @intFromBool(injected)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

    parameters[0] = if (exported) .{ .name = "arena", .value = try self.builder.expression(.{ .pointer = try @import("../intrinsics.zig").standardField(self, &.{ "heap", "ArenaAllocator" }) }) } else .{ .name = "allocator", .value = try @import("../intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = if (self.public_value_output) try @import("../types.zig").get(self, self.view_types, self.program.input_type) else try self.typeExpr(self.program.input_type) };

    if (injected) parameters[2] = .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) };
    if (needs_io) parameters[2 + @as(usize, @intFromBool(injected))] = .{ .name = "io", .value = try @import("../intrinsics.zig").standardField(self, &.{"Io"}) };
    if (needs_process) parameters[parameters.len - 1] = .{ .name = "process", .value = try @import("../intrinsics.zig").standardField(self, &.{ "process", "Init", "Minimal" }) };

    return .{ .name = name, .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = .{ .payload = if (self.public_value_output) try @import("../types.zig").get(self, self.view_types, self.program.output_type) else if (self.value_output) try self.layoutExpr(self.program.output_type) else try self.typeExpr(self.program.output_type), .errors = errors } }), .body = .{}, .exported = exported, .inlined = if (@hasField(@TypeOf(self.entry_flags), "inlined")) self.entry_flags.inlined else false };
}
