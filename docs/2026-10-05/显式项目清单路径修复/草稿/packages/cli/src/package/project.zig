const std = @import("std");
const Inputs = @import("../cli/watch/inputs.zig");
const compiler = @import("compiler");
const discover = @import("discover.zig");
const graph = @import("graph.zig");

pub const Result = struct { scopes: []const compiler.project.PackageScope = &.{}, entry: ?[]const u8 = null, manifest_path: ?[]const u8 = null, diagnostic: ?[]const u8 = null };

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8) !Result {
    return loadWithInputs(io, allocator, entry, config_path, null);
}

pub fn loadWithInputs(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, inputs: ?*Inputs) !Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const discovered = if (config_path) |path| discover.Result{ .path = path } else try discover.findWithInputs(io, temporary, entry, inputs);

    if (discovered.diagnostic) |message| return .{ .diagnostic = try allocator.dupe(u8, message) };

    const path = discovered.path orelse return .{};
    var resolved = try graph.loadWithInputs(io, temporary, path, inputs);

    defer resolved.deinit();

    if (resolved.diagnostic) |message| return .{ .diagnostic = try allocator.dupe(u8, message) };

    const scopes = try allocator.alloc(compiler.project.PackageScope, resolved.packages.len);

    for (resolved.packages, scopes) |package, *scope| {
        const root = try std.fs.path.resolve(allocator, &.{ resolved.root, package.path });
        var dependencies: std.ArrayList(compiler.project.Package) = .empty;

        for (package.dependencies) |edge| {
            const target = resolved.packages[edge.target];

            if (target.manifest.entry == null and target.manifest.exports.len == 0) return .{ .diagnostic = try std.fmt.allocPrint(allocator, "{s}/pkg.yaml: dependency {s}: target {s} has no public modules", .{ root, edge.name, target.manifest.name }) };

            const target_root = try std.fs.path.resolve(allocator, &.{ resolved.root, target.path });

            try appendExports(allocator, &dependencies, edge.name, target_root, target.manifest);
        }

        try appendExports(allocator, &dependencies, package.manifest.name, root, package.manifest);

        scope.* = .{ .root = root, .packages = dependencies.items };
    }

    const real = try std.Io.Dir.cwd().realPathFileAlloc(io, entry, allocator);
    const owner = compiler.project.package_scope.owner(scopes, real) orelse return .{ .diagnostic = "entry file is outside the configured package" };

    return .{ .scopes = scopes, .entry = real, .manifest_path = if (owner == 0) try std.fs.path.join(allocator, &.{ resolved.root, std.fs.path.basename(path) }) else try std.fs.path.join(allocator, &.{ scopes[owner].root, "pkg.yaml" }) };
}

fn appendExports(allocator: std.mem.Allocator, dependencies: *std.ArrayList(compiler.project.Package), name: []const u8, root: []const u8, manifest: @import("manifest/model.zig").Manifest) !void {
    if (manifest.entry) |entry| try dependencies.append(allocator, .{
        .specifier = try allocator.dupe(u8, name),
        .entry = try std.fs.path.resolve(allocator, &.{ root, entry }),
    });

    for (manifest.exports) |item| {
        var package = compiler.project.Package{ .specifier = if (std.mem.eql(u8, item.path, ".")) try allocator.dupe(u8, name) else try std.fmt.allocPrint(allocator, "{s}/{s}", .{ name, item.path[2..] }) };

        if (item.module) |module| {
            package.compiled = .{
                .instance = try allocator.dupe(u8, root),
                .artifact = try std.fs.path.resolve(allocator, &.{ root, manifest.library.? }),
                .name = try allocator.dupe(u8, module),
            };
        } else package.entry = try std.fs.path.resolve(allocator, &.{ root, item.source });

        try dependencies.append(allocator, package);
    }
}
