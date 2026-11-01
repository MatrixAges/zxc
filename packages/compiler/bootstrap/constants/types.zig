pub const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = enum { Integer, NegativeInteger, Float, String, Boolean, None, Unit, Some, Capture, Task, AwaitTask, CancelTask, Parallel, OptionalValue, EnumValue, ErrorValue, Reference, StoreGet, Field, Index, Length, List, Tuple, TupleField, Template, ListOperation, Transform, Scope, Iteration, ListUpdate, Call, Unary, Binary, Conditional, Match, Object, };
pub const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d = enum { Push, Pop, Sort, Reverse, Splice, Concat, };
pub const zx_type_fc8f584736df01963691da707910bd2c2c5e985c675abce771f0b48d679f9ea8 = enum { Map, Filter, Reduce, Every, Some, };
pub const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc = enum { Negate, Not, };
pub const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = enum { Coalesce, Add, Subtract, Multiply, Divide, Remainder, Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual, LogicalAnd, LogicalOr, };
pub const zx_type_7be95133e72393410a40fc823b566cf078ab17639087e25815196979d8afdee8 = enum { Root, Dead, UpperInput, UpperOutput, Underscore, Allocator, Async, Await, Break, Cancel, Case, Concurrent, Const, Declare, Default, Delete, Do, Else, Ensures, Enum, Export, False, For, From, Function, If, Import, In, Insert, Io, Let, Loop, Match, New, Next, Null, Process, QueryMany, QueryOne, Requires, Return, Store, Switch, Throw, Throws, Transaction, True, Try, Type, Update, Var, While, };
pub const zx_type_d5238ee868da2d7fb338f55b2b82971749c0fd5276129de354918ed484344fdf = enum { Integer, FractionStart, Fraction, ExponentStart, ExponentDigits, Done, };

pub const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d = struct {
    end: u64,
    last_byte: u8,
    phase: zx_type_d5238ee868da2d7fb338f55b2b82971749c0fd5276129de354918ed484344fdf,
    separators_valid: bool,
};

pub const zx_type_c6c2dc6f64943354fc7902be7e0dc617ac2422097e8adfbadc1d774b9e4cf256 = struct {
    diagnostic: []const u8,
    end: u64,
};

pub const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce = struct {
    floating: bool,
    id: u32,
    integer: bool,
    signed: bool,
    single: bool,
};

pub const zx_type_5a6a0f360a1353fb2b1ac9fda51403ae4d90f905d2e1747e832031c097b5016d = struct {
    floating: f64,
    integer: u64,
    message: []const u8,
    target: *const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce,
};

pub const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = struct {
    id: u32,
    negative: bool,
};

pub const zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c = struct {
    awaits: []const u32,
    binary_left: []const u32,
    binary_operators: []const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    binary_right: []const u32,
    booleans: []const bool,
    call_arguments: []const u32,
    call_functions: []const u32,
    call_store_count: []const u32,
    call_store_first: []const u32,
    call_stores: []const u32,
    cancellations: []const u32,
    captures: []const u32,
    collection_arguments: []const u32,
    collection_count: []const u32,
    collection_first: []const u32,
    collection_kinds: []const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d,
    collection_targets: []const u32,
    conditional_conditions: []const u32,
    conditional_no: []const u32,
    conditional_yes: []const u32,
    enumerations: []const u32,
    errors: []const u32,
    floats: []const f64,
    index_targets: []const u32,
    index_values: []const u32,
    integers: []const u64,
    iteration_bodies: []const u32,
    iteration_condition_parameters: []const u32,
    iteration_conditions: []const u32,
    iteration_initials: []const u32,
    iteration_parameters: []const u32,
    iteration_postconditions: []const bool,
    kinds: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    lengths: []const u32,
    match_conditions: []const u32,
    match_count: []const u32,
    match_fallbacks: []const u32,
    match_first: []const u32,
    match_results: []const u32,
    match_subjects: []const ?u32,
    negative_integers: []const u64,
    object_count: []const u32,
    object_evaluation_count: []const u32,
    object_evaluation_first: []const u32,
    object_evaluation_values: []const u32,
    object_field_indices: []const u32,
    object_field_values: []const u32,
    object_first: []const u32,
    optional_values: []const u32,
    parallel_count: []const u32,
    parallel_fields: []const ?u32,
    parallel_first: []const u32,
    parallel_tasks: []const u32,
    payloads: []const u32,
    projection_indices: []const u32,
    projection_targets: []const u32,
    references: []const u32,
    scope_borrows: []const bool,
    scope_count: []const u32,
    scope_first: []const u32,
    scope_results: []const u32,
    scope_symbols: []const ?u32,
    scope_values: []const u32,
    sequence_count: []const u32,
    sequence_first: []const u32,
    sequence_items: []const u32,
    some: []const u32,
    span_end: []const u64,
    span_start: []const u64,
    stores: []const u32,
    strings: []const []const u8,
    task_bodies: []const u32,
    task_capture_count: []const u32,
    task_capture_first: []const u32,
    task_captures: []const u32,
    transform_bodies: []const u32,
    transform_count: []const u32,
    transform_first: []const u32,
    transform_initials: []const ?u32,
    transform_kinds: []const zx_type_fc8f584736df01963691da707910bd2c2c5e985c675abce771f0b48d679f9ea8,
    transform_parameters: []const u32,
    transform_targets: []const u32,
    types: []const u32,
    unary_operands: []const u32,
    unary_operators: []const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    update_indices: []const u32,
    update_targets: []const u32,
    update_values: []const u32,
};

