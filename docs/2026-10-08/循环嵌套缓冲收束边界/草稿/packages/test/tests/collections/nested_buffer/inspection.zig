const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
pub const Case = struct { count: u64, length: usize, enabled: bool = true };
pub const Input = @typeInfo(@typeInfo(@TypeOf(program.execute)).@"fn".param_types[1].?).pointer.child;

fn column(actual: []const u64, input: *const Input, offset: u64, prefix: []const u64) !void {
    const appended: usize = if (input.enabled) @intCast(input.count) else 0;

    try std.testing.expectEqual(prefix.len + appended, actual.len);
    try std.testing.expectEqualSlices(u64, prefix, actual[0..prefix.len]);
    for (actual[prefix.len..], 0..) |value, index| try std.testing.expectEqual(offset + @as(u64, @intCast(index)), value);
    if (appended == 0 and prefix.len != 0) try std.testing.expectEqual(prefix.ptr, actual.ptr);
}

pub fn check(output: program.Output, input: *const Input) !void {
    try std.testing.expectEqual(input.count, output.generated.values.len);
    try std.testing.expectEqual(input.count, output.generated.offsets.len);
    try std.testing.expectEqual(input.count, output.generated.labels.len);

    for (output.generated.values, output.generated.offsets, 0..) |value, offset, index| {
        try std.testing.expectEqual(@as(u64, @intCast(index)), value);
        try std.testing.expectEqual(@as(u64, @intCast(index + 1)), offset);
    }

    for (output.generated.labels) |label| try std.testing.expectEqualStrings(input.label, label);
    try std.testing.expectEqualSlices(u64, input.prefix, output.untouched);
    if (input.prefix.len != 0) try std.testing.expectEqual(input.prefix.ptr, output.untouched.ptr);
    try std.testing.expectEqual(input.records.ptr, output.records.ptr);
    try std.testing.expectEqual(input.pairs.ptr, output.pairs.ptr);
    try std.testing.expectEqual(input.records.len, output.records.len);
    try std.testing.expectEqual(input.pairs.len, output.pairs.len);

    for (input.records, output.records) |before, after| {
        try std.testing.expectEqual(before, after);
        try std.testing.expectEqualSlices(u64, input.prefix, after.values);
        try std.testing.expectEqual(input.marker, after.marker);
    }

    for (input.pairs, output.pairs) |before, after| {
        try std.testing.expectEqual(before, after);
        try std.testing.expectEqualSlices(u64, input.prefix, after.@"0");
        try std.testing.expectEqual(input.marker, after.@"1");
    }

    if (comptime std.mem.eql(u8, mode, "fresh") or std.mem.eql(u8, mode, "modular")) {
        try column(output.object.values, input, 11, &.{});
        try column(output.tuple.@"0", input, 21, &.{});
        try std.testing.expectEqual(input.marker.value, output.object.marker.value);
        try std.testing.expectEqual(input.marker.value, output.tuple.@"1".value);
    } else if (comptime std.mem.eql(u8, mode, "tuple")) {
        try column(output.direct.@"0", input, 11, input.prefix);
        try std.testing.expectEqual(input.marker.value, output.direct.@"1".value);
        if (input.count == 0) try std.testing.expectEqual(input.marker, output.direct.@"1");
    } else if (comptime std.mem.eql(u8, mode, "dual")) {
        try column(output.first.values, input, 11, input.prefix);
        try column(output.second.values, input, 21, input.prefix);
        try std.testing.expectEqual(input.marker.value, output.first.marker.value);
        try std.testing.expectEqual(input.marker.value, output.second.marker.value);

        if (input.count == 0) {
            try std.testing.expectEqual(input.marker, output.first.marker);
            try std.testing.expectEqual(input.marker, output.second.marker);
        }
    } else {
        try column(output.direct.values, input, 11, input.prefix);
        try std.testing.expectEqual(input.marker.value, output.direct.marker.value);

        if (input.count == 0) try std.testing.expectEqual(input.marker, output.direct.marker);
    }
}
