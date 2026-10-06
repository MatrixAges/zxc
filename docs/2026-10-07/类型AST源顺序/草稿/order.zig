const std = @import("std");

const zx_type_11 = enum {
    Root,
    Dead,
    UpperI,
    UpperIn,
    UpperInp,
    UpperInpu,
    UpperInput,
    UpperO,
    UpperOu,
    UpperOut,
    UpperOutp,
    UpperOutpu,
    UpperOutput,
    Underscore,
    A,
    Al,
    All,
    Allo,
    Alloc,
    Alloca,
    Allocat,
    Allocato,
    Allocator,
    As,
    Asy,
    Asyn,
    Async,
    Aw,
    Awa,
    Awai,
    Await,
    B,
    Br,
    Bre,
    Brea,
    Break,
    C,
    Ca,
    Can,
    Canc,
    Cance,
    Cancel,
    Cas,
    Case,
    Co,
    Con,
    Conc,
    Concu,
    Concur,
    Concurr,
    Concurre,
    Concurren,
    Concurrent,
    Cons,
    Const,
    D,
    De,
    Dec,
    Decl,
    Decla,
    Declar,
    Declare,
    Def,
    Defa,
    Defau,
    Defaul,
    Default,
    Del,
    Dele,
    Delet,
    Delete,
    Do,
    E,
    El,
    Els,
    Else,
    En,
    Ens,
    Ensu,
    Ensur,
    Ensure,
    Ensures,
    Enu,
    Enum,
    Ex,
    Exp,
    Expo,
    Expor,
    Export,
    F,
    Fa,
    Fal,
    Fals,
    False,
    Fo,
    For,
    Fr,
    Fro,
    From,
    Fu,
    Fun,
    Func,
    Funct,
    Functi,
    Functio,
    Function,
    I,
    If,
    Im,
    Imp,
    Impo,
    Impor,
    Import,
    In,
    Ins,
    Inse,
    Inser,
    Insert,
    Io,
    L,
    Le,
    Let,
    Lo,
    Loo,
    Loop,
    M,
    Ma,
    Mat,
    Matc,
    Match,
    N,
    Ne,
    New,
    Nex,
    Next,
    Nu,
    Nul,
    Null,
    O,
    Ow,
    Own,
    Owne,
    Owned,
    P,
    Pr,
    Pro,
    Proc,
    Proce,
    Proces,
    Process,
    Q,
    Qu,
    Que,
    Quer,
    Query,
    QueryM,
    QueryMa,
    QueryMan,
    QueryMany,
    QueryO,
    QueryOn,
    QueryOne,
    R,
    Re,
    Req,
    Requ,
    Requi,
    Requir,
    Require,
    Requires,
    Ret,
    Retu,
    Retur,
    Return,
    S,
    St,
    Sto,
    Stor,
    Store,
    Sw,
    Swi,
    Swit,
    Switc,
    Switch,
    T,
    Th,
    Thr,
    Thro,
    Throw,
    Throws,
    Tr,
    Tra,
    Tran,
    Trans,
    Transa,
    Transac,
    Transact,
    Transacti,
    Transactio,
    Transaction,
    Tru,
    True,
    Try,
    Ty,
    Typ,
    Type,
    U,
    Up,
    Upd,
    Upda,
    Updat,
    Update,
    V,
    Va,
    Var,
    W,
    Wh,
    Whi,
    Whil,
    While,
};

const zx_type_12 = enum {
    Identifier,
    Keyword,
    Number,
    String,
    Template,
    Punctuation,
    Eof,
};

const zx_type_13 = enum {
    None,
    OpenBrace,
    CloseBrace,
    OpenParen,
    CloseParen,
    OpenBracket,
    CloseBracket,
    Colon,
    Semicolon,
    Comma,
    Dot,
    Question,
    Plus,
    Minus,
    Star,
    Slash,
    Percent,
    Less,
    Greater,
    Assign,
    Not,
    Ampersand,
    Pipe,
    Arrow,
    Equal,
    NotEqual,
    LessEqual,
    GreaterEqual,
    Coalesce,
    And,
    Or,
    Spread,
};

const zx_type_14 = struct {
    end: u64,
    start: u64,
};

const zx_type_15 = struct {
    dollar: bool,
    kind: zx_type_12,
    line_break: bool,
    span: *const zx_type_14,
    symbol: zx_type_13,
    word: zx_type_11,
};

const zx_type_16 = enum {
    Integer,
    FractionStart,
    Fraction,
    ExponentStart,
    ExponentDigits,
    Done,
};

const zx_type_17 = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_16,
    separators_valid: bool,
};

const zx_type_18 = struct {
    diagnostic: []const u8,
    end: u64,
};

const zx_type_19 = enum {
    Idle,
    Identifier,
    Number,
    String,
    StringEscape,
    LineComment,
    BlockComment,
    Template,
    TemplateEscape,
    Interpolation,
    InterpolationString,
    InterpolationStringEscape,
    InterpolationLineComment,
    InterpolationBlockComment,
};

