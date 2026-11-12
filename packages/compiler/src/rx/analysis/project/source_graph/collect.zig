const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const project = @import("frontend").project;
const model = @import("model.zig");
const Diagnostic = @import("../../call/target.zig").Diagnostic;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidGraph};

allocator: std.mem.Allocator,
options: project.Options,
modules: []model.Module,
paths: @import("zx").bytes.Map(usize),
edges: std.ArrayList(model.Edge) = .empty,
owner: usize = 0,
issue: ?Diagnostic = null,
pub fn ownerPath(self: *const Self) []const u8 {
    return self.modules[self.owner].path;
}

pub fn store(self: *Self, path: []const u8, location: rx.ast.Location, owner: []const u8) Error!void {
    const absolute = try std.fs.path.resolve(self.allocator, &.{ self.options.root_dir, path });

    if (!self.paths.contains(absolute)) {
        self.issue = .{ .path = try self.allocator.dupe(u8, owner), .location = location, .code = "capability", .message = "Store definition is not registered" };

        return error.InvalidGraph;
    }

    try self.local(path, location, .dependency);
}

pub fn fail(self: *Self, location: rx.ast.Location, message: []const u8) Error {
    self.issue = .{
        .path = self.modules[self.owner].path,
        .location = location,
        .code = "module",
        .message = try self.allocator.dupe(u8, message),
    };

    return error.InvalidGraph;
}

fn source(self: *Self, path: []const u8, location: rx.ast.Location, reference: model.Reference) Error!void {
    const index = self.paths.get(path) orelse return self.fail(location, "source module dependency is missing from the registered input set");

    try self.edges.append(self.allocator, .{ .target = .{ .source = index }, .location = location, .reference = reference });
}

pub fn local(self: *Self, path: []const u8, location: rx.ast.Location, reference: model.Reference) Error!void {
    const absolute = try std.fs.path.resolve(self.allocator, &.{ self.options.root_dir, path });
    const resolved = if (std.mem.endsWith(u8, absolute, ".zx")) try project.selectSource(self.allocator, absolute, self.options) else absolute;
    const scopes = self.options.package_scopes;

    if (scopes.len != 0) {
        const owner = project.package_scope.owner(scopes, self.modules[self.owner].path);

        if (owner == null) return self.fail(location, "source file does not belong to a declared package");
        if (project.package_scope.owner(scopes, resolved) != owner) return self.fail(location, "file import crosses a package boundary; declare and import the package dependency");
    }

    try self.source(resolved, location, reference);
}

pub fn import(self: *Self, reference: []const u8, location: rx.ast.Location, role: model.Reference) Error!void {
    const kind = project.specifier.classify(reference) catch return self.fail(location, "invalid or unknown import specifier");

    if (kind != .file and kind != .package) {
        try self.edges.append(self.allocator, .{ .target = .{ .native = try self.allocator.dupe(u8, reference) }, .location = location, .reference = role });

        return;
    }

    var reporter: zx.Reporter = .{};

    const target = project.resolveModuleTarget(self.allocator, self.modules[self.owner].path, reference, self.options, &reporter, .{ .start = location.offset, .end = location.offset }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return self.fail(location, reporter.diagnostic.?.message);
    };

    switch (target) {
        .source => |path| try self.source(path, location, role),
        .compiled => |compiled| try self.edges.append(self.allocator, .{ .target = .{ .compiled = compiled }, .location = location, .reference = role }),
    }
}
