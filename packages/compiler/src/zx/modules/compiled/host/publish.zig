const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../compiled.zig");
const load = @import("../load.zig");
const Input = @import("input.zig");
const Output = std.meta.Child(@import("generated_compiled_library").Output);
const borrow = @import("../../../ir/canonical/borrow.zig");
const function = @import("function.zig");

pub fn apply(allocator: std.mem.Allocator, input: *const Input, library: *const model.Library, output: *const Output, destination: load.Destination, call_scratch: ?load.CallScratch) (std.mem.Allocator.Error || error{InvalidModule})!model.Loaded {
    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, destination.types, &destination.origins.items, output.types.*, output.origins.*);

    const natives = borrow.columns(ir.NativeModuleTable, output.natives.*);

    for (0..natives.count()) |index| {
        try destination.native_modules.append(allocator, try @import("native.zig").materialize(allocator, natives.at(index), output.functions.types));
    }

    const functions = library.program.functions;
    const mapping: function.Mapping = .{ .types = output.functions.types, .natives = output.functions.natives };
    const context: function.Context = .{ .mapping = &mapping, .first = destination.functions.count(), .instance = library.instance };
    const function_allocator = if (call_scratch) |scratch| scratch.functions else allocator;

    try destination.functions.reserve(function_allocator, functions.count());

    for (0..functions.count()) |index| {
        try function.appendAssumeCapacity(function_allocator, destination.functions, functions.at(index), context);
    }

    const interface = if (call_scratch == null)
        try @import("interface.zig").materialize(allocator, input, output, context.first)
    else
        @as(@import("interface.zig").Interface, .{});

    return .{ .types = destination.types.view(), .nominal_types = destination.origins.items.view(), .exports = interface.exports, .store_initializers = interface.initializers };
}
