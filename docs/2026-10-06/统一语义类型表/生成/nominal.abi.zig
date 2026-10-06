pub const zx_type_11 = enum { None, InvalidPath, Missing, Cycle, };

pub const zx_type_14 = struct {
    issues: []const zx_type_11,
    offsets: []const u64,
    targets: []const u64,
};

pub const zx_type_15 = struct {
    count: u64,
    cursors: []const u64,
    depth: u64,
    edge: u64,
    frames: []const u64,
    graph: *const zx_type_14,
    issue: zx_type_11,
    marks: []const u64,
    order: []const u64,
    root: u64,
};

pub const zx_type_17 = struct { []const u64, ?u64, };

pub const zx_type_18 = struct {
    count: u64,
    edge: u64,
    issue: zx_type_11,
    order: []const u64,
};

pub const zx_type_20 = struct {
    offset: u64,
    source: []const u8,
    text: []const u8,
};

pub const zx_type_21 = struct {
    index: u64,
    matches: bool,
    offset: u64,
    source: []const u8,
    text: []const u8,
};

pub const zx_type_22 = struct {
    pattern: []const u8,
    source: []const u8,
};

pub const zx_type_23 = struct {
    pattern: []const u8,
    source: []const u8,
    start: u64,
};

pub const zx_type_24 = enum { ModuleFile, ModuleReference, SpecialFile, StoreReference, FunctionReference, };

pub const zx_type_25 = struct {
    source: []const u8,
    start: u64,
};

pub const zx_type_26 = struct {
    offset: u64,
    source: []const u8,
    start: u64,
    valid: bool,
};

pub const zx_type_27 = struct {
    kind: zx_type_24,
    path: []const u8,
    suffix: []const u8,
};

pub const zx_type_28 = struct {
    end: u64,
    parent: bool,
    start: u64,
};

pub const zx_type_30 = struct {
    dots: bool,
    offset: u64,
    segments: []const *const zx_type_28,
    start: u64,
};

pub const zx_type_31 = struct {
    parents: u64,
    segments: []const *const zx_type_28,
};

pub const zx_type_32 = struct { []const *const zx_type_28, void, };

pub const zx_type_33 = struct {
    byte: u8,
    state: *const zx_type_30,
};

pub const zx_type_34 = struct {
    end: u64,
    parent: bool,
    start: u64,
    state: *const zx_type_31,
};

pub const zx_type_35 = struct {
    segments: []const *const zx_type_28,
    valid: bool,
};

pub const zx_type_36 = enum { Static, Value, Expression, };

pub const zx_type_37 = struct {
    attribute: []const u8,
    element: []const u8,
};

pub const zx_type_38 = enum { None, Target, Input, Setter, };

pub const zx_type_39 = struct {
    has_function: bool,
    has_input: bool,
    has_module: bool,
    has_setter: bool,
};

pub const zx_type_40 = struct {
    offset: u64,
    source: []const u8,
};

pub const zx_type_41 = enum { App, Gateway, Store, Module, Invalid, };

pub const zx_type_42 = struct {
    expressions: bool,
    source: []const u8,
};

pub const zx_type_43 = struct {
    high: u8,
    low: u8,
    remaining: u8,
    valid: bool,
};

pub const zx_type_44 = struct {
    byte: u8,
    state: *const zx_type_43,
};

pub const zx_type_45 = struct {
    first: u8,
    second: u8,
    valid: bool,
};

pub const zx_type_46 = struct {
    end: u64,
    start: u64,
};

pub const zx_type_47 = struct {
    column: u64,
    line: u64,
    offset: u64,
};

pub const zx_type_48 = struct {
    character: bool,
    codepoint: u64,
    previous: u64,
    span: *const zx_type_46,
};

pub const zx_type_49 = struct {
    count: u64,
    head: u64,
    span: *const zx_type_46,
};

pub const zx_type_50 = enum { Prelude, BeforeRoot, Open, Attributes, Content, AfterRoot, Value, Done, };
pub const zx_type_51 = enum { Attribute, Text, Cdata, };

pub const zx_type_52 = struct {
    expression: bool,
    location: *const zx_type_47,
    name: *const zx_type_46,
    previous: u64,
    value: *const zx_type_49,
    value_location: *const zx_type_47,
};

pub const zx_type_53 = struct {
    location: *const zx_type_47,
    previous: u64,
    value: *const zx_type_49,
};

pub const zx_type_54 = struct {
    previous: u64,
    value: u64,
};

pub const zx_type_55 = struct {
    attribute_count: u64,
    attributes: u64,
    child_count: u64,
    children: u64,
    location: *const zx_type_47,
    name: *const zx_type_46,
    text: u64,
    text_count: u64,
};

pub const zx_type_61 = struct {
    attributes: []const *const zx_type_52,
    children: []const *const zx_type_54,
    nodes: []const *const zx_type_55,
    parts: []const *const zx_type_48,
    text: []const *const zx_type_53,
};

pub const zx_type_62 = struct {
    attribute: *const zx_type_46,
    attribute_location: *const zx_type_47,
    expressions: bool,
    issue: *const zx_type_47,
    location: *const zx_type_47,
    message: []const u8,
    phase: zx_type_50,
    result: u64,
    terminator: u8,
    text_start: u64,
    value_count: u64,
    value_head: u64,
    value_kind: zx_type_51,
    value_location: *const zx_type_47,
    value_start: u64,
};

pub const zx_type_63 = struct {
    control: *const zx_type_62,
    frame: *const zx_type_55,
    frames: []const *const zx_type_55,
    source: []const u8,
    tree: *const zx_type_61,
};

pub const zx_type_64 = struct {
    expressions: bool,
    message: []const u8,
    source: []const u8,
};

pub const zx_type_65 = struct {
    done: bool,
    offset: u64,
    source: []const u8,
};

pub const zx_type_66 = struct {
    count: u64,
    location: *const zx_type_47,
    source: []const u8,
};

pub const zx_type_67 = struct {
    column: u64,
    end: u64,
    line: u64,
    offset: u64,
    previous_cr: bool,
    source: []const u8,
};

pub const zx_type_68 = struct {
    count: u64,
    state: *const zx_type_63,
};

pub const zx_type_69 = struct {
    end: u64,
    message: []const u8,
};

pub const zx_type_70 = struct {
    left: *const zx_type_46,
    right: *const zx_type_46,
    source: []const u8,
};

pub const zx_type_71 = struct {
    end: u64,
    left: u64,
    matches: bool,
    right: u64,
    source: []const u8,
};

pub const zx_type_72 = struct {
    attributes: []const *const zx_type_52,
    head: u64,
    name: *const zx_type_46,
    source: []const u8,
};

pub const zx_type_73 = struct {
    attributes: []const *const zx_type_52,
    found: bool,
    head: u64,
    name: *const zx_type_46,
    source: []const u8,
};

pub const zx_type_74 = enum { Interpolation, String, LineComment, BlockComment, Template, };

pub const zx_type_75 = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_74,
    start: u64,
};

pub const zx_type_77 = struct {
    comment_start: u64,
    done: bool,
    frame: *const zx_type_75,
    frames: []const *const zx_type_75,
    issue: u64,
    message: []const u8,
    offset: u64,
    source: []const u8,
};

pub const zx_type_78 = struct {
    message: []const u8,
    offset: u64,
    state: *const zx_type_77,
};

pub const zx_type_80 = struct { []const *const zx_type_75, ?*const zx_type_75, };

pub const zx_type_81 = struct {
    depth: u64,
    mode: zx_type_74,
    offset: u64,
    start: u64,
    state: *const zx_type_77,
};

pub const zx_type_82 = struct { []const *const zx_type_75, void, };

pub const zx_type_83 = struct {
    end: u64,
    message: []const u8,
    offset: u64,
    source: []const u8,
};

pub const zx_type_84 = struct {
    message: []const u8,
    state: *const zx_type_63,
};

pub const zx_type_85 = struct {
    expression: bool,
    state: *const zx_type_63,
    value: *const zx_type_49,
};

pub const zx_type_86 = struct { []const *const zx_type_52, void, };
pub const zx_type_87 = struct { []const *const zx_type_53, void, };

pub const zx_type_88 = struct {
    kind: zx_type_51,
    state: *const zx_type_63,
    terminator: u8,
};

pub const zx_type_89 = struct { []const *const zx_type_55, void, };
pub const zx_type_91 = struct { []const *const zx_type_55, ?*const zx_type_55, };
pub const zx_type_92 = struct { []const *const zx_type_54, void, };

pub const zx_type_93 = struct {
    phase: zx_type_50,
    state: *const zx_type_63,
};

pub const zx_type_94 = enum { None, Unterminated, DoubleDash, };

pub const zx_type_95 = struct {
    done: bool,
    issue: zx_type_94,
    offset: u64,
    source: []const u8,
};

pub const zx_type_96 = enum { None, VersionRequired, Space, Name, Token, Quote, Unterminated, Version, Encoding, Standalone, Field, };

pub const zx_type_97 = struct {
    count: u64,
    done: bool,
    encoding: bool,
    issue: zx_type_96,
    offset: u64,
    source: []const u8,
    standalone: bool,
};

pub const zx_type_98 = struct {
    ignore_case: bool,
    source: []const u8,
    span: *const zx_type_46,
    text: []const u8,
};

pub const zx_type_99 = struct {
    ignore_case: bool,
    index: u64,
    matches: bool,
    offset: u64,
    source: []const u8,
    text: []const u8,
};

pub const zx_type_100 = struct {
    byte: u8,
    offset: u64,
    source: []const u8,
};

pub const zx_type_101 = struct {
    end: u64,
    hexadecimal: bool,
    source: []const u8,
    start: u64,
};

pub const zx_type_102 = struct {
    codepoint: u64,
    message: []const u8,
};

pub const zx_type_103 = struct {
    end: u64,
    offset: u64,
    overflow: bool,
    radix: u64,
    source: []const u8,
    valid: bool,
    value: u64,
};

pub const zx_type_104 = struct {
    end: u64,
    source: []const u8,
    start: u64,
};

pub const zx_type_105 = struct { []const *const zx_type_48, void, };

pub const zx_type_106 = struct {
    codepoint: u64,
    count: u64,
    state: *const zx_type_63,
};

pub const zx_type_107 = struct {
    negative: bool,
    offset: u64,
    seen: bool,
    source: []const u8,
    started: bool,
    valid: bool,
    value: u64,
};

pub const zx_type_108 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_111 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_112 = struct {
    base: *const zx_type_111,
    delta: *const zx_type_111,
};

pub const zx_type_113 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_108,
    label: []const u8,
    second: u32,
};

