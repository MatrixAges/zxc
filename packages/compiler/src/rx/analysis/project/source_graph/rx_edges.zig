const std = @import("std");
const rx = @import("rx");
const target = @import("../../call/target.zig");
const Collector = @import("collect.zig");
const Frame = struct { node: rx.ast.Node, child: usize = 0, entered: bool = false };

pub fn collect(collector: *Collector, source: rx.ModuleSource) Collector.Error!void {
    var frames: std.ArrayList(Frame) = .empty;

    defer frames.deinit(collector.allocator);

    try frames.append(collector.allocator, .{ .node = source.node });

    while (frames.items.len != 0) {
        const frame = &frames.items[frames.items.len - 1];

        if (!frame.entered) {
            frame.entered = true;

            try reference(collector, source.path, frame.node);
        }

        if (frame.child < frame.node.children.len) {
            const child = frame.node.children[frame.child];

            frame.child += 1;

            try frames.append(collector.allocator, .{ .node = child });
        } else _ = frames.pop();
    }
}

fn reference(collector: *Collector, owner: []const u8, node: rx.ast.Node) Collector.Error!void {
    const is_import = std.mem.eql(u8, node.name, "Import");
    const is_call = std.mem.eql(u8, node.name, "Call");

    if (!is_import and !is_call) return;

    const attribute = if (is_import)
        target.optionalAttribute(node, "from")

    else
        target.optionalAttribute(node, "module") orelse target.optionalAttribute(node, "fn");

    const value = attribute orelse return collector.fail(node.location, "source dependency requires an explicit target");
    const packages = rx.module_reference.dependencies(collector.options, collector.modules[collector.owner].path);

    if (std.mem.eql(u8, value.name, "module") and rx.module_reference.isPackage(value.value, packages)) {
        return collector.import(value.value, value.value_location);
    }

    const path = if (std.mem.eql(u8, value.name, "fn"))
        rx.resolveFunctionPath(collector.allocator, owner, value.value)

    else
        rx.resolveModulePath(collector.allocator, owner, value.value);

    const resolved = path catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return collector.fail(value.value_location, "source dependency must stay within the project root and name the expected module kind");
    };

    try collector.local(resolved, value.value_location);
}