pub const zx_type_14f3dd391f030e4255b4499e4026b6a3cded276023138283023207efa470ff42 = enum { Identifier, Keyword, Number, String, Template, Punctuation, Eof, };
pub const zx_type_5d7c9f8514b08298c82a3994f6fa57912f84c06ba02e8cdb8bfe77d784e94bfe = enum { None, OpenBrace, CloseBrace, OpenParen, CloseParen, OpenBracket, CloseBracket, Colon, Semicolon, Comma, Dot, Question, Plus, Minus, Star, Slash, Percent, Less, Greater, Assign, Not, Ampersand, Pipe, Arrow, Equal, NotEqual, LessEqual, GreaterEqual, Coalesce, And, Or, Spread, };

pub const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b = struct {
    end: u64,
    start: u64,
};

pub const zx_type_9a9da7f7939aacb35a219d6b75a213404ba8000d2996bd7fc41155db024115e2 = struct {
    dollar: bool,
    kind: zx_type_14f3dd391f030e4255b4499e4026b6a3cded276023138283023207efa470ff42,
    line_break: bool,
    span: *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    symbol: zx_type_5d7c9f8514b08298c82a3994f6fa57912f84c06ba02e8cdb8bfe77d784e94bfe,
    word: zx_type_7be95133e72393410a40fc823b566cf078ab17639087e25815196979d8afdee8,
};

pub const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = struct {
    boolean: bool,
    enumeration: u32,
    floating: f64,
    integer: u64,
    kind: zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    negative: bool,
    text: []const u8,
    type_id: u32,
};

pub const zx_type_7df0499f2bea00d301e06fee2a521203afd03ad36e9fe3f4bb9026b727bc5d74 = struct {
    names: []const []const u8,
    values: []const *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_aa5186cf7ed833c23cde6e3df277bc296171f23ebbf833ea84d2f62346febac3 = struct {
    expected: ?u32,
    floating: bool,
    negative: bool,
};

pub const zx_type_c47d0fc0fbede5d5ffc4e8d470a13ba4d11b3768bf927c8ac18e7e9635f0c30b = struct {
    comparison: bool,
    equality: bool,
    logical: bool,
};

pub const zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd = struct {
    left: f64,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: f64,
    single: bool,
};

pub const zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5 = enum { Idle, Identifier, Number, String, StringEscape, LineComment, BlockComment, Template, TemplateEscape, Interpolation, InterpolationString, InterpolationStringEscape, InterpolationLineComment, InterpolationBlockComment, };

pub const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
};

pub const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005 = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    start: u64,
};

pub const zx_type_c64cb676eec361417f485661579e36933ca528895e4d48e6cbc4d5827c42bbf0 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    depth: u64,
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    dollar: bool,
    frames: []const *const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    keyword_state: u64,
    line_break: bool,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    number: *const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_5d7c9f8514b08298c82a3994f6fa57912f84c06ba02e8cdb8bfe77d784e94bfe,
    tokens: []const *const zx_type_9a9da7f7939aacb35a219d6b75a213404ba8000d2996bd7fc41155db024115e2,
    warmed: u8,
};

