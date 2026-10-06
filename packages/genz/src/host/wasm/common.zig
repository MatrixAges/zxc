const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn assign(builder: Builder, name: []const u8, value: *const node.Expression) std.mem.Allocator.Error!node.Statement {
    return .{ .assignment = .{ .target = try builder.identifier(name), .value = value } };
}

pub fn invoke(builder: Builder, name: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return builder.call(try builder.identifier(name), &.{});
}

pub fn arena(builder: Builder) std.mem.Allocator.Error!*const node.Expression {
    return builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{try builder.path(&.{ "std", "heap", "wasm_allocator" })});
}

pub fn failure(builder: Builder, value: *const node.Expression, code: u32) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .catch_scope = .{ .value = value, .capture = "err", .body = try builder.statements(&.{
        try assign(builder, "result", try builder.builtin(.errorName, &.{try builder.identifier("err")})),
        .{ .result = try builder.integer(code) },
    }) } });
}

pub fn function(builder: Builder, name: []const u8, result: *const node.Expression, body: []const node.Statement, exported: bool) std.mem.Allocator.Error!node.Declaration {
    return .{ .function = .{ .name = name, .parameters = &.{}, .return_type = result, .body = try builder.statements(body), .abi_export = exported } };
}

pub fn current(builder: Builder) std.mem.Allocator.Error!node.Statement {
    return .{ .constant = .{ .name = "current", .value = try builder.expression(.{ .address_of = try builder.expression(.{ .optional_unwrap = try builder.identifier("request") }) }) } };
}

pub fn execute(builder: Builder, stateful: bool) std.mem.Allocator.Error!*const node.Expression {
    const value = try builder.identifier("value");

    const call = if (stateful)
        try builder.call(try builder.path(&.{ "current", "execute" }), &.{value})
    else
        try builder.call(try builder.path(&.{ "application", "execute" }), &.{ try builder.expression(.{ .address_of = try builder.path(&.{ "current", "arena" }) }), value });

    return builder.expression(.{ .conditional = .{
        .condition = try capabilities(builder),
        .yes = try builder.expression(.unreachable_value),
        .no = call,
    } });
}

pub fn capabilities(builder: Builder) std.mem.Allocator.Error!*const node.Expression {
    return builder.binary(.logical_or, try builder.path(&.{ "application", "requires_io" }), try builder.path(&.{ "application", "requires_process" }));
}
