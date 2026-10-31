const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");
pub const Data = struct { definitions: []Store.Definition, context: frontend.Context };
pub const Value = union(enum) { data: Data, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context) std.mem.Allocator.Error!Value {
    return loadIn(allocator, sources, .{ .entry = "", .context = context }, null);
}

pub fn loadSignatures(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, project: frontend.project.Options, signatures: frontend.project.signature_project.Data) std.mem.Allocator.Error!Value {
    return loadIn(allocator, sources, project, signatures);
}

fn loadIn(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, project: frontend.project.Options, signatures: ?frontend.project.signature_project.Data) std.mem.Allocator.Error!Value {
    const definitions = try allocator.alloc(Store.Definition, sources.len);
    var shared = project.context;

    for (sources, definitions, 0..) |source, *definition, index| {
        const aliases = if (signatures) |signed| try @import("../project/type_imports.zig").collect(allocator, source, project, signed) else @import("../project/type_imports.zig").Value{ .imports = &.{} };

        if (aliases == .diagnostic) return .{ .diagnostic = aliases.diagnostic };

        const result = try Store.analyze(allocator, .{ .owner = source.path, .node = source.node, .types = shared.types, .nominal_types = shared.nominal_types, .native_modules = shared.native_modules, .aliases = aliases.imports });

        if (result.value == .diagnostic) return .{ .diagnostic = result.value.diagnostic };

        definition.* = result.value.definition;

        for (definitions[0..index]) |previous| if (std.mem.eql(u8, previous.source_path, definition.source_path)) {
            const failed = try target.failure(allocator, .{ .path = source.path, .location = source.node.location, .code = "module", .message = "Store definition path is already registered" });

            return .{ .diagnostic = failed.diagnostic };
        };

        shared.types = definition.types;
    }

    return .{ .data = .{ .definitions = definitions, .context = shared } };
}
