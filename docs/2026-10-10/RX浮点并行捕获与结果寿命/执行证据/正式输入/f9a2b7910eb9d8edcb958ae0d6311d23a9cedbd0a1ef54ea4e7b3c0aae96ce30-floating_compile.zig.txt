const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const temporary = std.heap.page_allocator;
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 4) return error.ExpectedSourceRouteAndDirectory;

    _ = std.meta.stringToEnum(enum { source, forward, reverse, rx_forward, rx_reverse, zx_forward, zx_reverse, republish_forward, republish_reverse }, args[2]) orelse return error.InvalidRoute;

    const bytes = block: {
        const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], temporary, .limited(1024 * 1024));

        defer temporary.free(text);

        var parsed = try rx.parseXml(temporary, text);

        defer parsed.deinit();

        if (parsed.value != .node) return error.InvalidXml;

        var sources: std.ArrayList(compiler.project.Source) = .empty;

        defer {
            for (sources.items) |source| temporary.free(source.source);

            sources.deinit(temporary);
        }

        const names = if (args.len == 4) &[_][]const u8{ "identity.zx", "first.zx" } else args[4..];

        for (names) |name| {
            const path = if (args.len == 4) try std.fs.path.join(allocator, &.{ args[1][0 .. args[1].len - 3], name }) else name;
            const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, temporary, .limited(1024 * 1024));

            errdefer temporary.free(source);

            try sources.append(temporary, .{ .path = std.fs.path.basename(name), .source = source });
        }

        var inferred = try analysis.project.infer(temporary, .{
            .entry = "main.rx",
            .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
            .sources = sources.items,
            .project = .{ .entry = "" },
        });

        defer inferred.deinit();

        if (inferred.value == .diagnostic) {
            const issue = inferred.value.diagnostic;

            std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

            return error.InvalidContract;
        }

        const contract = inferred.value.contract;

        if (try compiler.validateIr(temporary, contract.program) != null) return error.InvalidIr;
        if (std.mem.eql(u8, args[2], "source")) return @import("floating/output.zig").emit(init, contract.program, args[3]);

        break :block try @import("parallel/library/archive.zig").encode(temporary, contract, std.mem.endsWith(u8, args[2], "reverse"));
    };

    defer temporary.free(bytes);

    try @import("floating/library.zig").emit(init, bytes, args[2], args[3]);
}
