pub const zx_type_11 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_15 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_16 = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
};

pub const zx_type_17 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    second: u32,
};

pub const zx_type_18 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_19 = struct {
    children: []const u32,
    fields: *const zx_type_18,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_20 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_21 = struct {
    delta: *const zx_type_15,
    id: u32,
};

pub const zx_type_22 = enum { Root, Dead, UpperI, UpperIn, UpperInp, UpperInpu, UpperInput, UpperO, UpperOu, UpperOut, UpperOutp, UpperOutpu, UpperOutput, Underscore, A, Al, All, Allo, Alloc, Alloca, Allocat, Allocato, Allocator, As, Asy, Asyn, Async, Aw, Awa, Awai, Await, B, Br, Bre, Brea, Break, C, Ca, Can, Canc, Cance, Cancel, Cas, Case, Co, Con, Conc, Concu, Concur, Concurr, Concurre, Concurren, Concurrent, Cons, Const, D, De, Dec, Decl, Decla, Declar, Declare, Def, Defa, Defau, Defaul, Default, Del, Dele, Delet, Delete, Do, E, El, Els, Else, En, Ens, Ensu, Ensur, Ensure, Ensures, Enu, Enum, Ex, Exp, Expo, Expor, Export, F, Fa, Fal, Fals, False, Fo, For, Fr, Fro, From, Fu, Fun, Func, Funct, Functi, Functio, Function, I, If, Im, Imp, Impo, Impor, Import, In, Ins, Inse, Inser, Insert, Io, L, Le, Let, Lo, Loo, Loop, M, Ma, Mat, Matc, Match, N, Ne, New, Nex, Next, Nu, Nul, Null, O, Ow, Own, Owne, Owned, P, Pr, Pro, Proc, Proce, Proces, Process, Q, Qu, Que, Quer, Query, QueryM, QueryMa, QueryMan, QueryMany, QueryO, QueryOn, QueryOne, R, Re, Req, Requ, Requi, Requir, Require, Requires, Ret, Retu, Retur, Return, S, St, Sto, Stor, Store, Sw, Swi, Swit, Switc, Switch, T, Th, Thr, Thro, Throw, Throws, Tr, Tra, Tran, Trans, Transa, Transac, Transact, Transacti, Transactio, Transaction, Tru, True, Try, Ty, Typ, Type, U, Up, Upd, Upda, Updat, Update, V, Va, Var, W, Wh, Whi, Whil, While, };
pub const zx_type_23 = enum { Identifier, Keyword, Number, String, Template, Punctuation, Eof, };
pub const zx_type_24 = enum { None, OpenBrace, CloseBrace, OpenParen, CloseParen, OpenBracket, CloseBracket, Colon, Semicolon, Comma, Dot, Question, Plus, Minus, Star, Slash, Percent, Less, Greater, Assign, Not, Ampersand, Pipe, Arrow, Equal, NotEqual, LessEqual, GreaterEqual, Coalesce, And, Or, Spread, };

pub const zx_type_25 = struct {
    end: u64,
    start: u64,
};

pub const zx_type_26 = struct {
    dollar: bool,
    kind: zx_type_23,
    line_break: bool,
    span: *const zx_type_25,
    symbol: zx_type_24,
    word: zx_type_22,
};

pub const zx_type_27 = enum { Integer, FractionStart, Fraction, ExponentStart, ExponentDigits, Done, };

pub const zx_type_28 = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_27,
    separators_valid: bool,
};

pub const zx_type_29 = struct {
    diagnostic: []const u8,
    end: u64,
};

pub const zx_type_30 = enum { Idle, Identifier, Number, String, StringEscape, LineComment, BlockComment, Template, TemplateEscape, Interpolation, InterpolationString, InterpolationStringEscape, InterpolationLineComment, InterpolationBlockComment, };

pub const zx_type_31 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
};

pub const zx_type_32 = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_30,
    start: u64,
};

pub const zx_type_36 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_25,
    depth: u64,
    diagnostic: *const zx_type_31,
    dollar: bool,
    frames: []const *const zx_type_32,
    keyword: zx_type_22,
    line_break: bool,
    mode: zx_type_30,
    number: *const zx_type_28,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_24,
    tokens: []const *const zx_type_26,
    warmed: u8,
};

