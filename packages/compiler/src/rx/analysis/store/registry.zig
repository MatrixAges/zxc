const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");
const Graph = @import("../project/source_graph/model.zig");
const Signatures = @import("../project/references/signatures.zig");
pub const Data = struct { definitions: []Store.Definition, context: frontend.Context };
pub const Value = union(enum) { data: Data, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context) std.mem.Allocator.Error!Value {
    return loadIn(allocator, allocator, sources, context, &.{}, null);
}

pub fn loadSignatures(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context, modules: []const Graph.Module, signatures: Signatures) std.mem.Allocator.Error!Value {
    return loadSignaturesIn(allocator, allocator, sources, context, modules, signatures);
}

pub fn loadSignaturesIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context, modules: []const Graph.Module, signatures: Signatures) std.mem.Allocator.Error!Value {
    return loadIn(allocator, backing, sources, context, modules, signatures);
}

fn loadIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context, modules: []const Graph.Module, signatures: ?Signatures) std.mem.Allocator.Error!Value {
    const definitions = try allocator.alloc(Store.Definition, sources.len);
    var paths: std.StringHashMapUnmanaged(void) = .empty;
    var shared = context;

    defer paths.deinit(backing);

    for (sources, definitions, 0..) |source, *definition, index| {
        const imports = @import("../project/type_imports.zig");
        const aliases = if (signatures) |signed| try imports.collect(allocator, source, modules[index], signed) else imports.Value{ .imports = &.{} };

        if (aliases == .diagnostic) return .{ .diagnostic = aliases.diagnostic };

        const result = try Store.analyzeIn(allocator, backing, .{ .owner = source.path, .node = source.node, .types = shared.types, .nominal_types = shared.nominal_types, .native_modules = shared.native_modules, .aliases = aliases.imports });

        if (result == .diagnostic) return .{ .diagnostic = result.diagnostic };

        definition.* = result.definition;

        if (signatures == null and (try paths.getOrPut(backing, definition.source_path)).found_existing) {
            const failed = try target.failure(allocator, .{ .path = source.path, .location = source.node.location, .code = "module", .message = "Store definition path is already registered" });

            return .{ .diagnostic = failed.diagnostic };
        }

        shared.types = definition.types;
    }

    return .{ .data = .{ .definitions = definitions, .context = shared } };
}
