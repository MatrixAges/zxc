const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");

pub const Value = union(enum) { bindings: []const Store.Binding, diagnostic: target.Diagnostic };

pub fn resolve(allocator: std.mem.Allocator, source: rx.ModuleSource, definitions: []const Store.Definition) std.mem.Allocator.Error!Value {
    var bindings: std.ArrayList(Store.Binding) = .empty;
    var aliases: std.StringHashMapUnmanaged(void) = .empty;

    defer aliases.deinit(allocator);

    for (source.node.children) |node| {
        if (!std.mem.eql(u8, node.name, "Store")) continue;

        const from = target.attribute(node, "from");

        const path = rx.resolveStorePath(allocator, source.path, from.value) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return failure(allocator, source.path, from.value_location, "Store reference must stay within the project root");
        };

        const definition = find(definitions, path) orelse return failure(allocator, source.path, from.value_location, "Store definition is not registered");
        var alias = definition.name;
        var location = from.value_location;

        for (node.attributes) |attribute| if (std.mem.eql(u8, attribute.name, "as")) {
            alias = attribute.value;
            location = attribute.value_location;
        };

        if (!identifier(alias)) return failure(allocator, source.path, location, "Store namespace must be an identifier; use as for a different display name");
        if ((try aliases.getOrPut(allocator, alias)).found_existing) return failure(allocator, source.path, location, "Store namespace is already registered in this module");

        for (definition.objects) |object| {
            if (!identifier(object.name)) return failure(allocator, source.path, from.value_location, "Store Object names must be identifiers");

            try bindings.append(allocator, .{
                .name = try std.fmt.allocPrint(allocator, "store.{s}.{s}", .{ alias, object.name }),
                .slot = .{
                    .path = try std.fmt.allocPrint(allocator, "store.{s}:{s}", .{ definition.source_path, object.name }),
                    .type_id = object.initial.output_type,
                    .writable = false,
                },
            });
        }
    }

    return .{ .bindings = bindings.items };
}

fn find(definitions: []const Store.Definition, path: []const u8) ?Store.Definition {
    for (definitions) |definition| if (std.mem.eql(u8, definition.source_path, path)) {
        return definition;
    };

    return null;
}

fn identifier(name: []const u8) bool {
    return frontend.binding_path.valid(name) and std.mem.indexOfAny(u8, name, ".$") == null;
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = path, .location = location, .code = "capability", .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