pub const zx_type_37 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_36,
};

pub const zx_type_38 = struct {
    comments: []const *const zx_type_25,
    diagnostic: *const zx_type_31,
    tokens: []const *const zx_type_26,
};

pub const zx_type_39 = enum { Named, Object, Optional, List, Tuple, Application, };
pub const zx_type_40 = enum { Start, Name, Suffix, ListEnd, Field, FieldOptional, FieldColon, TupleItem, Done, };

pub const zx_type_41 = struct {
    child: u64,
    count: u64,
    head: u64,
    kind: zx_type_39,
    name: *const zx_type_25,
};

pub const zx_type_42 = struct {
    name: *const zx_type_25,
    previous: u64,
    value: u64,
};

pub const zx_type_43 = struct {
    previous: u64,
    value: u64,
};

pub const zx_type_45 = struct {
    fields: []const u64,
    heads: []const u64,
    items: []const u64,
};

pub const zx_type_49 = struct {
    fields: []const *const zx_type_42,
    items: []const *const zx_type_43,
    nodes: []const *const zx_type_41,
};

pub const zx_type_50 = struct {
    count: u64,
    field: *const zx_type_25,
    head: u64,
    kind: zx_type_39,
    name: *const zx_type_25,
    optional: bool,
};

pub const zx_type_51 = struct {
    depth: u64,
    diagnostic: *const zx_type_31,
    index: u64,
    name: *const zx_type_25,
    phase: zx_type_40,
    result: u64,
    start: u64,
    token: *const zx_type_26,
};

pub const zx_type_53 = struct {
    control: *const zx_type_51,
    frames: []const *const zx_type_50,
    tree: *const zx_type_49,
};

pub const zx_type_54 = enum { Start, Kind, Name, Open, Value, Member, Separator, Done, };

pub const zx_type_55 = struct {
    count: u64,
    enumeration: bool,
    first: u64,
    name: *const zx_type_25,
    span: *const zx_type_25,
    value: u64,
};

pub const zx_type_56 = struct {
    count: u64,
    depth: u64,
    diagnostic: *const zx_type_31,
    enumeration: bool,
    first: u64,
    index: u64,
    last_end: u64,
    name: *const zx_type_25,
    opening: u64,
    opening_index: u64,
    phase: zx_type_54,
    start: u64,
    token: *const zx_type_26,
    type_diagnostic: bool,
};

pub const zx_type_58 = struct {
    control: *const zx_type_56,
    declarations: []const *const zx_type_55,
    members: []const *const zx_type_25,
    types: *const zx_type_53,
};

pub const zx_type_59 = enum { Named, Object, Optional, List, Tuple, Enumeration, Application, };

pub const zx_type_60 = struct {
    end: u64,
    start: u64,
    text: []const u8,
};

pub const zx_type_61 = struct {
    enumeration: bool,
    index: u64,
};

pub const zx_type_62 = struct {
    child: *const zx_type_61,
    count: u64,
    kind: zx_type_59,
    name: *const zx_type_60,
    position: u64,
};

pub const zx_type_63 = struct {
    name: *const zx_type_60,
    next: u64,
    value: *const zx_type_61,
};

pub const zx_type_64 = struct {
    next: u64,
    value: *const zx_type_61,
};

pub const zx_type_65 = struct {
    name: *const zx_type_60,
    value: *const zx_type_61,
};

pub const zx_type_66 = struct {
    count: u64,
    first: u64,
};

pub const zx_type_73 = struct {
    declarations: []const *const zx_type_65,
    enumerations: []const *const zx_type_66,
    fields: []const *const zx_type_63,
    items: []const *const zx_type_64,
    members: []const *const zx_type_60,
    nodes: []const *const zx_type_62,
};

pub const zx_type_74 = struct {
    bytes: []const u8,
    declarations: []const *const zx_type_55,
    members: []const *const zx_type_25,
    order: *const zx_type_45,
    types: *const zx_type_49,
};

pub const zx_type_76 = struct {
    indexed: *const zx_type_74,
    native: ?*const zx_type_73,
};

