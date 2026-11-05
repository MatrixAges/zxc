const std = @import("std");
const zx = @import("zx");
const Function = @import("../function.zig");
const levels = @import("levels.zig");
const generated = @import("generated_uniqueness_function_demand");
const AbiInput = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(AbiInput, "source"));

pub fn analyze(function: *Function, changed: *std.ArrayList(usize), marked: *std.ArrayList(Function.Mark)) std.mem.Allocator.Error!void {
    const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    var borrowed: levels.Borrowed = undefined;

    try borrowed.init(function);

    const source: Source = .{
        .kinds = function.slots.types.kinds,
        .native_modules = function.functions.native_modules,
        .carried = function.evaluation.?.carried,
        .inputs = @ptrCast(&function.summaries.inputs),
        .outputs = @ptrCast(&function.summaries.outputs),
        .function_index = if (function.function) |index| @intCast(index) else null,
        .deferred = function.deferred,
        .operations = @ptrCast(function.operations),
        .results = @ptrCast(function.order.results),
    };

    const input: Input = .{
        .context = if (@typeInfo(@FieldType(Input, "context")) == .pointer) &borrowed.descriptor else borrowed.context,
        .known = function.evaluation.?.known,
        .source = if (@typeInfo(@FieldType(Input, "source")) == .pointer) &source else zx.columns.borrow(@FieldType(Input, "source"), &source),
    };

    const result = generated.executeValue(function.allocator, if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("function demand failed: {s}", .{@errorName(err)}),
    };

    function.evaluation.?.known = result.known;
    function.evaluation.?.reads = result.reads;
    function.grew = function.grew or result.grew;

    try levels.publish(function);

    function.normalized.clearRetainingCapacity();
    function.renewed.clearRetainingCapacity();

    for (result.context.normalized) |entry| try function.normalized.put(@fromBackingInt(@intCast(entry.key)), levels.level(entry.value));
    for (result.context.renewed) |entry| try function.renewed.put(entry.key, levels.level(entry.value));
    for (result.marks) |entry| try marked.append(function.allocator, .{ .output = entry.output, .function = entry.function_index, .slot = entry.slot, .want = levels.level(entry.want) });
    for (result.changed) |index| try changed.append(function.allocator, index);
}
