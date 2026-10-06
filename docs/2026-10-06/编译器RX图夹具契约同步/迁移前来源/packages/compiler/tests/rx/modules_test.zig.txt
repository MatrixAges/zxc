const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

fn source(path: []const u8, children: []const rx.ast.Node) rx.ModuleSource {
    return .{ .path = path, .node = h.module(children) };
}

fn expectValid(sources: []const rx.ModuleSource) !void {
    var result = try rx.validateModules(std.testing.allocator, sources);

    defer result.deinit();

    switch (result.value) {
        .data => |data| try std.testing.expectEqual(sources.len, data.len),
        .diagnostic => |diagnostic| {
            std.debug.print("Module {d}: {s}\n", .{ diagnostic.source_index, diagnostic.issue.message });

            return error.UnexpectedModuleDiagnostic;
        },
    }
}

fn expectFailure(sources: []const rx.ModuleSource, owner: usize, attribute: ?[]const u8) !void {
    var result = try rx.validateModules(std.testing.allocator, sources);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(owner, result.value.diagnostic.source_index);

    if (attribute) |name| {
        try std.testing.expectEqualStrings(name, result.value.diagnostic.issue.attribute.?);
        try std.testing.expectEqualDeep(h.value_location, result.value.diagnostic.issue.location);
    } else {
        try std.testing.expectEqual(@as(?[]const u8, null), result.value.diagnostic.issue.attribute);
        try std.testing.expectEqualDeep(h.location, result.value.diagnostic.issue.location);
    }
}

test "modules compose through relative file paths without aliases or Pipeline" {
    const domain = source("domain/index.rx", &.{h.node("Call", .{ .service = "users", .in = "$in" }, &.{})});
    const parent = source("checkout.rx", &.{h.node("Call", .{ .service = "domain/index", .in = "$in" }, &.{})});

    try expectValid(&.{ parent, source("domain/users.rx", &.{h.call()}), domain });
}

test "orchestrator invokes multiple independent child modules" {
    const orchestrator = source("checkout.rx", &.{
        h.node("Call", .{ .service = "users", .in = "$in", .out = "ctx.user" }, &.{}),
        h.node("Call", .{ .service = "orders", .in = "ctx.user", .out = "ctx.order" }, &.{}),
    });

    try expectValid(&.{ source("users.rx", &.{h.call()}), source("orders.rx", &.{h.call()}), orchestrator });
}

test "Call requires exactly one function or service target" {
    const both = h.node("Call", .{ .@"fn" = "local", .service = "users", .in = "$in" }, &.{});
    const neither = h.node("Call", .{ .in = "$in" }, &.{});
    _ = try h.expectError("orders.rx", h.module(&.{both}), .context);
    _ = try h.expectError("orders.rx", h.module(&.{neither}), .context);

    inline for (.{ "/users", "users/", "app", "app.rx", "api.gateway", "jobs.store.rx", ".", ".." }) |path| {
        _ = try h.expectError("orders.rx", h.module(&.{h.node("Call", .{ .service = path, .in = "$in" }, &.{})}), .context);
    }
}

test "service calls cannot grant Store setters belonging to another module" {
    const invalid = h.node("Call", .{ .service = "users", .in = "$in", .setter = "[store.users.state]" }, &.{});

    _ = try h.expectError("orders.rx", h.module(&.{invalid}), .context);
}

test "Import is optional composition metadata and has no alias" {
    const imported = h.node("Import", .{ .from = "users" }, &.{});

    try expectValid(&.{ source("index.rx", &.{imported}), source("users.rx", &.{h.call()}) });

    _ = try h.expectError("orders.rx", h.module(&.{h.node("Task", .{ .name = "nested" }, &.{imported})}), .unexpected_element);
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Import", .{ .from = "users", .as = "account" }, &.{})}), .unknown_attribute);
}

test "same directory references support omitted dot slash and extension" {
    inline for (.{ "users", "./users", "users.rx", "./users.rx", "sub/../users" }) |path| {
        try expectValid(&.{
            source("area/index.rx", &.{h.node("Call", .{ .service = path, .in = "$in" }, &.{})}),
            source("area/users.rx", &.{h.call()}),
        });
    }
}

