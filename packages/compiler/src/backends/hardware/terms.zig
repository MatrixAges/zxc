const std = @import("std");
const ir = @import("ir.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidHardwareTerm};

allocator: std.mem.Allocator,
nodes: std.ArrayList(ir.Node) = .empty,
variables: std.StringHashMapUnmanaged(ir.Id) = .empty,
cache: std.StringHashMapUnmanaged(ir.Id) = .empty,
text: []const u8 = "",
offset: usize = 0,
depth: usize = 0,
origin: ?ir.Origin = null,
pub fn add(self: *Self, node: ir.Node) Error!ir.Id {
    if (self.nodes.items.len >= 100000 or node.sort.width == 0 or node.sort.width > 256) return error.InvalidHardwareTerm;

    const id: ir.Id = @enumFromInt(self.nodes.items.len);
    var located = node;
    located.origin = self.origin;

    try self.nodes.append(self.allocator, located);

    return id;
}

pub fn parse(self: *Self, text: []const u8) Error!ir.Id {
    if (text.len > 64 * 1024 * 1024) return error.InvalidHardwareTerm;

    self.text = text;
    self.offset = 0;
    self.depth = 0;

    const id = try self.term();

    self.space();

    if (self.offset != text.len) return error.InvalidHardwareTerm;

    return id;
}

fn term(self: *Self) Error!ir.Id {
    self.space();

    if (self.depth >= 512) return error.InvalidHardwareTerm;

    self.depth += 1;
    defer self.depth -= 1;
    const start = self.offset;
    const item = try self.token();

    const node: ir.Node = if (std.mem.eql(u8, item, "(")) try self.application() else blk: {
        if (self.variables.get(item)) |id| return id;
        if (std.mem.eql(u8, item, "true")) break :blk .{ .sort = .{ .width = 1, .boolean = true }, .value = .{ .constant = 1 } };
        if (std.mem.eql(u8, item, "false")) break :blk .{ .sort = .{ .width = 1, .boolean = true }, .value = .{ .constant = 0 } };

        return error.InvalidHardwareTerm;
    };

    const key = self.text[start..self.offset];

    if (self.cache.get(key)) |id| return id;

    const id = try self.add(node);

    try self.cache.put(self.allocator, key, id);

    return id;
}

fn application(self: *Self) Error!ir.Node {
    const operator = try self.token();

    if (std.mem.eql(u8, operator, "_")) {
        const literal = try self.token();

        if (!std.mem.startsWith(u8, literal, "bv")) return error.InvalidHardwareTerm;

        const value = std.fmt.parseInt(u64, literal[2..], 10) catch return error.InvalidHardwareTerm;
        const width = try self.number();

        try self.expect(")");
        if (width < 64 and value >> @intCast(width) != 0) return error.InvalidHardwareTerm;

        return .{ .sort = .{ .width = width }, .value = .{ .constant = value } };
    }

    if (std.mem.eql(u8, operator, "(")) {
        try self.expect("_");

        const extension = try self.token();
        const signed = std.mem.eql(u8, extension, "sign_extend");

        if (!signed and !std.mem.eql(u8, extension, "zero_extend")) return error.InvalidHardwareTerm;

        const extra = try self.number();

        try self.expect(")");

        const operand = try self.term();
        const operand_sort = self.sort(operand);

        try self.expect(")");
        if (operand_sort.boolean or extra > 256 or operand_sort.width + extra > 256) return error.InvalidHardwareTerm;

        return .{ .sort = .{ .width = operand_sort.width + extra }, .value = .{ .extend = .{ .operand = operand, .signed = signed, .extra = extra } } };
    }

    const left = try self.term();
    const left_sort = self.sort(left);

    if (std.mem.eql(u8, operator, "not") or std.mem.eql(u8, operator, "bvneg")) {
        const invert = std.mem.eql(u8, operator, "not");

        try self.expect(")");

        if (left_sort.boolean != invert) return error.InvalidHardwareTerm;

        return .{ .sort = left_sort, .value = if (invert) .{ .invert = left } else .{ .negate = left } };
    }

    const right = try self.term();
    const right_sort = self.sort(right);

    if (std.mem.eql(u8, operator, "ite")) {
        const no = try self.term();

        try self.expect(")");
        if (!left_sort.boolean or !right_sort.equal(self.sort(no))) return error.InvalidHardwareTerm;

        return .{ .sort = right_sort, .value = .{ .select = .{ .condition = left, .yes = right, .no = no } } };
    }

    try self.expect(")");

    const operation = operators.get(operator) orelse return error.InvalidHardwareTerm;

    if (!left_sort.equal(right_sort)) return error.InvalidHardwareTerm;

    const logical = operation == .logical_and or operation == .logical_or;
    const equality = operation == .equal;
    const comparison = @intFromEnum(operation) >= @intFromEnum(ir.Operator.unsigned_less);

    if (!equality and left_sort.boolean != logical) return error.InvalidHardwareTerm;

    return .{ .sort = if (logical or equality or comparison) .{ .width = 1, .boolean = true } else left_sort, .value = .{ .binary = .{ .operator = operation, .left = left, .right = right } } };
}

fn sort(self: *Self, id: ir.Id) ir.Sort {
    return self.nodes.items[@intFromEnum(id)].sort;
}

fn number(self: *Self) Error!u16 {
    return std.fmt.parseInt(u16, try self.token(), 10) catch error.InvalidHardwareTerm;
}

fn expect(self: *Self, value: []const u8) Error!void {
    if (!std.mem.eql(u8, try self.token(), value)) return error.InvalidHardwareTerm;
}

fn token(self: *Self) Error![]const u8 {
    self.space();

    const start = self.offset;

    if (start == self.text.len) return error.InvalidHardwareTerm;

    if (self.text[start] == '(' or self.text[start] == ')') {
        self.offset += 1;
    } else while (self.offset < self.text.len and !std.ascii.isWhitespace(self.text[self.offset]) and self.text[self.offset] != '(' and self.text[self.offset] != ')') : (self.offset += 1) {}

    return self.text[start..self.offset];
}

fn space(self: *Self) void {
    while (self.offset < self.text.len and std.ascii.isWhitespace(self.text[self.offset])) : (self.offset += 1) {}
}

const operators = std.StaticStringMap(ir.Operator).initComptime(.{
    .{ "and", .logical_and },         .{ "or", .logical_or },                .{ "=", .equal },
    .{ "bvadd", .add },               .{ "bvsub", .subtract },               .{ "bvmul", .multiply },
    .{ "bvudiv", .unsigned_divide },  .{ "bvsdiv", .signed_divide },         .{ "bvurem", .unsigned_remainder },
    .{ "bvsrem", .signed_remainder }, .{ "bvult", .unsigned_less },          .{ "bvule", .unsigned_less_equal },
    .{ "bvugt", .unsigned_greater },  .{ "bvuge", .unsigned_greater_equal }, .{ "bvslt", .signed_less },
    .{ "bvsle", .signed_less_equal }, .{ "bvsgt", .signed_greater },         .{ "bvsge", .signed_greater_equal },
});
