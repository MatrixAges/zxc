const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../artifact/model.zig");
const Native = @import("../../interface.zig").Native;
const Current = @import("../native_restore.zig").Current;
const Origins = @import("../../nominal_origins.zig");
const borrow = @import("../../../ir/canonical/borrow.zig");
const Input = std.meta.Child(@import("generated_native_restore").Input);
const Validation = std.meta.Child(@FieldType(Input, "validation"));
pub const Request = std.meta.Child(@FieldType(Validation, "request"));
const Published = std.meta.Child(@FieldType(Input, "published"));
const Self = @This();

signatures: std.meta.Child(@FieldType(Request, "signatures")),
modules: std.meta.Child(@FieldType(Request, "modules")),
origins: std.meta.Child(@FieldType(Request, "origins")),
declaration: std.meta.Child(@FieldType(Request, "declaration")),
types: std.meta.Child(@FieldType(Validation, "types")),
base: std.meta.Child(@FieldType(Input, "base")),
base_origins: std.meta.Child(@FieldType(Input, "base_origins")),
request: Request,
validation: Validation,
type_ids: []u32,
export_ids: []u32,
input_ids: []u32,
output_ids: []u32,
published: Published,
input: Input,
pub fn init(self: *Self, allocator: std.mem.Allocator, artifact: *const Artifact.Module, entry: Native, current: Current, admitted: bool) std.mem.Allocator.Error!void {
    self.signatures = borrow.columns(@TypeOf(self.signatures), artifact.functions);
    self.modules = borrow.columns(@TypeOf(self.modules), artifact.native_modules);
    self.origins = Origins.Table.borrow(@TypeOf(self.origins), artifact.nominal_types);
    self.declaration = .{ .identity = entry.identity, .specifier = entry.specifier, .path = entry.path, .import_name = entry.module, .namespace = entry.namespace };
    self.types = ir.TypeTable.borrow(@TypeOf(self.types), artifact.types);
    self.base = ir.TypeTable.borrow(@TypeOf(self.base), current.types.view());
    self.base_origins = Origins.Table.borrow(@TypeOf(self.base_origins), current.origins.items.view());
    const type_count = artifact.types.count();
    const export_count = artifact.exports.len;
    const member_count = artifact.functions.count();
    const ports = std.math.mul(usize, member_count, 2) catch return error.OutOfMemory;
    const original = if (admitted) 0 else export_count;
    const exports = std.math.add(usize, export_count, original) catch return error.OutOfMemory;
    const mapped = std.math.add(usize, type_count, ports) catch return error.OutOfMemory;
    const count = std.math.add(usize, mapped, exports) catch return error.OutOfMemory;
    const ids = try allocator.alloc(u32, count);

    self.type_ids = ids[0..type_count];
    self.input_ids = ids[type_count..][0..member_count];
    self.output_ids = ids[type_count + member_count ..][0..member_count];
    self.export_ids = ids[mapped..][0..export_count];

    const names, const source_ids = if (admitted) .{
        artifact.native_modules.type_names[0],
        artifact.native_modules.type_ids[0],
    } else columns: {
        const names = try allocator.alloc([]const u8, export_count);
        const source = ids[mapped + export_count ..];

        for (artifact.exports, names, source) |exported, *name, *id| {
            name.* = exported.name;
            id.* = @backingInt(exported.type_id);
        }

        break :columns .{ @as([]const []const u8, names), @as([]const u32, source) };
    };

    self.request = .{
        .path = artifact.path,
        .has_function = artifact.function != null,
        .dependency_count = artifact.dependencies.len,
        .type_import_count = artifact.type_imports.len,
        .constant_export_count = artifact.constant_exports.len,
        .constant_import_count = artifact.constant_imports.len,
        .store_count = artifact.stores.count(),
        .signatures = &self.signatures,
        .modules = &self.modules,
        .export_names = names,
        .export_types = source_ids,
        .origins = &self.origins,
        .import_count = artifact.function_imports.len,
        .declaration = &self.declaration,
    };

    self.validation = .{
        .request = &self.request,
        .types = &self.types,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    self.published = .{
        .inputs = @ptrCast(&self.input_ids),
        .outputs = @ptrCast(&self.output_ids),
        .exports = @ptrCast(&self.export_ids),
    };

    self.input = .{
        .validation = &self.validation,
        .origin_names = artifact.nominal_types.names,
        .base = &self.base,
        .base_origins = &self.base_origins,
        .type_ids = self.type_ids,
        .type_mapping = @ptrCast(&self.type_ids),
        .published = &self.published,
        .admitted = admitted,
    };
}
