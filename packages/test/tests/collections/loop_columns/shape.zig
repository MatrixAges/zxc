const std = @import("std");

pub fn check(allocator: std.mem.Allocator, source: []const u8, mode: []const u8) !void {
    var generated = try @import("generated_loop").parse(allocator, source);

    defer generated.deinit();

    const execute = generated.entrySource();
    const fallback = std.mem.eql(u8, mode, "fallback");
    const expected_lanes: usize = if (fallback) 0 else 1;

    if (generated.owners() != expected_lanes) return error.InvalidFrameValueBufferCount;
    if (fallback) return;

    const leaves = std.mem.eql(u8, mode, "leaves");
    const dual = std.mem.eql(u8, mode, "dual");
    const selected: usize = if (leaves) 3 else if (dual) 2 else 1;
    const lanes: usize = if (leaves or dual) 4 else 3;

    if (generated.totalOwners() != lanes) return error.InvalidColumnBufferCount;
    if (std.mem.count(u8, execute, ").deinit(allocator)") != lanes) return error.InvalidCleanupCount;
    if (std.mem.count(u8, execute, ").toOwnedSlice(allocator)") != selected) return error.InvalidTransferCount;
    if (std.mem.count(u8, execute, "errdefer (allocator).free(state_owned_") != selected) return error.InvalidTransferredErrorCleanupCount;
    if (generated.loop == null) return error.MissingLoop;
    if (std.mem.indexOf(u8, generated.body(), "(allocator).create(") != null) return error.PerIterationFrameBox;
    if (std.mem.count(u8, generated.after(), ").toOwnedSlice(allocator)") != selected) return error.InvalidTransferPlacement;
}
