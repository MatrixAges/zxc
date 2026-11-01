const std = @import("std");
const rx = @import("rx");
const target = @import("../../call/target.zig");
const Frame = struct { node: rx.ast.Node, child: usize = 0, entered: bool = false };

pub fn collect(collector: anytype, source: rx.ModuleSource) @TypeOf(collector.*).Error!void {
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

fn reference(collector: anytype, owner: []const u8, node: rx.ast.Node) @TypeOf(collector.*).Error!void {
    const is_import = std.mem.eql(u8, node.name, "Import");
    const is_call = std.mem.eql(u8, node.name, "Call");
    const is_route = std.mem.eql(u8, node.name, "Route");
    const is_type = std.mem.eql(u8, node.name, "Type");
    const is_store = std.mem.eql(u8, node.name, "Store") and target.optionalAttribute(node, "from") != null;
    const is_shortcut = std.mem.eql(u8, node.name, "Module") and target.optionalAttribute(node, "fn") != null;

    if (!is_import and !is_call and !is_type and !is_shortcut and !is_store and !is_route) return;

    const attribute = if (is_import or is_type or is_store)
        target.optionalAttribute(node, "from")

    else if (is_route)
        target.optionalAttribute(node, "service")
    else
        target.optionalAttribute(node, "module") orelse target.optionalAttribute(node, "fn");

    const value = attribute orelse return collector.fail(node.location, "source dependency requires an explicit target");
    const packages = rx.module_reference.dependencies(collector.options, collector.ownerPath());

    if ((is_type or std.mem.eql(u8, value.name, "module")) and rx.module_reference.isPackage(value.value, packages)) {
        return collector.import(value.value, value.value_location);
    }

    const path = if (is_store)
        rx.resolveStorePath(collector.allocator, owner, value.value)

    else if (is_type or std.mem.eql(u8, value.name, "fn"))
        rx.resolveFunctionPath(collector.allocator, owner, value.value)
    else
        rx.resolveModulePath(collector.allocator, owner, value.value);

    const resolved = path catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return collector.fail(value.value_location, "source dependency must stay within the project root and name the expected module kind");
    };

    if (is_store) return collector.store(resolved, value.value_location, owner);
    try collector.local(resolved, value.value_location);
}
