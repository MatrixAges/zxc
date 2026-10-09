const std = @import("std");
const Ast = std.zig.Ast;

pub fn check(source: []const u8, mode: []const u8) !void {
    const allocator = std.heap.page_allocator;
    const text = try allocator.dupeSentinel(u8, source, 0);

    defer allocator.free(text);

    var tree = try Ast.parse(allocator, text, .{});

    defer tree.deinit(allocator);

    if (tree.errors.len != 0) return error.InvalidGeneratedZig;

    const function = entry(tree) orelse return error.MissingExecute;
    const first = tree.firstToken(function);
    const last = tree.lastToken(function);
    const transfers = std.mem.eql(u8, mode, "map") or std.mem.eql(u8, mode, "filter") or std.mem.eql(u8, mode, "local") or std.mem.eql(u8, mode, "nested") or std.mem.eql(u8, mode, "tuple");
    var copies: usize = 0;
    var transferred = false;

    for (1..tree.nodes.len) |index| {
        const node: Ast.Node.Index = @fromBackingInt(@intCast(index));

        if (tree.firstToken(node) < first or tree.lastToken(node) > last) continue;
        if (std.mem.eql(u8, tree.tokenSlice(tree.nodeMainToken(node)), "@constCast")) transferred = true;

        var buffer: [1]Ast.Node.Index = undefined;
        const call = tree.fullCall(&buffer, node) orelse continue;
        const target = unwrap(tree, call.ast.fn_expr);

        if (tree.nodeTag(target) != .field_access or call.ast.params.len != 2) continue;
        if (!std.mem.eql(u8, tree.tokenSlice(tree.nodeData(target).node_and_token[1]), "dupe")) continue;
        if (!emptyArray(tree, call.ast.params[1])) copies += 1;
    }

    if (transfers) {
        if (copies != 0) return error.UnexpectedOwnedInitialCopy;
        if (!transferred) return error.MissingOwnedInitialTransfer;
    } else if (copies == 0) return error.MissingSharedInitialCopy;
}

fn entry(tree: Ast) ?Ast.Node.Index {
    for (tree.rootDecls()) |node| {
        if (tree.nodeTag(node) != .fn_decl) continue;

        var buffer: [1]Ast.Node.Index = undefined;
        const function = tree.fullFnProto(&buffer, node) orelse continue;
        const name = function.name_token orelse continue;

        if (std.mem.eql(u8, tree.tokenSlice(name), "execute")) return node;
    }

    return null;
}

fn emptyArray(tree: Ast, source: Ast.Node.Index) bool {
    const address = unwrap(tree, source);

    if (tree.nodeTag(address) != .address_of) return false;

    const value = unwrap(tree, tree.nodeData(address).node);
    var buffer: [2]Ast.Node.Index = undefined;
    const initial = tree.fullStructInit(&buffer, value) orelse return false;

    if (initial.ast.fields.len != 0) return false;

    const type_node = initial.ast.type_expr.unwrap() orelse return false;
    const array = tree.fullArrayType(unwrap(tree, type_node)) orelse return false;
    const count = unwrap(tree, array.ast.elem_count);
    const token = tree.tokenSlice(tree.nodeMainToken(count));

    if (tree.nodeTag(count) == .identifier) return std.mem.eql(u8, token, "_");
    if (tree.nodeTag(count) != .number_literal) return false;

    return (std.fmt.parseInt(u64, token, 0) catch return false) == 0;
}

fn unwrap(tree: Ast, source: Ast.Node.Index) Ast.Node.Index {
    var node = source;

    while (tree.nodeTag(node) == .grouped_expression) node = tree.nodeData(node).node_and_token[0];

    return node;
}
