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
    const ids = try allocator.alloc(u32, artifact.exports.len);

    for (artifact.exports, names, ids) |exported, *name, *id| {
        name.* = exported.name;
        id.* = @backingInt(exported.type_id);
    }

    const ImportPointer = std.meta.Elem(@FieldType(Request, "imports"));
    const imports = try allocator.alloc(ImportPointer, artifact.function_imports.len);

    for (artifact.function_imports, imports) |source, *target| {
        const item = try allocator.create(std.meta.Child(ImportPointer));
        item.* = .{ .namespace = source.namespace, .name = source.name, .id = @backingInt(source.id), .input_type = @backingInt(source.input_type), .output_type = @backingInt(source.output_type) };
        target.* = item;
    }

    self.request = .{
        .path = artifact.path,
        .has_function = artifact.function != null,
        .dependency_count = artifact.dependencies.len,
        .type_import_count = artifact.type_imports.len,
        .store_count = artifact.stores.count(),
        .signatures = &self.signatures,
        .modules = &self.modules,
        .export_names = names,
        .export_types = ids,
        .origins = &self.origins,
        .imports = imports,
        .declaration = &self.declaration,
    };

    self.validation = .{
        .request = &self.request,
        .types = &self.types,
        .version = zx.ir_version,
        .max_offset = std.math.maxInt(usize),
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    self.input = .{ .validation = &self.validation, .origin_names = artifact.nominal_types.names, .base = &self.base, .base_origins = &self.base_origins, .module_id = @backingInt(current.module) };
}
