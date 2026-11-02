const std = @import("std");
const GeneratedLoop = @import("generated_loop");

pub fn check(allocator: std.mem.Allocator, source: []const u8, mode: []const u8) !void {
    var generated = try GeneratedLoop.parse(allocator, source);

    defer generated.deinit();

    const execute = generated.entrySource();
    const inline_mode = std.mem.eql(u8, mode, "stack") or std.mem.eql(u8, mode, "nested") or std.mem.eql(u8, mode, "two_lanes") or std.mem.eql(u8, mode, "bounds") or std.mem.eql(u8, mode, "consumer") or std.mem.eql(u8, mode, "call");
    const lanes: usize = if (!inline_mode) 0 else if (std.mem.eql(u8, mode, "two_lanes")) 2 else 1;

    if (generated.owners() != lanes) return error.InvalidValueBufferCount;
    if (std.mem.count(u8, execute, ").deinit(allocator)") != lanes) return error.InvalidBufferCleanupCount;
    if (!inline_mode) return;
    if (generated.loop == null) return error.MissingLoop;

    const before = generated.before();

    if (std.mem.count(u8, before, ").ensureTotalCapacity(") != lanes) return error.InvalidInitialConversionCount;
    if (std.mem.count(u8, before, "for (") != lanes) return error.InvalidInitialFillCount;
    if (std.mem.indexOf(u8, execute, "toOwnedSlice") != null) return error.UnexpectedEscapingValueBuffer;

    const body = generated.body();

    if (std.mem.indexOf(u8, body, "(allocator).create(") != null) return error.PerIterationProductBox;
    if (std.mem.indexOf(u8, body, "(allocator).dupe(") != null) return error.PerIterationListCopy;
    if (std.mem.eql(u8, mode, "consumer") and !generated.projectedOnce("selection")) return error.InvalidConsumerAbiPlacement;
}
