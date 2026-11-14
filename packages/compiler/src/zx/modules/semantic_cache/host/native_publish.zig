const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Loaded = @import("../../native.zig");
const Current = @import("../native_restore.zig").Current;
const strings = @import("../../compiled/host/native.zig").strings;
const copyExternalDetails = @import("../../compiled/host/function.zig").copyExternalDetails;

pub fn apply(allocator: std.mem.Allocator, output: anytype, names: []const []const u8, ids: []const u32, current: Current) std.mem.Allocator.Error!Loaded.Result {
    const exports = try allocator.alloc(ir.Export, names.len);

    for (exports, names, ids) |*item, name, id| {
        item.* = .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(id) };
    }

    const signatures = zx.columns.view(ir.SignatureTable, output.signatures);
    const members = try allocator.alloc(Loaded.Member, signatures.count());

    if (members.len != 0) {
        const file = try allocator.dupe(u8, signatures.files[0]);
        const first_member = signatures.native_members[0];
        const namespace = try strings(allocator, first_member[0 .. first_member.len - 1]);

        for (members, 0..) |*member, index| {
            const signature = signatures.at(index);
            var external = signature.external.?;
            const name = try allocator.dupe(u8, external.exportName());
            const path = try allocator.alloc([]const u8, namespace.len + 1);

            @memcpy(path[0..namespace.len], namespace);

            path[namespace.len] = name;
            external.module = current.module;
            external.member = path;
            external.export_name = if (external.export_name != null) name else null;

            member.* = .{ .name = name, .function = .{
                .file_name = file,
                .input_type = signature.input_type,
                .output_type = signature.output_type,
                .output_ownership = signature.output_ownership,
                .external = try copyExternalDetails(allocator, external),
                .symbols = .{},
                .expressions = .{},
                .body = .{},
            } };
        }
    }

    const types = zx.columns.view(ir.TypeTable, output.types);

    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, current.types, &current.origins.items, types, output.origins);

    return .{ .types = current.types.view(), .exports = exports, .members = members };
}
