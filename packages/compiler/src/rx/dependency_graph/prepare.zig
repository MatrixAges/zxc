const std = @import("std");
const dsl = @import("dsl");
const generated = @import("generated_graph");
const checks = @import("../checks.zig");
const modules = @import("../modules.zig");
const paths = @import("../paths.zig");
const Input = @typeInfo(generated.Input).pointer.child;
const Issue = @typeInfo(@FieldType(Input, "issues")).pointer.child;
const Link = struct { owner: usize, node: *const dsl.ast.Node, attribute: []const u8 };
const Result = struct { input: Input, links: []const Link };
const Frame = struct { node: *const dsl.ast.Node, child: usize = 0, entered: bool = false };

pub fn build(allocator: std.mem.Allocator, sources: []const modules.Source, entries: []const modules.Module) std.mem.Allocator.Error!Result {
    var registered: std.StringHashMapUnmanaged(usize) = .empty;

    defer registered.deinit(allocator);

    for (entries, 0..) |entry, index| try registered.put(allocator, entry.path, index);

    var offsets: std.ArrayList(u64) = .empty;
    var targets: std.ArrayList(u64) = .empty;
    var issues: std.ArrayList(Issue) = .empty;
    var links: std.ArrayList(Link) = .empty;
    var frames: std.ArrayList(Frame) = .empty;

    defer frames.deinit(allocator);

    for (sources, 0..) |*source, owner| {
        try offsets.append(allocator, targets.items.len);
        try frames.append(allocator, .{ .node = &source.node });

        while (frames.items.len != 0) {
            const frame = &frames.items[frames.items.len - 1];

            if (!frame.entered) {
                frame.entered = true;
                const node = frame.node;
                const attribute: ?[]const u8 = if (std.mem.eql(u8, node.name, "Import")) "from" else if (std.mem.eql(u8, node.name, "Call") and checks.attribute(node.*, "module") != null) "module" else null;

                if (attribute) |key| {
                    const reference = checks.attribute(node.*, key).?;
                    const package = std.mem.eql(u8, key, "module") and @import("../module_reference.zig").isPackage(reference, source.packages);

                    if (!package) {
                        const target = try resolve(allocator, registered, entries[owner].path, reference);

                        try targets.append(allocator, target.index);
                        try issues.append(allocator, target.issue);
                        try links.append(allocator, .{ .owner = owner, .node = node, .attribute = key });
                    }
                }
            }

            if (frame.child < frame.node.children.len) {
                const child = &frame.node.children[frame.child];
                frame.child += 1;

                try frames.append(allocator, .{ .node = child });
            } else _ = frames.pop();
        }
    }

    try offsets.append(allocator, targets.items.len);

    return .{ .input = .{ .offsets = offsets.items, .targets = targets.items, .issues = issues.items }, .links = links.items };
}

fn resolve(allocator: std.mem.Allocator, registered: std.StringHashMapUnmanaged(usize), owner: []const u8, reference: []const u8) std.mem.Allocator.Error!struct { index: u64 = 0, issue: Issue = .None } {
    const path = paths.resolve(allocator, owner, reference) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidPath => return .{ .issue = .InvalidPath },
    };

    defer allocator.free(path);

    return if (registered.get(path)) |index| .{ .index = index } else .{ .issue = .Missing };
}
