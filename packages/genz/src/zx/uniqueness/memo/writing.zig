const std = @import("std");
const columns = @import("zx").columns;
const Memo = @import("../memo.zig");
const framing = @import("generated_uniqueness_memo_write_frame");
const Phase = framing.Output;
const Error = std.mem.Allocator.Error;

pub fn save(memo: *const Memo, allocator: std.mem.Allocator) Error![]u8 {
    var out: std.Io.Writer.Allocating = .init(allocator);

    errdefer out.deinit();

    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const memory = empty.allocator();
    const writer: *const anyopaque = @ptrCast(&out);
    var phase = try frame(memory, writer, .Header, 0);

    while (phase != .Done) {
        phase = switch (phase) {
            .Settled => try section(memory, writer, .Settled, &memo.settled),
            .Demanded => try section(memory, writer, .Demanded, &memo.demanded),
            .Planned => try section(memory, writer, .Planned, &memo.planned),
            .Flowed => try section(memory, writer, .Flowed, &memo.flowed),
            .Header, .Done => unreachable,
        };
    }

    return out.toOwnedSlice();
}

fn frame(memory: std.mem.Allocator, writer: *const anyopaque, phase: Phase, count: u32) Error!Phase {
    const input: std.meta.Child(framing.Input) = .{ .writer = @ptrCast(writer), .phase = phase, .count = count };

    return columns.invoke(framing.executeValue, memory, &input) catch |err| return failure(err);
}

fn section(memory: std.mem.Allocator, writer: *const anyopaque, comptime phase: Phase, map: anytype) Error!Phase {
    var count: u32 = 0;
    var values = map.iterator();

    while (values.next()) |entry| count += @intFromBool(entry.value_ptr.used);

    const next = try frame(memory, writer, phase, count);

    values = map.iterator();

    while (values.next()) |entry| {
        const value = entry.value_ptr;

        if (!value.used) continue;

        const digest: []const u8 = entry.key_ptr;

        switch (phase) {
            .Settled => try write(@import("generated_uniqueness_memo_write_settled"), memory, .{
                .writer = writer,
                .digest = digest,
                .passed = value.passed,
                .output = value.output,
            }),
            .Demanded => try write(@import("generated_uniqueness_memo_write_demanded"), memory, .{
                .writer = writer,
                .digest = digest,
                .marks = value.marks,
                .normalized = value.normalized,
                .renewed = value.renewed,
                .grew = value.grew,
            }),
            .Planned => try write(@import("generated_uniqueness_memo_write_planned"), memory, .{
                .writer = writer,
                .digest = digest,
                .flags = value.flags,
                .keys = value.renewals.keys,
                .paths = value.renewals.paths,
                .transfers = value.transfers,
                .slot_first = value.slot_first,
            }),
            .Flowed => try write(@import("generated_uniqueness_memo_write_flowed"), memory, .{
                .writer = writer,
                .digest = digest,
                .held = std.mem.sliceAsBytes(value.held),
                .text_held = std.mem.sliceAsBytes(value.text_held),
                .written = std.mem.sliceAsBytes(value.written),
            }),
            .Header, .Done => unreachable,
        }
    }

    return next;
}

fn write(comptime entry: type, memory: std.mem.Allocator, source: anytype) Error!void {
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    var input: Input = undefined;

    inline for (@typeInfo(Input).@"struct".field_names) |name| {
        @field(input, name) = if (comptime std.mem.eql(u8, name, "writer"))
            @ptrCast(source.writer)

        else if (comptime std.mem.eql(u8, name, "zx_origin"))
            null
        else
            columns.storage.view(@FieldType(Input, name), @field(source, name));
    }

    return entry.executeValue(memory, if (indirect) &input else input) catch |err| return failure(err);
}

fn failure(err: anyerror) Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => std.debug.panic("memo disk write failed: {s}", .{@errorName(err)}),
    };
}
