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

const FilePlan = if (enabled) Output(@import("generated_project_file_target")) else struct {
    kind: enum { Relative, Root, Extension, Invalid },
    prefix: u64,
    path: []const u8,
    suffix: []const u8,
    directory: bool,
    rx: bool,
};

const ResolvedFile = struct { path: []const u8, fallback: bool };
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
    return (try resolveFile(allocator, from, path, root, false, reporter, span)).path;
}

fn resolveFile(allocator: std.mem.Allocator, from: []const u8, path: []const u8, root: []const u8, allow_rx: bool, reporter: *zx.Reporter, span: zx.Span) zx.Error!ResolvedFile {
    const plan = filePlan(path, allow_rx);

    switch (plan.kind) {
        .Extension => return reporter.fail(.module, span, "project imports must omit the .zx extension; runtime and RX imports are forbidden"),
        .Invalid => return reporter.fail(.module, span, "imports require ./, ../ or @/ paths; external interfaces require explicit registration"),
        .Relative, .Root => {},
    }

    var buffer: [512]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, allocator);
    const temporary = scratch.allocator();

    const source = if (plan.directory)
        try paths.directoryFor(temporary, plan.path, plan.rx)
    else
        try std.fmt.allocPrint(temporary, "{s}{s}", .{ plan.path, plan.suffix });

    defer temporary.free(source);

    const base = switch (plan.kind) {
        .Root => root,
        .Relative => std.fs.path.dirname(from) orelse ".",
        else => unreachable,
    };

    return .{
        .path = try std.fs.path.resolve(allocator, &.{ base, source[@intCast(plan.prefix)..] }),
        .fallback = !plan.directory and !plan.rx,
    };
}

fn filePlan(path: []const u8, allow_rx: bool) FilePlan {
    if (comptime enabled) {
        const generated = @import("generated_project_file_target");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(generated.Input) = .{
            .path = path,
            .basename = std.fs.path.basename(path),
            .extension = std.fs.path.extension(path).len != 0,
            .allow_rx = allow_rx,
        };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    const rx = allow_rx and std.mem.endsWith(u8, path, ".rx");
    const stem = if (rx) path[0 .. path.len - ".rx".len] else path;
    const directory = paths.directoryReference(stem);

    const kind: @FieldType(FilePlan, "kind") = if (!directory and std.fs.path.extension(stem).len != 0)
        .Extension

    else if (std.mem.startsWith(u8, stem, "@/"))
        .Root
    else if (std.mem.eql(u8, stem, ".") or std.mem.eql(u8, stem, "..") or std.mem.startsWith(u8, stem, "./") or std.mem.startsWith(u8, stem, "../"))
        .Relative
    else
        .Invalid;

    return .{
        .kind = kind,
        .prefix = if (kind == .Root) "@/".len else 0,
        .path = stem,
        .suffix = if (rx) ".rx" else ".zx",
        .directory = directory,
        .rx = rx,
    };
}

pub fn resolve(allocator: std.mem.Allocator, from: []const u8, path: []const u8, route: Route, options: anytype, reporter: *zx.Reporter, span: zx.Span) zx.Error!Target {
    if (route == .Invalid) return reporter.fail(.module, span, "invalid or unknown import specifier");

    const owner = scopes.owner(options.package_scopes, from);
    const root = if (owner) |index| options.package_scopes[index].root else options.root_dir;

    if (options.package_scopes.len != 0 and owner == null) return reporter.fail(.module, span, "source file does not belong to a declared package");

    switch (route) {
        .File => {
            const file = try resolveFile(allocator, from, path, root, true, reporter, span);
            var resolved = file.path;

            errdefer allocator.free(resolved);

            const selected = if (file.fallback) try select(allocator, resolved, options.source_index) else resolved;

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
