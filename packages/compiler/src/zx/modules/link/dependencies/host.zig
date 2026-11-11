const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../build.zig");
const Record = @import("../../module_record.zig");
const Binding = @import("../../function_import.zig");
const generated = @import("generated_artifact_dependencies");
const Request = std.meta.Child(generated.Input);
const Provider = std.meta.Child(@FieldType(Request, "provider"));
const Consumer = std.meta.Child(@FieldType(Request, "consumer"));
const Bindings = std.meta.Child(@FieldType(Provider, "members"));
const Aliases = std.meta.Child(@FieldType(Provider, "aliases"));
const Constants = std.meta.Child(@typeInfo(@FieldType(Provider, "constants")).optional.child);
const Signatures = std.meta.Child(@FieldType(Request, "linked"));
const Dependency = std.meta.Child(@FieldType(Request, "dependency"));

const Context = struct {
    imports: Bindings,
    members: Bindings,
    aliases: Aliases,
    types: []const u32,
    functions: []const ?u32,
    linked: Signatures,
};

pub fn verify(self: *Builder, index: usize, functions: []const ?ir.FunctionId) Builder.Error!void {
    const consumer = &self.modules[index];
    var arena = std.heap.ArenaAllocator.init(self.temporary);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();

    const context: Context = .{
        .imports = try bindings(memory, consumer.function_imports),
        .members = try bindings(memory, consumer.members),
        .aliases = try aliases(memory, consumer.type_imports),
        .types = @ptrCast(self.type_mappings[index]),
        .functions = @ptrCast(functions),
        .linked = signatures(ir.SignatureTable.fromFunctions(self.functions.view())),
    };

    const checks = @import("generated_artifact_binding_checks");

    const input: std.meta.Child(checks.Input) = .{
        .count = consumer.functions.count(),
        .functions = context.functions,
        .imports = &context.imports,
        .linked = &context.linked,
        .members = &context.members,
        .types = context.types,
    };

    try decision(checks.executeValue, memory, &input);

    const targets = self.plan.sources(index);
    var source_index: usize = 0;

    for (consumer.dependencies) |*dependency| {
        if (dependency.target == .source) {
            const target_index: usize = @intCast(targets[source_index]);

            try check(self, index, target_index, dependency, &context);

            source_index += 1;
        } else {
            const external = @import("generated_artifact_external_dependency");

            const edge: std.meta.Child(external.Input) = .{
                .intrinsic = dependency.target == .intrinsic,
                .type_only = dependency.kind == .type_only,
                .specifier = dependency.specifier,
                .intrinsic_name = @import("../../intrinsic.zig").specifier,
                .native_specifiers = consumer.native_modules.specifiers,
            };

            const allowed = zx.columns.invoke(external.executeValue, memory, &edge) catch |err| return failure(err);

            if (!allowed) return error.InvalidModule;
        }
    }
}

fn check(self: *Builder, index: usize, target_index: usize, dependency: *const Record.Import, context: *const Context) Builder.Error!void {
    const consumer = &self.modules[index];
    const provider = &self.modules[target_index];
    var arena = std.heap.ArenaAllocator.init(self.temporary);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const compare_constants = dependency.kind == .enumeration and provider.constant_exports.len != 0;
    const marshal = @import("../../../analysis/constants/input.zig").marshal;
    const selected = if (dependency.exported) &context.members else &context.imports;
    const has_members = dependency.kind != .type_only and provider.members.len != 0;
    const has_aliases = dependency.kind != .function and dependency.names.len != 0;
    const provider_members = try bindings(memory, if (has_members) provider.members else &.{});
    const provider_aliases = try aliases(memory, if (has_aliases) provider.exports else &.{});
    const provider_signatures = signatures(provider.functions);

    const source: Provider = .{
        .executable = provider.function != null,
        .members = &provider_members,
        .signatures = &provider_signatures,
        .aliases = &provider_aliases,
        .kinds = provider.types.kinds,
        .constants = if (compare_constants) try marshal(Constants, memory, provider.constant_exports) else null,
        .types = @ptrCast(self.type_mappings[target_index]),
    };

    const destination: Consumer = .{
        .members = selected,
        .aliases = &context.aliases,
        .constants = if (compare_constants) try marshal(Constants, memory, consumer.constant_imports) else null,
        .types = context.types,
        .functions = context.functions,
    };

    const edge: Dependency = .{
        .kind = switch (dependency.kind) {
            .type_only => .TypeOnly,
            .function => .Function,
            .enumeration => .Enumeration,
        },
        .names = dependency.names,
        .source_names = dependency.source_names,
        .wildcard = dependency.wildcard,
    };

    const input: Request = .{ .provider = &source, .consumer = &destination, .linked = &context.linked, .dependency = &edge };

    return decision(generated.executeValue, memory, &input);
}

fn decision(comptime execute: anytype, allocator: std.mem.Allocator, input: anytype) Builder.Error!void {
    const result = zx.columns.invoke(execute, allocator, input) catch |err| return failure(err);

    return switch (result) {
        .Ready => {},
        .Invalid => error.InvalidModule,
        .Conflict => error.ConflictingInterface,
    };
}

fn failure(err: anyerror) Builder.Error {
    return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;
}

pub fn signatures(source: ir.SignatureTable) Signatures {
    return .{
        .files = source.files,
        .input_types = source.input_types,
        .output_types = source.output_types,
        .ownership = zx.columns.slice(@FieldType(Signatures, "ownership"), source.ownership),
    };
}

pub fn bindings(allocator: std.mem.Allocator, source: []const Binding) std.mem.Allocator.Error!Bindings {
    const names = try allocator.alloc([]const u8, source.len);
    const namespaces = try allocator.alloc(?[]const u8, source.len);
    const ids = try allocator.alloc(?u32, source.len);
    const inputs = try allocator.alloc(?u32, source.len);
    const outputs = try allocator.alloc(?u32, source.len);
    const intrinsics = try allocator.alloc(?u8, source.len);

    for (source, names, namespaces, ids, inputs, outputs, intrinsics) |binding, *name, *namespace, *id, *input, *output, *intrinsic| {
        name.* = binding.name;
        namespace.* = binding.namespace;
        id.* = if (binding.id) |value| @backingInt(value) else null;
        input.* = if (binding.input_type) |value| @backingInt(value) else null;
        output.* = if (binding.output_type) |value| @backingInt(value) else null;
        intrinsic.* = if (binding.intrinsic) |value| @intFromEnum(value) else null;
    }

    return .{ .names = names, .namespaces = namespaces, .ids = ids, .inputs = inputs, .outputs = outputs, .intrinsics = intrinsics };
}

pub fn aliases(allocator: std.mem.Allocator, source: []const ir.Export) std.mem.Allocator.Error!Aliases {
    const names = try allocator.alloc([]const u8, source.len);
    const types = try allocator.alloc(u32, source.len);

    for (source, names, types) |item, *name, *type_id| {
        name.* = item.name;
        type_id.* = @backingInt(item.type_id);
    }

    return .{ .names = names, .types = types };
}