pub const zx_type_77 = enum { Name, FinishName, Node, Wrap, Tuple, Object, };

pub const zx_type_78 = struct {
    ids: []const u32,
    names: []const []const u8,
};

pub const zx_type_79 = struct {
    aliases: *const zx_type_78,
    base: *const zx_type_15,
    native_interface: bool,
    resolved: *const zx_type_78,
    source: *const zx_type_76,
    visiting: []const []const u8,
};

pub const zx_type_80 = struct {
    children: u64,
    count: u64,
    declaration: *const zx_type_60,
    fields: u64,
    index: u64,
    list: bool,
    name: *const zx_type_60,
    operation: zx_type_77,
    position: u64,
    reference: *const zx_type_61,
    waiting: bool,
};

pub const zx_type_82 = struct {
    active: []const []const u8,
    cache: *const zx_type_78,
    context: *const zx_type_79,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_31,
    frames: []const *const zx_type_80,
    result: u32,
    scratch: *const zx_type_18,
};

pub const zx_type_83 = struct {
    context: *const zx_type_79,
    initialize: bool,
    name: *const zx_type_60,
    named: bool,
    reference: *const zx_type_61,
};

pub const zx_type_84 = struct {
    cache: *const zx_type_78,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_31,
    id: u32,
};

pub const zx_type_85 = struct {
    name: *const zx_type_60,
    operation: zx_type_77,
    reference: *const zx_type_61,
};

pub const zx_type_86 = struct {
    code: []const u8,
    message: []const u8,
    name: *const zx_type_60,
    state: *const zx_type_82,
};

pub const zx_type_87 = struct {
    source: []const u8,
    span: *const zx_type_25,
};

pub const zx_type_88 = struct { []const u8, []const u8, };

pub const zx_type_89 = struct {
    index: u64,
    source: *const zx_type_76,
};

pub const zx_type_90 = struct {
    limit: u64,
    name: []const u8,
    source: *const zx_type_76,
};

pub const zx_type_91 = struct {
    found: bool,
    index: u64,
};

pub const zx_type_92 = struct {
    found: bool,
    index: u64,
    limit: u64,
    name: []const u8,
    selected: u64,
    source: *const zx_type_76,
};

pub const zx_type_93 = struct {
    index: u64,
    state: *const zx_type_82,
};

pub const zx_type_94 = struct {
    name: []const u8,
    names: []const []const u8,
};

pub const zx_type_95 = struct {
    found: bool,
    index: u64,
    name: []const u8,
    names: []const []const u8,
};

pub const zx_type_96 = struct { []const []const u8, []const []const u8, };

pub const zx_type_97 = struct {
    count: u64,
    index: u64,
    state: *const zx_type_82,
};

pub const zx_type_98 = struct { []const []const u8, void, };
pub const zx_type_99 = struct { []const u32, void, };
pub const zx_type_101 = struct { []const []const u8, ?[]const u8, };
pub const zx_type_103 = struct { []const *const zx_type_80, ?*const zx_type_80, };

pub const zx_type_104 = struct {
    children: []const u32,
    count: u64,
    field_names: []const []const u8,
    field_types: []const u32,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    offset: u64,
    second: u32,
};

pub const zx_type_105 = struct {
    left: *const zx_type_104,
    right: *const zx_type_104,
};

pub const zx_type_106 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_104,
    right: *const zx_type_104,
};