pub const zx_type_114 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_115 = struct {
    children: []const u32,
    fields: *const zx_type_114,
    first: u32,
    kind: zx_type_108,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_116 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_117 = struct {
    delta: *const zx_type_111,
    id: u32,
};

pub const zx_type_118 = struct {
    id: u32,
    tables: *const zx_type_112,
};

pub const zx_type_119 = struct {
    candidate: *const zx_type_115,
    id: u32,
    tables: *const zx_type_112,
};

pub const zx_type_120 = struct {
    candidate: *const zx_type_115,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_111,
};

pub const zx_type_121 = struct {
    candidate: *const zx_type_115,
    tables: *const zx_type_112,
};

pub const zx_type_122 = struct {
    candidate: *const zx_type_115,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_112,
};

pub const zx_type_123 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
};

pub const zx_type_124 = struct {
    ids: []const u32,
    kinds: []const u8,
    members: []const []const u8,
    owners: []const []const u8,
};

pub const zx_type_125 = struct {
    base: *const zx_type_124,
    delta: *const zx_type_124,
};

pub const zx_type_126 = enum { Missing, Found, Conflict, };

pub const zx_type_127 = struct {
    id: u32,
    status: zx_type_126,
};

pub const zx_type_128 = struct {
    candidate: *const zx_type_115,
    origin: *const zx_type_123,
    origins: *const zx_type_125,
    tables: *const zx_type_112,
};

pub const zx_type_129 = struct {
    candidate: *const zx_type_115,
    count: u64,
    id: u32,
    index: u64,
    origin: *const zx_type_123,
    origins: *const zx_type_125,
    status: zx_type_126,
    tables: *const zx_type_112,
};

pub const zx_type_130 = enum { Root, Dead, UpperI, UpperIn, UpperInp, UpperInpu, UpperInput, UpperO, UpperOu, UpperOut, UpperOutp, UpperOutpu, UpperOutput, Underscore, A, Al, All, Allo, Alloc, Alloca, Allocat, Allocato, Allocator, As, Asy, Asyn, Async, Aw, Awa, Awai, Await, B, Br, Bre, Brea, Break, C, Ca, Can, Canc, Cance, Cancel, Cas, Case, Co, Con, Conc, Concu, Concur, Concurr, Concurre, Concurren, Concurrent, Cons, Const, D, De, Dec, Decl, Decla, Declar, Declare, Def, Defa, Defau, Defaul, Default, Del, Dele, Delet, Delete, Do, E, El, Els, Else, En, Ens, Ensu, Ensur, Ensure, Ensures, Enu, Enum, Ex, Exp, Expo, Expor, Export, F, Fa, Fal, Fals, False, Fo, For, Fr, Fro, From, Fu, Fun, Func, Funct, Functi, Functio, Function, I, If, Im, Imp, Impo, Impor, Import, In, Ins, Inse, Inser, Insert, Io, L, Le, Let, Lo, Loo, Loop, M, Ma, Mat, Matc, Match, N, Ne, New, Nex, Next, Nu, Nul, Null, O, Ow, Own, Owne, Owned, P, Pr, Pro, Proc, Proce, Proces, Process, Q, Qu, Que, Quer, Query, QueryM, QueryMa, QueryMan, QueryMany, QueryO, QueryOn, QueryOne, R, Re, Req, Requ, Requi, Requir, Require, Requires, Ret, Retu, Retur, Return, S, St, Sto, Stor, Store, Sw, Swi, Swit, Switc, Switch, T, Th, Thr, Thro, Throw, Throws, Tr, Tra, Tran, Trans, Transa, Transac, Transact, Transacti, Transactio, Transaction, Tru, True, Try, Ty, Typ, Type, U, Up, Upd, Upda, Updat, Update, V, Va, Var, W, Wh, Whi, Whil, While, };
pub const zx_type_131 = enum { Identifier, Keyword, Number, String, Template, Punctuation, Eof, };
pub const zx_type_132 = enum { None, OpenBrace, CloseBrace, OpenParen, CloseParen, OpenBracket, CloseBracket, Colon, Semicolon, Comma, Dot, Question, Plus, Minus, Star, Slash, Percent, Less, Greater, Assign, Not, Ampersand, Pipe, Arrow, Equal, NotEqual, LessEqual, GreaterEqual, Coalesce, And, Or, Spread, };

pub const zx_type_133 = struct {
    dollar: bool,
    kind: zx_type_131,
    line_break: bool,
    span: *const zx_type_46,
    symbol: zx_type_132,
    word: zx_type_130,
};

pub const zx_type_134 = enum { Integer, FractionStart, Fraction, ExponentStart, ExponentDigits, Done, };

pub const zx_type_135 = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_134,
    separators_valid: bool,
};

pub const zx_type_136 = struct {
    diagnostic: []const u8,
    end: u64,
};

pub const zx_type_137 = enum { Idle, Identifier, Number, String, StringEscape, LineComment, BlockComment, Template, TemplateEscape, Interpolation, InterpolationString, InterpolationStringEscape, InterpolationLineComment, InterpolationBlockComment, };

pub const zx_type_138 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
};

pub const zx_type_139 = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_137,
    start: u64,
};

pub const zx_type_143 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_46,
    depth: u64,
    diagnostic: *const zx_type_138,
    dollar: bool,
    frames: []const *const zx_type_139,
    keyword: zx_type_130,
    line_break: bool,
    mode: zx_type_137,
    number: *const zx_type_135,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_132,
    tokens: []const *const zx_type_133,
    warmed: u8,
};

pub const zx_type_144 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_143,
};

pub const zx_type_145 = struct {
    comments: []const *const zx_type_46,
    diagnostic: *const zx_type_138,
    tokens: []const *const zx_type_133,
};

pub const zx_type_146 = enum { Text, Expression, };
pub const zx_type_147 = enum { TemplateOpen, TemplateClose, InterpolationOpen, InterpolationClose, };

pub const zx_type_148 = struct {
    interpolation: u64,
    kind: zx_type_146,
    previous: u64,
    span: *const zx_type_46,
};

pub const zx_type_149 = struct {
    kind: zx_type_147,
    offset: u64,
    reference: u64,
};

pub const zx_type_153 = struct {
    events: []const *const zx_type_149,
    lexed: *const zx_type_145,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
};

pub const zx_type_154 = struct {
    lexed: *const zx_type_145,
    span: *const zx_type_46,
    token_templates: []const u64,
};

pub const zx_type_156 = struct {
    interpolations: []const *const zx_type_154,
    lexed: *const zx_type_145,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
};

pub const zx_type_157 = struct {
    comment: bool,
    end: u64,
    kind: []const u8,
    start: u64,
    state: *const zx_type_143,
};

pub const zx_type_158 = struct { []const *const zx_type_46, void, };
pub const zx_type_159 = struct { []const *const zx_type_133, void, };

pub const zx_type_160 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    state: *const zx_type_143,
};

pub const zx_type_161 = struct {
    count: u64,
    ids: []const u64,
    template: u64,
};

pub const zx_type_162 = struct {
    ids: []const u64,
};

pub const zx_type_163 = struct { []const u64, void, };

pub const zx_type_164 = struct {
    count: u64,
    head: u64,
    start: u64,
    text_start: u64,
};

pub const zx_type_166 = struct {
    events: []const *const zx_type_149,
    frames: []const *const zx_type_164,
    interpolations: u64,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
};

pub const zx_type_167 = struct {
    graph: *const zx_type_166,
    lexer: *const zx_type_143,
};

pub const zx_type_168 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_167,
};

pub const zx_type_169 = struct {
    byte: u8,
    keyword: zx_type_130,
};

pub const zx_type_170 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
};

pub const zx_type_171 = struct {
    byte: u8,
    length: u64,
    next: u8,
};

pub const zx_type_172 = struct { []const *const zx_type_139, void, };

pub const zx_type_173 = struct {
    byte: u8,
    state: *const zx_type_135,
};

pub const zx_type_175 = struct { []const *const zx_type_139, ?*const zx_type_139, };

pub const zx_type_176 = struct {
    graph: *const zx_type_166,
    interpolation: u64,
    kind: zx_type_146,
    span: *const zx_type_46,
    text_start: u64,
};

pub const zx_type_177 = struct { []const *const zx_type_148, void, };
pub const zx_type_179 = struct { []const *const zx_type_164, ?*const zx_type_164, };
pub const zx_type_180 = struct { []const *const zx_type_164, void, };

pub const zx_type_181 = struct {
    graph: *const zx_type_166,
    offset: u64,
};

pub const zx_type_182 = struct { []const *const zx_type_149, void, };
pub const zx_type_183 = struct { []const *const zx_type_49, void, };

pub const zx_type_184 = struct {
    braces: u64,
    byte: u8,
    graph: *const zx_type_166,
    has_next: bool,
    mode: zx_type_137,
    next: u8,
    offset: u64,
};

pub const zx_type_185 = struct {
    byte: u8,
    state: *const zx_type_167,
};

pub const zx_type_186 = struct {
    lexer: *const zx_type_143,
    present: bool,
    start: u64,
    token_templates: []const u64,
};

pub const zx_type_187 = struct {
    session: *const zx_type_186,
    start: u64,
};

pub const zx_type_189 = struct {
    active: *const zx_type_186,
    event_index: u64,
    events: []const *const zx_type_149,
    interpolations: []const *const zx_type_154,
    length: u64,
    offset: u64,
    parents: []const *const zx_type_187,
    skip: bool,
};

pub const zx_type_190 = struct {
    end: u64,
    present: bool,
    start: u64,
};

pub const zx_type_191 = struct {
    events: []const *const zx_type_149,
    length: u64,
};

pub const zx_type_192 = struct {
    end: u64,
    session: *const zx_type_186,
};

pub const zx_type_193 = struct { []const *const zx_type_154, void, };

pub const zx_type_194 = struct {
    end: u64,
    session: *const zx_type_186,
    start: u64,
    template: u64,
};

pub const zx_type_195 = struct {
    state: *const zx_type_189,
    template: u64,
};

pub const zx_type_197 = struct { []const *const zx_type_187, ?*const zx_type_187, };
pub const zx_type_198 = struct { []const *const zx_type_187, void, };

pub const zx_type_199 = struct {
    byte: u8,
    state: *const zx_type_143,
};

pub const zx_type_200 = struct {
    byte: u8,
    state: *const zx_type_189,
};

pub const zx_type_201 = enum { Named, Object, Optional, List, Tuple, Application, };
pub const zx_type_202 = enum { Start, Name, Suffix, ListEnd, Field, FieldOptional, FieldColon, TupleItem, Done, };

pub const zx_type_203 = struct {
    child: u64,
    count: u64,
    head: u64,
    kind: zx_type_201,
    name: *const zx_type_46,
};

pub const zx_type_204 = struct {
    name: *const zx_type_46,
    previous: u64,
    value: u64,
};

pub const zx_type_207 = struct {
    fields: []const *const zx_type_204,
    items: []const *const zx_type_54,
    nodes: []const *const zx_type_203,
};

pub const zx_type_208 = struct {
    count: u64,
    field: *const zx_type_46,
    head: u64,
    kind: zx_type_201,
    name: *const zx_type_46,
    optional: bool,
};

