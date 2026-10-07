const std = @import("std");
const zx = @import("zx");
const Module = @import("module.zig");
const Nodes = @import("frontend").ArtifactNodes;
const native = @import("frontend").native_link;

pub fn merge(allocator: std.mem.Allocator, calls: []Module.Call, types: zx.ir.TypeTable, shared: []const zx.ir.NativeModule) ![]const zx.ir.NativeModule {
    var modules: std.ArrayList(zx.ir.NativeModule) = .fromOwnedSlice(try @import("frontend").native_context.copy(allocator, shared));
    const mapping = try allocator.alloc(zx.ir.TypeId, types.count());

    for (mapping, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = &.{}, .native_modules = &.{} };

    for (calls) |*call| {
        const native_mapping = try allocator.alloc(zx.ir.NativeModuleId, call.callee.native_modules.len);

        for (call.callee.native_modules, native_mapping) |module, *id| id.* = try native.append(allocator, &modules, module, &nodes);

        const external = try allocator.dupe(?zx.ir.External, call.callee.functions.external);

        for (external) |*value| {
            if (value.*) |*item| item.module = native_mapping[@backingInt(item.module)];
        }

        call.callee.functions.external = external;
    }

    for (calls) |*call| call.callee.native_modules = modules.items;

    return modules.items;
}