pub const zx_type_107 = struct {
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_108 = struct {
    candidate: *const zx_type_19,
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_109 = struct {
    candidate: *const zx_type_19,
    tables: *const zx_type_16,
};

pub const zx_type_110 = struct {
    candidate: *const zx_type_19,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_111 = struct {
    candidate: *const zx_type_19,
    delta: *const zx_type_15,
};

pub const zx_type_112 = struct { []const u8, void, };

pub const zx_type_113 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_114 = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
};

pub const zx_type_115 = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
};

pub const zx_type_116 = struct {
    code: []const u8,
    message: []const u8,
};

pub const zx_type_117 = struct {
    candidate: *const zx_type_19,
    table: *const zx_type_15,
};

pub const zx_type_118 = struct {
    delta: *const zx_type_15,
    diagnostic: *const zx_type_116,
    id: u32,
};

pub const zx_type_119 = struct {
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_121 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_122 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
};

pub const zx_type_123 = struct {
    id: u32,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_124 = struct {
    found: bool,
    index: u64,
    limit: u64,
    tables: *const zx_type_16,
    target: zx_type_11,
};

pub const zx_type_125 = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_126 = struct { []const bool, void, };
pub const zx_type_127 = enum { None, TaskContainer, VoidList, TaskTuple, TaskObject, };

pub const zx_type_128 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_129 = struct {
    candidate: *const zx_type_19,
    state: *const zx_type_82,
};

pub const zx_type_130 = struct {
    enumeration: u64,
    index: u64,
    source: *const zx_type_76,
};

pub const zx_type_131 = struct {
    reference: *const zx_type_61,
    source: *const zx_type_76,
};

pub const zx_type_132 = struct {
    count: u64,
    diagnostic: *const zx_type_31,
    enumeration: u64,
    index: u64,
    names: []const []const u8,
    source: *const zx_type_76,
};

pub const zx_type_133 = struct {
    cache: *const zx_type_78,
    name: []const u8,
};

pub const zx_type_134 = struct {
    cache: *const zx_type_78,
    found: bool,
    id: u32,
    index: u64,
    name: []const u8,
};

pub const zx_type_135 = struct {
    frame: *const zx_type_80,
    state: *const zx_type_82,
};

pub const zx_type_136 = struct { []const *const zx_type_80, void, };
pub const zx_type_137 = struct { []const u32, []const u32, };

pub const zx_type_138 = struct {
    position: u64,
    source: *const zx_type_76,
};

pub const zx_type_139 = struct {
    initialize: bool,
    state: *const zx_type_82,
};

pub const zx_type_140 = struct { *const zx_type_83, };
pub const zx_type_141 = struct { *const zx_type_83, *const zx_type_82, };
pub const zx_type_142 = struct { *const zx_type_83, *const zx_type_82, *const zx_type_84, };

pub const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    children: []const u32,
    fields: *const zx_type_18,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_15,
    id: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_27,
    separators_valid: bool,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    diagnostic: []const u8,
    end: u64,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_36_14f151be98723b44a65ef54272e86f37e634a51c57971b7cdbf77db5daef53fc = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_25,
    depth: u64,
    diagnostic: *const zx_type_31,
    dollar: bool,
    frames: []const *const zx_type_32,
    keyword: zx_type_22,
    line_break: bool,
    mode: zx_type_30,
    number: value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_24,
    tokens: []const *const zx_type_26,
    warmed: u8,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_e1ffa7811185b0059f03a475523fa4c6e0b5b5a864f30612add6a83cb730f9cf = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_zx_type_36_14f151be98723b44a65ef54272e86f37e634a51c57971b7cdbf77db5daef53fc,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    comments: []const *const zx_type_25,
    diagnostic: *const zx_type_31,
    tokens: []const *const zx_type_26,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_51_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    depth: u64,
    diagnostic: *const zx_type_31,
    index: u64,
    name: *const zx_type_25,
    phase: zx_type_40,
    result: u64,
    start: u64,
    token: *const zx_type_26,
    zx_origin: ?*const zx_type_51 = null,
};

pub const value_zx_type_53_e1a3efb1661a55082d96026e298239963014feef940e12b8f12b12b89508e175 = struct {
    control: value_zx_type_51_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    frames: []const *const zx_type_50,
    tree: *const zx_type_49,
    zx_origin: ?*const zx_type_53 = null,
};

pub const value_zx_type_56_1f6cf931ff1653b987809c8802c1c5135603b2eaa9fca3d6a77de94ccab3545b = struct {
    count: u64,
    depth: u64,
    diagnostic: *const zx_type_31,
    enumeration: bool,
    first: u64,
    index: u64,
    last_end: u64,
    name: *const zx_type_25,
    opening: u64,
    opening_index: u64,
    phase: zx_type_54,
    start: u64,
    token: *const zx_type_26,
    type_diagnostic: bool,
    zx_origin: ?*const zx_type_56 = null,
};

pub const value_zx_type_58_890b4a7a9123a519f01aaace6bc158b2e83af2b77cde6ded9d9d394d76a71359 = struct {
    control: value_zx_type_56_1f6cf931ff1653b987809c8802c1c5135603b2eaa9fca3d6a77de94ccab3545b,
    declarations: []const *const zx_type_55,
    members: []const *const zx_type_25,
    types: value_zx_type_53_e1a3efb1661a55082d96026e298239963014feef940e12b8f12b12b89508e175,
    zx_origin: ?*const zx_type_58 = null,
};

pub const value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    active: []const []const u8,
    cache: *const zx_type_78,
    context: *const zx_type_79,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_31,
    frames: []const *const zx_type_80,
    result: u32,
    scratch: *const zx_type_18,
    zx_origin: ?*const zx_type_82 = null,
};

