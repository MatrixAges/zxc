const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const resolution = @import("../../analysis/types/resolve.zig");

pub const Signature = struct { input: zx.ir.TypeId, output: zx.ir.TypeId, native: zx.ir.NativeType };

pub fn analyze(arena: *std.heap.ArenaAllocator, types: *Types, view: anytype) zx.Error![]const Signature {
    const allocator = arena.allocator();
    const type_view = view.typeView();
    const signatures = try allocator.alloc(Signature, view.functionCount());

    for (signatures, 0..) |*signature, index| {
        const declaration = view.functionAt(index);
        const parameters = try allocator.alloc(zx.ir.TypeId, declaration.parameters.len);

        for (parameters, 0..) |*type_id, parameter_index| {
            type_id.* = try resolution.node(types, type_view, zx.syntax.borrow.item(declaration.parameters, parameter_index));

            if (type_id.* == Types.scalarId(.void)) return types.reporter.fail(.type_mismatch, declaration.name.span, "native void inputs use an empty parameter list");
        }

        const input = switch (parameters.len) {
            0 => Types.scalarId(.void),
            1 => parameters[0],
            else => try types.tuple(parameters),
        };

        const output = try resolution.node(types, type_view, declaration.output);

        if (declaration.concurrent and (try zx.ir.containsNativeReference(allocator, types.items.view(), input) or try zx.ir.containsNativeReference(allocator, types.items.view(), output))) return types.reporter.fail(.capability, declaration.name.span, "host reference accessors cannot declare concurrency");
        if (try zx.ir.containsNativeReference(allocator, types.items.view(), output) and !(try zx.ir.containsNativeReference(allocator, types.items.view(), input))) return types.reporter.fail(.ownership, declaration.name.span, "native reference results require a host reference input");

        signature.* = .{
            .input = input,
            .output = output,
            .native = try @import("../seed_native_types.zig").parameters(allocator, type_view, declaration.parameters, types.reporter),
        };
    }

    return signatures;
}