pub const zx_type_7138c28525eca8f14e552fd10461eef97e4464b8c5c3bf565834c0b69f05fc97 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_c64cb676eec361417f485661579e36933ca528895e4d48e6cbc4d5827c42bbf0,
};

pub const zx_type_0c6c4a961ecc31f92625b57e5abe1cce48c6937a3a2fb30c2bf3b18af14c6649 = struct {
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    tokens: []const *const zx_type_9a9da7f7939aacb35a219d6b75a213404ba8000d2996bd7fc41155db024115e2,
};

pub const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78 = struct {
    magnitude: u64,
    negative: bool,
};

pub const zx_type_0a4f4736fab8b70e6704149509fbcef96f5940930b96cade1bb4740d1067ae5f = struct {
    left: *const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78,
    target: *const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce,
};

pub const zx_type_d97e9881bb57ab90dad7ca756824034566dfbfaf9e79c079546d4d78484f56a3 = struct {
    message: []const u8,
    value: *const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78,
};

pub const zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = struct {
    left: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    type_id: u32,
};

pub const zx_type_374d081f355fd18c68751135bfa3a434f73641e64e935769510631d75221641f = struct {
    message: []const u8,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a = struct {
    expressions: *const zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c,
    root: u32,
};

pub const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2 = struct {
    arm: u64,
    id: u32,
};

pub const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    frames: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    values: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_f8d673af8bcfed48ea60cd3ea9012f391b94443999ac2619c91f43bdd7495539 = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
};

pub const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_3f31c09dbd202913870d0c048a6d9e125ecc81041e965ee18f3049ba27ad8205 = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
};

pub const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_3425a43fd8455c89a26bbf3ccd1009e459c685a636082fd3a553b2166db51923 = struct {
    id: u32,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
};

pub const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
};

pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct { []const bool, void, };

pub const zx_type_32ced6dd7d7f13befc4c5d00bc732e54a67c7184ee71ba2ca1e7a81cbbd55a6e = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    expressions: *const zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c,
    index: u64,
    required: []const bool,
    root: u64,
};

pub const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = struct {
    conditions: []const u32,
    end: u64,
    index: u64,
    required: []const bool,
    results: []const u32,
};

pub const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = struct {
    index: u64,
    result: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
};

pub const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799 = struct { []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, void, };
pub const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2 = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, void, };
pub const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087 = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, };
pub const zx_type_905ed48b3536bb20a396f3837ae74e8d058dc52bf1124b640631ad6663bdf431 = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, };
pub const zx_type_90e462b3542710c67d4733b4b2cdc04385865b48627535fcbdcfb757e1a78d49 = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, };
pub const zx_type_0753dfcab086a654d03f9a6f38c427e9c7a471cb8a2874aea4885b8b044ff6db = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_24facb3845225d23ac300c54fcc27a268c8ce4046a9a4eaaae735b0d9fc5143c = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_5fb170412785ecec6b29504bd4a440630c6f5f5c123f150c7a0a912bd565baff = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8, };

pub const value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb = struct {
    floating: bool,
    id: u32,
    integer: bool,
    signed: bool,
    single: bool,
    zx_origin: ?*const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce = null,
};

pub const value_b8c03207bf3d18306d6984999a583e49ea5aec54c71119e04cb374fc1d9f18ed = struct {
    floating: f64,
    integer: u64,
    message: []const u8,
    target: value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb,
    zx_origin: ?*const zx_type_5a6a0f360a1353fb2b1ac9fda51403ae4d90f905d2e1747e832031c097b5016d = null,
};

pub const value_c6bb726e124c9f9e56220e0a24f464f4d93ec79ffb8b708d17d970e3a75dda6c = struct {
    id: u32,
    negative: bool,
    zx_origin: ?*const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = null,
};

pub const value_14e4e20a7eaf52d62a05f5e3274156a4a5e995de1cbdb7488cfe2fb12943bc46 = struct {
    expected: ?u32,
    floating: bool,
    negative: bool,
    zx_origin: ?*const zx_type_aa5186cf7ed833c23cde6e3df277bc296171f23ebbf833ea84d2f62346febac3 = null,
};

pub const value_8f568b3b17837d2cfc380f3eb13c0b6101bbce8c12497f629d23ff5912b77c07 = struct {
    comparison: bool,
    equality: bool,
    logical: bool,
    zx_origin: ?*const zx_type_c47d0fc0fbede5d5ffc4e8d470a13ba4d11b3768bf927c8ac18e7e9635f0c30b = null,
};

