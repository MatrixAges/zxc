const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Loaded = @import("../../native.zig");
const Current = @import("../native_restore.zig").Current;
const Input = @import("native_input.zig");
const Members = @import("../../native/members.zig");

pub fn apply(allocator: std.mem.Allocator, output: anytype, mapped: *const Input, signatures: ir.SignatureTable, current: Current) std.mem.Allocator.Error!Loaded.Result {
    const names = mapped.request.export_names;
    const exports = try allocator.alloc(ir.Export, names.len);

    for (exports, names, mapped.export_ids) |*item, name, id| {
        item.* = .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(id) };
    }

    const members = try allocator.alloc(Loaded.Member, signatures.count());

    const namespace = if (members.len != 0) owned: {
        const first_member = signatures.native_members[0];
        const owner = try Members.fromPath(allocator, signatures.files[0], first_member[0 .. first_member.len - 1], current.module);

        for (members, 0..) |*member, index| {
            var signature = signatures.at(index);

            signature.input_type = @fromBackingInt(mapped.input_ids[index]);
            signature.output_type = @fromBackingInt(mapped.output_ids[index]);
            member.* = try owner.own(signature.external.?.exportName(), signature);
        }

        break :owned owner.namespace;
    } else null;

    const types = zx.columns.view(ir.TypeTable, output.types);

    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, current.types, &current.origins.items, types, output.origins);

    return .{ .types = current.types.view(), .exports = exports, .members = members, .namespace = namespace };
}
