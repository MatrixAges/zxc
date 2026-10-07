const std = @import("std");
const core = @import("../root.zig");
const api = @import("zxc_abi").native.@"std:url";
const record = @import("record.zig");
pub const domainToASCII = @import("domain.zig").domainToASCII;
pub const domainToUnicode = @import("domain.zig").domainToUnicode;

pub fn parse(allocator: std.mem.Allocator, input: []const u8) !api.Url {
    var parsed = try core.parse(allocator, input, null);

    defer parsed.deinit();

    return record.copy(allocator, parsed.value);
}

pub fn resolve(allocator: std.mem.Allocator, input: api.Resolve) !api.Url {
    var parsed = try core.parse(allocator, input.input, input.base);

    defer parsed.deinit();

    return record.copy(allocator, parsed.value);
}

pub fn tryParse(allocator: std.mem.Allocator, input: api.Resolve) !?api.Url {
    var parsed = core.parse(allocator, input.input, input.base) catch |err| switch (err) {
        error.OutOfMemory => return err,
        else => return null,
    };

    defer parsed.deinit();

    return try record.copy(allocator, parsed.value);
}

pub fn canParse(allocator: std.mem.Allocator, input: api.Resolve) !bool {
    var parsed = core.parse(allocator, input.input, input.base) catch |err| switch (err) {
        error.OutOfMemory => return err,
        else => return false,
    };

    parsed.deinit();

    return true;
}

pub fn stringify(allocator: std.mem.Allocator, input: api.Url) ![]const u8 {
    return core.serialize(allocator, record.read(input), false);
}

pub fn pathname(allocator: std.mem.Allocator, input: api.Url) ![]const u8 {
    return core.serializePath(allocator, record.read(input));
}

pub fn origin(allocator: std.mem.Allocator, input: api.Url) ![]const u8 {
    return core.origin(allocator, record.read(input));
}

pub fn pathToFileURL(allocator: std.mem.Allocator, input: api.FilePath) ![]const u8 {
    return core.pathToFileUrl(allocator, input.path, input.platform == .Windows, input.cwd);
}

pub fn fileURLToPath(allocator: std.mem.Allocator, input: api.FileUrl) ![]const u8 {
    return core.fileUrlToPath(allocator, record.read(input.url), input.platform == .Windows);
}

pub fn fileURLToBytes(allocator: std.mem.Allocator, input: api.FileUrl) ![]const u8 {
    return core.fileUrlToBytes(allocator, record.read(input.url), input.platform == .Windows);
}
