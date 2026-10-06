const std = @import("std");
const compiler = @import("compiler");

const RetainedAllocator = struct {
    buffer: std.heap.FixedBufferAllocator,
    fn allocator(self: *RetainedAllocator) std.mem.Allocator {
        return .{ .ptr = self, .vtable = &.{
            .alloc = alloc,
            .resize = std.mem.Allocator.noResize,
            .remap = std.mem.Allocator.noRemap,
            .free = free,
        } };
    }
    fn alloc(context: *anyopaque, length: usize, alignment: std.mem.Alignment, address: usize) ?[*]u8 {
        const self: *RetainedAllocator = @ptrCast(@alignCast(context));

        return self.buffer.allocator().rawAlloc(length, alignment, address);
    }
    fn free(_: *anyopaque, memory: []u8, _: std.mem.Alignment, _: usize) void {
        @memset(memory, 0xa5);
    }
};

const source = "export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return )\n}\n";
const valid = "export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return in\n}\n";
const sources: []const compiler.project.Source = &.{.{ .path = "main.zx", .source = source }};
const options: compiler.project.Options = .{ .entry = "main.zx", .root_dir = "/project" };
const Route = enum { compile, format, analyze, direct_analyze, compile_project, cache_destroy, direct_cache_destroy, semantic_destroy, direct_semantic_destroy, cache_replace, direct_cache_replace, semantic_replace, direct_semantic_replace };

fn report(route: Route, issue: compiler.Diagnostic, expected: compiler.Diagnostic) bool {
    const intact = std.mem.eql(u8, issue.message, expected.message);

    std.debug.print("{s}: intact={} code={s} span={d}:{d} source_index={any} bytes={any}\n", .{
        @tagName(route), intact, @tagName(issue.code), issue.span.start, issue.span.end, issue.source_index, issue.message,
    });

    return intact and issue.code == expected.code and issue.span.start == expected.span.start and issue.span.end == expected.span.end;
}

fn check(route: Route, expected: compiler.Diagnostic) !bool {
    const memory = try std.heap.page_allocator.alloc(u8, 32 * 1024 * 1024);

    defer std.heap.page_allocator.free(memory);

    var retained = RetainedAllocator{ .buffer = std.heap.FixedBufferAllocator.init(memory) };
    const allocator = retained.allocator();

    switch (route) {
        .compile, .format, .compile_project => {
            const result = switch (route) {
                .compile => try compiler.compile(allocator, source, "main.zx"),
                .format => try compiler.format(allocator, source, "main.zx"),
                .compile_project => try compiler.compileProject(allocator, sources, options),
                else => unreachable,
            };

            defer result.deinit(allocator);

            if (result != .diagnostic) return error.ExpectedDiagnostic;

            return report(route, result.diagnostic, expected);
        },
        else => {
            var result = switch (route) {
                .analyze => try compiler.analyzeProject(allocator, sources, options),
                .direct_analyze => try compiler.project.analyze(allocator, sources, options),
                .cache_destroy, .direct_cache_destroy, .cache_replace, .direct_cache_replace => blk: {
                    var cache = compiler.project.ParseCache{ .allocator = allocator };

                    defer cache.deinit();

                    const analyzed = if (route == .cache_destroy or route == .cache_replace)
                        try compiler.analyzeProjectWithCache(allocator, sources, options, &cache)
                    else
                        try compiler.project.analyzeWithCache(allocator, sources, options, &cache);

                    if (route == .cache_replace or route == .direct_cache_replace) {
                        _ = try cache.get(valid, "/project/main.zx");
                        const intact = report(route, analyzed.value.diagnostic, expected);

                        std.debug.print("replacement_before_cache_deinit: intact={}\n", .{intact});
                    }

                    break :blk analyzed;
                },
                .semantic_destroy, .direct_semantic_destroy, .semantic_replace, .direct_semantic_replace => blk: {
                    var cache = compiler.project.SemanticCache.init(allocator);

                    defer cache.deinit();

                    const analyzed = if (route == .semantic_destroy or route == .semantic_replace)
                        try compiler.analyzeProjectIncremental(allocator, sources, options, &cache)
                    else
                        try compiler.project.analyzeIncremental(allocator, sources, options, &cache);

                    if (route == .semantic_replace or route == .direct_semantic_replace) {
                        _ = try cache.parse_cache.get(valid, "/project/main.zx");
                        const intact = report(route, analyzed.value.diagnostic, expected);

                        std.debug.print("replacement_before_cache_deinit: intact={}\n", .{intact});
                    }

                    break :blk analyzed;
                },
                else => unreachable,
            };

            defer result.deinit();

            if (result.value != .diagnostic) return error.ExpectedDiagnostic;

            return report(route, result.value.diagnostic, expected);
        },
    }
}

pub fn main() !void {
    var parsed = try compiler.parse(std.heap.page_allocator, source, "main.zx");

    defer parsed.deinit();

    if (parsed.value != .diagnostic) return error.ExpectedDiagnostic;

    const expected = parsed.value.diagnostic;

    std.debug.print("parse_control: message={s} code={s} span={d}:{d}\n", .{ expected.message, @tagName(expected.code), expected.span.start, expected.span.end });

    var failures: usize = 0;

    for (std.enums.values(Route)) |route| {
        if (!try check(route, expected)) failures += 1;
    }

    std.debug.print("checked={d} failures={d}\n", .{ std.enums.values(Route).len, failures });

    if (failures != 0) return error.DiagnosticLifetimeViolation;
}
