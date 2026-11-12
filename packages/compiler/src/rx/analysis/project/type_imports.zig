const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("../call/target.zig");
const Graph = @import("source_graph/model.zig");
const Signatures = @import("references/signatures.zig");

pub const Value = union(enum) { imports: []const zx.ir.Export, diagnostic: target.Diagnostic };

pub fn values(allocator: std.mem.Allocator, types: zx.ir.TypeTable, imports: []const zx.ir.Export) std.mem.Allocator.Error![]const zx.ir.Export {
    var result: std.ArrayList(zx.ir.Export) = .empty;

    for (imports) |alias| {
        if (types.at(@backingInt(alias.type_id)) == .enumeration) try result.append(allocator, alias);
    }

    return result.items;
}

pub fn collect(allocator: std.mem.Allocator, source: rx.ModuleSource, module: Graph.Module, signatures: Signatures) std.mem.Allocator.Error!Value {
    var references: Graph.References = .{ .remaining = module.dependencies };
    var imports: std.ArrayList(zx.ir.Export) = .empty;

    for (source.node.children) |node| {
        if (!std.mem.eql(u8, node.name, "Type")) continue;

        const from = target.attribute(node, "from");
        const alias = target.optionalAttribute(node, "as") orelse return failure(allocator, source, from, "Type requires an explicit as attribute");
        const reference = references.next(.type_import);

        const index = switch (reference.target) {
            .source => |index| index,
            .compiled => return failure(allocator, source, from, "Type requires a ZX source module"),
            .native => return failure(allocator, source, from, "native and standard imports must use the interface registry"),
        };

        if (signatures.graph.modules[index].source != .zx) return failure(allocator, source, from, "Type requires a ZX source module");

        const signature = signatures.get(index) orelse return failure(allocator, source, from, "Type source signature is missing from the analyzed input set");

        try imports.ensureUnusedCapacity(allocator, signature.signature.exports.len);

        for (signature.signature.exports) |exported| {
            imports.appendAssumeCapacity(.{
                .name = try qualify(allocator, alias.value, exported.name),
                .type_id = exported.type_id,
            });
        }
    }

    return .{ .imports = imports.items };
}

fn qualify(allocator: std.mem.Allocator, alias: []const u8, member: []const u8) std.mem.Allocator.Error![]const u8 {
    if (comptime !@import("rx_options").generated_graph) return std.fmt.allocPrint(allocator, "{s}.{s}", .{ alias, member });

    const rule = @import("generated_rx_qualify_type");
    const input: std.meta.Child(rule.Input) = .{ .alias = alias, .member = member };

    return zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}

fn failure(allocator: std.mem.Allocator, source: rx.ModuleSource, attribute: rx.ast.Attribute, message: []const u8) std.mem.Allocator.Error!Value {
    return .{ .diagnostic = .{
        .path = try allocator.dupe(u8, source.path),
        .location = attribute.value_location,
        .code = "module",
        .message = message,
    } };
}
