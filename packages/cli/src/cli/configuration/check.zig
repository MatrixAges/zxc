const std = @import("std");
const pkgs = @import("pkgs");
const Kind = @import("kind.zig").Kind;

pub fn run(allocator: std.mem.Allocator, kind: Kind, source: []const u8, path: []const u8, writer: *std.Io.Writer) !bool {
    switch (kind) {
        .manifest => {
            var result = try @import("../../package/manifest.zig").parse(allocator, source);

            defer result.deinit();

            if (result.value == .diagnostic) {
                const issue = result.value.diagnostic;

                try writer.print("{s}:{d}:{d}: manifest: {s}\n", .{ path, issue.line, issue.column, issue.message });

                return false;
            }
        },
        .index => {
            const result = try pkgs.Index.parse(allocator, source);

            defer result.deinit();
        },
        .lock => {
            const result = try pkgs.Lock.parse(allocator, source);

            defer result.deinit();
        },
    }

    return true;
}