pub const zx_type_209 = struct {
    depth: u64,
    diagnostic: *const zx_type_138,
    index: u64,
    name: *const zx_type_46,
    phase: zx_type_202,
    result: u64,
    start: u64,
    token: *const zx_type_133,
};

pub const zx_type_211 = struct {
    control: *const zx_type_209,
    frames: []const *const zx_type_208,
    tree: *const zx_type_207,
};

pub const zx_type_212 = struct {
    depth: u64,
    start: u64,
};

pub const zx_type_213 = enum { None, Coalesce, Add, Subtract, Multiply, Divide, Remainder, Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual, And, Or, };
pub const zx_type_214 = enum { None, Coalesce, Logical, };

pub const zx_type_215 = struct {
    family: zx_type_214,
    operator: zx_type_213,
    precedence: u8,
};

pub const zx_type_216 = struct {
    binary: *const zx_type_215,
    generic: bool,
    lambda: bool,
};

pub const zx_type_218 = struct {
    after_identifier: bool,
    arrow: bool,
    hints: []const *const zx_type_216,
    parameter_start: bool,
};

pub const zx_type_220 = struct {
    hints: []const *const zx_type_216,
    interpolation_hints: []const []const *const zx_type_216,
    lexical: *const zx_type_156,
};

pub const zx_type_221 = enum { Number, String, Boolean, Null, Identifier, Field, Index, List, Call, Lambda, Template, Unary, Binary, Conditional, Match, Object, StateBlock, Capture, Async, Await, Cancel, };
pub const zx_type_222 = enum { BeginBinary, Primary, Postfix, Returning, FieldName, Arguments, ObjectName, ObjectColon, LambdaParameter, LambdaSeparator, LambdaArrow, LambdaBody, Callback, StateBlock, MatchStart, MatchCondition, MatchFallbackArrow, MatchEnd, GenericType, GenericCall, TemplateGather, TemplatePart, Done, };
pub const zx_type_223 = enum { BinaryLeft, BinaryRight, Unary, Group, Index, Arguments, ObjectValue, OptionsValue, Lambda, ConditionalYes, ConditionalNo, MatchSubject, MatchCondition, MatchResult, MatchFallback, Template, TemplatePart, Interpolation, Capture, Async, Await, Cancel, };

pub const zx_type_224 = struct {
    count: u64,
    depth: u64,
    first: u64,
    flag: bool,
    head: u64,
    kind: zx_type_221,
    name: *const zx_type_46,
    operator: zx_type_213,
    second: u64,
    span: *const zx_type_46,
    third: u64,
    type_argument: u64,
};

pub const zx_type_225 = struct {
    name: *const zx_type_46,
    previous: u64,
    spread: bool,
    value: u64,
};

pub const zx_type_226 = struct {
    name: *const zx_type_46,
    previous: u64,
};

pub const zx_type_227 = struct {
    expression: bool,
    previous: u64,
    span: *const zx_type_46,
    value: u64,
};

pub const zx_type_228 = struct {
    condition: u64,
    previous: u64,
    result: u64,
};

pub const zx_type_234 = struct {
    arms: []const *const zx_type_228,
    fields: []const *const zx_type_225,
    items: []const *const zx_type_54,
    nodes: []const *const zx_type_224,
    parameters: []const *const zx_type_226,
    parts: []const *const zx_type_227,
};

pub const zx_type_235 = struct {
    allow_lambda: bool,
    callback: bool,
    condition: bool,
    count: u64,
    cursor: u64,
    depth: u64,
    end: u64,
    family: zx_type_214,
    first: u64,
    flag: bool,
    head: u64,
    index: u64,
    kind: zx_type_223,
    maximum: u64,
    minimum: u8,
    name: *const zx_type_46,
    operator: zx_type_213,
    reset_family: bool,
    second: u64,
    start: u64,
    stream: u64,
};

pub const zx_type_236 = struct {
    allow_lambda: bool,
    base_depth: u64,
    cursor: u64,
    depth: u64,
    diagnostic: *const zx_type_138,
    family: zx_type_214,
    fresh_family: bool,
    hint: *const zx_type_216,
    index: u64,
    last_end: u64,
    lexical_diagnostic: u64,
    minimum: u8,
    phase: zx_type_222,
    primary_start: u64,
    result: u64,
    root_index: u64,
    stream: u64,
    template: u64,
    template_count: u64,
    template_head: u64,
    template_maximum: u64,
    token: *const zx_type_133,
    type_argument: u64,
    type_diagnostic: bool,
};

pub const zx_type_238 = struct {
    control: *const zx_type_236,
    frames: []const *const zx_type_235,
    prepared: *const zx_type_220,
    tree: *const zx_type_234,
    types: *const zx_type_211,
};

pub const zx_type_239 = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    prepared: *const zx_type_220,
    start: u64,
    tree: *const zx_type_234,
    types: *const zx_type_211,
};

pub const zx_type_240 = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    prepared: *const zx_type_220,
    start: u64,
};

pub const zx_type_241 = enum { Constant, Destructure, Result, Branch, Switch, StoreSet, Evaluate, StateUpdate, };
pub const zx_type_242 = enum { Root, Block, Statement, Case, };
pub const zx_type_243 = enum { BlockOpen, BlockNext, Statement, ConstName, ConstAfterName, PatternName, PatternSeparator, ConstAssign, ReturnValue, IfOpen, IfClose, IfElse, IfAlternative, SwitchOpen, SwitchClose, SwitchBrace, SwitchCase, CaseColon, CaseBody, CaseNext, StoreAssign, UpdateOperator, UpdateAssign, BeginValue, BeginCondition, BeginSwitch, BeginCase, Value, Expression, Type, EndStatement, Publish, Resume, Done, };

pub const zx_type_244 = struct {
    annotation: u64,
    count: u64,
    first: u64,
    head: u64,
    kind: zx_type_241,
    name: *const zx_type_46,
    operator: zx_type_213,
    second: u64,
    span: *const zx_type_46,
    third: u64,
};

pub const zx_type_245 = struct {
    previous: u64,
    span: *const zx_type_46,
};

pub const zx_type_246 = struct {
    body: u64,
    previous: u64,
    span: *const zx_type_46,
    value: u64,
};

pub const zx_type_250 = struct {
    blocks: []const *const zx_type_49,
    cases: []const *const zx_type_246,
    items: []const *const zx_type_54,
    names: []const *const zx_type_245,
    statements: []const *const zx_type_244,
};

pub const zx_type_251 = struct {
    annotation: u64,
    count: u64,
    depth: u64,
    first: u64,
    head: u64,
    kind: zx_type_242,
    name: *const zx_type_46,
    operator: zx_type_213,
    phase: zx_type_243,
    second: u64,
    start: u64,
    statement: zx_type_241,
    third: u64,
};

pub const zx_type_252 = struct {
    diagnostic: *const zx_type_138,
    expression_diagnostic: bool,
    phase: zx_type_243,
    result: u64,
    @"resume": zx_type_243,
    state_block: bool,
};

pub const zx_type_254 = struct {
    control: *const zx_type_252,
    expression: *const zx_type_236,
    expression_frames: []const *const zx_type_235,
    frame: *const zx_type_251,
    frames: []const *const zx_type_251,
};

pub const zx_type_256 = struct {
    control: *const zx_type_252,
    expression: *const zx_type_238,
    frame: *const zx_type_251,
    frames: []const *const zx_type_251,
    suspended: []const *const zx_type_254,
    tree: *const zx_type_250,
};

pub const zx_type_257 = struct {
    depth: u64,
    kind: zx_type_242,
    start: u64,
};

pub const zx_type_258 = struct {
    expression: *const zx_type_238,
    expression_only: bool,
    state_block: bool,
    tree: *const zx_type_250,
};

pub const zx_type_259 = struct {
    hint: *const zx_type_216,
    template: u64,
    token: *const zx_type_133,
};

pub const zx_type_260 = struct {
    phase: zx_type_222,
    state: *const zx_type_238,
};

pub const zx_type_261 = struct {
    phase: zx_type_243,
    state: *const zx_type_256,
};

pub const zx_type_262 = struct {
    code: []const u8,
    message: []const u8,
    state: *const zx_type_256,
};

pub const zx_type_263 = struct {
    kind: zx_type_242,
    nested: bool,
    phase: zx_type_243,
    @"resume": zx_type_243,
    state: *const zx_type_256,
};

pub const zx_type_264 = struct { []const *const zx_type_251, void, };

pub const zx_type_265 = struct {
    message: []const u8,
    phase: zx_type_243,
    state: *const zx_type_256,
    symbol: zx_type_132,
};

pub const zx_type_266 = struct {
    depth: u64,
    minimum: u8,
    state: *const zx_type_238,
};

pub const zx_type_267 = struct {
    minimum: u8,
    @"resume": zx_type_243,
    state: *const zx_type_256,
};

pub const zx_type_269 = struct { []const *const zx_type_251, ?*const zx_type_251, };
pub const zx_type_270 = struct { []const *const zx_type_246, void, };
pub const zx_type_271 = struct { []const *const zx_type_245, void, };
pub const zx_type_272 = struct { []const *const zx_type_244, void, };

pub const zx_type_273 = struct {
    depth: u64,
    kind: zx_type_223,
    start: u64,
};

pub const zx_type_274 = struct {
    frame: *const zx_type_235,
    state: *const zx_type_238,
};

pub const zx_type_276 = struct { []const *const zx_type_235, ?*const zx_type_235, };

pub const zx_type_277 = struct {
    node: *const zx_type_224,
    state: *const zx_type_238,
};

pub const zx_type_278 = struct { []const *const zx_type_224, void, };

pub const zx_type_279 = struct {
    depth: u64,
    end: u64,
    kind: zx_type_221,
    start: u64,
};

pub const zx_type_280 = struct {
    code: []const u8,
    message: []const u8,
    state: *const zx_type_238,
};

pub const zx_type_281 = struct {
    state: *const zx_type_238,
    updating: bool,
};

pub const zx_type_282 = struct { []const *const zx_type_235, void, };
pub const zx_type_283 = struct { []const *const zx_type_226, void, };

pub const zx_type_284 = struct {
    child: u64,
    count: u64,
    head: u64,
    kind: zx_type_201,
    name: *const zx_type_46,
    state: *const zx_type_211,
};

pub const zx_type_285 = struct { []const *const zx_type_203, void, };

pub const zx_type_286 = struct {
    phase: zx_type_202,
    state: *const zx_type_211,
};

pub const zx_type_288 = struct { []const *const zx_type_208, ?*const zx_type_208, };

pub const zx_type_289 = struct {
    code: []const u8,
    message: []const u8,
    state: *const zx_type_211,
};

pub const zx_type_290 = struct {
    frame: *const zx_type_208,
    state: *const zx_type_211,
};

pub const zx_type_291 = struct { []const *const zx_type_208, void, };

pub const zx_type_292 = struct {
    kind: zx_type_201,
    name: *const zx_type_46,
    phase: zx_type_202,
    state: *const zx_type_211,
};

pub const zx_type_293 = struct { []const *const zx_type_204, void, };

