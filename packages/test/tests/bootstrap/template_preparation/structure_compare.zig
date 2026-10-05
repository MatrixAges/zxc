const std = @import("std");
const zx = @import("zx");
const native = @import("native_template");
const lexical = @import("lexical_compare.zig");
const program = @import("program");

pub fn check(allocator: std.mem.Allocator, source: []const u8, actual: program.Output) !void {
    const template_seen = try allocator.alloc(u8, actual.templates.len);
    const part_seen = try allocator.alloc(bool, actual.parts.len);
    const interpolation_seen = try allocator.alloc(bool, actual.interpolations.len);

    @memset(template_seen, 0);
    @memset(part_seen, false);
    @memset(interpolation_seen, false);

    try references(actual.lexed, actual.token_templates, actual, template_seen);

    for (actual.interpolations) |interpolation| {
        try lexical.same(allocator, source, interpolation.span.start, interpolation.span.end, interpolation.lexed);
        try references(interpolation.lexed, interpolation.token_templates, actual, template_seen);
    }

    for (actual.templates) |template| {
        var reporter = zx.Reporter{};

        try std.testing.expect(template.span.start < template.span.end and template.span.end <= source.len);
        try std.testing.expectEqual(@as(u8, '`'), source[template.span.start]);
        try std.testing.expectEqual(try native.end(source, template.span.start, &reporter, 0), template.span.end);
        try std.testing.expect(template.count > 0 and template.count <= actual.parts.len);

        const ordered = try allocator.alloc(usize, template.count);
        var head = template.head;

        for (0..ordered.len) |index| {
            try std.testing.expect(head > 0 and head <= actual.parts.len);
            try std.testing.expect(!part_seen[head - 1]);

            part_seen[head - 1] = true;
            ordered[ordered.len - 1 - index] = head - 1;
            const previous = actual.parts[head - 1].previous;

            try std.testing.expect(previous < head);

            head = previous;
        }

        try std.testing.expectEqual(@as(u64, 0), head);

        var cursor = template.span.start + 1;

        for (ordered, 0..) |part_id, index| {
            const part = actual.parts[part_id];

            try std.testing.expect(part.span.start <= part.span.end and part.span.end < template.span.end);

            if (index % 2 == 0) {
                try std.testing.expectEqual(.Text, part.kind);
                try std.testing.expectEqual(cursor, part.span.start);
                try std.testing.expectEqual(@as(u64, 0), part.interpolation);

                while (cursor < part.span.end) {
                    try std.testing.expect(!std.mem.startsWith(u8, source[cursor..], "${"));

                    cursor += if (source[cursor] == '\\') @as(u64, 2) else 1;
                }

                try std.testing.expectEqual(cursor, part.span.end);
            } else {
                try std.testing.expectEqual(.Expression, part.kind);
                try std.testing.expectEqualStrings("${", source[cursor..][0..2]);
                try std.testing.expectEqual(cursor + 2, part.span.start);
                try std.testing.expectEqual(try native.interpolationEnd(source, part.span.start, &reporter, 0), part.span.end);
                try std.testing.expect(part.interpolation > 0 and part.interpolation <= actual.interpolations.len);

                const id = part.interpolation - 1;

                try std.testing.expect(!interpolation_seen[id]);
                try std.testing.expectEqualDeep(part.span.*, actual.interpolations[id].span.*);

                interpolation_seen[id] = true;
                cursor = part.span.end + 1;
            }
        }

        try std.testing.expectEqual(@as(usize, 1), ordered.len % 2);
        try std.testing.expectEqual(template.span.end - 1, cursor);
    }

    for (template_seen) |seen| try std.testing.expectEqual(@as(u8, 1), seen);
    for (part_seen) |seen| try std.testing.expect(seen);
    for (interpolation_seen) |seen| try std.testing.expect(seen);
}

fn references(lexed: anytype, ids: []const u64, actual: program.Output, seen: []u8) !void {
    try std.testing.expectEqual(lexed.tokens.len, ids.len);

    for (lexed.tokens, ids) |token, id| {
        if (token.kind == .Template) {
            try std.testing.expect(id > 0 and id <= actual.templates.len);
            try std.testing.expectEqualDeep(token.span.*, actual.templates[id - 1].span.*);
            try std.testing.expectEqual(@as(u8, 0), seen[id - 1]);

            seen[id - 1] = 1;
        } else try std.testing.expectEqual(@as(u64, 0), id);
    }
}
