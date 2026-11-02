const std = @import("std");
const Self = @This();

allocator: std.mem.Allocator,
source: [:0]u8,
tree: std.zig.Ast,
entry: std.zig.Ast.Node.Index,
loop: ?std.zig.Ast.Node.Index,
pub fn parse(allocator: std.mem.Allocator, source: []const u8) !Self {
    const text = try allocator.dupeSentinel(u8, source, 0);

    errdefer allocator.free(text);

    var tree = try std.zig.Ast.parse(allocator, text, .{});

    errdefer tree.deinit(allocator);

    if (tree.errors.len != 0) return error.InvalidGeneratedSource;

    const entry = for (tree.rootDecls()) |declaration| {
        if (tree.nodeTag(declaration) != .fn_decl) continue;

        var buffer: [1]std.zig.Ast.Node.Index = undefined;
        const function = tree.fullFnProto(&buffer, declaration).?;

        if (function.name_token) |name| if (std.mem.eql(u8, tree.tokenSlice(name), "executeIn")) break tree.nodeData(declaration).node_and_node[1];
    } else return error.MissingExecute;

    var loop: ?std.zig.Ast.Node.Index = null;

    for (0..tree.nodes.len) |index| {
        const node: std.zig.Ast.Node.Index = @fromBackingInt(@intCast(index));

        if (tree.firstToken(node) < tree.firstToken(entry) or tree.lastToken(node) > tree.lastToken(entry)) continue;
        if (tree.fullWhile(node) == null) continue;
        if (loop == null or tree.firstToken(node) < tree.firstToken(loop.?)) loop = node;
    }

    return .{ .allocator = allocator, .source = text, .tree = tree, .entry = entry, .loop = loop };
}

pub fn deinit(self: *Self) void {
    self.tree.deinit(self.allocator);
    self.allocator.free(self.source);
}

pub fn entrySource(self: Self) []const u8 {
    return self.tree.getNodeSource(self.entry);
}

pub fn before(self: Self) []const u8 {
    const entry = self.entrySource();
    const loop = self.tree.getNodeSource(self.loop.?);

    return entry[0 .. @intFromPtr(loop.ptr) - @intFromPtr(entry.ptr)];
}

pub fn body(self: Self) []const u8 {
    return self.tree.getNodeSource(self.tree.fullWhile(self.loop.?).?.ast.then_expr);
}

pub fn after(self: Self) []const u8 {
    const entry = self.entrySource();
    const loop = self.tree.getNodeSource(self.loop.?);

    return entry[@intFromPtr(loop.ptr) - @intFromPtr(entry.ptr) + loop.len ..];
}

pub fn owners(self: Self) usize {
    return self.ownerCount(true);
}

pub fn totalOwners(self: Self) usize {
    return self.ownerCount(false);
}

fn ownerCount(self: Self, products: bool) usize {
    var count: usize = 0;

    for (0..self.tree.nodes.len) |index| {
        const node: std.zig.Ast.Node.Index = @fromBackingInt(@intCast(index));

        if (self.tree.firstToken(node) < self.tree.firstToken(self.entry) or self.tree.lastToken(node) > self.tree.lastToken(self.entry)) continue;

        const declaration = self.tree.fullVarDecl(node) orelse continue;

        if (self.tree.tokenTag(declaration.ast.mut_token) != .keyword_var) continue;

        if (declaration.ast.type_node.unwrap()) |type_node| {
            const text = self.tree.getNodeSource(type_node);

            if (std.mem.indexOf(u8, text, if (products) ".ArrayList(state_type_" else ".ArrayList(") != null) count += 1;
        }
    }

    return count;
}

pub fn projectedCalls(self: Self, field: []const u8, after_loop: bool) usize {
    const first = if (after_loop) self.tree.lastToken(self.loop.?) else self.tree.firstToken(self.entry);

    return self.projectedIn(field, first, self.tree.lastToken(self.entry));
}

pub fn projectedOnce(self: Self, field: []const u8) bool {
    const count = self.projectedCalls(field, false);

    if (count != self.projectedCalls(field, true)) return false;

    for (0..self.tree.nodes.len) |index| {
        const node: std.zig.Ast.Node.Index = @fromBackingInt(@intCast(index));

        if (self.tree.firstToken(node) < self.tree.firstToken(self.entry) or self.tree.lastToken(node) > self.tree.lastToken(self.entry)) continue;

        const branch = self.tree.fullIf(node) orelse continue;
        const other = branch.ast.else_expr.unwrap() orelse continue;
        const yes = branch.ast.then_expr;
        const loop_first = self.tree.firstToken(self.loop.?);
        const loop_last = self.tree.lastToken(self.loop.?);

        if (loop_first < self.tree.firstToken(yes) or loop_last > self.tree.lastToken(yes)) continue;

        return count == 2 and self.projectedIn(field, self.tree.firstToken(yes), self.tree.lastToken(yes)) == 1 and self.projectedIn(field, self.tree.firstToken(other), self.tree.lastToken(other)) == 1;
    }

    return count == 1;
}

fn projectedIn(self: Self, field: []const u8, first: std.zig.Ast.TokenIndex, last: std.zig.Ast.TokenIndex) usize {
    var count: usize = 0;

    for (0..self.tree.nodes.len) |index| {
        const node: std.zig.Ast.Node.Index = @fromBackingInt(@intCast(index));

        if (self.tree.firstToken(node) < first or self.tree.lastToken(node) > last) continue;

        var buffer: [1]std.zig.Ast.Node.Index = undefined;
        const call = self.tree.fullCall(&buffer, node) orelse continue;

        for (call.ast.params) |argument| {
            if (self.tree.nodeTag(argument) != .field_access) continue;
            if (!std.mem.eql(u8, self.tree.tokenSlice(self.tree.lastToken(argument)), field)) continue;

            var target = self.tree.nodeData(argument).node_and_token[0];

            while (self.tree.nodeTag(target) == .grouped_expression) target = self.tree.nodeData(target).node_and_token[0];
            if (self.tree.nodeTag(target) == .identifier and std.mem.eql(u8, self.tree.tokenSlice(self.tree.nodeMainToken(target)), "in")) count += 1;
        }
    }

    return count;
}
