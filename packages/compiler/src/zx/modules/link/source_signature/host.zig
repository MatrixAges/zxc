const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../build.zig");
const dependency = @import("../dependencies/host.zig");
const generated = @import("generated_artifact_source_signature");
const Input = std.meta.Child(generated.Input);
const Signature = std.meta.Child(@FieldType(Input, "signature"));
const Ports = std.meta.Child(@FieldType(Signature, "ports"));
const Registry = std.meta.Child(@FieldType(Input, "registry"));
pub const Edges = @FieldType(Input, "edges");
const Edge = std.meta.Child(std.meta.Child(Edges));
const Bindings = std.meta.Child(@typeInfo(@FieldType(Edge, "members")).optional.child);

pub fn project(self: *const Builder, allocator: std.mem.Allocator, index: usize) std.mem.Allocator.Error!Edges {
    const module = &self.modules[index];
    const targets = self.plan.sources(index);
    const rows = try allocator.alloc(Edge, targets.len);
    const result = try allocator.alloc(*const Edge, targets.len);
    var target_index: usize = 0;
    var count: usize = 0;

    for (module.dependencies) |*item| {
        if (item.target != .source) continue;

        const provider = &self.modules[@intCast(targets[target_index])];

        target_index += 1;

        if (item.kind == .type_only) continue;

        const members = if (provider.members.len == 0) null else try allocator.create(Bindings);

        if (members) |table| table.* = try dependency.bindings(allocator, provider.members);

        rows[count] = .{
            .path = provider.path,
            .default_call = item.kind == .function,
            .members = members,
            .files = provider.functions.files,
        };

        result[count] = &rows[count];
        count += 1;
    }

    return result[0..count];
}

pub fn resolve(self: *const Builder, allocator: std.mem.Allocator, index: usize, edges: Edges, source: ir.Signature) Builder.Error!ir.FunctionId {
    const Ownership = @FieldType(Ports, "ownership");

    const ports: Ports = .{
        .input_type = @backingInt(source.input_type),
        .output_type = @backingInt(source.output_type),
        .ownership = switch (source.output_ownership) {
            .copy => Ownership.Copy,
            .borrowed => Ownership.Borrowed,
            .owned => Ownership.Owned,
        },
    };

    const signature: Signature = .{ .path = source.file_name, .key = source.file_name, .ports = &ports };
    const registry: Registry = .{ .keys = self.plan.paths, .buckets = self.plan.buckets, .values = &.{} };
    const linked = dependency.signatures(ir.SignatureTable.fromFunctions(self.functions.view()));

    const input: Input = .{
        .signature = &signature,
        .types = @ptrCast(self.type_mappings[index]),
        .registry = &registry,
        .edges = edges,
        .functions = @ptrCast(self.module_functions),
        .linked = &linked,
    };

    const result = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result.status) {
        .Ready => @fromBackingInt(result.id orelse return error.InvalidModule),
        .Invalid => error.InvalidModule,
        .Conflict => error.ConflictingInterface,
    };
}