const zx_type_20 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
};

const zx_type_21 = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_19,
    start: u64,
};

const zx_type_25 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_14,
    depth: u64,
    diagnostic: *const zx_type_20,
    dollar: bool,
    frames: []const *const zx_type_21,
    keyword: zx_type_11,
    line_break: bool,
    mode: zx_type_19,
    number: *const zx_type_17,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_13,
    tokens: []const *const zx_type_15,
    warmed: u8,
};

const zx_type_26 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_25,
};

const zx_type_27 = struct {
    comments: []const *const zx_type_14,
    diagnostic: *const zx_type_20,
    tokens: []const *const zx_type_15,
};

const zx_type_28 = enum {
    Named,
    Object,
    Optional,
    List,
    Tuple,
    Application,
};

const zx_type_29 = enum {
    Start,
    Name,
    Suffix,
    ListEnd,
    Field,
    FieldOptional,
    FieldColon,
    TupleItem,
    Done,
};

const zx_type_30 = struct {
    child: u64,
    count: u64,
    head: u64,
    kind: zx_type_28,
    name: *const zx_type_14,
};

const zx_type_31 = struct {
    name: *const zx_type_14,
    previous: u64,
    value: u64,
};

const zx_type_32 = struct {
    previous: u64,
    value: u64,
};

const zx_type_34 = struct {
    fields: []const u64,
    heads: []const u64,
    items: []const u64,
};

const zx_type_38 = struct {
    fields: []const *const zx_type_31,
    items: []const *const zx_type_32,
    nodes: []const *const zx_type_30,
};

const zx_type_39 = struct {
    count: u64,
    field: *const zx_type_14,
    head: u64,
    kind: zx_type_28,
    name: *const zx_type_14,
    optional: bool,
};

const zx_type_40 = struct {
    depth: u64,
    diagnostic: *const zx_type_20,
    index: u64,
    name: *const zx_type_14,
    phase: zx_type_29,
    result: u64,
    start: u64,
    token: *const zx_type_15,
};

const zx_type_42 = struct {
    control: *const zx_type_40,
    frames: []const *const zx_type_39,
    tree: *const zx_type_38,
};

const zx_type_43 = struct {
    node: *const zx_type_30,
    tree: *const zx_type_38,
};

const zx_type_44 = struct {
    current: u64,
    first: u64,
    kind: zx_type_28,
    remaining: u64,
    tree: *const zx_type_38,
};

const zx_type_45 = struct {
    index: u64,
    links: []const u64,
    source: []const *const zx_type_31,
};

const zx_type_46 = struct {
    []const u64,
    void,
};

const zx_type_47 = struct {
    index: u64,
    links: []const u64,
    source: []const *const zx_type_32,
};

const zx_type_48 = struct {
    index: u64,
    links: []const u64,
    tree: *const zx_type_38,
};

const value_zx_type_17_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_16,
    separators_valid: bool,
    zx_origin: ?*const zx_type_17 = null,
};

const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    diagnostic: []const u8,
    end: u64,
    zx_origin: ?*const zx_type_18 = null,
};

const value_zx_type_20_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_20 = null,
};

const value_zx_type_25_365095b2e4102717a2ad1cafad625c26abf7b31bf03c46b384a7c46916802955 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_14,
    depth: u64,
    diagnostic: value_zx_type_20_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    dollar: bool,
    frames: []const *const zx_type_21,
    keyword: zx_type_11,
    line_break: bool,
    mode: zx_type_19,
    number: value_zx_type_17_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_13,
    tokens: []const *const zx_type_15,
    warmed: u8,
    zx_origin: ?*const zx_type_25 = null,
};

const value_zx_type_26_6864d01f2cdb65ac396bbf72151d3cc46cc2d575ab41fc4f09cde10c9e6a568c = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_zx_type_25_365095b2e4102717a2ad1cafad625c26abf7b31bf03c46b384a7c46916802955,
    zx_origin: ?*const zx_type_26 = null,
};

const value_zx_type_27_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = struct {
    comments: []const *const zx_type_14,
    diagnostic: value_zx_type_20_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    tokens: []const *const zx_type_15,
    zx_origin: ?*const zx_type_27 = null,
};

const value_zx_type_34_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    fields: []const u64,
    heads: []const u64,
    items: []const u64,
    zx_origin: ?*const zx_type_34 = null,
};

const value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    fields: []const *const zx_type_31,
    items: []const *const zx_type_32,
    nodes: []const *const zx_type_30,
    zx_origin: ?*const zx_type_38 = null,
};

const value_zx_type_40_4b4ea4009453ea5e4d3d79e2158cdc223b3d2c1404741f1be6d92e28595818e4 = struct {
    depth: u64,
    diagnostic: value_zx_type_20_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    index: u64,
    name: *const zx_type_14,
    phase: zx_type_29,
    result: u64,
    start: u64,
    token: *const zx_type_15,
    zx_origin: ?*const zx_type_40 = null,
};

