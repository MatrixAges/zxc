const std = @import("std");
const compiler = @import("compiler");
const Alias = @import("../../package/manifest/model.zig").AbiAlias;

pub fn resolve(allocator: std.mem.Allocator, scope: compiler.project.PackageScope, configured: ?[]const Alias) ![]const Alias {
    var aliases: std.ArrayList(Alias) = .empty;

    if (configured) |entries| {
        for (entries) |entry| {
            var target: ?[]const u8 = null;

            for (scope.native_interfaces) |declaration| {
                if (std.mem.eql(u8, entry.specifier, declaration.specifier)) target = declaration.key();
            }

            for (scope.externals) |declaration| {
                if (std.mem.eql(u8, entry.specifier, declaration.specifier)) target = declaration.key();
            }

            try append(allocator, &aliases, .{ .name = entry.name, .specifier = target orelse return error.UnknownNativeAbiAlias });
        }
    } else {
        for (scope.native_interfaces) |entry| try append(allocator, &aliases, .{ .name = entry.specifier, .specifier = entry.key() });
        for (scope.externals) |entry| try append(allocator, &aliases, .{ .name = entry.specifier, .specifier = entry.key() });
    }

    return aliases.toOwnedSlice(allocator);
}

fn append(allocator: std.mem.Allocator, aliases: *std.ArrayList(Alias), value: Alias) !void {
    for (aliases.items) |previous| {
        if (!std.mem.eql(u8, previous.name, value.name)) continue;
        if (!std.mem.eql(u8, previous.specifier, value.specifier)) return error.ConflictingNativeAbiAlias;

        return;
    }

    try aliases.append(allocator, value);
}
