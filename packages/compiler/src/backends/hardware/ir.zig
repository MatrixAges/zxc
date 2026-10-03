const zx = @import("zx");

pub const Origin = struct { file_name: []const u8, span: zx.Span };
pub const Id = enum(u32) { _ };

pub const Sort = struct {
    width: u16,
    boolean: bool = false,
    pub fn equal(self: Sort, other: Sort) bool {
        return self.width == other.width and self.boolean == other.boolean;
    }
};

pub const Operator = enum {
    logical_and,
    logical_or,
    equal,
    add,
    subtract,
    multiply,
    unsigned_divide,
    signed_divide,
    unsigned_remainder,
    signed_remainder,
    unsigned_less,
    unsigned_less_equal,
    unsigned_greater,
    unsigned_greater_equal,
    signed_less,
    signed_less_equal,
    signed_greater,
    signed_greater_equal,
};

pub const Node = struct {
    sort: Sort,
    origin: ?Origin = null,
    value: union(enum) {
        input: usize,
        constant: u64,
        invert: Id,
        negate: Id,
        binary: struct { operator: Operator, left: Id, right: Id },
        select: struct { condition: Id, yes: Id, no: Id },
        extend: struct { operand: Id, signed: bool, extra: u16 },
    },
};

pub const Port = struct { name: []const u8, path: []const u8, sort: Sort, signed: bool, node: Id };
pub const Module = struct { nodes: []const Node, inputs: []const Port, outputs: []const Port, safe: Id };
