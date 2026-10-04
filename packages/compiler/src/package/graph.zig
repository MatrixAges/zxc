const std = @import("std");
const Inputs = @import("../cli/watch/inputs.zig");
const workspace = @import("workspace.zig");
const Manifest = @import("manifest/model.zig").Manifest;
const version = @import("pkgs").version;
const State = enum { fresh, visiting, done };
pub const Dependency = struct { name: []const u8, target: usize, development: bool };
pub const Package = struct { path: []const u8, manifest: Manifest, dependencies: []const Dependency = &.{} };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    root: []const u8 = "",
    packages: []Package = &.{},
    diagnostic: ?[]const u8 = null,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn load(io: std.Io, allocator: std.mem.Allocator, path: []const u8) !Result {
    return loadWithInputs(io, allocator, path, null);
}

pub fn loadWithInputs(io: std.Io, allocator: std.mem.Allocator, path: []const u8, inputs: ?*Inputs) !Result {
    var result: Result = .{ .arena = .init(allocator) };

    errdefer result.deinit();

    resolve(io, &result, path, inputs) catch |err| {
        if (err == error.OutOfMemory) return err;
        if (result.diagnostic == null) result.diagnostic = try std.fmt.allocPrint(result.arena.allocator(), "{s}: {s}", .{ path, @errorName(err) });
    };

    return result;
}

fn resolve(io: std.Io, result: *Result, path: []const u8, inputs: ?*Inputs) !void {
    const allocator = result.arena.allocator();
    const discovered = try workspace.loadWithInputs(io, allocator, path, inputs);

    if (discovered.diagnostic) |message| {
        result.diagnostic = message;

        return error.InvalidPackageGraph;
    }

    result.root = try std.Io.Dir.cwd().realPathFileAlloc(io, std.fs.path.dirname(path) orelse ".", allocator);

    for (discovered.packages) |package| {
        for ([_][]const @import("manifest/model.zig").Dependency{ package.manifest.dependencies, package.manifest.dev_dependencies }) |entries| {
            for (entries) |entry| {
                if (std.mem.startsWith(u8, entry.requirement, "workspace:")) continue;

                result.packages = @import("installed.zig").load(io, allocator, result.root, discovered.packages, inputs) catch |err| {
                    if (err == error.PackagesNotInstalled) result.diagnostic = try std.fmt.allocPrint(allocator, "{s}/pkg.yaml: dependency {s}: external dependency is not installed; run zxc pkg install", .{ package.path, entry.name });

                    return err;
                };

                return;
            }
        }
    }

    result.packages = try allocator.alloc(Package, discovered.packages.len);

    for (discovered.packages, result.packages) |source, *package| package.* = .{ .path = source.path, .manifest = source.manifest };

    for (result.packages, 0..) |*package, owner| {
        var dependencies: std.ArrayList(Dependency) = .empty;

        for ([_][]const @import("manifest/model.zig").Dependency{ package.manifest.dependencies, package.manifest.dev_dependencies }, 0..) |entries, kind| {
            for (entries) |entry| {
                for (dependencies.items) |previous| {
                    if (std.mem.eql(u8, previous.name, entry.name)) return fail(result, owner, entry.name, "dependency appears in both dependencies and dev_dependencies");
                }

                const target = try dependency(result, owner, entry.name, entry.requirement);

                try dependencies.append(allocator, .{ .name = entry.name, .target = target, .development = kind == 1 });
            }
        }

        package.dependencies = try dependencies.toOwnedSlice(allocator);
    }

    const states = try allocator.alloc(State, result.packages.len);

    @memset(states, .fresh);

    for (result.packages, 0..) |_, index| try visit(result, states, index, 0);
}

fn dependency(result: *Result, owner: usize, name: []const u8, requirement: []const u8) !usize {
    if (!std.mem.startsWith(u8, requirement, "workspace:")) return fail(result, owner, name, "external dependency is not installed; run zxc pkg install");

    const text = requirement["workspace:".len..];
    var target_name = name;
    var range = text;
    var target_path: ?[]const u8 = null;

    if (std.mem.startsWith(u8, text, "./") or std.mem.startsWith(u8, text, "../")) {
        target_path = try std.fs.path.resolve(result.arena.allocator(), &.{ result.root, result.packages[owner].path, text });
        range = "*";
    } else if (std.mem.lastIndexOfScalar(u8, text, '@')) |separator| {
        if (separator == 0) return fail(result, owner, name, "workspace alias requires a package name and version range");

        target_name = text[0..separator];
        range = text[separator + 1 ..];
    }

    for (result.packages, 0..) |package, index| {
        const matches = if (target_path) |path| std.mem.eql(u8, path, try std.fs.path.resolve(result.arena.allocator(), &.{ result.root, package.path })) else std.mem.eql(u8, package.manifest.name, target_name);

        if (!matches) continue;

        if (range.len != 0 and !std.mem.eql(u8, range, "*") and !std.mem.eql(u8, range, "^") and !std.mem.eql(u8, range, "~")) {
            const accepted = version.matches(range, try std.SemanticVersion.parse(package.manifest.version)) catch return fail(result, owner, name, "invalid workspace version range");

            if (!accepted) return fail(result, owner, name, "workspace package version does not satisfy the dependency range");
        }

        return index;
    }

    return fail(result, owner, name, "workspace dependency has no matching local package");
}

fn visit(result: *Result, states: []State, index: usize, depth: usize) error{ OutOfMemory, InvalidPackageGraph }!void {
    if (states[index] == .done) return;
    if (states[index] == .visiting) return fail(result, index, result.packages[index].manifest.name, "package dependencies must be acyclic");
    if (depth >= 256) return fail(result, index, result.packages[index].manifest.name, "package dependency depth exceeds 256");

    states[index] = .visiting;

    for (result.packages[index].dependencies) |edge| try visit(result, states, edge.target, depth + 1);

    states[index] = .done;
}

fn fail(result: *Result, owner: usize, name: []const u8, message: []const u8) error{ OutOfMemory, InvalidPackageGraph } {
    result.diagnostic = try std.fmt.allocPrint(result.arena.allocator(), "{s}/pkg.yaml: dependency {s}: {s}", .{ result.packages[owner].path, name, message });

    return error.InvalidPackageGraph;
}
