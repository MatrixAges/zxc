const std = @import("std");
const compiler = @import("compiler");

test "observe original void operator parsing without assuming diagnostic codes" {
    const memory = std.testing.allocator;
    const parsed = try std.json.parseFromSlice(std.json.Value, memory, @embedFile("probe_cases.json"), .{});

    defer parsed.deinit();

    for (parsed.value.array.items) |row| {
        const expression = row.object.get("expression").?.string;
        const assertion = row.object.get("assertion_kind").?.string;
        const binding = if (std.mem.eql(u8, assertion, "ReferenceError")) "" else "    const x = in\n";
        const source = try std.fmt.allocPrint(memory, "export type Input = u64\n\nexport type Output = void\n\nexport default function (in: Input): Output {{\n{s}    return {s}\n}}\n", .{ binding, expression });

        defer memory.free(source);

        var result = try compiler.project.analyze(memory, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx", .root_dir = "/project" });

        defer result.deinit();

        if (result.value == .diagnostic) {
            const issue = result.value.diagnostic;

            const report = try std.json.Stringify.valueAlloc(memory, .{
                .id = row.object.get("id").?.string,
                .status = "diagnostic",
                .code = @tagName(issue.code),
                .start = issue.span.start,
                .end = issue.span.end,
                .message = issue.message,
                .source = source,
            }, .{});

            defer memory.free(report);
            std.debug.print("OBSERVE {s}\n", .{report});
        } else {
            std.debug.print("ACCEPTED {s}\n", .{row.object.get("id").?.string});
        }
    }
}
