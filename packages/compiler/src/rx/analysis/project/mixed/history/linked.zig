const std = @import("std");
const frontend = @import("frontend");
const Loaded = frontend.project.artifact.source_link.Loaded;

pub fn equal(left: *const Loaded, right: *const Loaded) bool {
    const link = @import("generated_rx_mixed_history_link");
    const Input = std.meta.Child(link.Input);
    const Port = std.meta.Child(@FieldType(Input, "left"));
    const lhs = port(Port, left);
    const rhs = port(Port, right);
    const input: Input = .{ .left = &lhs, .right = &rhs };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const allocator = fixed.allocator();

    if (!(link.executeIn(allocator, &input) catch unreachable)) return false;
    if (!rows(@import("generated_rx_mixed_history_export"), allocator, left.exports, right.exports)) return false;
    if (!rows(@import("generated_rx_mixed_history_initializer"), allocator, left.store_initializers, right.store_initializers)) return false;
    if (left.members.len != right.members.len or left.constant_exports.len != right.constant_exports.len) return false;

    if (left.members.ptr != right.members.ptr) {
        const entry = @import("generated_rx_mixed_history_member");
        const Pair = std.meta.Child(entry.Input);
        const Member = std.meta.Child(@FieldType(Pair, "left"));

        for (left.members, right.members) |*x, *y| {
            const l = x.borrow(Member);
            const r = y.borrow(Member);

            if (!(entry.executeIn(allocator, &.{ .left = &l, .right = &r }) catch unreachable)) return false;
        }
    }

    if (left.constant_exports.ptr != right.constant_exports.ptr) {
        const entry = @import("generated_rx_mixed_history_constant");
        const Pair = std.meta.Child(entry.Input);
        const Constant = std.meta.Child(@FieldType(Pair, "left"));
        const Literal = std.meta.Child(@FieldType(Constant, "value"));

        for (left.constant_exports, right.constant_exports) |x, y| {
            const l = frontend.borrowConstant(Literal, x);
            const r = frontend.borrowConstant(Literal, y);
            const a_constant: Constant = .{ .name = x.name, .value = &l };
            const b_constant: Constant = .{ .name = y.name, .value = &r };

            if (!(entry.executeIn(allocator, &.{ .left = &a_constant, .right = &b_constant }) catch unreachable)) return false;
        }
    }

    return true;
}

fn port(comptime Port: type, value: *const Loaded) Port {
    return .{
        .function = if (value.function) |id| @backingInt(id) else null,
        .input_type = @backingInt(value.input_type),
        .output_type = @backingInt(value.output_type),
    };
}

fn rows(comptime entry: type, allocator: std.mem.Allocator, left: anytype, right: @TypeOf(left)) bool {
    if (left.len != right.len) return false;
    if (left.ptr == right.ptr) return true;

    const Input = std.meta.Child(entry.Input);
    const Row = std.meta.Child(@FieldType(Input, "left"));

    for (left, right) |a, b| {
        const lhs = row(Row, a);
        const rhs = row(Row, b);

        if (!(entry.executeIn(allocator, &.{ .left = &lhs, .right = &rhs }) catch unreachable)) return false;
    }

    return true;
}

fn row(comptime Row: type, source: anytype) Row {
    var result: Row = undefined;

    inline for (@typeInfo(Row).@"struct".field_names) |name| {
        @field(result, name) = if (@typeInfo(@FieldType(@TypeOf(source), name)) == .@"enum")
            @backingInt(@field(source, name))
        else
            @field(source, name);
    }

    return result;
}
