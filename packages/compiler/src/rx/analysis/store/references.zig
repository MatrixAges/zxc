const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Store = @import("../store.zig");
const target = @import("../call/target.zig");
const Graph = @import("../project/source_graph/model.zig");

pub const Value = union(enum) { bindings: []const Store.Binding, diagnostic: target.Diagnostic };

pub fn resolve(allocator: std.mem.Allocator, source: rx.ModuleSource, edges: []const Graph.Edge, modules: []const Graph.Module, definitions: []const Store.Definition) std.mem.Allocator.Error!Value {
    var bindings: std.ArrayList(Store.Binding) = .empty;
    var aliases: std.StringHashMapUnmanaged(void) = .empty;
    var references: Graph.References = .{ .remaining = edges };

    defer aliases.deinit(allocator);

    for (source.node.children) |node| {
        if (!std.mem.eql(u8, node.name, "Store")) continue;

        const from = target.attribute(node, "from");
        const edge = references.next(.store);
        const definition = &definitions[modules[edge.target.source].source.store];
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

            const names = try slotNames(allocator, alias, definition.source_path, object.name);

            try bindings.append(allocator, .{
                .name = names.reference,
                .slot = .{
                    .path = names.identity,
                    .type_id = object.initial.output_type,
                    .writable = false,
                },
            });
        }
    }

    return .{ .bindings = bindings.items };
}

const SlotNames = struct { reference: []const u8, identity: []const u8 };

fn slotNames(allocator: std.mem.Allocator, alias: []const u8, path: []const u8, object: []const u8) std.mem.Allocator.Error!SlotNames {
    if (comptime !@import("rx_options").generated_graph) return .{
        .reference = try std.fmt.allocPrint(allocator, "store.{s}.{s}", .{ alias, object }),
        .identity = try std.fmt.allocPrint(allocator, "store.{s}:{s}", .{ path, object }),
    };

    const rule = @import("generated_rx_store_slot_names");
    const input: std.meta.Child(rule.Input) = .{ .alias = alias, .path = path, .object = object };

    const names = zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .reference = names.reference, .identity = names.identity };
}

fn identifier(name: []const u8) bool {
    return frontend.binding_path.valid(name) and std.mem.indexOfAny(u8, name, ".$") == null;
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = path, .location = location, .code = "capability", .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
