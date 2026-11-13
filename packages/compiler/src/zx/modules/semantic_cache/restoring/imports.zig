const std = @import("std");
const Record = @import("../../module_record.zig");
pub const batch_size = @import("../../package_scope.zig").lookup_batch_size;

pub fn dependency(comptime Row: type, value: *const Record.Import) Row {
    const target = &value.target;
    const compiled = if (target.* == .compiled) &target.compiled else null;

    return .{
        .specifier = value.specifier,
        .identity = value.identity orelse value.specifier,
        .names = value.names,
        .source_names = if (value.source_names.len == 0) value.names else value.source_names,
        .kind = @backingInt(value.kind),
        .exported = value.exported,
        .wildcard = value.wildcard,
        .target = @backingInt(std.meta.activeTag(target.*)),
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
            self.write(0, previous, current, view);

            return self.rows(previous.len);
        }
        pub fn write(self: *Self, start: usize, previous: anytype, current: @TypeOf(previous), comptime view: anytype) void {
            const end = start + previous.len;

            for (previous, current, self.left[start..end], self.right[start..end], self.left_view[start..end], self.right_view[start..end]) |*a, *b, *l, *r, *p, *q| {
                l.* = view(Row, a);
                r.* = view(Row, b);
                p.* = l;
                q.* = r;
            }
        }
        pub fn rows(self: *const Self, count: usize) Rows {
            return .{ .previous = self.left_view[0..count], .current = self.right_view[0..count] };
        }
    };
}
