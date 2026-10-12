const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

/// The library entry. `execute` runs the body in an arena the host lends; `executeIn` runs it on an allocator the host
/// owns, so a host allocating from one thread can skip the atomic operations an arena shared between threads costs on
/// every allocation, and `execute` only hands its arena's allocator on. A body that starts tasks shares its allocator
/// between threads, which `execute` sets up from the arena, so it keeps `execute` alone.
pub fn declarations(lowering: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (@import("tasks/allocator.zig").required(lowering.program, lowering.task_functions)) return output.append(lowering.allocator, try lowering.function("execute", true));

    var inner = try lowering.function("executeIn", false);

    inner.function.exported = true;

    try output.append(lowering.allocator, inner);
    try output.append(lowering.allocator, try forward(lowering, inner.function));
}

fn forward(lowering: *Lower, inner: node.Function) Lower.Error!node.Declaration {
    const builder = lowering.builder;
    const parameters = try lowering.allocator.dupe(node.Field, inner.parameters);
    const arguments = try lowering.allocator.alloc(node.ExpressionId, parameters.len);
    const arena = try builder.identifier("arena");
    parameters[0] = .{ .name = "arena", .value = try builder.expression(.{ .pointer = try @import("intrinsics.zig").standardField(lowering, &.{ "heap", "ArenaAllocator" }) }) };
    arguments[0] = try builder.call(try builder.field(arena, "allocator"), &.{});

    for (parameters[1..], arguments[1..]) |parameter, *argument| argument.* = try builder.identifier(parameter.name);

    const result = try builder.call(try builder.identifier(inner.name), arguments);

    return .{ .function = .{ .name = "execute", .parameters = parameters, .return_type = inner.return_type, .body = try builder.statements(&.{.{ .result = result }}), .exported = true } };
}
