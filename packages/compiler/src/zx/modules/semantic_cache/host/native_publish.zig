const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Loaded = @import("../../native.zig");
const Current = @import("../native_restore.zig").Current;
const Artifact = @import("../../artifact/model.zig");
const Native = @import("../../interface.zig").Native;
const strings = @import("../../compiled/host/native.zig").strings;
const copyExternalDetails = @import("../../compiled/host/function.zig").copyExternalDetails;

pub fn apply(allocator: std.mem.Allocator, output: anytype, artifact: *const Artifact.Module, entry: *const Native, current: Current) std.mem.Allocator.Error!Loaded.Result {
    const exports = try allocator.alloc(ir.Export, artifact.exports.len);

    for (exports, artifact.exports, output.export_types) |*item, *original, id| {
        item.* = .{ .name = try allocator.dupe(u8, original.name), .type_id = @fromBackingInt(id) };
    }

    const members = try allocator.alloc(Loaded.Member, artifact.functions.count());

    if (members.len != 0) {
        const file = try allocator.dupe(u8, entry.path);
        const namespace = try strings(allocator, entry.namespace);

        for (members, output.ports.input_types, output.ports.output_types, 0..) |*member, input, result, index| {
            const signature = artifact.functions.at(index);
            const name = try allocator.dupe(u8, artifact.function_imports[index].name);
            const path = try allocator.alloc([]const u8, namespace.len + 1);

            @memcpy(path[0..namespace.len], namespace);

            path[namespace.len] = name;

            var external = signature.external.?;
            external.module = current.module;
            external.member = path;
            external.export_name = if (external.export_name != null) name else null;

            member.* = .{ .name = name, .function = .{
                .file_name = file,
                .input_type = @fromBackingInt(input),
                .output_type = @fromBackingInt(result),
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
