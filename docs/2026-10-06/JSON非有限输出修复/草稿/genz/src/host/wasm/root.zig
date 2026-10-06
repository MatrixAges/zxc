const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool, output: @import("../json_output.zig").Output) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    var declarations: std.ArrayList(node.Declaration) = .empty;
    const u32_type = try builder.expression(.{ .primitive = .u32 });

    try declarations.appendSlice(builder.allocator, try @import("storage.zig").lower(builder, stateful));

    try declarations.appendSlice(builder.allocator, &.{
        try @import("input.zig").lower(builder),
        try @import("json.zig").execute(builder),
        try common.function(builder, "zxc_result_ptr", u32_type, &.{.{ .result = try builder.builtin(.intFromPtr, &.{try builder.path(&.{ "result", "ptr" })}) }}, true),
        try common.function(builder, "zxc_result_len", u32_type, &.{.{ .result = try builder.builtin(.intCast, &.{try builder.path(&.{ "result", "len" })}) }}, true),
        try @import("lifecycle.zig").reset(builder),
        try @import("lifecycle.zig").deinit(builder, stateful),
        try @import("lifecycle.zig").prepare(builder, stateful),
        try @import("json.zig").run(builder, stateful, output),
    });

    try declarations.appendSlice(builder.allocator, try @import("scalar.zig").lower(builder, stateful));

    return @import("../../render.zig").render(allocator, declarations.items);
}