pub const zx_type_294 = struct {
    state: *const zx_type_211,
    token: *const zx_type_133,
};

pub const zx_type_295 = struct {
    state: *const zx_type_238,
    type_argument: u64,
};

pub const zx_type_296 = struct { []const *const zx_type_225, void, };
pub const zx_type_297 = struct { []const *const zx_type_227, void, };
pub const zx_type_298 = struct { []const *const zx_type_228, void, };
pub const zx_type_299 = struct { []const *const zx_type_254, void, };
pub const zx_type_301 = struct { []const *const zx_type_254, ?*const zx_type_254, };

pub const zx_type_302 = struct {
    depth: u64,
    prepared: *const zx_type_220,
    start: u64,
    state_block: bool,
};

pub const zx_type_303 = struct {
    expression: *const zx_type_238,
    tree: *const zx_type_250,
};

pub const zx_type_304 = struct {
    body: *const zx_type_250,
    control: *const zx_type_236,
    frames: []const *const zx_type_235,
    prepared: *const zx_type_220,
    tree: *const zx_type_234,
    types: *const zx_type_211,
};

pub const zx_type_305 = enum { Start, Kind, Name, Open, Value, Member, Separator, Done, };

pub const zx_type_306 = struct {
    count: u64,
    enumeration: bool,
    first: u64,
    name: *const zx_type_46,
    span: *const zx_type_46,
    value: u64,
};

pub const zx_type_307 = struct {
    count: u64,
    depth: u64,
    diagnostic: *const zx_type_138,
    enumeration: bool,
    first: u64,
    index: u64,
    last_end: u64,
    name: *const zx_type_46,
    opening: u64,
    opening_index: u64,
    phase: zx_type_305,
    start: u64,
    token: *const zx_type_133,
    type_diagnostic: bool,
};

pub const zx_type_309 = struct {
    control: *const zx_type_307,
    declarations: []const *const zx_type_306,
    members: []const *const zx_type_46,
    types: *const zx_type_211,
};

pub const zx_type_310 = enum { Open, Input, Colon, InputName, ParameterEnd, StoreOpen, StoreName, StoreClose, StoreEnd, Close, ResultColon, ResultName, Contract, ContractOpen, Predicate, ContractClose, Done, };

pub const zx_type_311 = struct {
    ensures: bool,
    predicate: u64,
    span: *const zx_type_46,
};

pub const zx_type_312 = struct {
    contract_start: u64,
    diagnostic: *const zx_type_138,
    ensures: bool,
    expression_diagnostic: bool,
    has_ensures: bool,
    has_store: bool,
    phase: zx_type_310,
    token: *const zx_type_133,
};

pub const zx_type_314 = struct {
    body: *const zx_type_250,
    contracts: []const *const zx_type_311,
    control: *const zx_type_312,
    expression: *const zx_type_238,
};

pub const zx_type_315 = enum { Start, Binding, Name, Separator, From, Path, End, Done, };
pub const zx_type_316 = enum { Function, Enumeration, TypeOnly, };

pub const zx_type_317 = struct {
    count: u64,
    first: u64,
    kind: zx_type_316,
    path: *const zx_type_46,
    span: *const zx_type_46,
};

pub const zx_type_318 = struct {
    count: u64,
    diagnostic: *const zx_type_138,
    first: u64,
    index: u64,
    named: bool,
    opening: *const zx_type_46,
    path: *const zx_type_46,
    phase: zx_type_315,
    start: u64,
    token: *const zx_type_133,
    type_only: bool,
};

pub const zx_type_320 = struct {
    control: *const zx_type_318,
    imports: []const *const zx_type_317,
    names: []const *const zx_type_46,
};

pub const zx_type_321 = struct {
    blocks: *const zx_type_250,
    body: ?u64,
    comments: []const *const zx_type_46,
    contracts: []const *const zx_type_311,
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    expressions: *const zx_type_234,
    function_start: u64,
    has_store: bool,
    import_names: []const *const zx_type_46,
    imports: []const *const zx_type_317,
    members: []const *const zx_type_46,
    tokens: []const *const zx_type_133,
    types: *const zx_type_207,
};

pub const zx_type_322 = struct {
    blocks: *const zx_type_250,
    comments: []const *const zx_type_46,
    diagnostic: *const zx_type_138,
    expressions: *const zx_type_234,
    result: u64,
    tokens: []const *const zx_type_133,
    types: *const zx_type_207,
};

pub const zx_type_323 = struct {
    phase: zx_type_310,
    state: *const zx_type_314,
};

pub const zx_type_324 = struct {
    code: []const u8,
    message: []const u8,
    state: *const zx_type_314,
};

pub const zx_type_325 = struct {
    message: []const u8,
    phase: zx_type_310,
    state: *const zx_type_314,
    symbol: zx_type_132,
    word: zx_type_130,
};

pub const zx_type_326 = struct { []const *const zx_type_311, void, };

pub const zx_type_327 = struct {
    depth: u64,
    prepared: *const zx_type_220,
    start: u64,
};

pub const zx_type_328 = enum { Declarations, Start, Declare, Function, Name, Open, Inject, Parameter, Colon, ParameterType, Separator, OutputColon, OutputType, Throws, ErrorOpen, ErrorName, ErrorSeparator, Concurrent, End, Done, };

pub const zx_type_329 = struct {
    allocator_argument: bool,
    concurrent: bool,
    count: u64,
    error_count: u64,
    errors_present: bool,
    fallible: bool,
    first_error: u64,
    first_parameter: u64,
    io_argument: bool,
    name: *const zx_type_46,
    output: u64,
    process_argument: bool,
};

pub const zx_type_330 = struct {
    name: *const zx_type_46,
    value: u64,
};

pub const zx_type_331 = struct {
    current: *const zx_type_329,
    diagnostic: *const zx_type_138,
    index: u64,
    injected: u64,
    parameter: *const zx_type_46,
    phase: zx_type_328,
};

pub const zx_type_334 = struct {
    control: *const zx_type_331,
    declarations: *const zx_type_309,
    errors: []const *const zx_type_46,
    functions: []const *const zx_type_329,
    lexed: *const zx_type_145,
    parameters: []const *const zx_type_330,
};

pub const zx_type_335 = struct {
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    errors: []const *const zx_type_46,
    functions: []const *const zx_type_329,
    members: []const *const zx_type_46,
    parameters: []const *const zx_type_330,
    types: *const zx_type_207,
};

pub const zx_type_336 = struct {
    phase: zx_type_305,
    state: *const zx_type_309,
};

pub const zx_type_337 = struct {
    message: []const u8,
    state: *const zx_type_309,
};

pub const zx_type_338 = struct { []const *const zx_type_306, void, };

pub const zx_type_339 = struct {
    state: *const zx_type_309,
    token: *const zx_type_133,
};

pub const zx_type_340 = struct {
    count: u64,
    phase: zx_type_328,
    state: *const zx_type_334,
};

pub const zx_type_341 = struct {
    code: []const u8,
    message: []const u8,
    state: *const zx_type_334,
};

pub const zx_type_342 = struct { []const *const zx_type_329, void, };
pub const zx_type_343 = struct { []const *const zx_type_330, void, };

pub const zx_type_344 = struct {
    kind: zx_type_131,
    state: *const zx_type_218,
    symbol: zx_type_132,
    word: zx_type_130,
};

pub const zx_type_345 = struct { []const *const zx_type_216, void, };

pub const zx_type_346 = struct {
    kind: zx_type_131,
    symbol: zx_type_132,
    word: zx_type_130,
};

pub const zx_type_348 = struct { []const *const zx_type_346, void, };

pub const zx_type_349 = struct {
    imports: *const zx_type_320,
    prepared: *const zx_type_220,
};

pub const zx_type_350 = struct {
    message: []const u8,
    span: *const zx_type_46,
    state: *const zx_type_320,
};

pub const zx_type_351 = struct { []const *const zx_type_317, void, };

pub const zx_type_352 = struct {
    state: *const zx_type_320,
    token: *const zx_type_133,
};

pub const zx_type_353 = struct {
    index: u64,
    prepared: *const zx_type_220,
};

pub const zx_type_354 = struct {
    declarations: *const zx_type_309,
    prefix: *const zx_type_349,
};

pub const zx_type_355 = struct {
    diagnostic: *const zx_type_138,
    index: u64,
    present: bool,
    start: u64,
};

pub const zx_type_356 = struct {
    declaration_diagnostic: *const zx_type_138,
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    function_start: u64,
    import_diagnostic: *const zx_type_138,
    imports: []const *const zx_type_317,
    members: []const *const zx_type_46,
    names: []const *const zx_type_46,
    present: bool,
    type_diagnostic: bool,
};

pub const zx_type_357 = struct {
    header: *const zx_type_314,
    prefix: *const zx_type_356,
};

pub const zx_type_358 = struct {
    body: *const zx_type_256,
    contracts: []const *const zx_type_311,
    header: *const zx_type_312,
    prefix: *const zx_type_356,
};

pub const zx_type_359 = struct {
    depth: u64,
    start: u64,
    tokens: []const *const zx_type_133,
};

pub const zx_type_360 = struct {
    depth: u64,
    diagnostic: *const zx_type_138,
    start: u64,
};

pub const zx_type_361 = enum { File, Package, Zig, C, Standard, LegacyLibrary, Invalid, };

pub const zx_type_362 = struct {
    offset: u64,
    separator: u64,
    source: []const u8,
    valid: bool,
};

pub const zx_type_364 = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    source: []const u8,
    start: u64,
};

pub const zx_type_365 = struct {
    depth: u64,
    source: []const u8,
    start: u64,
    state_block: bool,
};

pub const zx_type_366 = struct {
    depth: u64,
    source: []const u8,
    start: u64,
};

pub const zx_type_367 = struct { *const zx_type_14, };
pub const zx_type_368 = struct { *const zx_type_14, *const zx_type_18, };
pub const zx_type_369 = struct { *const zx_type_27, };
pub const zx_type_370 = struct { *const zx_type_27, bool, };
pub const zx_type_371 = struct { []const u8, };
pub const zx_type_372 = struct { []const u8, []const *const zx_type_28, };
pub const zx_type_373 = struct { []const u8, []const *const zx_type_28, *const zx_type_35, };
pub const zx_type_374 = struct { *const zx_type_37, };
pub const zx_type_375 = struct { *const zx_type_37, zx_type_36, };
pub const zx_type_376 = struct { *const zx_type_39, };
pub const zx_type_377 = struct { *const zx_type_39, zx_type_38, };
pub const zx_type_378 = struct { []const u8, bool, };
pub const zx_type_379 = struct { []const u8, zx_type_41, };
pub const zx_type_380 = struct { *const zx_type_42, };
pub const zx_type_381 = struct { *const zx_type_42, *const zx_type_42, };
pub const zx_type_382 = struct { *const zx_type_42, *const zx_type_42, []const u8, };
pub const zx_type_383 = struct { *const zx_type_42, *const zx_type_42, []const u8, *const zx_type_63, };
pub const zx_type_384 = struct { []const u8, ?u64, };
pub const zx_type_385 = struct { *const zx_type_121, };
pub const zx_type_386 = struct { *const zx_type_121, *const zx_type_116, };
pub const zx_type_387 = struct { *const zx_type_128, };
pub const zx_type_388 = struct { *const zx_type_128, *const zx_type_127, };
pub const zx_type_389 = struct { *const zx_type_128, *const zx_type_127, u64, };

