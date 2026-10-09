const std = @import("std");
const frontend = @import("frontend");
const Module = @import("../../module.zig");

pub fn retain(allocator: std.mem.Allocator, contract: *Module.Contract) std.mem.Allocator.Error!void {
    const types = try frontend.type_table.copy(allocator, contract.types);
    const native_modules = try frontend.native_context.copy(allocator, contract.native_modules);
    const calls = try allocator.dupe(Module.Call, contract.calls);

    for (calls) |*call| {
        call.callee.types = types;
        call.callee.native_modules = native_modules;
        call.argument.types = types;
        call.argument.native_modules = native_modules;
    }

    if (contract.result) |*result| {
        result.types = types;
        result.native_modules = native_modules;
    }

    contract.calls = calls;
}