pub const value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    context: *const zx_type_79,
    initialize: bool,
    name: *const zx_type_60,
    named: bool,
    reference: *const zx_type_61,
    zx_origin: ?*const zx_type_83 = null,
};

pub const value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    cache: *const zx_type_78,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_31,
    id: u32,
    zx_origin: ?*const zx_type_84 = null,
};

pub const value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    name: *const zx_type_60,
    operation: zx_type_77,
    reference: *const zx_type_61,
    zx_origin: ?*const zx_type_85 = null,
};

pub const value_zx_type_86_b007dd1e4c63d95a3155329e1f60b16a22582c9bf6a4aa0bbdeb58811f8f72c5 = struct {
    code: []const u8,
    message: []const u8,
    name: *const zx_type_60,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_86 = null,
};

pub const value_zx_type_87_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    source: []const u8,
    span: *const zx_type_25,
    zx_origin: ?*const zx_type_87 = null,
};

pub const value_zx_type_88_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, []const u8, ?*const zx_type_88, };

pub const value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_89 = null,
};

pub const value_zx_type_90_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    limit: u64,
    name: []const u8,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_90 = null,
};

pub const value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    index: u64,
    zx_origin: ?*const zx_type_91 = null,
};

pub const value_zx_type_92_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    found: bool,
    index: u64,
    limit: u64,
    name: []const u8,
    selected: u64,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_92 = null,
};

pub const value_zx_type_93_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = struct {
    index: u64,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_93 = null,
};

pub const value_zx_type_94_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    name: []const u8,
    names: []const []const u8,
    zx_origin: ?*const zx_type_94 = null,
};

pub const value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    found: bool,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    zx_origin: ?*const zx_type_95 = null,
};

pub const value_zx_type_96_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, []const []const u8, ?*const zx_type_96, };

pub const value_zx_type_97_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = struct {
    count: u64,
    index: u64,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_97 = null,
};

pub const value_zx_type_98_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_98, };
pub const value_zx_type_99_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_99, };
pub const value_zx_type_101_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const []const u8, ?[]const u8, ?*const zx_type_101, };
pub const value_zx_type_103_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_80, ?*const zx_type_80, ?*const zx_type_103, };

pub const value_zx_type_105_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: *const zx_type_104,
    right: *const zx_type_104,
    zx_origin: ?*const zx_type_105 = null,
};

pub const value_zx_type_106_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_104,
    right: *const zx_type_104,
    zx_origin: ?*const zx_type_106 = null,
};

pub const value_zx_type_107_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_107 = null,
};

pub const value_zx_type_108_867ec9aa987e04cef9004f10d74da0de91acec53c3b161384080c48e933b23d1 = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_108 = null,
};

pub const value_zx_type_109_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_109 = null,
};

pub const value_zx_type_110_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_110 = null,
};

pub const value_zx_type_111_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    delta: *const zx_type_15,
    zx_origin: ?*const zx_type_111 = null,
};

pub const value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_112, };

pub const value_zx_type_113_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: []const u8,
    right: []const u8,
    zx_origin: ?*const zx_type_113 = null,
};

pub const value_zx_type_114_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
    zx_origin: ?*const zx_type_114 = null,
};

pub const value_zx_type_115_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
    zx_origin: ?*const zx_type_115 = null,
};

pub const value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    code: []const u8,
    message: []const u8,
    zx_origin: ?*const zx_type_116 = null,
};

