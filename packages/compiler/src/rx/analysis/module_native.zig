const std = @import("std");
const zx = @import("zx");
const Module = @import("module.zig");
const Nodes = @import("frontend").ArtifactNodes;
const native = @import("frontend").native_link;

pub fn merge(allocator: std.mem.Allocator, calls: []Module.Call, types: zx.ir.TypeTable, shared: zx.ir.NativeModuleTable) !zx.ir.NativeModuleTable {
    var modules: zx.ir.NativeModuleStorage = try @import("frontend").native_context.storage(allocator, shared);
    const mapping = try allocator.alloc(zx.ir.TypeId, types.count());

    for (mapping, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = &.{}, .native_modules = &.{} };

    for (calls) |*call| {
        const native_mapping = try allocator.alloc(zx.ir.NativeModuleId, call.callee.native_modules.count());

        for (0..call.callee.native_modules.count(), native_mapping) |module_row, *id| {
            const module = call.callee.native_modules.at(module_row);

            id.* = try native.append(allocator, &modules, module, &nodes);
        }

        const external = try allocator.dupe(?u32, call.callee.functions.native_modules);

        for (external) |*value| {
            if (value.*) |module| value.* = @backingInt(native_mapping[module]);
        }

        call.callee.functions.native_modules = external;
    }

    for (calls) |*call| call.callee.native_modules = modules.view();

    return modules.view();
}
