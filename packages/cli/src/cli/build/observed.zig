const std = @import("std");
const builtin = @import("builtin");
const Inputs = @import("../watch/inputs.zig");
const Options = @import("../options.zig").Options;
const Response = @import("../backend/protocol.zig").Result;
const Self = @This();
pub const artifact_name = "application";

pub const Cache = struct {
    cwd: []const u8,
    local: []const u8,
    global: []const u8,
    pub fn init(io: std.Io, allocator: std.mem.Allocator, environment: *const std.process.Environ.Map) !Cache {
        const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
        const global = environment.get("ZIG_GLOBAL_CACHE_DIR") orelse try std.fs.path.join(allocator, &.{ try @import("../toolchain/cache.zig").root(allocator, environment), "backend" });

        return .{
            .cwd = cwd,
            .local = try std.fs.path.resolve(allocator, &.{ cwd, ".zxc", "cache", "backend" }),
            .global = try std.fs.path.resolve(allocator, &.{ cwd, global }),
        };
    }
};

response: Response,
input_paths: []const []const u8,
new_inputs: bool,
binary: ?[]const u8,
assembly: ?[]const u8,
bindings: ?@import("../node/bindings.zig") = null,
pub fn deinit(self: *Self) void {
    self.response.deinit();

    self.* = undefined;
}

pub fn resolve(io: std.Io, response: *Response, cache: Cache, library: []const u8, options: Options, inputs: *Inputs) !Self {
    const allocator = response.arena.allocator();
    const paths = try allocator.alloc([]const u8, response.inputs.len);
    var new_inputs = false;

    for (response.inputs, paths) |input, *absolute| {
        const prefix = switch (input.prefix) {
            .build_root, .cwd => cache.cwd,
            .zig_lib => library,
            .local_cache => cache.local,
            .global_cache => cache.global,
        };

        const path = try std.fs.path.resolve(allocator, &.{ prefix, input.path });

        absolute.* = path;
        new_inputs = new_inputs or !inputs.entries.contains(path);

        try inputs.add(io, path);
    }

    var binary: ?[]const u8 = null;
    var assembly: ?[]const u8 = null;

    if (response.succeeded) {
        const target = if (options.target) |triple| try std.zig.system.resolveTargetQuery(io, try std.Target.Query.parse(.{ .arch_os_abi = triple })) else builtin.target;
        const name = try std.zig.binNameAlloc(allocator, .{ .root_name = artifact_name, .cpu_arch = target.cpu.arch, .os_tag = target.os.tag, .ofmt = target.ofmt, .abi = target.abi, .output_mode = if (options.host == .node) .Lib else .Exe, .link_mode = if (options.host == .node) .dynamic else .static });
        const digest = std.fmt.bytesToHex(response.digest.?, .lower);
        const directory = try std.fs.path.join(allocator, &.{ cache.local, "o", &digest });
        binary = try std.fs.path.join(allocator, &.{ directory, name });

        if (options.assembly != null) assembly = try std.fs.path.join(allocator, &.{ directory, artifact_name ++ ".s" });
    }

    return .{ .response = response.*, .input_paths = paths, .new_inputs = new_inputs, .binary = binary, .assembly = assembly };
}

pub fn publish(self: *const Self, io: std.Io, allocator: std.mem.Allocator, inputs: *const Inputs, options: Options) !bool {
    if (!self.response.succeeded or !self.response.inputs_complete or self.new_inputs) return false;

    const output = try @import("../watch/output.zig").check(io, allocator, inputs, options.output.?);

    defer allocator.free(output);

    if (options.assembly) |path| {
        const assembly = try @import("../watch/output.zig").check(io, allocator, inputs, path);

        defer allocator.free(assembly);

        if (std.mem.eql(u8, output, assembly)) return error.ConflictingOutputPaths;
    }

    if (self.bindings) |files| {
        try files.check(io, allocator, options);

        for ([_][]const u8{ files.module_path, files.declaration_path }) |path| {
            const checked = try @import("../watch/output.zig").check(io, allocator, inputs, path);

            allocator.free(checked);
        }
    }

    var observed = try inputs.observed(allocator);

    defer observed.deinit();

    var current = try inputs.current(io, allocator);

    defer current.deinit();

    if (!observed.same(current)) return false;
    if (self.bindings) |files| try files.publish(io);
    if (self.assembly) |path| try std.Io.Dir.cwd().copyFile(path, .cwd(), options.assembly.?, io, .{ .make_path = true });
    try std.Io.Dir.cwd().copyFile(self.binary.?, .cwd(), options.output.?, io, .{ .make_path = true });

    return true;
}
