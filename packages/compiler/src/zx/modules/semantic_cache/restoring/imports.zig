const std = @import("std");
const zx = @import("zx");
const Record = @import("../../module_record.zig");
pub const batch_size = @import("../../package_scope.zig").lookup_batch_size;

pub fn dependencies(previous: []const Record.Import, current: []const Record.Import) bool {
    const rule = @import("generated_semantic_restore_dependencies");
    const Input = std.meta.Child(rule.Input);

    if (previous.len != current.len) return false;

    const Row = std.meta.Child(std.meta.Elem(@FieldType(Input, "previous")));
    var batch: Batch(Row) = undefined;
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var offset: usize = 0;

    while (offset < previous.len) {
        const end = offset + @min(batch_size, previous.len - offset);
        const rows = batch.project(previous[offset..end], current[offset..end], dependency);
        const input: Input = .{ .previous = rows.previous, .current = rows.current };

        if (!(zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable)) return false;

        offset = end;
    }

    return true;
}

fn dependency(comptime Row: type, value: *const Record.Import) Row {
    const target = &value.target;
    const compiled = if (target.* == .compiled) &target.compiled else null;

    return .{
        .specifier = value.specifier,
        .identity = value.identity orelse value.specifier,
        .names = value.names,
        .source_names = if (value.source_names.len == 0) value.names else value.source_names,
        .kind = @intFromEnum(value.kind),
        .exported = value.exported,
        .wildcard = value.wildcard,
        .target = @intFromEnum(std.meta.activeTag(target.*)),
        .path = switch (target.*) {
            .source => |path| path,
            .compiled => |artifact| artifact.artifact,
            else => "",
        },
        .instance = if (compiled) |artifact| artifact.instance else "",
        .member = if (compiled) |artifact| artifact.name else "",
    };
}

pub fn Batch(comptime Row: type) type {
    return struct {
        const Self = @This();
        const Rows = struct { previous: []const *const Row, current: []const *const Row };
        left: [batch_size]Row,
        right: [batch_size]Row,
        left_view: [batch_size]*const Row,
        right_view: [batch_size]*const Row,
        pub fn project(self: *Self, previous: anytype, current: @TypeOf(previous), comptime view: anytype) Rows {
            const count = previous.len;

            for (previous, current, self.left[0..count], self.right[0..count], self.left_view[0..count], self.right_view[0..count]) |*a, *b, *l, *r, *p, *q| {
                l.* = view(Row, a);
                r.* = view(Row, b);
                p.* = l;
                q.* = r;
            }

            return .{ .previous = self.left_view[0..count], .current = self.right_view[0..count] };
        }
    };
}
