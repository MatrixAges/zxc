const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const compiler = @import("compiler");
const Reference = @import("rx_analysis").project.source_graph.Reference;
const Self = @This();
pub const Error = anyerror;

allocator: std.mem.Allocator,
options: compiler.project.Options,
owner: []const u8,
queue: *std.ArrayList([]const u8),
queued: *std.StringHashMapUnmanaged(void),
io: std.Io,
inputs: ?*@import("../../watch/inputs.zig"),
libraries: ?*@import("../../library/inputs.zig"),
writer: *std.Io.Writer,
pub fn ownerPath(self: *const Self) []const u8 {
    return self.owner;
}

pub fn fail(self: *Self, location: rx.ast.Location, message: []const u8) Error {
    try self.writer.print("{s}:{d}:{d}: module: {s}\n", .{ self.owner, location.line, location.column, message });

    return error.InvalidSourceGraph;
}

pub fn local(self: *Self, path: []const u8, _: rx.ast.Location, _: Reference) Error!void {
    const absolute = try std.fs.path.resolve(self.allocator, &.{ self.options.root_dir, path });
    const found = try self.queued.getOrPut(self.allocator, absolute);

    if (found.found_existing) {
        self.allocator.free(absolute);

        return;
    }

    try self.queue.append(self.allocator, absolute);
}

pub fn store(self: *Self, path: []const u8, location: rx.ast.Location, _: []const u8) Error!void {
    return self.local(path, location, .dependency);
}

pub fn import(self: *Self, reference: []const u8, location: rx.ast.Location, role: Reference) Error!void {
    const kind = compiler.project.specifier.classify(reference) catch return self.fail(location, "invalid module reference");

    if (kind != .file and kind != .package) return;

    var reporter: zx.Reporter = .{};

    const target = compiler.project.resolveModuleTarget(self.allocator, self.owner, reference, self.options, &reporter, .{ .start = location.offset, .end = location.offset }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return self.fail(location, reporter.diagnostic.?.message);
    };

    switch (target) {
        .source => |path| try self.local(path, location, role),
        .compiled => |compiled| if (self.libraries) |libraries| try libraries.add(self.io, compiled, self.options, self.inputs),
    }
}

pub fn header(self: *Self, view: anytype) Error!void {
    for (0..view.importCount()) |index| {
        const item = view.importAt(index);

        try self.import(item.path, .{ .offset = item.span.start, .line = 1, .column = 1 }, .dependency);
    }
}
