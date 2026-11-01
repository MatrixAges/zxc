const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Origins = @import("../nominal_origins.zig");
const Signature = @import("../source_signature.zig");
const generated = @import("generated_source_signature");
const borrow = @import("../../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);
const Declarations = std.meta.Child(@FieldType(Input, "declarations"));

pub fn analyze(types: *Types, source: []const u8, syntax: anytype, constants: []const zx.ir.Constant) zx.Error!Signature.Result {
    var arena = zx.Arena.init(types.allocator);

    defer arena.deinit();

    return run(types, &arena, source, borrow.pointer(@FieldType(Declarations, "syntax"), syntax), null, constants);
}

pub fn analyzeNative(types: *Types, source: []const u8, program: zx.ast.Program, constants: []const zx.ir.Constant) zx.Error!Signature.Result {
    var arena = zx.Arena.init(types.allocator);

    defer arena.deinit();

    const input = try @import("../../analysis/analyzer/host/native/root.zig").convert(.header, arena.allocator(), program);

    return run(types, &arena, source, borrow.pointer(@FieldType(Declarations, "syntax"), input.syntax), borrow.pointer(@typeInfo(@FieldType(Declarations, "native")).optional.child, input.native), constants);
}

fn run(types: *Types, arena: *zx.Arena, source: []const u8, syntax: @FieldType(Declarations, "syntax"), native: @FieldType(Declarations, "native"), constants: []const zx.ir.Constant) zx.Error!Signature.Result {
    const allocator = arena.allocator();
    const type_base = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Declarations, "type_base")), types.items.view());
    const nominal_base = Origins.Table.borrow(std.meta.Child(@FieldType(Declarations, "nominal_base")), if (types.shared) |shared| shared.origins.items.view() else .{});
    const origin: Origins.Origin = if (types.shared) |shared| shared.origin else .{ .source = "" };

    const nominal_origin: std.meta.Child(@FieldType(Declarations, "nominal_origin")) = .{
        .kind = switch (origin) {
            .source => 0,
            .native => 1,
            .external => 2,
        },
        .owner = switch (origin) {
            .source, .native => |name| name,
            .external => |value| value.module,
        },
        .member = if (origin == .external) origin.external.member else "",
    };

    const names = try allocator.alloc([]const u8, types.aliases.len);
    const ids = try allocator.alloc(u32, types.aliases.len);

    for (types.aliases, names, ids) |alias, *name, *id| {
        name.* = alias.name;
        id.* = @backingInt(alias.type_id);
    }

    const aliases: std.meta.Child(@FieldType(Declarations, "aliases")) = .{ .names = names, .ids = ids };

    const declarations = Declarations{
        .bytes = source,
        .syntax = syntax,
        .native = native,
        .type_base = &type_base,
        .aliases = &aliases,
        .nominal_base = &nominal_base,
        .nominal_origin = &nominal_origin,
        .shared = types.shared != null,
    };

    const Values = std.meta.Child(@typeInfo(@FieldType(Input, "imports")).optional.child);

    const input = Input{
        .declarations = &declarations,
        .imports = try @import("../../analysis/constants/input.zig").marshal(Values, allocator, constants),
    };

    const output = generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return types.reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(types.allocator, "internal compiler error: generated signature analysis failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try types.allocator.dupe(u8, output.diagnostic.message),
    );

    var unshared: Origins.Storage = .{};
    const origins = if (types.shared) |shared| &shared.origins.items else &unshared;

    try @import("../../analysis/semantic/merging/commit.zig").append(types.allocator, &types.items, origins, output.type_delta.*, output.nominal_delta.*);

    const exports = try types.allocator.alloc(zx.ir.Export, output.export_names.len);

    for (output.export_names, output.export_types, exports) |name, type_id, *exported| {
        exported.* = .{ .name = try types.allocator.dupe(u8, name), .type_id = @fromBackingInt(type_id) };
    }

    return .{
        .ports = .{ .input_type = @fromBackingInt(output.input_type), .output_type = @fromBackingInt(output.output_type) },
        .exports = exports,
        .constant_exports = try publishConstants(types.allocator, output),
        .type_only = output.type_only,
        .has_store = output.has_store,
    };
}

fn publishConstants(allocator: std.mem.Allocator, output: generated.Output) std.mem.Allocator.Error![]const zx.ir.Constant {
    const scope = output.constant_scope orelse return &.{};
    const first: usize = @intCast(output.constant_first);
    const constants = try allocator.alloc(zx.ir.Constant, scope.names.len - first);

    for (scope.names[first..], scope.values[first..], constants) |name, literal, *constant| constant.* = .{
        .name = try allocator.dupe(u8, name),
        .type_id = @fromBackingInt(literal.type_id),
        .value = try @import("../../analysis/constants/input.zig").own(allocator, literal),
    };

    return constants;
}