pub const value_4808db2512df05ec5d386415650b183ce13fdfd718020962ad8a0e4c8d33334b = struct {
    left: f64,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: f64,
    single: bool,
    zx_origin: ?*const zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd = null,
};

pub const value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e = null,
};

pub const value_88d559e53ba17a917462a1809e7f67751ef0c44590e5345deacc7c984e1156ec = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    depth: u64,
    diagnostic: value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320,
    dollar: bool,
    frames: []const *const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    keyword_state: u64,
    line_break: bool,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    number: *const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_5d7c9f8514b08298c82a3994f6fa57912f84c06ba02e8cdb8bfe77d784e94bfe,
    tokens: []const *const zx_type_9a9da7f7939aacb35a219d6b75a213404ba8000d2996bd7fc41155db024115e2,
    warmed: u8,
    zx_origin: ?*const zx_type_c64cb676eec361417f485661579e36933ca528895e4d48e6cbc4d5827c42bbf0 = null,
};

pub const value_833f990003225f6e25bd6d498baaf755c2b4d47dcc7147fe71a0356a546aa858 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_88d559e53ba17a917462a1809e7f67751ef0c44590e5345deacc7c984e1156ec,
    zx_origin: ?*const zx_type_7138c28525eca8f14e552fd10461eef97e4464b8c5c3bf565834c0b69f05fc97 = null,
};

pub const value_5354f985496909fa56d8134f6f938250630576199899f106a889ad6b76badcc9 = struct {
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    diagnostic: value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320,
    tokens: []const *const zx_type_9a9da7f7939aacb35a219d6b75a213404ba8000d2996bd7fc41155db024115e2,
    zx_origin: ?*const zx_type_0c6c4a961ecc31f92625b57e5abe1cce48c6937a3a2fb30c2bf3b18af14c6649 = null,
};

pub const value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43 = struct {
    magnitude: u64,
    negative: bool,
    zx_origin: ?*const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78 = null,
};

pub const value_9665061c1684657adf2f7d7bb1d3cae18bfd07f85cc1b7701ce65593d567c0be = struct {
    left: value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43,
    target: value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb,
    zx_origin: ?*const zx_type_0a4f4736fab8b70e6704149509fbcef96f5940930b96cade1bb4740d1067ae5f = null,
};

pub const value_b8158d62b5c164a2d0aac9fde6849ee1b0cf6a0c9c3479e7f6f9d6e8218509a2 = struct {
    message: []const u8,
    value: value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43,
    zx_origin: ?*const zx_type_d97e9881bb57ab90dad7ca756824034566dfbfaf9e79c079546d4d78484f56a3 = null,
};

pub const value_aa0d26cc0e88cd5936e5f12c41131a9936fbc2135966c84abd7ef1777ab7654c = struct {
    left: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    type_id: u32,
    zx_origin: ?*const zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = null,
};

pub const value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730 = struct {
    message: []const u8,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_374d081f355fd18c68751135bfa3a434f73641e64e935769510631d75221641f = null,
};

pub const value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d = struct {
    diagnostic: value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320,
    frames: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    values: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676 = struct {
    cursor: value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
    zx_origin: ?*const zx_type_f8d673af8bcfed48ea60cd3ea9012f391b94443999ac2619c91f43bdd7495539 = null,
};

pub const value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = null,
};

pub const value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108 = struct {
    cursor: value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
    zx_origin: ?*const zx_type_3f31c09dbd202913870d0c048a6d9e125ecc81041e965ee18f3049ba27ad8205 = null,
};

pub const value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5 = struct {
    diagnostic: value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = null,
};

pub const value_de7e557a1f4d614dfa1118c605778c70db10cfe21b8d0483d1af3768155ad272 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = null,
};

pub const value_686162ce84bf0ca7a8acc1ef308e84a546d3eb5f7c94d4c5725fc373b98b2027 = struct {
    id: u32,
    input: *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a,
    zx_origin: ?*const zx_type_3425a43fd8455c89a26bbf3ccd1009e459c685a636082fd3a553b2166db51923 = null,
};

pub const value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7 = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const value_6a282f8e7c0212f76daa60106fe90427f3ae895d34edd0dad552701c12a05ae2 = struct { []const bool, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };

