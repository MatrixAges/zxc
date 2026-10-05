const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
const Mode = enum { pure, helper_write, helper_read, entry_read, missing_parameter, field_write, incomplete_object };
const header = "export type Input = u64\n\nexport type Output = u64\n\n";

fn check(allocator: std.mem.Allocator, mode: Mode) !void {
    const helper = switch (mode) {
        .helper_write => header ++ "export default function (in: Input, { store }): Output {\n  store.jobs.counter = { value: in, history: [8] }\n\n  return in\n}\n",
        .helper_read => header ++ "export default function (in: Input): Output {\n  return $store.value.value\n}\n",
        else => header ++ "export default function (in: Input): Output {\n  return in + 1\n}\n",
    };

    const body = switch (mode) {
        .entry_read => "  const next = $store.value.value\n\n  store.jobs.counter = { value: next, history: [8] }\n",
        .field_write => "  const next = helper(in)\n\n  store.jobs.counter.value = next\n",
        .incomplete_object => "  const next = helper(in)\n\n  store.jobs.counter = { value: next }\n",
        else => "  const next = helper(in)\n\n  store.jobs.counter = { value: next, history: [8] }\n",
    };

    const entry = try std.mem.concat(allocator, u8, &.{
        "import helper from \"./helper.zx\"\n\n" ++ header,
        if (mode == .missing_parameter) "export default function (in: Input): Output {\n" else "export default function (in: Input, { store }): Output {\n",
        body,
        "\n  return next\n}\n",
    });

    defer allocator.free(entry);

    var main = try rx.parseXml(allocator, "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter]} out='ctx.value'/><Return value={ctx.value}/></Module>");

    defer main.deinit();

    var state = try rx.parseXml(allocator, @embedFile("fixtures/state.store.rx"));

    defer state.deinit();

    try std.testing.expect(main.value == .node and state.value == .node);

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = main.value.node }},
        .stores = &.{.{ .path = "state.store.rx", .node = state.value.node }},
        .sources = &.{ .{ .path = "write.zx", .source = entry }, .{ .path = "helper.zx", .source = helper } },
    });

    defer result.deinit();

    if (mode == .pure) {
        try std.testing.expect(result.value == .contract);
        try std.testing.expectEqual(@as(usize, 1), result.value.contract.program.stores.len);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.contract.program) == null);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings(if (mode == .incomplete_object) "type_mismatch" else "capability", result.value.diagnostic.code);
        try std.testing.expectEqualStrings(if (mode == .helper_write or mode == .helper_read) "helper.zx" else "write.zx", result.value.diagnostic.path);
    }
}

test "RX Store function permission pure" {
    try check(std.testing.allocator, .pure);
}

test "RX Store function permission helper_write" {
    try check(std.testing.allocator, .helper_write);
}

test "RX Store function permission helper_read" {
    try check(std.testing.allocator, .helper_read);
}

test "RX Store function permission entry_read" {
    try check(std.testing.allocator, .entry_read);
}

test "RX Store function permission missing_parameter" {
    try check(std.testing.allocator, .missing_parameter);
}

test "RX Store function permission field_write" {
    try check(std.testing.allocator, .field_write);
}

test "RX Store function permission incomplete_object" {
    try check(std.testing.allocator, .incomplete_object);
}

test "RX Store function permission pure allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.pure});
}

test "RX Store function permission helper_write allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.helper_write});
}
