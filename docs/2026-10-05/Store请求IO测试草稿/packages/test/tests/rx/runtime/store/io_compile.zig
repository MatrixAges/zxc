const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { write, service, readonly }, args[1]) orelse return error.InvalidMode;

    const texts = [_][]const u8{
        switch (mode) {
            .write => @embedFile("io/fixtures/write.rx"),
            .service => @embedFile("io/fixtures/service.rx"),
            .readonly => @embedFile("io/fixtures/readonly.rx"),
        },
        @embedFile("io/fixtures/write.rx"),
        @embedFile("io/fixtures/state.store.rx"),
    };

    var parsed: [3]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;
    }

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{ .{ .path = "main.rx", .node = parsed[0].value.node }, .{ .path = "leaf.rx", .node = parsed[1].value.node } },
        .stores = &.{.{ .path = "state.store.rx", .node = parsed[2].value.node }},
        .sources = &.{
            .{ .path = "read.zx", .source = @embedFile("io/fixtures/read.zx") },
            .{ .path = "save.zx", .source = @embedFile("io/fixtures/save.zx") },
            .{ .path = "view.zx", .source = @embedFile("io/fixtures/view.zx") },
            .{ .path = "combine.zx", .source = @embedFile("io/fixtures/combine.zx") },
            .{ .path = "snapshot.zx", .source = @embedFile("io/fixtures/snapshot.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const contract = result.value.contract;

    if (contract.program.stores.len != 1 or contract.store_definitions.len != 1) return error.InvalidStoreCount;
    if (try compiler.validateIr(allocator, contract.program) != null) return error.InvalidIr;
    try @import("dual/emit_state.zig").write(init, contract, args[2]);
}