pub const value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    issues: []const zx_type_11,
    offsets: []const u64,
    targets: []const u64,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_15_aaa56cff424361d44bfd6e096281a697ea7ba1f132207b5ae6f511a597d171e8 = struct {
    count: u64,
    cursors: []const u64,
    depth: u64,
    edge: u64,
    frames: []const u64,
    graph: value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    issue: zx_type_11,
    marks: []const u64,
    order: []const u64,
    root: u64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_zx_type_17_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_17, };

pub const value_zx_type_18_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    count: u64,
    edge: u64,
    issue: zx_type_11,
    order: []const u64,
    zx_origin: ?*const zx_type_18 = null,
};

pub const value_zx_type_20_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    offset: u64,
    source: []const u8,
    text: []const u8,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    matches: bool,
    offset: u64,
    source: []const u8,
    text: []const u8,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    pattern: []const u8,
    source: []const u8,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    pattern: []const u8,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    offset: u64,
    source: []const u8,
    start: u64,
    valid: bool,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    kind: zx_type_24,
    path: []const u8,
    suffix: []const u8,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_30_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    dots: bool,
    offset: u64,
    segments: []const *const zx_type_28,
    start: u64,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    parents: u64,
    segments: []const *const zx_type_28,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_28, void, ?*const zx_type_32, };

pub const value_zx_type_33_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b = struct {
    byte: u8,
    state: value_zx_type_30_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = struct {
    end: u64,
    parent: bool,
    start: u64,
    state: value_zx_type_31_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_34 = null,
};

pub const value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    segments: []const *const zx_type_28,
    valid: bool,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    attribute: []const u8,
    element: []const u8,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_39_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    has_function: bool,
    has_input: bool,
    has_module: bool,
    has_setter: bool,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    high: u8,
    low: u8,
    remaining: u8,
    valid: bool,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_44_455ec73b9aeac5def17353be03fafb63798ca6f942034cf59d8714d7d36a663b = struct {
    byte: u8,
    state: value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    zx_origin: ?*const zx_type_44 = null,
};

pub const value_zx_type_45_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    first: u8,
    second: u8,
    valid: bool,
    zx_origin: ?*const zx_type_45 = null,
};

pub const value_zx_type_61_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    attributes: []const *const zx_type_52,
    children: []const *const zx_type_54,
    nodes: []const *const zx_type_55,
    parts: []const *const zx_type_48,
    text: []const *const zx_type_53,
    zx_origin: ?*const zx_type_61 = null,
};

pub const value_zx_type_62_27f6baed02dfb16b8bbeaef695a80d4899de28e19dde605fcd26d176c6e70749 = struct {
    attribute: *const zx_type_46,
    attribute_location: *const zx_type_47,
    expressions: bool,
    issue: *const zx_type_47,
    location: *const zx_type_47,
    message: []const u8,
    phase: zx_type_50,
    result: u64,
    terminator: u8,
    text_start: u64,
    value_count: u64,
    value_head: u64,
    value_kind: zx_type_51,
    value_location: *const zx_type_47,
    value_start: u64,
    zx_origin: ?*const zx_type_62 = null,
};

pub const value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9 = struct {
    control: value_zx_type_62_27f6baed02dfb16b8bbeaef695a80d4899de28e19dde605fcd26d176c6e70749,
    frame: *const zx_type_55,
    frames: []const *const zx_type_55,
    source: []const u8,
    tree: value_zx_type_61_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_63 = null,
};

pub const value_zx_type_64_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    expressions: bool,
    message: []const u8,
    source: []const u8,
    zx_origin: ?*const zx_type_64 = null,
};

pub const value_zx_type_65_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    done: bool,
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_65 = null,
};

pub const value_zx_type_66_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    count: u64,
    location: *const zx_type_47,
    source: []const u8,
    zx_origin: ?*const zx_type_66 = null,
};

pub const value_zx_type_67_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    column: u64,
    end: u64,
    line: u64,
    offset: u64,
    previous_cr: bool,
    source: []const u8,
    zx_origin: ?*const zx_type_67 = null,
};

pub const value_zx_type_68_f55ebb04e8ad599a71f5ca82355cb7e15b79bfa8fe1c64be5b9b867a443f9c63 = struct {
    count: u64,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    zx_origin: ?*const zx_type_68 = null,
};

pub const value_zx_type_69_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    end: u64,
    message: []const u8,
    zx_origin: ?*const zx_type_69 = null,
};

pub const value_zx_type_70_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    left: *const zx_type_46,
    right: *const zx_type_46,
    source: []const u8,
    zx_origin: ?*const zx_type_70 = null,
};

pub const value_zx_type_71_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    end: u64,
    left: u64,
    matches: bool,
    right: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_71 = null,
};

pub const value_zx_type_72_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    attributes: []const *const zx_type_52,
    head: u64,
    name: *const zx_type_46,
    source: []const u8,
    zx_origin: ?*const zx_type_72 = null,
};

pub const value_zx_type_73_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    attributes: []const *const zx_type_52,
    found: bool,
    head: u64,
    name: *const zx_type_46,
    source: []const u8,
    zx_origin: ?*const zx_type_73 = null,
};

pub const value_zx_type_77_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    comment_start: u64,
    done: bool,
    frame: *const zx_type_75,
    frames: []const *const zx_type_75,
    issue: u64,
    message: []const u8,
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_77 = null,
};

pub const value_zx_type_78_bc0beef4baed6cbec65527f285ce2af317364f06c28bd549a5782c80f0e63a13 = struct {
    message: []const u8,
    offset: u64,
    state: value_zx_type_77_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_78 = null,
};

pub const value_zx_type_80_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_75, ?*const zx_type_75, ?*const zx_type_80, };

pub const value_zx_type_81_c84c26a9aeeadffae2c520ceec3a77677925bb0a1e531f432a4ef6320a255d60 = struct {
    depth: u64,
    mode: zx_type_74,
    offset: u64,
    start: u64,
    state: value_zx_type_77_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_81 = null,
};

pub const value_zx_type_82_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_75, void, ?*const zx_type_82, };

pub const value_zx_type_83_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    end: u64,
    message: []const u8,
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_83 = null,
};

pub const value_zx_type_84_f55ebb04e8ad599a71f5ca82355cb7e15b79bfa8fe1c64be5b9b867a443f9c63 = struct {
    message: []const u8,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    zx_origin: ?*const zx_type_84 = null,
};

pub const value_zx_type_85_fc14c5a403b4432a27e2ccf277256288968901fe7047d8839ab9358ffd1c9b0e = struct {
    expression: bool,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    value: *const zx_type_49,
    zx_origin: ?*const zx_type_85 = null,
};

pub const value_zx_type_86_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_52, void, ?*const zx_type_86, };
pub const value_zx_type_87_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_53, void, ?*const zx_type_87, };

pub const value_zx_type_88_fc14c5a403b4432a27e2ccf277256288968901fe7047d8839ab9358ffd1c9b0e = struct {
    kind: zx_type_51,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    terminator: u8,
    zx_origin: ?*const zx_type_88 = null,
};

pub const value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_55, void, ?*const zx_type_89, };
pub const value_zx_type_91_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_55, ?*const zx_type_55, ?*const zx_type_91, };
pub const value_zx_type_92_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_54, void, ?*const zx_type_92, };

pub const value_zx_type_93_f55ebb04e8ad599a71f5ca82355cb7e15b79bfa8fe1c64be5b9b867a443f9c63 = struct {
    phase: zx_type_50,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    zx_origin: ?*const zx_type_93 = null,
};

pub const value_zx_type_95_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    done: bool,
    issue: zx_type_94,
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_95 = null,
};

pub const value_zx_type_97_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    count: u64,
    done: bool,
    encoding: bool,
    issue: zx_type_96,
    offset: u64,
    source: []const u8,
    standalone: bool,
    zx_origin: ?*const zx_type_97 = null,
};

pub const value_zx_type_98_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    ignore_case: bool,
    source: []const u8,
    span: *const zx_type_46,
    text: []const u8,
    zx_origin: ?*const zx_type_98 = null,
};

pub const value_zx_type_99_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    ignore_case: bool,
    index: u64,
    matches: bool,
    offset: u64,
    source: []const u8,
    text: []const u8,
    zx_origin: ?*const zx_type_99 = null,
};

pub const value_zx_type_100_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    byte: u8,
    offset: u64,
    source: []const u8,
    zx_origin: ?*const zx_type_100 = null,
};

pub const value_zx_type_101_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    end: u64,
    hexadecimal: bool,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_101 = null,
};

pub const value_zx_type_102_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    codepoint: u64,
    message: []const u8,
    zx_origin: ?*const zx_type_102 = null,
};

pub const value_zx_type_103_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    end: u64,
    offset: u64,
    overflow: bool,
    radix: u64,
    source: []const u8,
    valid: bool,
    value: u64,
    zx_origin: ?*const zx_type_103 = null,
};

pub const value_zx_type_104_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    end: u64,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_104 = null,
};

pub const value_zx_type_105_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_48, void, ?*const zx_type_105, };

pub const value_zx_type_106_453ee70fa4d6ed141b091f0cf83e5d7da3a72caede555ddeb415b523da83cd56 = struct {
    codepoint: u64,
    count: u64,
    state: value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9,
    zx_origin: ?*const zx_type_106 = null,
};

pub const value_zx_type_107_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    negative: bool,
    offset: u64,
    seen: bool,
    source: []const u8,
    started: bool,
    valid: bool,
    value: u64,
    zx_origin: ?*const zx_type_107 = null,
};

pub const value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_111,
    delta: *const zx_type_111,
    zx_origin: ?*const zx_type_112 = null,
};

pub const value_zx_type_113_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_108,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_113 = null,
};

pub const value_zx_type_114_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_114 = null,
};

pub const value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_114_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_108,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_115 = null,
};

pub const value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_116 = null,
};

pub const value_zx_type_117_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_111,
    id: u32,
    zx_origin: ?*const zx_type_117 = null,
};

pub const value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    id: u32,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_118 = null,
};

pub const value_zx_type_119_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    id: u32,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_119 = null,
};

pub const value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_111,
    zx_origin: ?*const zx_type_120 = null,
};

pub const value_zx_type_121_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22 = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_121 = null,
};

pub const value_zx_type_122_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_122 = null,
};

pub const value_zx_type_123_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
    zx_origin: ?*const zx_type_123 = null,
};

pub const value_zx_type_125_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_124,
    delta: *const zx_type_124,
    zx_origin: ?*const zx_type_125 = null,
};

