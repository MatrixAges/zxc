const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../build.zig");
const dependency = @import("../dependencies/host.zig");
const Nodes = @import("../../artifact/nodes.zig");
const generated = @import("generated_artifact_signature");
const Input = std.meta.Child(generated.Input);
const Ports = std.meta.Child(@FieldType(Input, "ports"));
const Registry = std.meta.Child(@FieldType(Input, "registry"));
const Edges = @FieldType(Input, "edges");
const Edge = std.meta.Child(std.meta.Child(Edges));
const Bindings = std.meta.Child(@typeInfo(@FieldType(Edge, "members")).optional.child);
const External = std.meta.Child(@typeInfo(@FieldType(Input, "external")).optional.child);
const Modules = std.meta.Child(@FieldType(Input, "modules"));
const Signatures = std.meta.Child(@FieldType(Input, "linked"));

fn project(self: *const Builder, allocator: std.mem.Allocator, index: usize) std.mem.Allocator.Error!Edges {
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

pub fn bind(self: *Builder, index: usize, mapping: []?ir.FunctionId, native_ids: []const ?ir.NativeModuleId, nodes: *Nodes) Builder.Error!void {
    if (mapping.len == 0) return;

    var arena = std.heap.ArenaAllocator.init(self.temporary);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const signatures = self.modules[index].functions;
    const registry: Registry = .{ .keys = self.plan.paths, .buckets = self.plan.buckets, .values = &.{} };
    const modules = zx.columns.columns(Modules, self.native_modules.view());
    var edges: ?Edges = null;

    for (mapping, 0..) |*id, row| {
        const source = signatures.at(row);

        if (source.external == null and edges == null) edges = try project(self, memory, index);

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

        const external = if (source.external) |value| @import("../native/signature.zig").borrow(External, value) else null;
        const linked = zx.columns.columns(Signatures, ir.SignatureTable.fromFunctions(self.functions.view()));

        const input: Input = .{
            .path = source.file_name,
            .key = source.file_name,
            .ports = &ports,
            .external = if (external) |*value| value else null,
            .types = @ptrCast(self.type_mappings[index]),
            .modules = &modules,
            .native_ids = @ptrCast(native_ids),
            .linked = &linked,
            .registry = &registry,
            .edges = edges orelse &.{},
            .functions = @ptrCast(self.module_functions),
        };

        id.* = try resolve(self, memory, nodes, source, &input);
    }
}

fn resolve(self: *Builder, allocator: std.mem.Allocator, nodes: *Nodes, source: ir.Signature, input: *const Input) Builder.Error!ir.FunctionId {
    const result = zx.columns.invoke(generated.executeValue, allocator, input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result.status) {
        .Reuse => @fromBackingInt(@as(u32, @intCast(result.row))),
        .Insert => {
            var resolved = source;
            resolved.input_type = @fromBackingInt(result.input_type);
            resolved.output_type = @fromBackingInt(result.output_type);
            const module: ir.NativeModuleId = @fromBackingInt(result.native_id orelse return error.InvalidModule);
            const external = try nodes.externalMapped(source.external orelse return error.InvalidModule, module);

            try self.appendExternal(resolved, external);

            return @fromBackingInt(@as(u32, @intCast(result.row)));
        },
        .Invalid => error.InvalidModule,
        .Conflict => error.ConflictingInterface,
    };
}
