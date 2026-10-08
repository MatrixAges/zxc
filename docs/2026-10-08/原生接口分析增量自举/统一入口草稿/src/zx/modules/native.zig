const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("interface.zig").Native;
const Members = @import("native/members.zig");
const Types = @import("../analysis/types.zig");
pub const Member = Members.Member;
pub const Result = struct { types: ir.TypeTable, exports: []const ir.Export, members: []const Member };

pub fn load(arena: *std.heap.ArenaAllocator, entry: Native, module: ir.NativeModuleId, existing: *ir.TypeStorage, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, span: zx.Span) zx.Error!Result {
    const allocator = arena.allocator();
    var local: zx.Reporter = .{};

    return analyze(arena, entry, module, existing, origins, &local) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = local.diagnostic.?;
        const location = zx.source.locate(entry.source, issue.span.start);
        const message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ entry.path, location.line, location.column, issue.message });

        return reporter.fail(issue.code, span, message);
    };
}

fn analyze(arena: *std.heap.ArenaAllocator, entry: Native, module: ir.NativeModuleId, existing: *ir.TypeStorage, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter) zx.Error!Result {
    const allocator = arena.allocator();
    var types = Types{ .native_interface = true, .allocator = allocator, .reporter = reporter, .declarations = &.{}, .shared = if (origins) |items| Types.Shared{ .origins = items, .origin = .{ .native = entry.key() } } else null };

    types.items = existing.*;
    existing.* = .{};
    defer existing.* = types.items;

    const analyzed = if (@import("parser_options").generated_parser)
        try @import("native/interface.zig").analyze(&types, entry, module)
    else
        try @import("native/seed.zig").analyze(arena, &types, entry, module);

    return .{ .types = types.items.view(), .exports = analyzed.exports, .members = analyzed.members };
}
