const std = @import("std");
const compiler = @import("compiler");
const cached = @import("cached.zig");
const mixed = @import("mixed/analyze.zig");
const check = @import("mixed/check.zig");
const Fixture = enum { basic, mixed, loops };

fn emit(allocator: std.mem.Allocator, io: std.Io, program: compiler.ir.Program, paths: []const []const u8) !void {
    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = paths[0], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = paths[1], .data = bundle.types });
}

fn link(allocator: std.mem.Allocator, temporary: std.mem.Allocator, records: []const compiler.project.artifact.Result) !compiler.project.artifact.linker.Result {
    const modules = try temporary.alloc(compiler.project.artifact.Module, records.len);

    for (records, 0..) |record, index| modules[records.len - 1 - index] = record.value;

    return compiler.project.artifact.linker.link(allocator, modules, "/project/main.zx");
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 8) return error.ExpectedFixtureAndSixOutputs;

    const fixture = std.meta.stringToEnum(Fixture, args[1]) orelse return error.InvalidFixture;
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const allocator = heap.allocator();
    const empty_digest = try compiler.project.SemanticCache.contextDigest(allocator, .{});
    var decoded: []compiler.project.artifact.Result = &.{};
    var decoded_count: usize = 0;

    defer for (decoded[0..decoded_count]) |*record| record.deinit();

    {
        const records = extracted: {
            var result = if (fixture == .loops) try @import("loops/analyze.zig").analyze(allocator) else if (fixture == .mixed) try mixed.analyze(allocator, @embedFile("helper.zx")) else mixed.Result{
                .analysis = try compiler.project.analyze(allocator, &.{
                    .{ .path = "main.zx", .source = @embedFile("main.zx") },
                    .{ .path = "helper.zx", .source = @embedFile("helper.zx") },
                }, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = &.{.{ .specifier = "zig:choice", .path = "choice.d.zx", .source = @embedFile("choice.d.zx"), .module = "choice" }} }),
                .context_digest = empty_digest,
            };

            defer result.analysis.deinit();

            const analysis = &result.analysis;

            if (analysis.value == .diagnostic) std.debug.print("analysis diagnostic: {s}\n", .{analysis.value.diagnostic.message});
            if (analysis.value != .ir) return error.InvalidAnalysis;
            if (fixture == .loops and try compiler.validateIr(allocator, analysis.value.ir) != null) return error.InvalidLoopIr;
            if (fixture == .mixed) try check.program(allocator, analysis.value.ir);
            try emit(allocator, init.io, analysis.value.ir, args[2..4]);

            const items = try init.arena.allocator().alloc(compiler.project.artifact.Result, analysis.modules.len);
            var count: usize = 0;

            errdefer for (items[0..count]) |*record| record.deinit();

            decoded = try init.arena.allocator().alloc(compiler.project.artifact.Result, items.len);

            for (items, 0..) |*record, index| {
                record.* = try compiler.project.artifact.extract(allocator, analysis, index);
                count += 1;
                const digest = if (std.mem.eql(u8, record.value.path, "/project/main.zx")) result.context_digest else empty_digest;
                decoded[index] = try cached.restore(allocator, record.value, digest);
                decoded_count += 1;
            }

            break :extracted items;
        };

        defer for (records) |*record| record.deinit();

        var linked = try link(allocator, init.arena.allocator(), records);

        defer linked.deinit();

        if (fixture == .loops and try compiler.validateIr(allocator, linked.program) != null) return error.InvalidLinkedLoopIr;
        if (fixture == .mixed) try check.program(allocator, linked.program);
        try emit(allocator, init.io, linked.program, args[4..6]);
    }

    var restored = try link(allocator, init.arena.allocator(), decoded);

    defer restored.deinit();

    for (decoded[0..decoded_count]) |*record| record.deinit();

    decoded_count = 0;

    if (fixture == .loops and try compiler.validateIr(allocator, restored.program) != null) return error.InvalidRestoredLoopIr;
    if (fixture == .mixed) try check.program(allocator, restored.program);
    try emit(allocator, init.io, restored.program, args[6..8]);
}
