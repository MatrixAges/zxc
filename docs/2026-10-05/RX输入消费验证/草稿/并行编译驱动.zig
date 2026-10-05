const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = std.meta.stringToEnum(enum { owned_module, owned_direct, owned_task, owned_service, direct, service, error_first, allocation_first, input_error, task_direct, task_service, task_nested, task_error_first, task_allocation_first, task_input_error, task_capture, task_borrowed, thread_direct, thread_service, thread_task, thread_nested, task_borrowed_nested }, args[1]) orelse return error.InvalidMode;

    const entry_text = switch (mode) {
        .owned_module => @embedFile("parallel/fixtures/owned/module.rx"),
        .owned_direct => @embedFile("parallel/fixtures/owned/direct.rx"),
        .owned_task => @embedFile("parallel/fixtures/owned/task.rx"),
        .owned_service => @embedFile("parallel/fixtures/owned/service.rx"),
        .direct => @embedFile("parallel/fixtures/main.rx"),
        .service => @embedFile("parallel/fixtures/service.rx"),
        .error_first => @embedFile("parallel/fixtures/error_first.rx"),
        .allocation_first => @embedFile("parallel/fixtures/allocation_first.rx"),
        .input_error => @embedFile("parallel/fixtures/input_error.rx"),
        .task_direct => @embedFile("parallel/fixtures/task/direct.rx"),
        .task_service => @embedFile("parallel/fixtures/task/service.rx"),
        .task_nested => @embedFile("parallel/fixtures/task/nested.rx"),
        .task_error_first => @embedFile("parallel/fixtures/task/error_first.rx"),
        .task_allocation_first => @embedFile("parallel/fixtures/task/allocation_first.rx"),
        .task_input_error => @embedFile("parallel/fixtures/task/input_error.rx"),
        .task_capture => @embedFile("parallel/fixtures/task/capture.rx"),
        .task_borrowed => @embedFile("parallel/fixtures/task/borrowed.rx"),
        .task_borrowed_nested => @embedFile("parallel/fixtures/task/borrowed_nested.rx"),
        .thread_direct => @embedFile("parallel/fixtures/thread_direct.rx"),
        .thread_service => @embedFile("parallel/fixtures/thread_service.rx"),
        .thread_task => @embedFile("parallel/fixtures/thread_task.rx"),
        .thread_nested => @embedFile("parallel/fixtures/thread_nested.rx"),
    };

    const texts = [_][]const u8{
        entry_text,
        if (mode == .owned_service) @embedFile("parallel/fixtures/owned/leaf.rx") else if (mode == .thread_service) @embedFile("parallel/fixtures/thread_leaf.rx") else @embedFile("parallel/fixtures/left.rx"),
        if (mode == .owned_service) @embedFile("parallel/fixtures/owned/leaf.rx") else if (mode == .thread_service) @embedFile("parallel/fixtures/thread_leaf.rx") else @embedFile("parallel/fixtures/right.rx"),
    };

    const names = [_][]const u8{ "main.rx", "left.rx", "right.rx" };
    var parsed: [3]rx.XmlResult = undefined;
    var sources: [3]rx.ModuleSource = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, names, &parsed, &sources) |text, name, *item, *source| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;

        source.* = .{ .path = name, .node = item.value.node };
    }

    var owned_library: ?compiler.library.Result = null;

    defer if (owned_library) |*library| library.deinit();

    if (mode == .owned_module) {
        var owned_analysis = try compiler.project.analyze(allocator, &.{.{ .path = "consume.zx", .source = @embedFile("parallel/fixtures/owned/consume.zx") }}, .{ .entry = "consume.zx", .root_dir = "/library" });

        defer owned_analysis.deinit();

        if (owned_analysis.value != .ir) return error.InvalidOwnedInput;

        owned_library = try compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &owned_analysis }});
    }

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .project = .{
            .entry = "",
            .packages = if (owned_library != null) &.{.{ .specifier = "owned/consume", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume" } }} else &.{},
            .compiled_libraries = if (owned_library) |library| &.{.{ .instance = "owned@1", .artifact = "owned.zxlib", .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types }} else &.{},
        },
        .modules = &sources,
        .sources = &.{
            .{ .path = "consume.zx", .source = @embedFile("parallel/fixtures/owned/consume.zx") },
            .{ .path = "copy_values.zx", .source = @embedFile("parallel/fixtures/copy_values.zx") },
            .{ .path = "first.zx", .source = @embedFile("fixtures/first.zx") },
            .{ .path = "map_values.zx", .source = @embedFile("fixtures/map_values.zx") },
            .{ .path = "double_values.zx", .source = @embedFile("parallel/fixtures/double_values.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const program = result.value.contract.program;

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    if (std.mem.startsWith(u8, args[3], "archive_")) {
        const bytes = try @import("parallel/library/archive.zig").encode(allocator, result.value.contract, std.mem.endsWith(u8, args[3], "reverse"));

        defer allocator.free(bytes);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bytes });

        return;
    }

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
}
