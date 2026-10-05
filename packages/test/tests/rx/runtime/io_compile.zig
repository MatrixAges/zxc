const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { workflow, service, task, selection, discard, void, void_service, input_error }, args[1]) orelse return error.InvalidMode;

    const main_text = switch (mode) {
        .workflow => @embedFile("io/fixtures/workflow.rx"),
        .service => @embedFile("io/fixtures/service.rx"),
        .task => @embedFile("io/fixtures/task.rx"),
        .selection => @embedFile("io/fixtures/selection.rx"),
        .discard => @embedFile("io/fixtures/discard.rx"),
        .void => @embedFile("io/fixtures/void.rx"),
        .void_service => @embedFile("io/fixtures/void_service.rx"),
        .input_error => @embedFile("io/fixtures/input_error.rx"),
    };

    const texts = [_][]const u8{ main_text, if (mode == .void_service) @embedFile("io/fixtures/void.rx") else @embedFile("io/fixtures/workflow.rx") };
    const names = [_][]const u8{ "main.rx", "leaf.rx" };
    var parsed: [2]rx.XmlResult = undefined;
    var modules: [2]rx.ModuleSource = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, names, &parsed, &modules) |text, name, *item, *module| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;

        module.* = .{ .path = name, .node = item.value.node };
    }

    var inferred = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &modules,
        .sources = &.{
            .{ .path = "write.zx", .source = @embedFile("io/fixtures/write.zx") },
            .{ .path = "read.zx", .source = @embedFile("io/fixtures/read.zx") },
            .{ .path = "read_after.zx", .source = @embedFile("io/fixtures/read.zx") },
            .{ .path = "copy.zx", .source = @embedFile("io/fixtures/copy.zx") },
            .{ .path = "rename.zx", .source = @embedFile("io/fixtures/rename.zx") },
            .{ .path = "truncate.zx", .source = @embedFile("io/fixtures/truncate.zx") },
        },
    });

    defer inferred.deinit();

    if (inferred.value == .diagnostic) {
        const issue = inferred.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const program = inferred.value.contract.program;

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    for (program.native_modules) |native| {
        try std.testing.expectEqualStrings("zxc_standard", native.import_name);
        try std.testing.expectEqualStrings("std:fs", native.specifier);
    }

    if (std.mem.startsWith(u8, args[3], "archive_")) {
        const bytes = try @import("parallel/library/archive.zig").encode(allocator, inferred.value.contract, std.mem.endsWith(u8, args[3], "reverse"));

        defer allocator.free(bytes);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bytes });

        return;
    }

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
}
