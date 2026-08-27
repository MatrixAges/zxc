const diagnostic = @import("diagnostic.zig");

pub const Location = diagnostic.Location;

pub const TokenKind = enum {
    identifier,
    keyword,
    number,
    string,
    symbol,
    eof,
};

pub const Token = struct {
    kind: TokenKind,
    lexeme: []const u8,
    location: Location,
};

pub const TypeNode = union(enum) {
    named: NamedType,
    object: ObjectType,
    optional: *const TypeNode,
    list: *const TypeNode,
};

pub const NamedType = struct {
    name: []const u8,
    location: Location,
};

pub const ObjectType = struct {
    fields: []const TypeField,
    location: Location,
};

pub const TypeField = struct {
    name: []const u8,
    value_type: *const TypeNode,
    location: Location,
};

pub const TypeDeclaration = struct {
    name: []const u8,
    value_type: *const TypeNode,
    location: Location,
};

pub const EnumDeclaration = struct {
    name: []const u8,
    members: []const NamedValue,
    location: Location,
};

pub const NamedValue = struct {
    name: []const u8,
    location: Location,
};

pub const Declaration = union(enum) {
    type_decl: TypeDeclaration,
    enum_decl: EnumDeclaration,

    pub fn name(self: Declaration) []const u8 {
        return switch (self) {
            .type_decl => |value| value.name,
            .enum_decl => |value| value.name,
        };
    }

    pub fn location(self: Declaration) Location {
        return switch (self) {
            .type_decl => |value| value.location,
            .enum_decl => |value| value.location,
        };
    }
};

pub const Literal = struct {
    kind: LiteralKind,
    source: []const u8,
    location: Location,
};

pub const LiteralKind = enum {
    number,
    string,
    boolean,
    null,
};

pub const Expression = union(enum) {
    literal: Literal,
    identifier: NamedValue,
    member: MemberExpression,
    index: IndexExpression,
    unary: UnaryExpression,
    binary: BinaryExpression,
    ternary: TernaryExpression,
    object: ObjectExpression,
    list: ListExpression,
    call: CallExpression,

    pub fn location(self: Expression) Location {
        return switch (self) {
            .literal => |value| value.location,
            .identifier => |value| value.location,
            .member => |value| value.location,
            .index => |value| value.location,
            .unary => |value| value.location,
            .binary => |value| value.location,
            .ternary => |value| value.location,
            .object => |value| value.location,
            .list => |value| value.location,
            .call => |value| value.location,
        };
    }
};

pub const MemberExpression = struct {
    target: *const Expression,
    property: []const u8,
    location: Location,
};

pub const IndexExpression = struct {
    target: *const Expression,
    index: *const Expression,
    location: Location,
};

pub const UnaryExpression = struct {
    operator: []const u8,
    operand: *const Expression,
    location: Location,
};

pub const BinaryExpression = struct {
    operator: []const u8,
    left: *const Expression,
    right: *const Expression,
    location: Location,
};

pub const TernaryExpression = struct {
    condition: *const Expression,
    when_true: *const Expression,
    when_false: *const Expression,
    location: Location,
};

pub const ObjectExpression = struct {
    fields: []const ObjectField,
    location: Location,
};

pub const ObjectField = struct {
    name: []const u8,
    value: *const Expression,
    location: Location,
};

pub const ListExpression = struct {
    items: []const *const Expression,
    location: Location,
};

pub const CallExpression = struct {
    callee: *const Expression,
    arguments: []const *const Expression,
    location: Location,
};

pub const Statement = union(enum) {
    constant: ConstStatement,
    if_stmt: IfStatement,
    switch_stmt: SwitchStatement,
    return_stmt: ReturnStatement,

    pub fn location(self: Statement) Location {
        return switch (self) {
            .constant => |value| value.location,
            .if_stmt => |value| value.location,
            .switch_stmt => |value| value.location,
            .return_stmt => |value| value.location,
        };
    }
};

pub const ConstStatement = struct {
    name: []const u8,
    initializer: *const Expression,
    location: Location,
};

pub const IfStatement = struct {
    condition: *const Expression,
    then_body: []const Statement,
    else_body: ?[]const Statement,
    location: Location,
};

pub const SwitchStatement = struct {
    subject: *const Expression,
    cases: []const SwitchCase,
    location: Location,
};

pub const SwitchCase = struct {
    value: ?*const Expression,
    body: []const Statement,
    location: Location,
};

pub const ReturnStatement = struct {
    value: ?*const Expression,
    location: Location,
};

pub const FunctionDeclaration = struct {
    body: []const Statement,
    location: Location,
};

pub const Program = struct {
    declarations: []const Declaration,
    function_declaration: FunctionDeclaration,
};