pub const value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    id: u32,
    status: zx_type_126,
    zx_origin: ?*const zx_type_127 = null,
};

pub const value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1 = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    origin: value_zx_type_123_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    origins: value_zx_type_125_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_128 = null,
};

pub const value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = struct {
    candidate: value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    id: u32,
    index: u64,
    origin: value_zx_type_123_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    origins: value_zx_type_125_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    status: zx_type_126,
    tables: value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_129 = null,
};

pub const value_zx_type_136_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    diagnostic: []const u8,
    end: u64,
    zx_origin: ?*const zx_type_136 = null,
};

pub const value_zx_type_144_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_143,
    zx_origin: ?*const zx_type_144 = null,
};

pub const value_zx_type_153_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    events: []const *const zx_type_149,
    lexed: *const zx_type_145,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
    zx_origin: ?*const zx_type_153 = null,
};

pub const value_zx_type_156_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    interpolations: []const *const zx_type_154,
    lexed: *const zx_type_145,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
    zx_origin: ?*const zx_type_156 = null,
};

pub const value_zx_type_157_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    comment: bool,
    end: u64,
    kind: []const u8,
    start: u64,
    state: *const zx_type_143,
    zx_origin: ?*const zx_type_157 = null,
};

pub const value_zx_type_158_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_46, void, ?*const zx_type_158, };
pub const value_zx_type_159_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_133, void, ?*const zx_type_159, };

pub const value_zx_type_160_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    state: *const zx_type_143,
    zx_origin: ?*const zx_type_160 = null,
};

pub const value_zx_type_161_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    count: u64,
    ids: []const u64,
    template: u64,
    zx_origin: ?*const zx_type_161 = null,
};

pub const value_zx_type_162_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    ids: []const u64,
    zx_origin: ?*const zx_type_162 = null,
};

pub const value_zx_type_163_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_163, };

pub const value_zx_type_166_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    events: []const *const zx_type_149,
    frames: []const *const zx_type_164,
    interpolations: u64,
    parts: []const *const zx_type_148,
    templates: []const *const zx_type_49,
    token_templates: []const u64,
    zx_origin: ?*const zx_type_166 = null,
};

pub const value_zx_type_167_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    graph: value_zx_type_166_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    lexer: *const zx_type_143,
    zx_origin: ?*const zx_type_167 = null,
};

pub const value_zx_type_168_2ee1b437c3c7b243726987cbde925c71258c6f631fef5cb1befd6f163418e133 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_zx_type_167_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189,
    zx_origin: ?*const zx_type_168 = null,
};

pub const value_zx_type_169_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    byte: u8,
    keyword: zx_type_130,
    zx_origin: ?*const zx_type_169 = null,
};

pub const value_zx_type_170_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    zx_origin: ?*const zx_type_170 = null,
};

pub const value_zx_type_171_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    byte: u8,
    length: u64,
    next: u8,
    zx_origin: ?*const zx_type_171 = null,
};

pub const value_zx_type_172_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_139, void, ?*const zx_type_172, };

pub const value_zx_type_173_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    byte: u8,
    state: *const zx_type_135,
    zx_origin: ?*const zx_type_173 = null,
};

pub const value_zx_type_175_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_139, ?*const zx_type_139, ?*const zx_type_175, };

pub const value_zx_type_176_e366d4f93466af93bfbf8b4815757383af115756f7364062c2c9d566a0fb2311 = struct {
    graph: value_zx_type_166_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    interpolation: u64,
    kind: zx_type_146,
    span: *const zx_type_46,
    text_start: u64,
    zx_origin: ?*const zx_type_176 = null,
};

pub const value_zx_type_177_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_148, void, ?*const zx_type_177, };
pub const value_zx_type_179_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_164, ?*const zx_type_164, ?*const zx_type_179, };
pub const value_zx_type_180_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_164, void, ?*const zx_type_180, };

pub const value_zx_type_181_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    graph: value_zx_type_166_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    offset: u64,
    zx_origin: ?*const zx_type_181 = null,
};

pub const value_zx_type_182_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_149, void, ?*const zx_type_182, };
pub const value_zx_type_183_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_49, void, ?*const zx_type_183, };

pub const value_zx_type_184_ea1b7ae541093ece52c59f2de2f23eb593426bae77184c88543e9788bf3186e6 = struct {
    braces: u64,
    byte: u8,
    graph: value_zx_type_166_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    has_next: bool,
    mode: zx_type_137,
    next: u8,
    offset: u64,
    zx_origin: ?*const zx_type_184 = null,
};

pub const value_zx_type_185_e41dba34f76afd34a5fb7345932a9f0d46cd277adb7113135fd86d14513ea8dd = struct {
    byte: u8,
    state: value_zx_type_167_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189,
    zx_origin: ?*const zx_type_185 = null,
};

pub const value_zx_type_189_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    active: *const zx_type_186,
    event_index: u64,
    events: []const *const zx_type_149,
    interpolations: []const *const zx_type_154,
    length: u64,
    offset: u64,
    parents: []const *const zx_type_187,
    skip: bool,
    zx_origin: ?*const zx_type_189 = null,
};

pub const value_zx_type_190_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    end: u64,
    present: bool,
    start: u64,
    zx_origin: ?*const zx_type_190 = null,
};

pub const value_zx_type_191_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    events: []const *const zx_type_149,
    length: u64,
    zx_origin: ?*const zx_type_191 = null,
};

pub const value_zx_type_192_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    end: u64,
    session: *const zx_type_186,
    zx_origin: ?*const zx_type_192 = null,
};

pub const value_zx_type_193_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_154, void, ?*const zx_type_193, };

pub const value_zx_type_194_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    end: u64,
    session: *const zx_type_186,
    start: u64,
    template: u64,
    zx_origin: ?*const zx_type_194 = null,
};

pub const value_zx_type_195_3fd235e03c65a6809dbfc1f8c9af05ad3740e7bdb3ee2ec0b25cf4f091780922 = struct {
    state: value_zx_type_189_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    template: u64,
    zx_origin: ?*const zx_type_195 = null,
};

pub const value_zx_type_197_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_187, ?*const zx_type_187, ?*const zx_type_197, };
pub const value_zx_type_198_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_187, void, ?*const zx_type_198, };

pub const value_zx_type_199_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    byte: u8,
    state: *const zx_type_143,
    zx_origin: ?*const zx_type_199 = null,
};

pub const value_zx_type_200_e13f2ae2715b62f8bb48c4d65f0c60942a231b21f296c9a31710843cfcd55d77 = struct {
    byte: u8,
    state: value_zx_type_189_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    zx_origin: ?*const zx_type_200 = null,
};

pub const value_zx_type_207_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    fields: []const *const zx_type_204,
    items: []const *const zx_type_54,
    nodes: []const *const zx_type_203,
    zx_origin: ?*const zx_type_207 = null,
};

pub const value_zx_type_209_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    depth: u64,
    diagnostic: *const zx_type_138,
    index: u64,
    name: *const zx_type_46,
    phase: zx_type_202,
    result: u64,
    start: u64,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_209 = null,
};

pub const value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99 = struct {
    control: value_zx_type_209_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    frames: []const *const zx_type_208,
    tree: value_zx_type_207_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_211 = null,
};

pub const value_zx_type_212_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    depth: u64,
    start: u64,
    zx_origin: ?*const zx_type_212 = null,
};

pub const value_zx_type_218_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    after_identifier: bool,
    arrow: bool,
    hints: []const *const zx_type_216,
    parameter_start: bool,
    zx_origin: ?*const zx_type_218 = null,
};

pub const value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1 = struct {
    hints: []const *const zx_type_216,
    interpolation_hints: []const []const *const zx_type_216,
    lexical: value_zx_type_156_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_220 = null,
};

pub const value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    arms: []const *const zx_type_228,
    fields: []const *const zx_type_225,
    items: []const *const zx_type_54,
    nodes: []const *const zx_type_224,
    parameters: []const *const zx_type_226,
    parts: []const *const zx_type_227,
    zx_origin: ?*const zx_type_234 = null,
};

pub const value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e = struct {
    control: *const zx_type_236,
    frames: []const *const zx_type_235,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    tree: value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    types: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_238 = null,
};

pub const value_zx_type_239_2bcbc5056b375c8cf4abd675e3f8f6111556257fec95587c4771a497329b2eef = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    start: u64,
    tree: value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    types: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_239 = null,
};

pub const value_zx_type_240_a850ca5e0d4e0441ff179f8f89acd818706dc92461dc87c4c99d7ebc33dc937a = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    start: u64,
    zx_origin: ?*const zx_type_240 = null,
};

pub const value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    blocks: []const *const zx_type_49,
    cases: []const *const zx_type_246,
    items: []const *const zx_type_54,
    names: []const *const zx_type_245,
    statements: []const *const zx_type_244,
    zx_origin: ?*const zx_type_250 = null,
};

pub const value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524 = struct {
    control: *const zx_type_252,
    expression: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    frame: *const zx_type_251,
    frames: []const *const zx_type_251,
    suspended: []const *const zx_type_254,
    tree: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_256 = null,
};

pub const value_zx_type_257_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    depth: u64,
    kind: zx_type_242,
    start: u64,
    zx_origin: ?*const zx_type_257 = null,
};

pub const value_zx_type_258_92c1d7b280faa670c3459e62cbded8cc8a8f3ff93d19fdf493f817914a8a8d77 = struct {
    expression: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    expression_only: bool,
    state_block: bool,
    tree: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_258 = null,
};

pub const value_zx_type_259_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    hint: *const zx_type_216,
    template: u64,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_259 = null,
};

pub const value_zx_type_260_7fa4181557a985a506927b22a31784ed1fd77cf5800b74f3a5e51b0976448b30 = struct {
    phase: zx_type_222,
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_260 = null,
};

pub const value_zx_type_261_b5035a54e5c51e6bc81e0228ed7980b3df614234449d6d75a5de4d858c9004c7 = struct {
    phase: zx_type_243,
    state: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    zx_origin: ?*const zx_type_261 = null,
};

pub const value_zx_type_262_490374fb11629108ba1aa9e40002bea289147dc3e4dee945e378309c15d1939f = struct {
    code: []const u8,
    message: []const u8,
    state: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    zx_origin: ?*const zx_type_262 = null,
};

pub const value_zx_type_263_a45a6e8dac3d7e2f824cc0d33244e8f0b04d6bade68a226d385d61f67d1f0027 = struct {
    kind: zx_type_242,
    nested: bool,
    phase: zx_type_243,
    @"resume": zx_type_243,
    state: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    zx_origin: ?*const zx_type_263 = null,
};

pub const value_zx_type_264_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_251, void, ?*const zx_type_264, };

pub const value_zx_type_265_3555ef38ea5101bd05c3bb9007d790ebf70eef0e01159ec95160a75140aab1f5 = struct {
    message: []const u8,
    phase: zx_type_243,
    state: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    symbol: zx_type_132,
    zx_origin: ?*const zx_type_265 = null,
};

