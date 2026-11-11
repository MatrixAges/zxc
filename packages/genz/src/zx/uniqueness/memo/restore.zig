const std = @import("std");
const zx = @import("zx");
const Level = @import("../level.zig").Level;
const Summaries = @import("../summaries.zig");
const inspecting = @import("generated_uniqueness_memo_restore_inspect");
const publishing = @import("generated_uniqueness_memo_restore_publish");
const Input = std.meta.Child(inspecting.Input);
const Publication = std.meta.Child(publishing.Input);

pub fn apply(backing: std.mem.Allocator, source: []const u8, summaries: *Summaries, body: usize, callees: []const u32, demanded: bool, normalized: *std.AutoHashMap(zx.ir.ExprId, Level), renewed: *std.AutoHashMap(u64, Level)) std.mem.Allocator.Error!bool {
    var scratch = std.heap.ArenaAllocator.init(backing);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const input: Input = .{
        .source = source,
        .body = body,
        .callees = callees,
        .demanded = demanded,
        .input = @ptrCast(&summaries.input),
        .output = @ptrCast(&summaries.output),
        .inputs = @ptrCast(&summaries.inputs),
        .outputs = @ptrCast(&summaries.outputs),
    };

    const decoded = (zx.columns.invoke(inspecting.executeValue, memory.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds, error.IntegerOverflow, error.Overflow => return false,
        else => std.debug.panic("memo state inspection failed: {s}", .{@errorName(err)}),
    }) orelse return false;

    try normalized.ensureTotalCapacity(@intCast(decoded.normalized.keys.len));
    try renewed.ensureTotalCapacity(@intCast(decoded.renewed.keys.len));

    const publication: Publication = .{
        .input = zx.columns.pointer(@FieldType(Publication, "input"), &input),
        .facts_start = decoded.facts_start,
        .wants_start = decoded.renewed.end,
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    zx.columns.invoke(publishing.executeValue, empty.allocator(), &publication) catch |err| {
        std.debug.panic("validated memo state could not be published: {s}", .{@errorName(err)});
    };

    replace(zx.ir.ExprId, normalized, decoded.normalized);
    replace(u64, renewed, decoded.renewed);

    return true;
}

fn replace(comptime Key: type, map: *std.AutoHashMap(Key, Level), entries: anytype) void {
    map.clearRetainingCapacity();

    for (entries.keys, entries.levels) |key, level| {
        map.putAssumeCapacity(if (Key == u64) key else @fromBackingInt(@intCast(key)), @bitCast(@as(u3, @intCast(level))));
    }
}
