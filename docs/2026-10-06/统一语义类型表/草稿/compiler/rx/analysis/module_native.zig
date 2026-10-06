const std = @import("std");
const zx = @import("zx");
const Module = @import("module.zig");
const Nodes = @import("frontend").ArtifactNodes;
const native = @import("frontend").native_link;

pub fn merge(allocator: std.mem.Allocator, calls: []Module.Call, types: zx.ir.TypeTable) ![]const zx.ir.NativeModule {
    var modules: std.ArrayList(zx.ir.NativeModule) = .empty;
    const mapping = try allocator.alloc(zx.ir.TypeId, types.count());

    for (mapping, 0..) |*id, index| id.* = @enumFromInt(index);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = &.{}, .native_modules = &.{} };

    for (calls) |*call| {
        const native_mapping = try allocator.alloc(zx.ir.NativeModuleId, call.callee.native_modules.len);

        for (call.callee.native_modules, native_mapping) |module, *id| id.* = try native.append(allocator, &modules, module, &nodes);

        const functions = try allocator.dupe(zx.ir.Function, call.callee.functions);

        for (functions) |*function| {
            if (function.external) |*external| external.module = native_mapping[@intFromEnum(external.module)];
        }

        call.callee.functions = functions;
    }

    for (calls) |*call| call.callee.native_modules = modules.items;

    return modules.items;
}
