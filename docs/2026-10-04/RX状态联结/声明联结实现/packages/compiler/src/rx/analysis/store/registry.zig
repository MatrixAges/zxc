const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");
pub const Data = struct { definitions: []Store.Definition, context: frontend.Context };
pub const Value = union(enum) { data: Data, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, context: frontend.Context) std.mem.Allocator.Error!Value {
    const definitions = try allocator.alloc(Store.Definition, sources.len);
    var shared = context;

    for (sources, definitions, 0..) |source, *definition, index| {
        const result = try Store.analyze(allocator, .{ .owner = source.path, .node = source.node, .types = shared.types, .nominal_types = shared.nominal_types });

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