pub const value_zx_type_266_3b68efdc701daa072430441dbe6c51c44fdaad39b95355fa264e4c4b94ff913a = struct {
    depth: u64,
    minimum: u8,
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_266 = null,
};

pub const value_zx_type_267_490374fb11629108ba1aa9e40002bea289147dc3e4dee945e378309c15d1939f = struct {
    minimum: u8,
    @"resume": zx_type_243,
    state: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    zx_origin: ?*const zx_type_267 = null,
};

pub const value_zx_type_269_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_251, ?*const zx_type_251, ?*const zx_type_269, };
pub const value_zx_type_270_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_246, void, ?*const zx_type_270, };
pub const value_zx_type_271_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_245, void, ?*const zx_type_271, };
pub const value_zx_type_272_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_244, void, ?*const zx_type_272, };

pub const value_zx_type_273_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    depth: u64,
    kind: zx_type_223,
    start: u64,
    zx_origin: ?*const zx_type_273 = null,
};

pub const value_zx_type_274_7fa4181557a985a506927b22a31784ed1fd77cf5800b74f3a5e51b0976448b30 = struct {
    frame: *const zx_type_235,
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_274 = null,
};

pub const value_zx_type_276_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_235, ?*const zx_type_235, ?*const zx_type_276, };

pub const value_zx_type_277_7fa4181557a985a506927b22a31784ed1fd77cf5800b74f3a5e51b0976448b30 = struct {
    node: *const zx_type_224,
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_277 = null,
};

pub const value_zx_type_278_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_224, void, ?*const zx_type_278, };

pub const value_zx_type_279_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    depth: u64,
    end: u64,
    kind: zx_type_221,
    start: u64,
    zx_origin: ?*const zx_type_279 = null,
};

pub const value_zx_type_280_3b68efdc701daa072430441dbe6c51c44fdaad39b95355fa264e4c4b94ff913a = struct {
    code: []const u8,
    message: []const u8,
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_280 = null,
};

pub const value_zx_type_281_7f404930781229613e820a44e8441edc8aa8b77080d2c4c4045556fd7e9cdf1e = struct {
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    updating: bool,
    zx_origin: ?*const zx_type_281 = null,
};

pub const value_zx_type_282_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_235, void, ?*const zx_type_282, };
pub const value_zx_type_283_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_226, void, ?*const zx_type_283, };

pub const value_zx_type_284_dbdbac3a480688e0bb9d9b2a87b0d12ecc428645e8aa4b5cc74f99f9fad2a1c2 = struct {
    child: u64,
    count: u64,
    head: u64,
    kind: zx_type_201,
    name: *const zx_type_46,
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_284 = null,
};

pub const value_zx_type_285_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_203, void, ?*const zx_type_285, };

pub const value_zx_type_286_65cb7af22b4a0a687091344648bca17a7a863bb299f26abe21820d9cf423ae8c = struct {
    phase: zx_type_202,
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_286 = null,
};

pub const value_zx_type_288_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_208, ?*const zx_type_208, ?*const zx_type_288, };

pub const value_zx_type_289_74323c4158c6fd79e3005ac8b7aa86c8ee4afeccd834762ad5bb09fbbd1c0493 = struct {
    code: []const u8,
    message: []const u8,
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_289 = null,
};

pub const value_zx_type_290_65cb7af22b4a0a687091344648bca17a7a863bb299f26abe21820d9cf423ae8c = struct {
    frame: *const zx_type_208,
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_290 = null,
};

pub const value_zx_type_291_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_208, void, ?*const zx_type_291, };

pub const value_zx_type_292_96b7a459e9c87af54762817d3e207603dee628f382033c528514077a1cae1f99 = struct {
    kind: zx_type_201,
    name: *const zx_type_46,
    phase: zx_type_202,
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_292 = null,
};

pub const value_zx_type_293_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_204, void, ?*const zx_type_293, };

pub const value_zx_type_294_e60347c65124ac38daf1a20e53521b14a8b8d0c4c81d798bcb4077a9a08a6ce2 = struct {
    state: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_294 = null,
};

pub const value_zx_type_295_7f404930781229613e820a44e8441edc8aa8b77080d2c4c4045556fd7e9cdf1e = struct {
    state: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    type_argument: u64,
    zx_origin: ?*const zx_type_295 = null,
};

pub const value_zx_type_296_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_225, void, ?*const zx_type_296, };
pub const value_zx_type_297_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_227, void, ?*const zx_type_297, };
pub const value_zx_type_298_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_228, void, ?*const zx_type_298, };
pub const value_zx_type_299_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_254, void, ?*const zx_type_299, };
pub const value_zx_type_301_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const *const zx_type_254, ?*const zx_type_254, ?*const zx_type_301, };

pub const value_zx_type_302_560bb7a4d5f073d9a2fc467df6fe7afb2097343a0dc83f5559d8530944ca1024 = struct {
    depth: u64,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    start: u64,
    state_block: bool,
    zx_origin: ?*const zx_type_302 = null,
};

pub const value_zx_type_303_949667bd8c9168f4ea38146cacf2cf8a0613b4f5994a87bb919762898bc6062e = struct {
    expression: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    tree: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_303 = null,
};

pub const value_zx_type_304_478eb7d0979249227fcf0280c04d35311ca97bb554ab8daef38a0a219f7069e1 = struct {
    body: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    control: *const zx_type_236,
    frames: []const *const zx_type_235,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    tree: value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    types: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_304 = null,
};

pub const value_zx_type_307_1f6cf931ff1653b987809c8802c1c5135603b2eaa9fca3d6a77de94ccab3545b = struct {
    count: u64,
    depth: u64,
    diagnostic: *const zx_type_138,
    enumeration: bool,
    first: u64,
    index: u64,
    last_end: u64,
    name: *const zx_type_46,
    opening: u64,
    opening_index: u64,
    phase: zx_type_305,
    start: u64,
    token: *const zx_type_133,
    type_diagnostic: bool,
    zx_origin: ?*const zx_type_307 = null,
};

pub const value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea = struct {
    control: value_zx_type_307_1f6cf931ff1653b987809c8802c1c5135603b2eaa9fca3d6a77de94ccab3545b,
    declarations: []const *const zx_type_306,
    members: []const *const zx_type_46,
    types: value_zx_type_211_3d4acdf86258039cbdbe5c274a8acd76d0c1d090dc7f46092a910e9027d72b99,
    zx_origin: ?*const zx_type_309 = null,
};

pub const value_zx_type_312_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    contract_start: u64,
    diagnostic: *const zx_type_138,
    ensures: bool,
    expression_diagnostic: bool,
    has_ensures: bool,
    has_store: bool,
    phase: zx_type_310,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_312 = null,
};

pub const value_zx_type_314_2b945e954668d79a1828a63af686318e734737f524f3484029ebbdb1c25be8f2 = struct {
    body: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    contracts: []const *const zx_type_311,
    control: value_zx_type_312_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    expression: value_zx_type_238_b14d81bd852082d928c7e97a3a48f317953fa9f765bc0c0407cdb3f926b69b5e,
    zx_origin: ?*const zx_type_314 = null,
};

pub const value_zx_type_318_e94c22d54df2577542e5f7da583caa35b601e7dc58d30f5a71ec9a9dd45d3f6d = struct {
    count: u64,
    diagnostic: *const zx_type_138,
    first: u64,
    index: u64,
    named: bool,
    opening: *const zx_type_46,
    path: *const zx_type_46,
    phase: zx_type_315,
    start: u64,
    token: *const zx_type_133,
    type_only: bool,
    zx_origin: ?*const zx_type_318 = null,
};

pub const value_zx_type_320_74ed739624cff66047721e4df18908cd0e813cc99bd4a24ae4f125763c8bb979 = struct {
    control: value_zx_type_318_e94c22d54df2577542e5f7da583caa35b601e7dc58d30f5a71ec9a9dd45d3f6d,
    imports: []const *const zx_type_317,
    names: []const *const zx_type_46,
    zx_origin: ?*const zx_type_320 = null,
};

pub const value_zx_type_321_98b1b942e54ad4de1c559c0afca1d1e8700968f48be1ba4ce091a0117c9042b9 = struct {
    blocks: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    body: ?u64,
    comments: []const *const zx_type_46,
    contracts: []const *const zx_type_311,
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    expressions: value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    function_start: u64,
    has_store: bool,
    import_names: []const *const zx_type_46,
    imports: []const *const zx_type_317,
    members: []const *const zx_type_46,
    tokens: []const *const zx_type_133,
    types: value_zx_type_207_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_321 = null,
};

pub const value_zx_type_322_cf861ecdf2dd35492aa9b049fab0f12a8791e5a7e7d7b29e6526bf853d5f3a6e = struct {
    blocks: value_zx_type_250_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    comments: []const *const zx_type_46,
    diagnostic: *const zx_type_138,
    expressions: value_zx_type_234_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    result: u64,
    tokens: []const *const zx_type_133,
    types: value_zx_type_207_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_322 = null,
};

pub const value_zx_type_323_842662395182ba06c53f6233ff182cb877f2d14adf983d735350c2e2ab3989f1 = struct {
    phase: zx_type_310,
    state: value_zx_type_314_2b945e954668d79a1828a63af686318e734737f524f3484029ebbdb1c25be8f2,
    zx_origin: ?*const zx_type_323 = null,
};

pub const value_zx_type_324_cb12ae0354ef9a7b0ad942718b433ec227171d4c986508e9810b78833331750b = struct {
    code: []const u8,
    message: []const u8,
    state: value_zx_type_314_2b945e954668d79a1828a63af686318e734737f524f3484029ebbdb1c25be8f2,
    zx_origin: ?*const zx_type_324 = null,
};

pub const value_zx_type_325_2f5d77901c7ef668169e2e46abbecc10c41614cc4d3b591b2ccd133261aecf3d = struct {
    message: []const u8,
    phase: zx_type_310,
    state: value_zx_type_314_2b945e954668d79a1828a63af686318e734737f524f3484029ebbdb1c25be8f2,
    symbol: zx_type_132,
    word: zx_type_130,
    zx_origin: ?*const zx_type_325 = null,
};

pub const value_zx_type_326_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_311, void, ?*const zx_type_326, };

pub const value_zx_type_327_052649772570e9e1a779a1ca8a51af5149fa9264c16507a20b9a91c1b77a4c73 = struct {
    depth: u64,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    start: u64,
    zx_origin: ?*const zx_type_327 = null,
};

pub const value_zx_type_331_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    current: *const zx_type_329,
    diagnostic: *const zx_type_138,
    index: u64,
    injected: u64,
    parameter: *const zx_type_46,
    phase: zx_type_328,
    zx_origin: ?*const zx_type_331 = null,
};

pub const value_zx_type_334_98c4f25de91df6a683e085c44ed62ffde457104eda7522af14d002fefd39ae1b = struct {
    control: value_zx_type_331_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    declarations: value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea,
    errors: []const *const zx_type_46,
    functions: []const *const zx_type_329,
    lexed: *const zx_type_145,
    parameters: []const *const zx_type_330,
    zx_origin: ?*const zx_type_334 = null,
};