pub const value_zx_type_117_97ef35768e4b20dbfdbabd40eb84aaab7839cc3ecd945184605f4cfb6fb1cb3b = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_117 = null,
};

pub const value_zx_type_118_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    delta: *const zx_type_15,
    diagnostic: value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    id: u32,
    zx_origin: ?*const zx_type_118 = null,
};

pub const value_zx_type_119_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_119 = null,
};

pub const value_zx_type_121_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_121 = null,
};

pub const value_zx_type_122_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
    zx_origin: ?*const zx_type_122 = null,
};

pub const value_zx_type_123_152936f5b3ece57cfa1afaff5c987671dc1de239be81c121450e61f890947569 = struct {
    id: u32,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_123 = null,
};

pub const value_zx_type_124_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = struct {
    found: bool,
    index: u64,
    limit: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    target: zx_type_11,
    zx_origin: ?*const zx_type_124 = null,
};

pub const value_zx_type_125_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_125 = null,
};

pub const value_zx_type_126_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_126, };

pub const value_zx_type_128_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_128 = null,
};

pub const value_zx_type_129_07c74191144c16fd328e32cc7c190af6999d85b07cacb18a5b9ea1e55e5f3920 = struct {
    candidate: value_zx_type_19_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_129 = null,
};

pub const value_zx_type_130_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    enumeration: u64,
    index: u64,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_130 = null,
};

pub const value_zx_type_131_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    reference: *const zx_type_61,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_131 = null,
};

pub const value_zx_type_132_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    diagnostic: *const zx_type_31,
    enumeration: u64,
    index: u64,
    names: []const []const u8,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_132 = null,
};

pub const value_zx_type_133_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    cache: *const zx_type_78,
    name: []const u8,
    zx_origin: ?*const zx_type_133 = null,
};

pub const value_zx_type_134_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    cache: *const zx_type_78,
    found: bool,
    id: u32,
    index: u64,
    name: []const u8,
    zx_origin: ?*const zx_type_134 = null,
};

pub const value_zx_type_135_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = struct {
    frame: *const zx_type_80,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_135 = null,
};

pub const value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_80, void, ?*const zx_type_136, };
pub const value_zx_type_137_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, []const u32, ?*const zx_type_137, };

pub const value_zx_type_138_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    position: u64,
    source: *const zx_type_76,
    zx_origin: ?*const zx_type_138 = null,
};

pub const value_zx_type_139_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = struct {
    initialize: bool,
    state: value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_139 = null,
};

pub const value_zx_type_140_7695a4d364d66a6902b4af6ac6744d237e533b15944969bca7543d8f0ffc99af = struct { value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, ?*const zx_type_140, };
pub const value_zx_type_141_b91b3eda6ee3880a4ea80a4b04e4312e5fcc8ae9f3ca0889f1d8bfc6af5383a8 = struct { value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, ?*const zx_type_141, };
pub const value_zx_type_142_e7f93ec4de7c79f3d8c34ccd6498759327c2c4ad7c7b35ab41719e546b88446f = struct { value_zx_type_83_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, value_zx_type_82_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, value_zx_type_84_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, ?*const zx_type_142, };

pub const native_by_identity = struct {
    pub const @"std:encoding" = struct {
        pub const encodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"zig:zxc_native_6884535bb82ae9c8fe2547d6b588ad089f0731f03c019853f97b5522cf27531d" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const narrow = struct {
            pub const Input = u64;
            pub const Output = u32;
            pub const InputValue = u64;
            pub const OutputValue = u32;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"std:encoding" = struct {
    };
    pub const @"zig:zxc_native_6884535bb82ae9c8fe2547d6b588ad089f0731f03c019853f97b5522cf27531d" = struct {
    };
};

pub const native = struct {
    pub const @"std:encoding" = (native_by_identity).@"std:encoding";
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_6884535bb82ae9c8fe2547d6b588ad089f0731f03c019853f97b5522cf27531d";
};

pub const layouts = struct {
    pub const @"std:encoding" = (layouts_by_identity).@"std:encoding";
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_6884535bb82ae9c8fe2547d6b588ad089f0731f03c019853f97b5522cf27531d";
};
