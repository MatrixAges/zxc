const std = @import("std");
const zx = @import("zx");
const Function = @import("../function.zig");
const levels = @import("levels.zig");
const analysis = @import("generated_uniqueness_function_plan");
const publication = @import("generated_uniqueness_function_plan_finish");
const Input = std.meta.Child(analysis.Input);
const Finish = std.meta.Child(publication.Input);

pub fn build(function: *Function, allocator: std.mem.Allocator) std.mem.Allocator.Error!Function.Plan {
    var borrowed: levels.Borrowed = undefined;

    try borrowed.init(function);

    const context: *const @TypeOf(borrowed.descriptor) = &borrowed.descriptor;
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), function.slots.types);
    const state = zx.columns.view(std.meta.Child(@FieldType(Input, "state")), function.evaluation.?);

    const input: Input = .{
        .context = zx.columns.pointer(@FieldType(Input, "context"), context),
        .state = &state,
        .types = &types,
        .time = function.order.nodes.time,
        .operations = @ptrCast(function.operations),
        .repeated = @ptrCast(function.order.repeated),
        .results = @ptrCast(function.order.results),
    };

    const facts = zx.columns.invoke(analysis.executeValue, function.allocator, &input) catch |err| return failure(err);

    const finish: Finish = .{
        .source = zx.columns.pointer(@FieldType(Finish, "source"), &input),
        .flags = facts.flags,
        .keys = try allocator.dupe(u64, facts.keys),
        .needed = facts.needed,
    };

    const result = zx.columns.invoke(publication.executeValue, allocator, &finish) catch |err| return failure(err);
    function.evaluation.?.known = facts.known;
    function.evaluation.?.reads = facts.reads;

    try levels.publish(function);

    return .{
        .flags = @ptrCast(result.flags),
        .renewals = .{ .keys = result.renewals.keys, .paths = result.renewals.paths },
        .transfers = result.transfers,
        .slot_first = try allocator.dupe(u32, function.sites.slot_first[function.sites.symbols.count()..]),
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    std.debug.panic("function plan failed: {s}", .{@errorName(err)});
}
