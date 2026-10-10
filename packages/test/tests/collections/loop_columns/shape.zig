const std = @import("std");

pub fn check(source: []const u8, mode: []const u8) !void {
    const start = std.mem.indexOf(u8, source, "pub fn execute(") orelse return error.MissingExecute;
    const end_of_execute = std.mem.indexOfPos(u8, source, start, "\n}") orelse return error.MissingExecuteEnd;
    const execute = source[start .. end_of_execute + 2];
    const fallback = std.mem.eql(u8, mode, "fallback");
    const expected_lanes: usize = if (fallback) 0 else 1;

    if (std.mem.count(u8, execute, ".ArrayList(state_type_") != expected_lanes) return error.InvalidFrameValueBufferCount;
    if (fallback) return;

    const leaves = std.mem.eql(u8, mode, "leaves");
    const dual = std.mem.eql(u8, mode, "dual");
    const selected: usize = if (leaves) 3 else if (dual) 2 else 1;
    const lanes: usize = if (leaves or dual) 4 else 3;

    if (std.mem.count(u8, execute, ".ArrayList(") != lanes) return error.InvalidColumnBufferCount;
    if (std.mem.count(u8, execute, ").deinit(allocator)") != lanes) return error.InvalidCleanupCount;
    if (std.mem.count(u8, execute, ").toOwnedSlice(allocator)") != selected) return error.InvalidTransferCount;
    if (std.mem.count(u8, execute, "errdefer (allocator).free(state_owned_") != selected) return error.InvalidTransferredErrorCleanupCount;

    const loop = std.mem.indexOf(u8, execute, "while (") orelse return error.MissingLoop;
    const open = std.mem.indexOfScalarPos(u8, execute, loop, '{') orelse return error.MissingLoopBody;
    var depth: usize = 1;
    var end = open + 1;

    while (end < execute.len and depth > 0) : (end += 1) {
        if (execute[end] == '{') depth += 1;
        if (execute[end] == '}') depth -= 1;
    }

    if (depth != 0) return error.UnclosedLoopBody;
    if (std.mem.indexOf(u8, execute[open + 1 .. end - 1], "(allocator).create(") != null) return error.PerIterationFrameBox;
    if (std.mem.count(u8, execute[end..], ").toOwnedSlice(allocator)") != selected) return error.InvalidTransferPlacement;
}