pub const value_zx_type_335_32295c02b6473c9eaee08be8884734bfc2452a2b88208b6e8d8d9cbdac4f7c90 = struct {
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    errors: []const *const zx_type_46,
    functions: []const *const zx_type_329,
    members: []const *const zx_type_46,
    parameters: []const *const zx_type_330,
    types: value_zx_type_207_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_335 = null,
};

pub const value_zx_type_336_880440e811ba58da330f67efc4a97933c3e5a5298cee9c2cb1994eb63ac5c80c = struct {
    phase: zx_type_305,
    state: value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea,
    zx_origin: ?*const zx_type_336 = null,
};

pub const value_zx_type_337_880440e811ba58da330f67efc4a97933c3e5a5298cee9c2cb1994eb63ac5c80c = struct {
    message: []const u8,
    state: value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea,
    zx_origin: ?*const zx_type_337 = null,
};

pub const value_zx_type_338_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_306, void, ?*const zx_type_338, };

pub const value_zx_type_339_587875a76cb282e97d9912eaba26f982636db4d1dc1199b860efaefc52bf634f = struct {
    state: value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_339 = null,
};

pub const value_zx_type_340_8d6e8c3e50a8fd1b24be47000790023ad1c2bbc46b42ae31f8513be59c349788 = struct {
    count: u64,
    phase: zx_type_328,
    state: value_zx_type_334_98c4f25de91df6a683e085c44ed62ffde457104eda7522af14d002fefd39ae1b,
    zx_origin: ?*const zx_type_340 = null,
};

pub const value_zx_type_341_8d6e8c3e50a8fd1b24be47000790023ad1c2bbc46b42ae31f8513be59c349788 = struct {
    code: []const u8,
    message: []const u8,
    state: value_zx_type_334_98c4f25de91df6a683e085c44ed62ffde457104eda7522af14d002fefd39ae1b,
    zx_origin: ?*const zx_type_341 = null,
};

pub const value_zx_type_342_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_329, void, ?*const zx_type_342, };
pub const value_zx_type_343_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_330, void, ?*const zx_type_343, };

pub const value_zx_type_344_3a2d3372119d766901b9e73d1d1a1cb69e32e364aec8da316dab97f3e55fcf11 = struct {
    kind: zx_type_131,
    state: value_zx_type_218_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    symbol: zx_type_132,
    word: zx_type_130,
    zx_origin: ?*const zx_type_344 = null,
};

pub const value_zx_type_345_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_216, void, ?*const zx_type_345, };
pub const value_zx_type_348_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_346, void, ?*const zx_type_348, };

pub const value_zx_type_349_b673806bf780797b250bc79743f607cedef2f47ff3095be2e08bede0e013c780 = struct {
    imports: value_zx_type_320_74ed739624cff66047721e4df18908cd0e813cc99bd4a24ae4f125763c8bb979,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    zx_origin: ?*const zx_type_349 = null,
};

pub const value_zx_type_350_8999b33bedf11f28c88abbae648ad03c330dee8c36f3e054c801280c89c4c7cf = struct {
    message: []const u8,
    span: *const zx_type_46,
    state: value_zx_type_320_74ed739624cff66047721e4df18908cd0e813cc99bd4a24ae4f125763c8bb979,
    zx_origin: ?*const zx_type_350 = null,
};

pub const value_zx_type_351_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_317, void, ?*const zx_type_351, };

pub const value_zx_type_352_7e17ef8dfa501169a62bfb2545f83ac5a0ca6e4560881fd01c72e29a5047fd19 = struct {
    state: value_zx_type_320_74ed739624cff66047721e4df18908cd0e813cc99bd4a24ae4f125763c8bb979,
    token: *const zx_type_133,
    zx_origin: ?*const zx_type_352 = null,
};

pub const value_zx_type_353_0731ad0b6305819527f701fdb3f90b0e263654b39ccff2c08dbd0ab493df0728 = struct {
    index: u64,
    prepared: value_zx_type_220_d46d81b23fe7b76cbd993c184d69769a718bc4753e6ec9bd75f5f207d6851ed1,
    zx_origin: ?*const zx_type_353 = null,
};

pub const value_zx_type_354_85dd8be9c95d740d10add8b11fcbe23db17475fce6c0596c3b0b1530c315fd63 = struct {
    declarations: value_zx_type_309_d4c36911b9e29c07c9fb12b56567bd5ba9d6014af03c3a6e74374757c00d5bea,
    prefix: value_zx_type_349_b673806bf780797b250bc79743f607cedef2f47ff3095be2e08bede0e013c780,
    zx_origin: ?*const zx_type_354 = null,
};

pub const value_zx_type_355_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    diagnostic: *const zx_type_138,
    index: u64,
    present: bool,
    start: u64,
    zx_origin: ?*const zx_type_355 = null,
};

pub const value_zx_type_356_da661b49334d413f36d3d895c2756a9e593006d5314c17c8350b6eb2653d308d = struct {
    declaration_diagnostic: *const zx_type_138,
    declarations: []const *const zx_type_306,
    diagnostic: *const zx_type_138,
    function_start: u64,
    import_diagnostic: *const zx_type_138,
    imports: []const *const zx_type_317,
    members: []const *const zx_type_46,
    names: []const *const zx_type_46,
    present: bool,
    type_diagnostic: bool,
    zx_origin: ?*const zx_type_356 = null,
};

pub const value_zx_type_357_1f04b50dcea292e91c48ee3fd64055b310aed26c1ac68dc315e07410670815ca = struct {
    header: value_zx_type_314_2b945e954668d79a1828a63af686318e734737f524f3484029ebbdb1c25be8f2,
    prefix: value_zx_type_356_da661b49334d413f36d3d895c2756a9e593006d5314c17c8350b6eb2653d308d,
    zx_origin: ?*const zx_type_357 = null,
};

pub const value_zx_type_358_886f599a1ee857d53c84aa4262653d370442e5a835ca1192636c3ba834381020 = struct {
    body: value_zx_type_256_8479351ede6be59f4cda24c2c469bcb9266110074e57ce839eee441715fb7524,
    contracts: []const *const zx_type_311,
    header: value_zx_type_312_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    prefix: value_zx_type_356_da661b49334d413f36d3d895c2756a9e593006d5314c17c8350b6eb2653d308d,
    zx_origin: ?*const zx_type_358 = null,
};

pub const value_zx_type_359_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    depth: u64,
    start: u64,
    tokens: []const *const zx_type_133,
    zx_origin: ?*const zx_type_359 = null,
};

pub const value_zx_type_360_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    depth: u64,
    diagnostic: *const zx_type_138,
    start: u64,
    zx_origin: ?*const zx_type_360 = null,
};

pub const value_zx_type_362_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    offset: u64,
    separator: u64,
    source: []const u8,
    valid: bool,
    zx_origin: ?*const zx_type_362 = null,
};

pub const value_zx_type_364_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    allow_lambda: bool,
    depth: u64,
    minimum: u8,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_364 = null,
};

pub const value_zx_type_365_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    depth: u64,
    source: []const u8,
    start: u64,
    state_block: bool,
    zx_origin: ?*const zx_type_365 = null,
};

pub const value_zx_type_366_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    depth: u64,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_366 = null,
};

pub const value_zx_type_367_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_367, };
pub const value_zx_type_368_7a8ac30af04c84613c3591f9b4f6e1998d2be62e127f0e92267c8278bac14469 = struct { value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, value_zx_type_18_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, ?*const zx_type_368, };
pub const value_zx_type_369_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_27_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_369, };
pub const value_zx_type_370_654b20ccf64f2ca64b6802425f9952e8447842f7a750a25aaabc98a2fcd9a52f = struct { value_zx_type_27_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, bool, ?*const zx_type_370, };
pub const value_zx_type_371_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { []const u8, ?*const zx_type_371, };
pub const value_zx_type_372_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, []const *const zx_type_28, ?*const zx_type_372, };
pub const value_zx_type_373_152936f5b3ece57cfa1afaff5c987671dc1de239be81c121450e61f890947569 = struct { []const u8, []const *const zx_type_28, value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_373, };
pub const value_zx_type_374_ed98ab2d684155f0f16edf3c906e8b7cce9beb0c415885713abde878f5ffabc6 = struct { value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_374, };
pub const value_zx_type_375_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac = struct { value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, zx_type_36, ?*const zx_type_375, };
pub const value_zx_type_376_009b209c29dfed37d6f0ddf10651eb819801430299ea03fd6bf9a11471606d6e = struct { value_zx_type_39_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, ?*const zx_type_376, };
pub const value_zx_type_377_9068dcb27588fc549cd15008d3bd15e507480c6631115fd15614e1d02077b29f = struct { value_zx_type_39_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, zx_type_38, ?*const zx_type_377, };
pub const value_zx_type_378_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, bool, ?*const zx_type_378, };
pub const value_zx_type_379_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, zx_type_41, ?*const zx_type_379, };
pub const value_zx_type_380_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { *const zx_type_42, ?*const zx_type_380, };
pub const value_zx_type_381_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { *const zx_type_42, *const zx_type_42, ?*const zx_type_381, };
pub const value_zx_type_382_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct { *const zx_type_42, *const zx_type_42, []const u8, ?*const zx_type_382, };
pub const value_zx_type_383_a8c3e1ea5f073d804dd4c3c6f22022e193ea2fdf73c44b10053e3d575c1ab52a = struct { *const zx_type_42, *const zx_type_42, []const u8, value_zx_type_63_80555316fab46b98d9e67c8a0796576b0c4658813e160fc48c23fcbd82c043e9, ?*const zx_type_383, };
pub const value_zx_type_384_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u8, ?u64, ?*const zx_type_384, };
pub const value_zx_type_385_3d737c25beebe2a18d04b5c587bf669d60bd72b031fa62ba4f5d0156e88f4c98 = struct { value_zx_type_121_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22, ?*const zx_type_385, };
pub const value_zx_type_386_d8ee14d912067aafb721571f07e5c9842de4a549d45487b6299ab64d050f099f = struct { value_zx_type_121_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22, value_zx_type_116_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_386, };
pub const value_zx_type_387_475866a3f353a8a47f6ab0885fb4b30f36ff1f58084698bde724e89c256aa61e = struct { value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1, ?*const zx_type_387, };
pub const value_zx_type_388_1ea32252e17a0c8adaf6be018e9fa07bbdfcd9c32bebaeef35b7534b47c6fd19 = struct { value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1, value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_388, };
pub const value_zx_type_389_cc88f911436e5a47ad165b93a2db230325085053eb6711c670677a1a9e5f079e = struct { value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1, value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, u64, ?*const zx_type_389, };

pub const native = struct {
    pub const @"zig:integers" = struct {
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

pub const layouts = struct {
    pub const @"zig:integers" = struct {
    };
};
