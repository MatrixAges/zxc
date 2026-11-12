const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("../../call/target.zig");
const Reference = @import("model.zig").Reference;
const generated = @import("rx_options").generated_graph;
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
    const kind = classify(node.name);

    const attribute = switch (kind) {
        .Other => return,
        .Store => target.optionalAttribute(node, "from") orelse return,
        .Shortcut => target.optionalAttribute(node, "fn") orelse return,
        .Import, .Type => target.optionalAttribute(node, "from"),
        .Route => target.optionalAttribute(node, "service"),
        .Call => target.optionalAttribute(node, "module") orelse target.optionalAttribute(node, "fn"),
    };

    const value = attribute orelse return collector.fail(node.location, "source dependency requires an explicit target");
    const module = kind == .Call and std.mem.eql(u8, value.name, "module");

    const role: Reference = switch (kind) {
        .Call, .Shortcut => .call,
        .Type => .type_import,
        else => .dependency,
    };

    if (kind == .Type or module) {
        const packages = rx.module_reference.dependencies(collector.options, collector.ownerPath());

        if (rx.module_reference.isPackage(value.value, packages)) return collector.import(value.value, value.value_location, role);
    }

    const path = switch (kind) {
        .Store => rx.resolveStorePath(collector.allocator, owner, value.value),
        .Type, .Shortcut => rx.resolveFunctionPath(collector.allocator, owner, value.value),
        .Call => if (module) rx.resolveModulePath(collector.allocator, owner, value.value) else rx.resolveFunctionPath(collector.allocator, owner, value.value),
        .Import, .Route => rx.resolveModulePath(collector.allocator, owner, value.value),
        .Other => unreachable,
    };

    const resolved = path catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return collector.fail(value.value_location, "source dependency escapes the project root or is not a valid module path");
    };

    if (kind == .Store) return collector.store(resolved, value.value_location, owner);
    try collector.local(resolved, value.value_location, role);
}

const Kind = if (generated)
    @typeInfo(@TypeOf(@import("generated_rx_reference_kind").executeValue(undefined, undefined))).error_union.payload

else
    enum { Import, Call, Shortcut, Type, Store, Route, Other };

fn classify(tag: []const u8) Kind {
    if (comptime generated) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return @import("generated_rx_reference_kind").executeValue(empty.allocator(), tag) catch unreachable;
    }

    if (std.mem.eql(u8, tag, "Import")) return .Import;
    if (std.mem.eql(u8, tag, "Call")) return .Call;
    if (std.mem.eql(u8, tag, "Module")) return .Shortcut;
    if (std.mem.eql(u8, tag, "Type")) return .Type;
    if (std.mem.eql(u8, tag, "Store")) return .Store;
    if (std.mem.eql(u8, tag, "Route")) return .Route;

    return .Other;
}
