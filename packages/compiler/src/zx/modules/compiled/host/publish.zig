const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../compiled.zig");
const Destination = @import("../load.zig").Destination;
const Output = std.meta.Child(@import("generated_compiled_library").Output);
const borrow = @import("../../../ir/canonical/borrow.zig");
const function = @import("function.zig");

pub fn apply(allocator: std.mem.Allocator, function_allocator: std.mem.Allocator, library: *const model.Library, output: *const Output, destination: Destination) (std.mem.Allocator.Error || error{InvalidModule})!model.Loaded {
    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, destination.types, &destination.origins.items, output.types.*, output.origins.*);

    const natives = borrow.columns(ir.NativeModuleTable, output.natives.*);

    for (0..natives.count()) |index| {
        try destination.native_modules.append(allocator, try @import("native.zig").copy(allocator, natives.at(index)));
    }

    const functions = library.program.functions;
    const mapping: function.Mapping = .{ .types = output.functions.types, .natives = output.functions.natives };
    const context: function.Context = .{ .mapping = &mapping, .first = destination.functions.count(), .instance = library.instance };

    try destination.functions.reserve(function_allocator, functions.count());

    for (0..functions.count()) |index| {
        try function.appendAssumeCapacity(function_allocator, destination.functions, functions.at(index), context);
    }

    const aliased = output.aliases.names.len != 0;
    const names = if (aliased) output.aliases.names else output.exports.names;
    const exports = try allocator.alloc(model.Export, names.len);

    for (exports, names, 0..) |*exported, name, position| {
        const index = if (aliased) @as(usize, @intCast(output.aliases.rows[position])) else position;

        if (aliased) {
            const first = output.aliases.first[index];

            if (first != position) {
                exported.* = exports[@intCast(first)];
                exported.name = try allocator.dupe(u8, name);

                continue;
            }
        }

        const types = try allocator.alloc(ir.Export, output.exports.type_names[index].len);

        for (types, output.exports.type_names[index], output.exports.type_ids[index]) |*item, type_name, id| {
            item.* = .{ .name = try allocator.dupe(u8, type_name), .type_id = @fromBackingInt(id) };
        }

        const source_members = output.exports.members[index];
        const members = try allocator.alloc(@import("../../function_import.zig"), source_members.names.len);

        for (members, 0..) |*member, row| member.* = .{
            .intrinsic = if (source_members.intrinsics[row]) |operation| @fromBackingInt(@intCast(@backingInt(operation))) else null,
            .namespace = null,
            .name = try allocator.dupe(u8, source_members.names[row]),
            .id = if (source_members.ids[row]) |id| @fromBackingInt(id) else null,
            .input_type = if (source_members.input_types[row]) |id| @fromBackingInt(id) else null,
            .output_type = if (source_members.output_types[row]) |id| @fromBackingInt(id) else null,
        };

        exported.* = .{
            .name = try allocator.dupe(u8, name),
            .path = try allocator.dupe(u8, output.exports.paths[index]),
            .function = if (output.exports.functions[index]) |id| @fromBackingInt(id) else null,
            .types = types,
            .members = members,
            .constants = try @import("../../../analysis/constants/exports.zig").own(allocator, output.exports.constants[index], 0),
        };
    }

    const initializers = try allocator.alloc(model.StoreInitializer, output.initializers.identities.len);

    for (initializers, 0..) |*item, index| {
        item.* = .{ .identity = try allocator.dupe(u8, output.initializers.identities[index]), .schema_version = output.initializers.versions[index], .function = @fromBackingInt(output.initializers.functions[index]) };
    }

    return .{ .types = destination.types.view(), .nominal_types = destination.origins.items.view(), .exports = exports, .store_initializers = initializers };
}