const value_zx_type_42_db7570c1a55b3d0290113419e01ef4c6880014f077ed48f5b1ab9774bac9d7ce = struct {
    control: value_zx_type_40_4b4ea4009453ea5e4d3d79e2158cdc223b3d2c1404741f1be6d92e28595818e4,
    frames: []const *const zx_type_39,
    tree: value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_42 = null,
};

const value_zx_type_43_cdc1f61d62011c24c95af10831445b895443795508d45a3efbae896fbe93578d = struct {
    node: *const zx_type_30,
    tree: value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_43 = null,
};

const value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = struct {
    current: u64,
    first: u64,
    kind: zx_type_28,
    remaining: u64,
    tree: value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_44 = null,
};

const value_zx_type_45_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    links: []const u64,
    source: []const *const zx_type_31,
    zx_origin: ?*const zx_type_45 = null,
};

const value_zx_type_46_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const u64,
    void,
    ?*const zx_type_46,
};

const value_zx_type_47_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    links: []const u64,
    source: []const *const zx_type_32,
    zx_origin: ?*const zx_type_47 = null,
};

const value_zx_type_48_5c55ea113028a923cd7b60993d0cbd0ca61f6c42ff9efed54c09fd78195978c4 = struct {
    index: u64,
    links: []const u64,
    tree: value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_48 = null,
};

pub const Input = *const zx_type_38;
pub const Output = *const zx_type_34;
pub const requires_io = false;
pub const requires_process = false;

const zx_shape_0 = .{
    .kind = .scalar,
};

const zx_shape_1 = .{
    .kind = .scalar,
};

const zx_shape_2 = .{
    .kind = .scalar,
};

const zx_shape_3 = .{
    .kind = .scalar,
};

const zx_shape_4 = .{
    .kind = .scalar,
};

const zx_shape_5 = .{
    .kind = .scalar,
};

const zx_shape_6 = .{
    .kind = .scalar,
};

const zx_shape_7 = .{
    .kind = .scalar,
};

const zx_shape_8 = .{
    .kind = .scalar,
};

const zx_shape_9 = .{
    .kind = .scalar,
};

const zx_shape_10 = .{
    .kind = .string,
};

const zx_shape_11 = .{
    .kind = .scalar,
};

const zx_shape_12 = .{
    .kind = .scalar,
};

const zx_shape_13 = .{
    .kind = .scalar,
};

const zx_shape_14 = .{
    .kind = .object,
    .fields = .{
        .end = zx_shape_5,
        .start = zx_shape_5,
    },
};

const zx_shape_15 = .{
    .kind = .object,
    .fields = .{
        .dollar = zx_shape_1,
        .kind = zx_shape_12,
        .line_break = zx_shape_1,
        .span = zx_shape_14,
        .symbol = zx_shape_13,
        .word = zx_shape_11,
    },
};

const zx_shape_16 = .{
    .kind = .scalar,
};

const zx_shape_17 = .{
    .kind = .object,
    .fields = .{
        .end = zx_shape_5,
        .last_byte = zx_shape_2,
        .phase = zx_shape_16,
        .separators_valid = zx_shape_1,
    },
};

const zx_shape_18 = .{
    .kind = .object,
    .fields = .{
        .diagnostic = zx_shape_10,
        .end = zx_shape_5,
    },
};

const zx_shape_19 = .{
    .kind = .scalar,
};

const zx_shape_20 = .{
    .kind = .object,
    .fields = .{
        .code = zx_shape_10,
        .end = zx_shape_5,
        .message = zx_shape_10,
        .start = zx_shape_5,
    },
};

const zx_shape_21 = .{
    .kind = .object,
    .fields = .{
        .braces = zx_shape_5,
        .depth = zx_shape_5,
        .mode = zx_shape_19,
        .start = zx_shape_5,
    },
};

const zx_shape_22 = .{
    .kind = .list,
    .child = zx_shape_21,
};

const zx_shape_23 = .{
    .kind = .list,
    .child = zx_shape_15,
};

const zx_shape_24 = .{
    .kind = .list,
    .child = zx_shape_14,
};

const zx_shape_25 = .{
    .kind = .object,
    .fields = .{
        .ahead_one = zx_shape_2,
        .ahead_two = zx_shape_2,
        .braces = zx_shape_5,
        .comments = zx_shape_24,
        .depth = zx_shape_5,
        .diagnostic = zx_shape_20,
        .dollar = zx_shape_1,
        .frames = zx_shape_22,
        .keyword = zx_shape_11,
        .line_break = zx_shape_1,
        .mode = zx_shape_19,
        .number = zx_shape_17,
        .offset = zx_shape_5,
        .skip_until = zx_shape_5,
        .source_length = zx_shape_5,
        .start = zx_shape_5,
        .symbol = zx_shape_13,
        .tokens = zx_shape_23,
        .warmed = zx_shape_2,
    },
};

