const std = @import("std");
const zx = @import("zx");
const Self = @This();
const enabled = @import("rx_options").generated_graph;
const mark = if (enabled) @import("generated_rx_task_capture_mark") else void;
const Marked = if (enabled) @FieldType(@typeInfo(@TypeOf(mark.executeState)).@"fn".param_types[1].?, "marked") else []bool;

marked: Marked,
remaining: usize,
pub fn init(allocator: std.mem.Allocator, types: []const zx.ir.TypeId) std.mem.Allocator.Error!Self {
    if (comptime enabled) {
        const rule = @import("generated_rx_task_capture_init");

        const marked = rule.executeState(allocator, .{ .items = @ptrCast(types), .storage = .plain }) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => unreachable,
        };

        return .{ .marked = marked, .remaining = types.len };
    }

    const marked = try allocator.alloc(bool, types.len);

    @memset(marked, false);

    return .{ .marked = marked, .remaining = types.len };
}

pub fn observeMapped(self: *Self, references: []const u32, mapping: ?[]const u32) void {
    if (self.remaining == 0 or references.len == 0) return;

    if (comptime !enabled) {
        for (references) |symbol| {
            if (symbol == 0) continue;

            const index = symbol - 1;
            const position = if (mapping) |mapped| if (index < mapped.len) mapped[index] else continue else index;

            if (position >= self.marked.len) continue;

            if (!self.marked[position]) {
                self.marked[position] = true;
                self.remaining -= 1;
            }

            if (self.remaining == 0) break;
        }

        return;
    }

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = mark.executeState(empty.allocator(), .{
        .references = .{ .items = references, .storage = .plain },
        .positions = if (mapping) |items| .{ .items = items, .storage = .plain } else null,
        .marked = self.marked,
        .remaining = self.remaining,
        .cursor = 0,
    }) catch unreachable;

    std.debug.assert(result.marked.items.ptr == self.marked.items.ptr);

    self.marked = result.marked;
    self.remaining = @intCast(result.remaining);
}

pub fn positions(self: Self, allocator: std.mem.Allocator, types: []const zx.ir.TypeId) std.mem.Allocator.Error![]const u32 {
    const count = types.len - self.remaining;

    if (count == 0) return &.{};

    if (comptime enabled) {
        const rule = @import("generated_rx_task_capture_positions");
        const input: std.meta.Child(rule.Input) = .{ .marked = self.marked.items, .type_ids = @ptrCast(types[0..count]) };

        return zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => unreachable,
        };
    }

    const selected = try allocator.alloc(u32, count);
    var written: usize = 0;

    for (self.marked, 0..) |marked, index| {
        if (!marked) continue;

        selected[written] = @intCast(index);
        written += 1;
    }

    return selected;
}
