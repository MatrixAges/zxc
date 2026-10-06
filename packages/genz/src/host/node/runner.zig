const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const memory = builder.allocator;
    const napi = try builder.identifier("napi");
    var declarations: std.ArrayList(node.Declaration) = .empty;

    try declarations.append(memory, .{ .constant = .{ .name = "stateful", .value = try builder.expression(.{ .boolean = stateful }), .exported = true } });

    for ([_]struct { name: []const u8, module: []const u8 }{
        .{ .name = "std", .module = "std" },
        .{ .name = "application", .module = "application" },
        .{ .name = "napi", .module = "zxc_napi" },
        .{ .name = "Context", .module = "node/context.zig" },
    }) |entry| try declarations.append(memory, .{ .constant = .{ .name = entry.name, .value = try builder.builtin(.import, &.{try builder.string(entry.module)}) } });

    try declarations.appendSlice(memory, &.{
        .{ .constant = .{ .name = "api", .value = try builder.field(napi, "api") } },
        .{ .constant = .{ .name = "enqueue", .value = try builder.field(try builder.builtin(.import, &.{try builder.string("node/enqueue.zig")}), "callback") } },
        .{ .comptime_scope = try builder.statements(&.{try builder.branch(try builder.binary(.logical_or, try builder.path(&.{ "application", "requires_io" }), try builder.path(&.{ "application", "requires_process" })), &.{.{ .expression = try builder.builtin(.compileError, &.{try builder.string("Node addons require an explicit host implementation for I/O and process capabilities")}) }}, &.{})}) },
        .{ .function = .{ .name = "node_api_module_get_api_version_v1", .parameters = &.{}, .return_type = try builder.expression(.{ .primitive = .i32 }), .body = try builder.statements(&.{.{ .result = try builder.integer(6) }}), .abi_export = true } },
        try @import("register.zig").entry(builder),
        try @import("register.zig").lower(builder, stateful),
        .{ .function = .{
            .name = "finalize",
            .parameters = try memory.dupe(node.Field, &.{
                .{ .name = "_", .value = try builder.path(&.{ "api", "Env" }) },
                .{ .name = "data", .value = try common.dataType(builder) },
                .{ .name = "_", .value = try common.dataType(builder) },
            }),
            .return_type = try builder.expression(.{ .primitive = .void }),
            .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
            .body = try builder.statements(&.{ try common.context(builder), .{ .expression = try builder.call(try builder.path(&.{ "context", "release" }), &.{}) } }),
        } },
        try common.callback(builder, "callback", "execute", false),
        try @import("execute.zig").lower(builder, stateful),
    });

    return @import("../../render.zig").render(allocator, declarations.items);
}