pub const value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = struct {
    diagnostic: value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320,
    expressions: *const zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c,
    index: u64,
    required: []const bool,
    root: u64,
    zx_origin: ?*const zx_type_32ced6dd7d7f13befc4c5d00bc732e54a67c7184ee71ba2ca1e7a81cbbd55a6e = null,
};

pub const value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = struct {
    conditions: []const u32,
    end: u64,
    index: u64,
    required: []const bool,
    results: []const u32,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const value_19e2aa0bc8c8fa335e8ec7b7c38da3c484057a561ff1d06849d4f7345f2e3f3f = struct {
    index: u64,
    result: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const value_2fdd31a48200da7b4f90c5db0ca77d0a396a00a7f3c75d8daf1eeac2e8c6b87b = struct { []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const value_1f9649a515f859e127a36ca89d608790532a16e6ea1546c96e78e731cef9beae = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const value_630ec9d33439476996e1b739fdd47d00a4a4e78a448fb9fdfb5f6a73ff0e909a = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const value_d1615c604053d7d54632bd32389a620ed30035bd1eac9e95f79f61ea6c52a776 = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, ?*const zx_type_905ed48b3536bb20a396f3837ae74e8d058dc52bf1124b640631ad6663bdf431, };
pub const value_5675d7cae9e0830f0e291475766b21c814766ebd3f8f2a231f40bc554ecf8ac5 = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, ?*const zx_type_90e462b3542710c67d4733b4b2cdc04385865b48627535fcbdcfb757e1a78d49, };
pub const value_3e41268e1af9eed26a49bcd990307c5f125c295f10bda73b67cf4dbab921b7d6 = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, ?*const zx_type_0753dfcab086a654d03f9a6f38c427e9c7a471cb8a2874aea4885b8b044ff6db, };
pub const value_4a4bf82fef40183934e729f4af45a60a24a4298444f2f69f44c0d3b2f324b63d = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, ?*const zx_type_24facb3845225d23ac300c54fcc27a268c8ce4046a9a4eaaae735b0d9fc5143c, };
pub const value_4c9efffacb576d9a456aec2ffecbd8f4d650c7b11388f37e3aa42fd76988ba5c = struct { *const zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a, value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d, value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5, ?*const zx_type_5fb170412785ecec6b29504bd4a440630c6f5f5c123f150c7a0a912bd565baff, };

pub const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

pub fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{ OutOfMemory, }![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));

    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    const capacity: usize = (if ((count == 0)) 0 else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(count, 8)));
    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (offset + (capacity * @sizeOf(T)))));
    const data: [*]T = @ptrCast(@alignCast(((bytes).ptr + offset)));
    const fresh: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, ((bytes).ptr + offset)) - @sizeOf(ZxHeader))));

    (fresh).* = .{ .capacity = capacity, .committed = count, };

    @memcpy((data)[0..(items).len], items);

    return (data)[0..count];
}

pub fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

pub fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8) error{ OutOfMemory, }!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path));
                (target).* = fresh;
            }
        } else {
            if (@hasField(V, ((path)[0])[1])) {
                @field((target).*, ((path)[0])[1]) = null;
            }

            (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..]));
        }
    }
}

pub const native = struct {
    pub const @"std:float" = struct {
        pub const narrow = struct {
            pub const Input = f64;
            pub const Output = f32;
            pub const InputValue = f64;
            pub const OutputValue = f32;
        };
        pub const widen = struct {
            pub const Input = f32;
            pub const Output = f64;
            pub const InputValue = f32;
            pub const OutputValue = f64;
        };
        pub const isFinite = struct {
            pub const Input = f64;
            pub const Output = bool;
            pub const InputValue = f64;
            pub const OutputValue = bool;
        };
        pub const parse32 = struct {
            pub const Input = []const u8;
            pub const Output = ?f32;
            pub const InputValue = []const u8;
            pub const OutputValue = ?f32;
        };
        pub const parse64 = struct {
            pub const Input = []const u8;
            pub const Output = ?f64;
            pub const InputValue = []const u8;
            pub const OutputValue = ?f64;
        };
    };
    pub const @"std:integer" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const widenByte = struct {
            pub const Input = u8;
            pub const Output = u64;
            pub const InputValue = u8;
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
    pub const @"std:float" = struct {
    };
    pub const @"std:integer" = struct {
    };
};

