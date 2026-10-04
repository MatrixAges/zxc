const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

pub const Case = struct {
    source: []const u8,
    code: ?[]const u8 = null,
    marker: []const u8 = "",
    last: bool = false,
    other_store: bool = false,
    slots: usize = 0,
};

pub fn run(case: Case) !void {
    const allocator = std.testing.allocator;
    var main = try rx.parseXml(allocator, case.source);

    defer main.deinit();

    var state = try rx.parseXml(allocator, @embedFile("fixtures/state.store.rx"));

    defer state.deinit();

    try std.testing.expect(main.value == .node and state.value == .node);

    const stores = [_]rx.ModuleSource{
        .{ .path = "state.store.rx", .node = state.value.node },
        .{ .path = "other.store.rx", .node = state.value.node },
    };
    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = main.value.node }},
        .stores = stores[0..if (case.other_store) @as(usize, 2) else 1],
        .sources = &.{
            .{ .path = "read.zx", .source = @embedFile("fixtures/read.zx") },
            .{ .path = "write.zx", .source = @embedFile("fixtures/write.zx") },
        },
    });

    defer result.deinit();

    if (case.code) |code| {
        try std.testing.expect(result.value == .diagnostic);

        const issue = result.value.diagnostic;
        const offset = if (case.last) std.mem.lastIndexOf(u8, case.source, case.marker).? else std.mem.indexOf(u8, case.source, case.marker).?;

        try std.testing.expectEqualStrings(code, issue.code);
        try std.testing.expectEqualStrings("main.rx", issue.path);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqual(@as(usize, 1), issue.location.line);
        try std.testing.expectEqual(offset + 1, issue.location.column);
    } else {
        try std.testing.expect(result.value == .contract);
        try std.testing.expectEqual(case.slots, result.value.contract.program.stores.len);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.contract.program) == null);

        if (case.slots == 2) {
            const slots = result.value.contract.program.stores;

            try std.testing.expect(!std.mem.eql(u8, slots[0].path, slots[1].path));
        }
    }
}
