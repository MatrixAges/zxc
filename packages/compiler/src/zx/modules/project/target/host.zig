const std = @import("std");
const zx = @import("zx");
const paths = @import("../../module_path.zig");
const scopes = @import("../../package_scope.zig");
const specifier = @import("../../specifier.zig");
const intrinsic = @import("../../intrinsic.zig").specifier;
const source_index = @import("../../source_index.zig");
const compiled = @import("../../compiled.zig");
const enabled = @import("parser_options").generated_parser;
pub const Target = union(enum) { source: []const u8, compiled: compiled.Target };
pub const Route = if (enabled) Output(@import("generated_project_import_route")) else enum { File, Package, Intrinsic, Interface, Invalid };
const Base = if (enabled) Output(@import("generated_project_path_base")) else enum { Relative, Root, Extension, Invalid };
const Shape = if (enabled) Output(@import("generated_project_package_shape")) else enum { Source, Compiled, InvalidSource, InvalidCompiled };

fn Output(comptime module: type) type {
    return @typeInfo(@TypeOf(module.executeValue(undefined, undefined))).error_union.payload;
}

pub fn classify(path: []const u8) Route {
    if (comptime enabled) {
        const generated = @import("generated_project_import_route");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(generated.Input) = .{ .path = path, .intrinsic = intrinsic };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    return switch (specifier.classify(path) catch return .Invalid) {
        .file => .File,
        .package => .Package,
        else => if (std.mem.eql(u8, path, intrinsic)) .Intrinsic else .Interface,
    };
}

pub fn resolvePath(allocator: std.mem.Allocator, from: []const u8, path: []const u8, root: []const u8, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    const directory = paths.directoryReference(path);
    const base = pathBase(path, directory);

    switch (base) {
        .Extension => return reporter.fail(.module, span, "project imports must omit the .zx extension; runtime and RX imports are forbidden"),
        .Invalid => return reporter.fail(.module, span, "imports require ./, ../ or @/ paths; external interfaces require explicit registration"),
        .Relative, .Root => {},
    }

    const source = if (directory) try paths.directory(allocator, path) else try std.fmt.allocPrint(allocator, "{s}.zx", .{path});

    defer allocator.free(source);

    return switch (base) {
        .Root => std.fs.path.resolve(allocator, &.{ root, source[2..] }),
        .Relative => std.fs.path.resolve(allocator, &.{ std.fs.path.dirname(from) orelse ".", source }),
        else => unreachable,
    };
}

fn pathBase(path: []const u8, directory: bool) Base {
    const extension = std.fs.path.extension(path).len != 0;

    if (comptime enabled) {
        const generated = @import("generated_project_path_base");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(generated.Input) = .{ .path = path, .directory = directory, .extension = extension };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (!directory and extension) return .Extension;
    if (std.mem.startsWith(u8, path, "@/")) return .Root;
    if (std.mem.eql(u8, path, ".") or std.mem.eql(u8, path, "..") or std.mem.startsWith(u8, path, "./") or std.mem.startsWith(u8, path, "../")) return .Relative;

    return .Invalid;
}

pub fn resolve(allocator: std.mem.Allocator, from: []const u8, path: []const u8, route: Route, options: anytype, reporter: *zx.Reporter, span: zx.Span) zx.Error!Target {
    if (route == .Invalid) return reporter.fail(.module, span, "invalid or unknown import specifier");

    const owner = scopes.owner(options.package_scopes, from);
    const root = if (owner) |index| options.package_scopes[index].root else options.root_dir;

    if (options.package_scopes.len != 0 and owner == null) return reporter.fail(.module, span, "source file does not belong to a declared package");

    switch (route) {
        .File => {
            var resolved = if (std.mem.endsWith(u8, path, ".rx")) block: {
                const candidate = try resolvePath(allocator, from, path[0 .. path.len - ".rx".len], root, reporter, span);

                defer allocator.free(candidate);

                break :block try std.fmt.allocPrint(allocator, "{s}.rx", .{candidate[0 .. candidate.len - ".zx".len]});
            } else try resolvePath(allocator, from, path, root, reporter, span);

            errdefer allocator.free(resolved);

            const selected = if (paths.directoryReference(path)) resolved else try select(allocator, resolved, options.source_index);

            if (selected.ptr != resolved.ptr) allocator.free(resolved);

            resolved = selected;

            if (options.package_scopes.len != 0 and scopes.owner(options.package_scopes, resolved) != owner) return crossedPackage(reporter, span);

            return .{ .source = resolved };
        },
        .Package => {
            const dependencies = if (owner) |index| options.package_scopes[index].packages else options.packages;

            return dependency(allocator, path, options.root_dir, dependencies, reporter, span);
        },
        .Intrinsic, .Interface => return reporter.fail(.module, span, "native and standard imports must use the interface registry"),
        .Invalid => unreachable,
    }
}

fn dependency(allocator: std.mem.Allocator, path: []const u8, root: []const u8, packages: []const scopes.Package, reporter: *zx.Reporter, span: zx.Span) zx.Error!Target {
    const selected = if (comptime enabled) packageSelection(packages, path) else packageSelectionSeed(packages, path);
    const index = selected.first orelse return reporter.fail(.module, span, "ZX package is not declared in the project dependencies");
    const package = &packages[index];

    switch (packageShape(package)) {
        .InvalidSource => return reporter.fail(.module, span, "package entry must be a .zx or .rx source file"),
        .InvalidCompiled => return reporter.fail(.module, span, "compiled package target must identify one instance, artifact and public module"),
        .Source, .Compiled => {},
    }

    if (selected.duplicate) return reporter.fail(.module, span, "duplicate ZX package specifier");

    if (package.compiled) |value| {
        const instance = try allocator.dupe(u8, value.instance);

        errdefer allocator.free(instance);

        const artifact = try std.fs.path.resolve(allocator, &.{ root, value.artifact });

        errdefer allocator.free(artifact);

        return .{ .compiled = .{
            .instance = instance,
            .artifact = artifact,
            .name = try allocator.dupe(u8, value.name),
        } };
    }

    return .{ .source = try std.fs.path.resolve(allocator, &.{ root, package.entry }) };
}

const PackageSelection = struct { first: ?u64 = null, duplicate: bool = false };

fn packageSelection(packages: []const scopes.Package, path: []const u8) PackageSelection {
    const generated = @import("generated_project_package_select");
    const Input = std.meta.Child(generated.Input);
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var specifiers: [scopes.lookup_batch_size][]const u8 = undefined;
    var first: ?u64 = null;
    var offset: usize = 0;

    while (offset < packages.len) {
        const batch = packages[offset..][0..@min(specifiers.len, packages.len - offset)];

        for (batch, specifiers[0..batch.len]) |*package, *specifier_name| specifier_name.* = package.specifier;

        const input: Input = .{ .specifiers = specifiers[0..batch.len], .name = path, .offset = offset, .first = first };
        const result = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;

        if (result.duplicate) return .{ .first = result.first, .duplicate = true };

        first = result.first;
        offset += batch.len;
    }

    return .{ .first = first };
}

fn packageSelectionSeed(packages: []const scopes.Package, path: []const u8) PackageSelection {
    var selected: PackageSelection = .{};

    for (packages, 0..) |*package, index| {
        if (!std.mem.eql(u8, package.specifier, path)) continue;

        if (selected.first != null) {
            selected.duplicate = true;

            break;
        }

        selected.first = index;
    }

    return selected;
}

fn packageShape(package: *const scopes.Package) Shape {
    if (comptime enabled) {
        const generated = @import("generated_project_package_shape");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const value = if (package.compiled) |*target| target else null;

        const input: std.meta.Child(generated.Input) = .{
            .entry = package.entry,
            .compiled = value != null,
            .instance = if (value) |target| target.instance.len != 0 else false,
            .artifact = if (value) |target| target.artifact.len != 0 else false,
            .name = if (value) |target| target.name.len != 0 else false,
        };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (package.compiled) |value| {
        return if (package.entry.len == 0 and value.instance.len != 0 and value.artifact.len != 0 and value.name.len != 0) .Compiled else .InvalidCompiled;
    }

    return if (std.mem.endsWith(u8, package.entry, ".zx") or std.mem.endsWith(u8, package.entry, ".rx")) .Source else .InvalidSource;
}

pub fn select(allocator: std.mem.Allocator, candidate: []const u8, index: ?*const source_index.Map) std.mem.Allocator.Error![]const u8 {
    const known = index orelse return candidate;

    return paths.select(allocator, candidate, source_index.Known{ .paths = known });
}

pub fn checkFile(from: []const u8, target: []const u8, packages: []const scopes.Scope, reporter: *zx.Reporter, span: zx.Span) zx.Error!void {
    if (packages.len == 0) return;

    const owner = scopes.owner(packages, from) orelse return reporter.fail(.module, span, "source file does not belong to a declared package");

    if (scopes.owner(packages, target) != owner) return crossedPackage(reporter, span);
}

fn crossedPackage(reporter: *zx.Reporter, span: zx.Span) zx.Error {
    return reporter.fail(.module, span, "file import crosses a package boundary; declare and import the package dependency");
}