test "registration normalizes paths and distinguishes equal basenames in different directories" {
    const sources = [_]rx.ModuleSource{ source("./area//sub/../users.rx", &.{}), source("other/users.rx", &.{}) };
    var result = try rx.validateModules(std.testing.allocator, &sources);

    defer result.deinit();

    try std.testing.expect(result.value == .data);
    try std.testing.expectEqualStrings("area/users.rx", result.value.data[0].path);
    try std.testing.expectEqualStrings("other/users.rx", result.value.data[1].path);
    try expectFailure(&.{ source("area/users.rx", &.{}), source("./area/sub/../users.rx", &.{}) }, 1, null);
}

test "missing module files and references escaping the root report their source" {
    try expectFailure(&.{source("index.rx", &.{h.node("Import", .{ .from = "absent" }, &.{})})}, 0, "from");
    try expectFailure(&.{source("index.rx", &.{h.node("Call", .{ .service = "absent", .in = "$in" }, &.{})})}, 0, "service");
    try expectFailure(&.{source("index.rx", &.{h.node("Call", .{ .service = "../outside", .in = "$in" }, &.{})})}, 0, "service");
    try expectFailure(&.{source("../outside.rx", &.{})}, 0, null);
}

test "self calls and indirect cycles are detected after path normalization" {
    try expectFailure(&.{source("self.rx", &.{h.node("Call", .{ .service = "./nested/../self", .in = "$in" }, &.{})})}, 0, "service");

    const a = source("a.rx", &.{h.node("Call", .{ .service = "sub/b", .in = "$in" }, &.{})});
    const b = source("sub/b.rx", &.{h.node("Call", .{ .service = "../c", .in = "$in" }, &.{})});
    const c = source("c.rx", &.{h.node("Call", .{ .service = "a", .in = "$in" }, &.{})});

    try expectFailure(&.{ a, b, c }, 2, "service");
}

test "unused imports also cannot form circular composition" {
    const a = source("a.rx", &.{h.node("Import", .{ .from = "b" }, &.{})});
    const b = source("b.rx", &.{h.node("Import", .{ .from = "a" }, &.{})});

    try expectFailure(&.{ a, b }, 1, "from");
}

test "diamond dependencies and repeated calls are not cycles" {
    const left = source("left.rx", &.{h.node("Call", .{ .service = "users", .in = "$in" }, &.{})});
    const right = source("right.rx", &.{h.node("Call", .{ .service = "users", .in = "$in" }, &.{})});

    const top = source("top.rx", &.{
        h.node("Call", .{ .service = "left", .in = "$in" }, &.{}),
        h.node("Call", .{ .service = "right", .in = "$in" }, &.{}),
        h.node("Call", .{ .service = "left", .in = "$in" }, &.{}),
    });

    try expectValid(&.{ top, left, right, source("users.rx", &.{h.call()}) });
}

test "calls inside nested control structures participate in cycle detection" {
    const a = source("a.rx", &.{h.node("Task", .{ .name = "nested" }, &.{h.node("Call", .{ .service = "b", .in = "$in" }, &.{})})});
    const b = source("b.rx", &.{h.node("Call", .{ .service = "a", .in = "$in" }, &.{})});

    try expectFailure(&.{ a, b }, 1, "service");
}

test "module graph allocation failures release partial syntax and graph data" {
    const sources = [_]rx.ModuleSource{
        source("users.rx", &.{h.call()}),
        source("index.rx", &.{h.node("Call", .{ .service = "users", .in = "$in" }, &.{})}),
    };

    try std.testing.checkAllAllocationFailures(std.testing.allocator, struct {
        fn run(allocator: std.mem.Allocator, input: []const rx.ModuleSource) !void {
            var result = try rx.validateModules(allocator, input);

            defer result.deinit();

            try std.testing.expect(result.value == .data);
        }
    }.run, .{&sources});
}

test "event names do not create direct module dependency edges" {
    try expectValid(&.{
        source("a.rx", &.{h.node("Emit", .{ .event = "b", .value = "$in" }, &.{})}),
        source("b.rx", &.{h.node("Emit", .{ .event = "a", .value = "$in" }, &.{})}),
    });
}

test "registration rejects non module file kinds and invalid paths" {
    inline for (.{ "/absolute.rx", "app.rx", "api.gateway.rx", "state.store.rx", "users.rx/", "users", "users.zx" }) |path| {
        try expectFailure(&.{source(path, &.{})}, 0, null);
    }
}
