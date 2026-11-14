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
const Request = std.meta.Child(@FieldType(Validation, "request"));
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
input: Input,
pub fn init(self: *Self, allocator: std.mem.Allocator, artifact: Artifact.Module, entry: Native, current: Current) std.mem.Allocator.Error!void {
    self.signatures = borrow.columns(@TypeOf(self.signatures), artifact.functions);
    self.modules = borrow.columns(@TypeOf(self.modules), artifact.native_modules);
    self.origins = Origins.Table.borrow(@TypeOf(self.origins), artifact.nominal_types);
    self.declaration = .{ .identity = entry.identity, .specifier = entry.specifier, .path = entry.path, .import_name = entry.module, .namespace = entry.namespace };
    self.types = ir.TypeTable.borrow(@TypeOf(self.types), artifact.types);
    self.base = ir.TypeTable.borrow(@TypeOf(self.base), current.types.view());
    self.base_origins = Origins.Table.borrow(@TypeOf(self.base_origins), current.origins.items.view());

    const names = try allocator.alloc([]const u8, artifact.exports.len);

    self.export_ids = try allocator.alloc(u32, artifact.exports.len);

    for (artifact.exports, names, self.export_ids) |exported, *name, *id| {
        name.* = exported.name;
        id.* = @backingInt(exported.type_id);
    }

    const ImportPointer = std.meta.Elem(@FieldType(Request, "imports"));
    const Import = std.meta.Child(ImportPointer);
    const rows = try allocator.alloc(Import, artifact.function_imports.len);
    const imports = try allocator.alloc(ImportPointer, artifact.function_imports.len);

    for (artifact.function_imports, rows, imports) |*source, *row, *target| {
        row.* = source.borrow(Import);
        target.* = row;
    }

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
        .export_types = self.export_ids,
        .origins = &self.origins,
        .imports = imports,
        .declaration = &self.declaration,
    };

    self.validation = .{
        .request = &self.request,
        .types = &self.types,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    self.type_ids = try allocator.alloc(u32, artifact.types.count());

    @memset(self.type_ids, 0);

    self.input = .{
        .validation = &self.validation,
        .origin_names = artifact.nominal_types.names,
        .base = &self.base,
        .base_origins = &self.base_origins,
        .type_ids = self.type_ids,
        .type_mapping = @ptrCast(&self.type_ids),
        .export_ids = @ptrCast(&self.export_ids),
    };
}
