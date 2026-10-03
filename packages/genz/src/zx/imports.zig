const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error![]const []const u8 {
    const names = try self.allocator.alloc([]const u8, self.program.native_modules.len);
    var imported: std.StringHashMapUnmanaged([]const u8) = .empty;

    for (output.items) |declaration| {
        if (declaration != .constant) continue;

        const value = declaration.constant.value;

        if (value.* != .builtin or value.builtin.name != .import or value.builtin.arguments.len != 1) continue;

        const argument = value.builtin.arguments[0];

        if (argument.* == .string) try imported.put(self.allocator, argument.string, declaration.constant.name);
    }

    for (self.program.native_modules, names, 0..) |module, *name, index| {
        if (imported.get(module.import_name)) |existing| {
            name.* = existing;

            continue;
        }

        name.* = try std.fmt.allocPrint(self.allocator, "zx_native_{d}", .{index});

        try imported.put(self.allocator, module.import_name, name.*);

        try output.append(self.allocator, .{ .constant = .{
            .name = name.*,
            .value = try self.builtin(.import, &.{try self.builder.string(module.import_name)}),
        } });
    }

    return names;
}
