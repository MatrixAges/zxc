const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
pub const Source = struct { path: []const u8, text: []const u8 };
pub const Expected = struct { code: []const u8 = "name", marker: []const u8, path: []const u8 = "main.rx", last: bool = false, message: ?[]const u8 = null };

pub const Case = struct {
    source: []const u8,
    modules: []const Source = &.{},
    expected: ?Expected = null,
    output: compiler.ir.Scalar = .u64,
    store: bool = false,
    store_source: ?[]const u8 = null,
    slots: usize = 0,
};

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const parsed = try allocator.alloc(rx.XmlResult, case.modules.len + 1);

    defer allocator.free(parsed);

    const modules = try allocator.alloc(rx.ModuleSource, parsed.len);

    defer allocator.free(modules);

    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (parsed, modules, 0..) |*item, *module, index| {
        const source: Source = if (index == 0) .{ .path = "main.rx", .text = case.source } else case.modules[index - 1];
        item.* = try rx.parseXml(allocator, source.text);
        count += 1;

        try std.testing.expect(item.value == .node);

        module.* = .{ .path = source.path, .node = item.value.node };
    }

    var store = try rx.parseXml(allocator, case.store_source orelse @embedFile("fixtures/state.store.rx"));

    defer store.deinit();

    try std.testing.expect(store.value == .node);

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = modules,
        .stores = if (case.store) &.{.{ .path = "state.store.rx", .node = store.value.node }} else &.{},
        .sources = &.{
            .{ .path = "write_list.zx", .source = @embedFile("fixtures/write_list.zx") },
            .{ .path = "list.zx", .source = @embedFile("fixtures/list.zx") },
            .{ .path = "number.zx", .source = @embedFile("fixtures/number.zx") },
            .{ .path = "write.zx", .source = @embedFile("fixtures/write.zx") },
            .{ .path = "native.zx", .source = @embedFile("fixtures/native.zx") },
            .{ .path = "bridge.zx", .source = @embedFile("fixtures/bridge.zx") },
            .{ .path = "unused.zx", .source = @embedFile("fixtures/unused.zx") },
        },
        .project = .{
            .entry = "",
            .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = "export declare function apply(input: u64): u64\n", .module = "sample" }},
        },
    });

    defer result.deinit();

    if (case.expected) |expected| {
        if (result.value != .diagnostic) return error.ExpectedDiagnostic;

        const issue = result.value.diagnostic;
        var text = case.source;

        for (case.modules) |module| {
            if (std.mem.eql(u8, module.path, expected.path)) text = module.text;
        }

        const offset = (if (expected.last) std.mem.lastIndexOf(u8, text, expected.marker) else std.mem.indexOf(u8, text, expected.marker)) orelse return error.MissingMarker;
        var line: usize = 1;
        var column: usize = 1;

        for (text[0..offset]) |byte| {
            if (byte == '\n') {
                line += 1;
                column = 1;
            } else column += 1;
        }

        errdefer std.debug.print("diagnostic {s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        try std.testing.expectEqualStrings(expected.code, issue.code);
        try std.testing.expectEqualStrings(expected.path, issue.path);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqual(line, issue.location.line);
        try std.testing.expectEqual(column, issue.location.column);
        if (expected.message) |message| try std.testing.expect(std.mem.indexOf(u8, issue.message, message) != null);
    } else {
        if (result.value == .diagnostic) {
            std.debug.print("unexpected diagnostic {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

            return error.UnexpectedDiagnostic;
        }

        const program = result.value.contract.program;

        try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.output }, program.types[@intFromEnum(program.output_type)]);
        try std.testing.expectEqual(case.slots, program.stores.len);
        try std.testing.expect(try compiler.validateIr(allocator, program) == null);
    }
}
