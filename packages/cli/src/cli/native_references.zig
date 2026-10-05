const std = @import("std");
pub const Kind = enum { zig, asset };
pub const Reference = struct { path: []const u8, kind: Kind };
pub const Result = struct { references: []const Reference, dynamic_resources: bool, c_imports: bool };

pub fn read(allocator: std.mem.Allocator, source: []const u8) !Result {
    const text = try allocator.dupeSentinel(u8, source, 0);

    defer allocator.free(text);

    var tree = try std.zig.Ast.parse(allocator, text, .{});

    defer tree.deinit(allocator);

    if (tree.errors.len != 0) return error.InvalidNativeSource;

    var references: std.ArrayList(Reference) = .empty;
    var dynamic_resources = false;
    var c_imports = false;

    for (0..tree.nodes.len) |index| {
        const node: std.zig.Ast.Node.Index = @enumFromInt(index);
        var buffer: [2]std.zig.Ast.Node.Index = undefined;
        const parameters = tree.builtinCallParams(&buffer, node) orelse continue;
        const name = tree.tokenSlice(tree.nodeMainToken(node));

        if (std.mem.eql(u8, name, "@cImport")) c_imports = true;

        const is_import = std.mem.eql(u8, name, "@import");
        const is_resource = std.mem.eql(u8, name, "@embedFile");

        if (!is_import and !is_resource) continue;
        if (parameters.len != 1) return error.InvalidNativeSource;

        if (tree.nodeTag(parameters[0]) != .string_literal) {
            if (is_import) return error.InvalidNativeImport;

            dynamic_resources = true;

            continue;
        }

        const literal = tree.tokenSlice(tree.nodeMainToken(parameters[0]));
        const path = try std.zig.string_literal.parseAlloc(allocator, literal);

        if (is_import and !std.mem.endsWith(u8, path, ".zig")) {
            allocator.free(path);

            continue;
        }

        try references.append(allocator, .{ .path = path, .kind = if (is_import) .zig else .asset });
    }

    return .{ .references = references.items, .dynamic_resources = dynamic_resources, .c_imports = c_imports };
}
