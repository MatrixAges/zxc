const std = @import("std");
const zx = @import("zx");
const generated = @import("rx_options").generated_graph;

const Result = if (generated)
    @typeInfo(@TypeOf(@import("generated_rx_compiled_admission").executeValue(undefined, undefined))).error_union.payload
else
    enum { Executable, MissingFunction, Setter, Transaction };

pub fn check(function: ?zx.ir.FunctionId, functions: *const zx.ir.FunctionStorage, setter: bool) Result {
    const row = if (function) |id| @backingInt(id) else null;
    const has_stores = if (row) |index| functions.stores.items[index].count() != 0 else false;
    const orchestration = if (row) |index| functions.store_modes.items[index] == .orchestration else false;

    if (comptime generated) {
        const rule = @import("generated_rx_compiled_admission");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(rule.Input) = .{
            .executable = function != null,
            .setter = setter,
            .has_stores = has_stores,
            .orchestration = orchestration,
        };

        return zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (row == null) return .MissingFunction;
    if (setter) return .Setter;
    if (has_stores and !orchestration) return .Transaction;

    return .Executable;
}
