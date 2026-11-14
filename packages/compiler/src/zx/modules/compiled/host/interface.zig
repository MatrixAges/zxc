const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const model = @import("../../compiled.zig");
const Input = @import("input.zig");
const FunctionImport = @import("../../function_import.zig");
const literal = @import("../../../analysis/constants/input.zig");
const Plan = std.meta.Child(@import("generated_compiled_library").Output);
const generated = @import("generated_compiled_interface");
const Request = std.meta.Child(generated.Input);

pub const Interface = struct {
    exports: []const model.Export = &.{},
    initializers: []const model.StoreInitializer = &.{},
};

pub fn materialize(allocator: std.mem.Allocator, input: *const Input, plan: *const Plan, first: usize) (std.mem.Allocator.Error || error{InvalidModule})!Interface {
    if (input.exports.names.len == 0 and input.initializers.identities.len == 0) return .{};

    const Exports = std.meta.Child(@FieldType(Request, "exports"));
    const Initializers = std.meta.Child(@FieldType(Request, "initializers"));
    const Selection = std.meta.Child(@typeInfo(@FieldType(Request, "selection")).optional.child);
    const exports_view = zx.columns.view(Exports, input.exports);
    const initializers_view = zx.columns.view(Initializers, input.initializers);
    const selection = if (plan.selection) |value| zx.columns.view(Selection, value) else null;

    const request: Request = .{
        .exports = &exports_view,
        .initializers = &initializers_view,
        .selection = if (selection) |*value| value else null,
        .first = first,
        .mapping = plan.functions.types,
        .instance = input.input.instance,
    };

    const owned = zx.columns.invoke(generated.executeValue, allocator, &request) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    const references = owned.surface.references;
    const exports = try allocator.alloc(model.Export, references.len);

    for (references, exports, 0..) |reference, *exported, index| {
        const original: usize = @intCast(reference.first);

        exported.* = if (original == index)
            try exportRow(allocator, reference.name, owned.surface.exports[@intCast(reference.row)])

        else
            exports[original];

        exported.name = reference.name;
    }

    const initializers = try allocator.alloc(model.StoreInitializer, owned.initializers.len);

    for (owned.initializers, initializers) |source, *target| {
        target.* = .{
            .identity = source.identity,
            .schema_version = source.schema_version,
            .function = @fromBackingInt(source.function),
        };
    }

    return .{ .exports = exports, .initializers = initializers };
}

fn exportRow(allocator: std.mem.Allocator, name: []const u8, source: anytype) std.mem.Allocator.Error!model.Export {
    const types = try allocator.alloc(ir.Export, source.types.len);
    const members = try allocator.alloc(FunctionImport, source.members.len);
    const constants = try allocator.alloc(ir.Constant, source.constants.len);

    for (source.types, types) |value, *target| target.* = .{
        .name = value.name,
        .type_id = @fromBackingInt(value.type_id),
    };

    for (source.members, members) |value, *target| target.* = .{
        .name = value.name,
        .id = if (value.id) |id| @fromBackingInt(id) else null,
        .input_type = if (value.input_type) |id| @fromBackingInt(id) else null,
        .output_type = if (value.output_type) |id| @fromBackingInt(id) else null,
        .intrinsic = if (value.intrinsic) |operation| @fromBackingInt(@intCast(@backingInt(operation))) else null,
    };

    for (source.constants, constants) |value, *target| target.* = .{
        .name = value.name,
        .type_id = @fromBackingInt(value.type_id),
        .value = literal.view(value),
    };

    return .{
        .name = name,
        .path = source.path,
        .function = if (source.function) |id| @fromBackingInt(id) else null,
        .types = types,
        .members = members,
        .constants = constants,
    };
}
