const std = @import("std");
const Inputs = @import("watch/inputs.zig");
const compiler = @import("compiler");
const model = @import("../package/manifest/model.zig");
const manifest = @import("../package/manifest.zig");
pub const NativeModule = model.NativeModule;
pub const NativeInterface = model.NativeInterface;
pub const Config = model.Manifest;
pub const NativeSettings = @import("project/scopes.zig").NativeSettings;
pub const Loaded = struct { project: compiler.project.Options, config: Config = .{ .name = "", .version = "" }, native_settings: []const NativeSettings = &.{}, diagnostic: ?[]const u8 = null };

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8) !Loaded {
    return loadWithInputs(io, allocator, entry, config_path, null);
}

pub fn loadWithInputs(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, inputs: ?*Inputs) !Loaded {
    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
    const source_path = try std.fs.path.resolve(allocator, &.{ cwd, entry });
    const packages = try @import("../package/project.zig").loadWithInputs(io, allocator, source_path, config_path, inputs);
    var loaded = Loaded{ .project = .{ .entry = packages.entry orelse source_path, .root_dir = cwd, .package_scopes = packages.scopes }, .diagnostic = packages.diagnostic };

    if (loaded.diagnostic != null) return loaded;

    const path = packages.manifest_path orelse return loaded;

    if (inputs) |observed| try observed.add(io, path);

    const source = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024));

    if (inputs) |observed| try observed.record(io, path, source);

    const parsed = try manifest.parse(allocator, source);

    const config = switch (parsed.value) {
        .data => |data| data,
        .diagnostic => |issue| {
            loaded.diagnostic = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: manifest: {s}", .{ path, issue.line, issue.column, issue.message });

            return loaded;
        },
    };

    const root_dir = std.fs.path.dirname(path).?;
    const resolved = try @import("project/scopes.zig").load(io, allocator, packages.scopes, root_dir, config, inputs);

    return .{
        .project = .{
            .entry = loaded.project.entry,
            .root_dir = root_dir,
            .package_scopes = resolved.scopes,
            .externals = resolved.config.externals,
            .native_interfaces = resolved.interfaces,
        },
        .config = resolved.config,
        .native_settings = resolved.settings,
    };
}
