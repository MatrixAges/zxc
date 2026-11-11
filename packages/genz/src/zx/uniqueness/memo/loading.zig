const std = @import("std");
const columns = @import("zx").columns;
const Memo = @import("../memo.zig");
const Function = @import("../function.zig");
const Level = @import("../level.zig").Level;
const disk = @import("disk.zig");
const Error = std.mem.Allocator.Error;

pub fn load(memo: *Memo, source: []const u8) Error!void {
    const layout = (try disk.inspect(memo.arena.child_allocator, source)) orelse return;
    const allocator = memo.arena.allocator();
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const memory = empty.allocator();

    try section(allocator, memory, source, layout.settled_start, layout.settled_count, &memo.settled, settled);
    try section(allocator, memory, source, layout.demanded_start, layout.demanded_count, &memo.demanded, demanded);
    try section(allocator, memory, source, layout.planned_start, layout.planned_count, &memo.planned, planned);
    try section(allocator, memory, source, layout.flowed_start, layout.flowed_count, &memo.flowed, flowed);
}

fn section(allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64, count: u32, map: anytype, comptime materialize: anytype) Error!void {
    try map.ensureUnusedCapacity(allocator, count);

    var at = start;

    for (0..count) |_| {
        const key = source[@intCast(at)..][0..@sizeOf(Memo.Digest)].*;
        const row = try materialize(allocator, memory, source, at + @sizeOf(Memo.Digest));

        map.putAssumeCapacity(key, row.value);

        at = row.end;
    }
}

fn Row(comptime T: type) type {
    return struct { value: T, end: u64 };
}

fn settled(allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64) Error!Row(Memo.Settled) {
    const shape = try decode(@import("generated_uniqueness_memo_disk_settled"), memory, .{ .source = source, .start = start, .trusted = true }) orelse unreachable;
    const passed = try allocator.alloc(Function.Contribution, shape.passed_count);
    var at = shape.passed_start;

    for (passed) |*target| {
        const row = try decode(@import("generated_uniqueness_memo_disk_contribution"), memory, .{ .source = source, .start = at });
        target.* = .{ .callee = row.callee, .levels = try copy(Level, allocator, source, row.start, row.end) };
        at = row.end;
    }

    return .{
        .value = .{ .passed = passed, .output = try copy(Level, allocator, source, shape.output_start, shape.output_end), .used = false },
        .end = shape.end,
    };
}

fn demanded(allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64) Error!Row(Memo.Demanded) {
    const shape = try decode(@import("generated_uniqueness_memo_disk_demanded"), memory, .{ .source = source, .start = start, .trusted = true }) orelse unreachable;

    return .{
        .value = .{
            .marks = try rows(Function.Mark, @import("generated_uniqueness_memo_disk_mark"), allocator, memory, source, shape.marks_start, shape.marks_count),
            .normalized = try rows(Memo.Normalized, @import("generated_uniqueness_memo_disk_normalized"), allocator, memory, source, shape.normalized_start, shape.normalized_count),
            .renewed = try rows(Memo.Renewed, @import("generated_uniqueness_memo_disk_renewed"), allocator, memory, source, shape.renewed_start, shape.renewed_count),
            .grew = shape.grew,
            .used = false,
        },
        .end = shape.end,
    };
}

fn planned(allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64) Error!Row(Memo.Planned) {
    const shape = try decode(@import("generated_uniqueness_memo_disk_planned"), memory, .{ .source = source, .start = start, .trusted = true }) orelse unreachable;
    const paths = try allocator.alloc([]const u32, shape.paths_count);
    var at = shape.paths_start;

    for (paths) |*path| {
        const span = try decode(@import("generated_uniqueness_memo_disk_vector"), memory, .{ .source = source, .start = at, .width = @as(u64, @sizeOf(u32)) });
        path.* = try copy(u32, allocator, source, span.start, span.end);
        at = span.end;
    }

    return .{
        .value = .{
            .flags = try copy(Function.Flags, allocator, source, shape.flags_start, shape.flags_end),
            .renewals = .{ .keys = try copy(u64, allocator, source, shape.keys_start, shape.keys_end), .paths = paths },
            .transfers = try copy(u64, allocator, source, shape.transfers_start, shape.transfers_end),
            .slot_first = try copy(u32, allocator, source, shape.slot_first_start, shape.slot_first_end),
            .used = false,
        },
        .end = shape.end,
    };
}

fn flowed(allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64) Error!Row(Memo.Flowed) {
    const shape = try decode(@import("generated_uniqueness_memo_disk_flowed"), memory, .{ .source = source, .start = start, .trusted = true }) orelse unreachable;

    return .{
        .value = .{
            .held = try copy(bool, allocator, source, shape.held_start, shape.held_end),
            .text_held = try copy(bool, allocator, source, shape.text_held_start, shape.text_held_end),
            .written = try copy(bool, allocator, source, shape.written_start, shape.written_end),
            .used = false,
        },
        .end = shape.end,
    };
}

fn decode(comptime entry: type, memory: std.mem.Allocator, source: anytype) Error!@typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload {
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const input = columns.view(Input, source);

    return entry.executeValue(memory, if (indirect) &input else input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => error.OutOfMemory,
        else => std.debug.panic("validated memo row could not be decoded: {s}", .{@errorName(err)}),
    };
}

fn rows(comptime T: type, comptime entry: type, allocator: std.mem.Allocator, memory: std.mem.Allocator, source: []const u8, start: u64, count: u32) Error![]const T {
    const output = try allocator.alloc(T, count);
    var at = start;

    for (output) |*target| {
        const row = try decode(entry, memory, .{ .source = source, .start = at });

        inline for (@typeInfo(T).@"struct".field_names) |name| {
            const Field = @FieldType(T, name);
            const value = @field(row, name);

            @field(target, name) = if (Field == Level)
                @bitCast(@as(u3, @intCast(value)))

            else if (@typeInfo(Field) == .@"enum")
                @fromBackingInt(value)
            else
                value;
        }

        at = row.end;
    }

    return output;
}

fn copy(comptime T: type, allocator: std.mem.Allocator, source: []const u8, start: u64, end: u64) Error![]const T {
    const raw = source[@intCast(start)..@intCast(end)];
    const output = try allocator.alloc(T, @divExact(raw.len, @sizeOf(T)));

    @memcpy(std.mem.sliceAsBytes(output), raw);

    if (@sizeOf(T) != 1 and @import("builtin").target.cpu.arch.endian() != .little) {
        for (output) |*value| value.* = @byteSwap(value.*);
    }

    return output;
}
