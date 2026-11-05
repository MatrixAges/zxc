const std = @import("std");
const zx = @import("zx");
const Function = @import("../function.zig");
const levels = @import("levels.zig");
const generated = @import("generated_uniqueness_function_plan");
const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const indirect = @typeInfo(Parameter) == .pointer;
const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

pub fn build(function: *Function, allocator: std.mem.Allocator) std.mem.Allocator.Error!Function.Plan {
    var borrowed: levels.Borrowed = undefined;

    try borrowed.init(function);

    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), function.slots.types);
    const AbiState = std.meta.Child(@FieldType(std.meta.Child(generated.Input), "state"));
    const state = zx.columns.view(AbiState, function.evaluation.?);
    const Context = @FieldType(Input, "context");
    const State = @FieldType(Input, "state");

    const input: Input = .{
        .context = if (@typeInfo(Context) == .pointer) &borrowed.descriptor else borrowed.context,
        .state = if (@typeInfo(State) == .pointer) &state else zx.columns.borrow(State, &state),
        .types = &types,
        .time = function.order.nodes.time,
        .operations = @ptrCast(function.operations),
        .repeated = @ptrCast(function.order.repeated),
        .results = @ptrCast(function.order.results),
    };

    const result = generated.executeValue(function.allocator, if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("function plan failed: {s}", .{@errorName(err)}),
    };

    function.evaluation.?.known = result.known;
    function.evaluation.?.reads = result.reads;

    try levels.publish(function);

    const flags = try allocator.alloc(Function.Flags, result.flags.len);
    const renewals = try allocator.alloc(Function.Renewal, result.renewals.len);

    for (result.flags, flags) |value, *target| target.* = @bitCast(@as(u8, @intCast(value)));
    for (result.renewals, renewals) |value, *target| target.* = .{ .owner = @fromBackingInt(value.owner), .path = try allocator.dupe(u32, value.path), .value = value.value };

    return .{ .flags = flags, .renewals = renewals, .transfers = try allocator.dupe(u64, result.transfers), .slot_first = try allocator.dupe(u32, function.sites.slot_first[function.sites.symbols.count()..]) };
}
