const std = @import("std");
const compiler = @import("compiler");
const model = @import("../../package/manifest/model.zig");
const Inputs = @import("../watch/inputs.zig");
const identity = compiler.project.compiled.identity;
const Self = @This();

library: compiler.library.Result,
instance: []const u8,
pub fn load(io: std.Io, allocator: std.mem.Allocator, root: []const u8, config: model.Manifest, scopes: []const compiler.project.PackageScope, inputs: ?*Inputs) !?Self {
    const relative = config.library orelse return null;

    if (config.native_modules.len == 0 and config.native_interfaces.len == 0 and config.externals.len == 0) return null;

    const path = try std.fs.path.resolve(allocator, &.{ root, relative });

    defer allocator.free(path);

    if (inputs) |observed| try observed.add(io, path);
    try @import("../../package/source.zig").validateWithInputs(io, allocator, path, scopes, inputs);

    const bytes = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(64 * 1024 * 1024));

    defer allocator.free(bytes);

    if (inputs) |observed| try observed.record(io, path, bytes);

    return .{ .library = try compiler.library.codec.decode(allocator, bytes), .instance = root };
}

pub fn deinit(self: *Self) void {
    self.library.deinit();
}

pub fn name(self: Self, allocator: std.mem.Allocator, local: []const u8) ![]const u8 {
    return identity.nativeName(allocator, self.instance, local);
}

pub fn declaration(self: Self, allocator: std.mem.Allocator, specifier: []const u8) ![]const u8 {
    var key: ?[]const u8 = null;
    var shared = false;

    for (self.library.program.native_modules) |module| {
        if (!std.mem.eql(u8, module.specifier, specifier) and !std.mem.eql(u8, module.key(), specifier)) continue;
        if (key) |previous| if (!std.mem.eql(u8, previous, module.key())) return error.ConflictingNativeAbiAlias;

        key = module.key();
        shared = std.mem.startsWith(u8, module.specifier, "std:");
    }

    const original = key orelse return error.UnknownNativeAbiAlias;

    if (shared) return allocator.dupe(u8, original);

    return identity.scope(allocator, self.instance, original);
}

pub fn aliases(self: Self, allocator: std.mem.Allocator, configured: ?[]const model.AbiAlias) ![]const model.AbiAlias {
    var result: std.ArrayList(model.AbiAlias) = .empty;

    if (configured) |entries| {
        for (entries) |entry| try result.append(allocator, .{ .name = entry.name, .specifier = try self.declaration(allocator, entry.specifier) });
    } else {
        for (self.library.program.native_modules) |module| {
            if (std.mem.startsWith(u8, module.specifier, "std:")) continue;

            for (result.items) |previous| {
                if (std.mem.eql(u8, previous.name, module.specifier)) return error.ConflictingNativeAbiAlias;
            }

            try result.append(allocator, .{
                .name = try allocator.dupe(u8, module.specifier),
                .specifier = try self.declaration(allocator, module.key()),
            });
        }
    }

    return result.toOwnedSlice(allocator);
}
