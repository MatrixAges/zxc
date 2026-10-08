const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Members = @import("members.zig");
const Member = Members.Member;
const Native = @import("../interface.zig").Native;

pub fn analyze(arena: *std.heap.ArenaAllocator, types: *Types, entry: Native, module: zx.ir.NativeModuleId) zx.Error!@import("interface.zig").Result {
    const allocator = arena.allocator();
    const parsed = try @import("../declarations.zig").parse(allocator, entry.source, types.reporter);
    const view = @import("view.zig").Native{ .value = parsed };
    const type_view = view.typeView();

    try @import("../../analysis/types/resolve.zig").initialize(types, type_view);

    for (entry.namespace) |part| {
        if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return types.reporter.fail(.module, .{ .start = 0, .end = 0 }, "native namespaces require nonempty UTF-8 member names");
    }

    const declarations = type_view.declarations();
    const exports = try allocator.alloc(zx.ir.Export, declarations.count());
    var iterator = declarations.iterator();

    for (exports) |*item| {
        const declaration = iterator.next().?;

        item.* = .{ .name = try allocator.dupe(u8, declaration.name.text), .type_id = types.resolved.get(declaration.name.text).? };
    }

    const signatures = try @import("seed_signatures.zig").analyze(arena, types, view);
    const members = try allocator.alloc(Member, signatures.len);

    if (members.len != 0) {
        const owner = try Members.init(allocator, entry, module);

        for (members, signatures, 0..) |*member, signature, index| {
            const declaration = view.functionAt(index);

            member.* = try owner.create(.{
                .name = declaration.name.text,
                .signature = .{ .input = @backingInt(signature.input), .output = @backingInt(signature.output) },
                .allocator_argument = declaration.allocator_argument,
                .io_argument = declaration.io_argument,
                .process_argument = declaration.process_argument,
                .expand_tuple = declaration.parameters.len > 1,
                .fallible = declaration.fallible,
                .errors = declaration.errors,
                .concurrent = declaration.concurrent,
            }, signature.native);
        }
    }

    return .{ .exports = exports, .members = members };
}