const zx_shape_26 = .{
    .kind = .object,
    .fields = .{
        .after = zx_shape_2,
        .byte = zx_shape_2,
        .has_after = zx_shape_1,
        .has_next = zx_shape_1,
        .next = zx_shape_2,
        .state = zx_shape_25,
    },
};

const zx_shape_27 = .{
    .kind = .object,
    .fields = .{
        .comments = zx_shape_24,
        .diagnostic = zx_shape_20,
        .tokens = zx_shape_23,
    },
};

const zx_shape_28 = .{
    .kind = .scalar,
};

const zx_shape_29 = .{
    .kind = .scalar,
};

const zx_shape_30 = .{
    .kind = .object,
    .fields = .{
        .child = zx_shape_5,
        .count = zx_shape_5,
        .head = zx_shape_5,
        .kind = zx_shape_28,
        .name = zx_shape_14,
    },
};

const zx_shape_31 = .{
    .kind = .object,
    .fields = .{
        .name = zx_shape_14,
        .previous = zx_shape_5,
        .value = zx_shape_5,
    },
};

const zx_shape_32 = .{
    .kind = .object,
    .fields = .{
        .previous = zx_shape_5,
        .value = zx_shape_5,
    },
};

const zx_shape_33 = .{
    .kind = .list,
    .child = zx_shape_5,
};

const zx_shape_34 = .{
    .kind = .object,
    .fields = .{
        .fields = zx_shape_33,
        .heads = zx_shape_33,
        .items = zx_shape_33,
    },
};

const zx_shape_35 = .{
    .kind = .list,
    .child = zx_shape_30,
};

const zx_shape_36 = .{
    .kind = .list,
    .child = zx_shape_31,
};

const zx_shape_37 = .{
    .kind = .list,
    .child = zx_shape_32,
};

const zx_shape_38 = .{
    .kind = .object,
    .fields = .{
        .fields = zx_shape_36,
        .items = zx_shape_37,
        .nodes = zx_shape_35,
    },
};

const zx_shape_39 = .{
    .kind = .object,
    .fields = .{
        .count = zx_shape_5,
        .field = zx_shape_14,
        .head = zx_shape_5,
        .kind = zx_shape_28,
        .name = zx_shape_14,
        .optional = zx_shape_1,
    },
};

const zx_shape_40 = .{
    .kind = .object,
    .fields = .{
        .depth = zx_shape_5,
        .diagnostic = zx_shape_20,
        .index = zx_shape_5,
        .name = zx_shape_14,
        .phase = zx_shape_29,
        .result = zx_shape_5,
        .start = zx_shape_5,
        .token = zx_shape_15,
    },
};

const zx_shape_41 = .{
    .kind = .list,
    .child = zx_shape_39,
};

const zx_shape_42 = .{
    .kind = .object,
    .fields = .{
        .control = zx_shape_40,
        .frames = zx_shape_41,
        .tree = zx_shape_38,
    },
};

const zx_shape_43 = .{
    .kind = .object,
    .fields = .{
        .node = zx_shape_30,
        .tree = zx_shape_38,
    },
};

const zx_shape_44 = .{
    .kind = .object,
    .fields = .{
        .current = zx_shape_5,
        .first = zx_shape_5,
        .kind = zx_shape_28,
        .remaining = zx_shape_5,
        .tree = zx_shape_38,
    },
};

const zx_shape_45 = .{
    .kind = .object,
    .fields = .{
        .index = zx_shape_5,
        .links = zx_shape_33,
        .source = zx_shape_36,
    },
};

const zx_shape_46 = .{
    .kind = .object,
    .fields = .{
        .@"0" = zx_shape_33,
        .@"1" = zx_shape_0,
    },
};

const zx_shape_47 = .{
    .kind = .object,
    .fields = .{
        .index = zx_shape_5,
        .links = zx_shape_33,
        .source = zx_shape_37,
    },
};

const zx_shape_48 = .{
    .kind = .object,
    .fields = .{
        .index = zx_shape_5,
        .links = zx_shape_33,
        .tree = zx_shape_38,
    },
};

pub const input_shape = zx_shape_38;
pub const output_shape = zx_shape_34;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_43) error{
    IndexOutOfBounds,
    OutOfMemory,
}!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    if (((((in).node).kind != @as(zx_type_28, .Object)) and (((in).node).kind != @as(zx_type_28, .Tuple)))) {
        return @as(u64, 0);
    }

    return block_23: {
        const operand_8 = block_7: {
            const operand_2 = (in).tree;
            const operand_3 = ((in).node).kind;
            const operand_4 = ((in).node).head;
            const operand_5 = @as(u64, 0);
            const operand_6 = ((in).node).count;

            break :block_7 zx_type_44{
                .tree = operand_2,
                .kind = operand_3,
                .current = operand_4,
                .first = operand_5,
                .remaining = operand_6,
            };
        };

        var state_1: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c{
            .current = (operand_8).current,
            .first = (operand_8).first,
            .kind = (operand_8).kind,
            .remaining = (operand_8).remaining,
            .tree = value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{
                .fields = ((operand_8).tree).fields,
                .items = ((operand_8).tree).items,
                .nodes = ((operand_8).tree).nodes,
                .zx_origin = (operand_8).tree,
            },
            .zx_origin = (&operand_8),
        };

        while (((state_1).remaining != @as(u64, 0))) {
            state_1 = block_22: {
                const value_3: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = state_1;
                _ = (value_3).first;

                const value_5: u64 = (state_1).current;

                const value_6: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = block_21: {
                    break :block_21 @as(value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c, value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c{
                        .current = (value_3).current,
                        .first = block_20: {
                            break :block_20 value_5;
                        },
                        .kind = (value_3).kind,
                        .remaining = (value_3).remaining,
                        .tree = (value_3).tree,
                    });
                };
                const value_7: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = value_6;

                _ = (value_7).current;

                const value_9: u64 = (if (((value_6).kind == @as(zx_type_28, .Object))) (block_16: {
                    const operand_14 = ((value_6).tree).fields;
                    const operand_15 = ((value_6).current - @as(u64, 1));

                    if ((operand_15 >= (operand_14).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_16 (operand_14)[@intCast(operand_15)];
                }).previous else (block_19: {
                    const operand_17 = ((value_6).tree).items;
                    const operand_18 = ((value_6).current - @as(u64, 1));

                    if ((operand_18 >= (operand_17).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_19 (operand_17)[@intCast(operand_18)];
                }).previous);

                const value_10: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = block_13: {
                    break :block_13 @as(value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c, value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c{
                        .current = block_12: {
                            break :block_12 value_9;
                        },
                        .first = (value_7).first,
                        .kind = (value_7).kind,
                        .remaining = (value_7).remaining,
                        .tree = (value_7).tree,
                    });
                };
                const value_11: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = value_10;
                const value_12: u64 = (value_11).remaining;
                const value_13: u64 = @as(u64, 1);

                const value_14: value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c = block_11: {
                    break :block_11 @as(value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c, value_zx_type_44_22a2bfa3a7f9491c1c7b3b6dbd7385b9f318100fe0c6920976b06086f68dba3c{
                        .current = (value_11).current,
                        .first = (value_11).first,
                        .kind = (value_11).kind,
                        .remaining = (block_9: {
                            break :block_9 value_12;
                        } - block_10: {
                            break :block_10 value_13;
                        }),
                        .tree = (value_11).tree,
                    });
                };

                break :block_22 value_14;
            };
        }

        break :block_23 (state_1).first;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_38) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const zx_type_34 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u64 = block_133: {
        break :block_133 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_2: []const u64 = block_132: {
        break :block_132 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_21: *const zx_type_45 = block_131: {
        const operand_99 = block_98: {
            const operand_93 = (in).fields;
            const operand_94 = value_1;
            const operand_95 = @as(u64, 0);

            break :block_98 block_97: {
                const operand_96 = (try (allocator).create(zx_type_45));

                (operand_96).* = @as(zx_type_45, zx_type_45{
                    .source = operand_93,
                    .links = operand_94,
                    .index = operand_95,
                });

                break :block_97 @as(*const zx_type_45, operand_96);
            };
        };

        var state_capacity_101: (std).ArrayList(u64) = .empty;
        var state_capacity_started_102 = false;

        defer (state_capacity_101).deinit(allocator);

        const state_type_103 = struct {
            index: u64,
            links: []const u64,
            source: []const *const zx_type_31,
        };

        const state_type_118 = struct {
            end: u64,
            start: u64,
        };
        const state_type_119 = struct {
            name: state_type_118,
            previous: u64,
            value: u64,
        };
        const state_type_122 = struct {
            []const u64,
            void,
        };
        var state_92: state_type_103 = state_type_103{
            .index = (operand_99).index,
            .links = (operand_99).links,
            .source = (operand_99).source,
        };

        var state_changed_100 = false;

        while (((state_92).index < @as(u64, ((state_92).source).len))) {
            state_92 = block_126: {
                const value_5: state_type_103 = state_92;
                _ = (value_5).links;

                const value_7: []const u64 = (block_125: {
                    const operand_123 = (state_92).links;
                    const operand_124 = @as(u64, 0);

                    _ = (try ((std).math).add(usize, (operand_123).len, 1));

                    if ((!state_capacity_started_102)) {
                        (try (state_capacity_101).appendSlice(allocator, operand_123));

                        state_capacity_started_102 = true;
                    } else {
                        ((state_capacity_101).items).len = (operand_123).len;
                    }

                    (try (state_capacity_101).append(allocator, operand_124));

                    break :block_125 @as(state_type_122, .{
                        (state_capacity_101).items,
                        {},
                    });
                }).@"0";
                const value_8: state_type_103 = block_121: {
                    break :block_121 state_type_103{
                        .index = (value_5).index,
                        .links = value_7,
                        .source = (value_5).source,
                    };
                };
                const value_9: u64 = (block_120: {
                    const operand_117 = block_116: {
                        const operand_114 = (value_8).source;
                        const operand_115 = (value_8).index;

                        if ((operand_115 >= (operand_114).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_116 (operand_114)[@intCast(operand_115)];
                    };

                    break :block_120 state_type_119{
                        .name = state_type_118{
                            .end = ((operand_117).name).end,
                            .start = ((operand_117).name).start,
                        },
                        .previous = (operand_117).previous,
                        .value = (operand_117).value,
                    };
                }).previous;

                const value_16: state_type_103 = (if ((value_9 != @as(u64, 0))) block_113: {
                    const value_10: state_type_103 = value_8;
                    const value_11: []const u64 = (value_10).links;
                    const value_12: u64 = (value_9 - @as(u64, 1));

                    _ = block_112: {
                        const operand_110 = value_11;
                        const operand_111 = value_12;

                        if ((operand_111 >= (operand_110).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_112 (operand_110)[@intCast(operand_111)];
                    };

                    const value_14: u64 = ((value_8).index + @as(u64, 1));

                    const value_15: state_type_103 = block_109: {
                        break :block_109 state_type_103{
                            .index = (value_10).index,
                            .links = block_108: {
                                const operand_105 = value_11;
                                const operand_106 = value_12;
                                const operand_107 = value_14;

                                if ((operand_106 >= (operand_105).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_capacity_started_102)) {
                                    (try (state_capacity_101).appendSlice(allocator, operand_105));

                                    state_capacity_started_102 = true;
                                } else {
                                    ((state_capacity_101).items).len = (operand_105).len;
                                }

                                ((state_capacity_101).items)[@intCast(operand_106)] = operand_107;

                                break :block_108 (state_capacity_101).items;
                            },
                            .source = (value_10).source,
                        };
                    };

                    break :block_113 value_15;
                } else value_8);

                const value_17: state_type_103 = value_16;
                const value_18: u64 = (value_17).index;
                const value_19: u64 = @as(u64, 1);
                const value_20: state_type_103 = block_104: {
                    break :block_104 state_type_103{
                        .index = (value_18 + value_19),
                        .links = (value_17).links,
                        .source = (value_17).source,
                    };
                };

                break :block_126 value_20;
            };

            state_changed_100 = true;
        }

        var state_owned_127: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_127);

        if (state_capacity_started_102) {
            ((state_capacity_101).items).len = ((state_92).links).len;
            state_owned_127 = (try (state_capacity_101).toOwnedSlice(allocator));
        }

        if (state_capacity_started_102) {
            (state_92).links = state_owned_127;
        }

        break :block_131 (if (state_changed_100) block_130: {
            const operand_129 = (try (allocator).create(zx_type_45));

            (operand_129).* = @as(zx_type_45, zx_type_45{
                .index = (state_92).index,
                .links = (state_92).links,
                .source = (state_92).source,
            });

            break :block_130 @as(*const zx_type_45, operand_129);
        } else operand_99);
    };

    const value_40: *const zx_type_47 = block_91: {
        const operand_60 = block_59: {
            const operand_54 = (in).items;
            const operand_55 = value_2;
            const operand_56 = @as(u64, 0);

            break :block_59 block_58: {
                const operand_57 = (try (allocator).create(zx_type_47));

                (operand_57).* = @as(zx_type_47, zx_type_47{
                    .source = operand_54,
                    .links = operand_55,
                    .index = operand_56,
                });

                break :block_58 @as(*const zx_type_47, operand_57);
            };
        };

        var state_capacity_62: (std).ArrayList(u64) = .empty;
        var state_capacity_started_63 = false;

        defer (state_capacity_62).deinit(allocator);

        const state_type_64 = struct {
            index: u64,
            links: []const u64,
            source: []const *const zx_type_32,
        };

        const state_type_79 = struct {
            previous: u64,
            value: u64,
        };
        const state_type_82 = struct {
            []const u64,
            void,
        };
        var state_53: state_type_64 = state_type_64{
            .index = (operand_60).index,
            .links = (operand_60).links,
            .source = (operand_60).source,
        };

        var state_changed_61 = false;

        while (((state_53).index < @as(u64, ((state_53).source).len))) {
            state_53 = block_86: {
                const value_24: state_type_64 = state_53;

                _ = (value_24).links;

                const value_26: []const u64 = (block_85: {
                    const operand_83 = (state_53).links;
                    const operand_84 = @as(u64, 0);

                    _ = (try ((std).math).add(usize, (operand_83).len, 1));

                    if ((!state_capacity_started_63)) {
                        (try (state_capacity_62).appendSlice(allocator, operand_83));

                        state_capacity_started_63 = true;
                    } else {
                        ((state_capacity_62).items).len = (operand_83).len;
                    }

                    (try (state_capacity_62).append(allocator, operand_84));

                    break :block_85 @as(state_type_82, .{
                        (state_capacity_62).items,
                        {},
                    });
                }).@"0";
                const value_27: state_type_64 = block_81: {
                    break :block_81 state_type_64{
                        .index = (value_24).index,
                        .links = value_26,
                        .source = (value_24).source,
                    };
                };
                const value_28: u64 = (block_80: {
                    const operand_78 = block_77: {
                        const operand_75 = (value_27).source;
                        const operand_76 = (value_27).index;

                        if ((operand_76 >= (operand_75).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_77 (operand_75)[@intCast(operand_76)];
                    };

                    break :block_80 state_type_79{
                        .previous = (operand_78).previous,
                        .value = (operand_78).value,
                    };
                }).previous;

                const value_35: state_type_64 = (if ((value_28 != @as(u64, 0))) block_74: {
                    const value_29: state_type_64 = value_27;
                    const value_30: []const u64 = (value_29).links;
                    const value_31: u64 = (value_28 - @as(u64, 1));

                    _ = block_73: {
                        const operand_71 = value_30;
                        const operand_72 = value_31;

                        if ((operand_72 >= (operand_71).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_73 (operand_71)[@intCast(operand_72)];
                    };

                    const value_33: u64 = ((value_27).index + @as(u64, 1));

                    const value_34: state_type_64 = block_70: {
                        break :block_70 state_type_64{
                            .index = (value_29).index,
                            .links = block_69: {
                                const operand_66 = value_30;
                                const operand_67 = value_31;
                                const operand_68 = value_33;

                                if ((operand_67 >= (operand_66).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_capacity_started_63)) {
                                    (try (state_capacity_62).appendSlice(allocator, operand_66));

                                    state_capacity_started_63 = true;
                                } else {
                                    ((state_capacity_62).items).len = (operand_66).len;
                                }

                                ((state_capacity_62).items)[@intCast(operand_67)] = operand_68;
                                break :block_69 (state_capacity_62).items;
                            },
                            .source = (value_29).source,
                        };
                    };

                    break :block_74 value_34;
                } else value_27);

                const value_36: state_type_64 = value_35;
                const value_37: u64 = (value_36).index;
                const value_38: u64 = @as(u64, 1);

                const value_39: state_type_64 = block_65: {
                    break :block_65 state_type_64{
                        .index = (value_37 + value_38),
                        .links = (value_36).links,
                        .source = (value_36).source,
                    };
                };

                break :block_86 value_39;
            };

            state_changed_61 = true;
        }

        var state_owned_87: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_87);

        if (state_capacity_started_63) {
            ((state_capacity_62).items).len = ((state_53).links).len;
            state_owned_87 = (try (state_capacity_62).toOwnedSlice(allocator));
        }

        if (state_capacity_started_63) {
            (state_53).links = state_owned_87;
        }

        break :block_91 (if (state_changed_61) block_90: {
            const operand_89 = (try (allocator).create(zx_type_47));

            (operand_89).* = @as(zx_type_47, zx_type_47{
                .index = (state_53).index,
                .links = (state_53).links,
                .source = (state_53).source,
            });

            break :block_90 @as(*const zx_type_47, operand_89);
        } else operand_60);
    };

    const value_41: []const u64 = block_52: {
        break :block_52 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_52: *const zx_type_48 = block_51: {
        const operand_14 = block_13: {
            const operand_8 = in;
            const operand_9 = value_41;
            const operand_10 = @as(u64, 0);

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create(zx_type_48));

                (operand_11).* = @as(zx_type_48, zx_type_48{
                    .tree = operand_8,
                    .links = operand_9,
                    .index = operand_10,
                });

                break :block_12 @as(*const zx_type_48, operand_11);
            };
        };

        var state_capacity_16: (std).ArrayList(u64) = .empty;
        var state_capacity_started_17 = false;

        defer (state_capacity_16).deinit(allocator);

        const state_type_18 = struct {
            fields: []const *const zx_type_31,
            items: []const *const zx_type_32,
            nodes: []const *const zx_type_30,
        };
        const state_type_19 = struct {
            index: u64,
            links: []const u64,
            tree: state_type_18,
        };
        const state_type_22 = struct {
            []const u64,
            void,
        };
        const state_type_24 = struct {
            end: u64,
            start: u64,
        };
        const state_type_25 = struct {
            child: u64,
            count: u64,
            head: u64,
            kind: zx_type_28,
            name: state_type_24,
        };
        const state_type_26 = struct {
            node: state_type_25,
            tree: state_type_18,
        };
        var state_7: state_type_19 = state_type_19{
            .index = (operand_14).index,
            .links = (operand_14).links,
            .tree = state_type_18{
                .fields = ((operand_14).tree).fields,
                .items = ((operand_14).tree).items,
                .nodes = ((operand_14).tree).nodes,
            },
        };

        var state_changed_15 = false;

        while (((state_7).index < @as(u64, (((state_7).tree).nodes).len))) {
            state_7 = block_44: {
                const value_44: state_type_19 = state_7;
                _ = (value_44).links;

                const value_46: []const u64 = (block_43: {
                    const operand_23 = (state_7).links;

                    const operand_42 = block_41: {
                        const operand_35 = block_34: {
                            const operand_27 = (state_7).tree;
                            const operand_33 = block_32: {
                                const operand_31 = block_30: {
                                    const operand_28 = ((state_7).tree).nodes;
                                    const operand_29 = (state_7).index;

                                    if ((operand_29 >= (operand_28).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_30 (operand_28)[@intCast(operand_29)];
                                };
                                break :block_32 state_type_25{
                                    .child = (operand_31).child,
                                    .count = (operand_31).count,
                                    .head = (operand_31).head,
                                    .kind = (operand_31).kind,
                                    .name = state_type_24{
                                        .end = ((operand_31).name).end,
                                        .start = ((operand_31).name).start,
                                    },
                                };
                            };

                            break :block_34 state_type_26{
                                .tree = operand_27,
                                .node = operand_33,
                            };
                        };
                        const operand_36 = zx_type_14{
                            .end = (((operand_35).node).name).end,
                            .start = (((operand_35).node).name).start,
                        };
                        const operand_37 = zx_type_30{
                            .child = ((operand_35).node).child,
                            .count = ((operand_35).node).count,
                            .head = ((operand_35).node).head,
                            .kind = ((operand_35).node).kind,
                            .name = (&operand_36),
                        };
                        const operand_38 = zx_type_38{
                            .fields = ((operand_35).tree).fields,
                            .items = ((operand_35).tree).items,
                            .nodes = ((operand_35).tree).nodes,
                        };
                        const operand_39 = zx_type_43{
                            .node = (&operand_37),
                            .tree = (&operand_38),
                        };

                        const operand_40 = (try function_0(allocator, (&operand_39)));

                        break :block_41 operand_40;
                    };

                    _ = (try ((std).math).add(usize, (operand_23).len, 1));

                    if ((!state_capacity_started_17)) {
                        (try (state_capacity_16).appendSlice(allocator, operand_23));

                        state_capacity_started_17 = true;
                    } else {
                        ((state_capacity_16).items).len = (operand_23).len;
                    }

                    (try (state_capacity_16).append(allocator, operand_42));

                    break :block_43 @as(state_type_22, .{
                        (state_capacity_16).items,
                        {},
                    });
                }).@"0";
                const value_47: state_type_19 = block_21: {
                    break :block_21 state_type_19{
                        .index = (value_44).index,
                        .links = value_46,
                        .tree = (value_44).tree,
                    };
                };
                const value_48: state_type_19 = value_47;
                const value_49: u64 = (value_48).index;
                const value_50: u64 = @as(u64, 1);

                const value_51: state_type_19 = block_20: {
                    break :block_20 state_type_19{
                        .index = (value_49 + value_50),
                        .links = (value_48).links,
                        .tree = (value_48).tree,
                    };
                };

                break :block_44 value_51;
            };

            state_changed_15 = true;
        }

        var state_owned_45: []const u64 = (&[_]u64{});

        errdefer (allocator).free(state_owned_45);

        if (state_capacity_started_17) {
            ((state_capacity_16).items).len = ((state_7).links).len;
            state_owned_45 = (try (state_capacity_16).toOwnedSlice(allocator));
        }

        if (state_capacity_started_17) {
            (state_7).links = state_owned_45;
        }

        break :block_51 (if (state_changed_15) block_50: {
            const operand_49 = (try (allocator).create(zx_type_48));

            (operand_49).* = @as(zx_type_48, zx_type_48{
                .index = (state_7).index,
                .links = (state_7).links,
                .tree = block_48: {
                    const operand_47 = (try (allocator).create(zx_type_38));

                    (operand_47).* = @as(zx_type_38, zx_type_38{
                        .fields = ((state_7).tree).fields,
                        .items = ((state_7).tree).items,
                        .nodes = ((state_7).tree).nodes,
                    });

                    break :block_48 @as(*const zx_type_38, operand_47);
                },
            });

            break :block_50 @as(*const zx_type_48, operand_49);
        } else operand_14);
    };

    return block_6: {
        const operand_1 = (value_52).links;
        const operand_2 = (value_21).links;
        const operand_3 = (value_40).links;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_34));

            (operand_4).* = @as(zx_type_34, zx_type_34{
                .heads = operand_1,
                .fields = operand_2,
                .items = operand_3,
            });

            break :block_5 @as(*const zx_type_34, operand_4);
        };
    };
}
