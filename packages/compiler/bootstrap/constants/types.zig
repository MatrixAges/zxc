pub const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = enum { Integer, NegativeInteger, Float, String, Boolean, None, Unit, Some, Capture, Task, AwaitTask, CancelTask, Parallel, OptionalValue, EnumValue, ErrorValue, Reference, StoreGet, Field, Index, Length, List, Tuple, TupleField, Template, ListOperation, Transform, Scope, Iteration, ListUpdate, Call, Unary, Binary, Conditional, Match, Object, };
pub const zx_type_5f1d726b49a72852da9b9f20e25f8aeb68ceee87ffd03cc9ce985e80448bd8af = enum { Push, Pop, Sort, Reverse, Splice, Concat, Slice, };
pub const zx_type_e76202ba7e8fa459e4363bda9b871257e2b192c42640e03e65c79eedcb6527f5 = enum { Map, Filter, Reduce, Every, Some, Sort, };
pub const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc = enum { Negate, Not, };
pub const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = enum { Coalesce, Add, Subtract, Multiply, Divide, Remainder, Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual, LogicalAnd, LogicalOr, };
pub const zx_type_68e9f3b21f9f424bcfe58e375c12c696ec6b3839065a833c705a461c2d743481 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_cba597263faf9115e05af19ef297c6cc2ef940004dc17f97b9afe58ccb17ada9 = struct {
    base: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    delta: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
};

pub const zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_a818820f12e779866b6b5eb611564ecefe53c174a637a10b4df4f86b6a99454d = struct {
    delta: bool,
    first: u32,
    kind: zx_type_68e9f3b21f9f424bcfe58e375c12c696ec6b3839065a833c705a461c2d743481,
    label: []const u8,
    second: u32,
};

pub const zx_type_86f402666e2483dcd5c437254561574187b9b98f0b7bf33508f30931fc136725 = enum { Root, Dead, UpperInput, UpperOutput, Underscore, Allocator, As, Async, Await, Break, Cancel, Case, Concurrent, Const, Declare, Default, Delete, Do, Else, Ensures, Enum, Export, False, For, From, Function, If, Import, In, Insert, Io, Let, Loop, Match, New, Next, Null, Process, QueryMany, QueryOne, Requires, Return, Store, Switch, Throw, Throws, Transaction, True, Try, Type, Update, Var, While, };
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

pub const zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd = struct {
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
    collection_kinds: []const zx_type_5f1d726b49a72852da9b9f20e25f8aeb68ceee87ffd03cc9ce985e80448bd8af,
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
    iteration_environment_symbols: []const ?u32,
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
    transform_kinds: []const zx_type_e76202ba7e8fa459e4363bda9b871257e2b192c42640e03e65c79eedcb6527f5,
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
pub const zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2 = enum { None, OpenBrace, CloseBrace, OpenParen, CloseParen, OpenBracket, CloseBracket, Colon, Semicolon, Comma, Dot, Question, Plus, Minus, Star, Slash, Percent, Less, Greater, Assign, Not, Ampersand, Pipe, Arrow, Pipeline, Equal, NotEqual, LessEqual, GreaterEqual, Coalesce, And, Or, Spread, };

pub const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b = struct {
    end: u64,
    start: u64,
};

pub const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade = struct {
    dollar: bool,
    kind: zx_type_14f3dd391f030e4255b4499e4026b6a3cded276023138283023207efa470ff42,
    line_break: bool,
    span: *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    symbol: zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2,
    word: zx_type_86f402666e2483dcd5c437254561574187b9b98f0b7bf33508f30931fc136725,
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

pub const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9 = struct { u64, u64, };

pub const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = struct {
    id: u32,
    negative: bool,
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

pub const zx_type_236347990c6302cbba81ab192964858c9461a680bac0f1f51c3da4e720fa53c4 = struct {
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
    symbol: zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2,
    tokens: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
    warmed: u8,
};

pub const zx_type_57e31919cc7e828326c51c8148292fc6ce529567616ade4182868401ab08c2a8 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: *const zx_type_236347990c6302cbba81ab192964858c9461a680bac0f1f51c3da4e720fa53c4,
};

pub const zx_type_f444e95923acf9b8b0b6445ff3889f228cda784c853fea527a95d2341e3d2419 = struct {
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    tokens: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
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

pub const zx_type_b4225be6fa1a627bb33a27b79b46d3d9703a5719c2ef60883c75b2c476680384 = struct {
    exports: ?*const zx_type_7df0499f2bea00d301e06fee2a521203afd03ad36e9fe3f4bb9026b727bc5d74,
    imports: ?*const zx_type_7df0499f2bea00d301e06fee2a521203afd03ad36e9fe3f4bb9026b727bc5d74,
    types: *const zx_type_cba597263faf9115e05af19ef297c6cc2ef940004dc17f97b9afe58ccb17ada9,
};

pub const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd = struct {
    expressions: *const zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd,
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

pub const zx_type_550547f55176da255cb842b27a44e80bb2675265940072376b7bff47239cb259 = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
};

pub const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_3c0a16f48a75e75b07ffa018632eb8b3639bd59370a97c563f92023fa4b12e3e = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
};

pub const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_e309d9489e8deea9b46aa4153d8bc1e52e4b7c7a6aa2b0d84c6b8da83ab5fe9a = struct {
    id: u32,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
};

pub const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
};

pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct { []const bool, void, };

pub const zx_type_8374de7cf3dd33c653c80a97f5574b01d205ac9583066dacbd9728705af9377c = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    expressions: *const zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd,
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
pub const zx_type_700f489e074c6e71f789910e2bfa494cb1322b1b9bdb111f67a4ad7f50f3700b = struct { *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd, };
pub const zx_type_f8b8aacb1d2e68f6af399129b1cea0eded5b91883e14853468c6150600bd2b2b = struct { *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, };
pub const zx_type_71cb0e04e016d0c659bc24ea1f0a750335b31002edcd7b88c91728aa7d4b1f22 = struct { *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_9198b7a0e61d41e684312e75f451685a07375e583a6da23ca8ce103efcd895e5 = struct { *const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8, };

pub const value_426271d6bd026d9613b46371872e72cdf8ec896dd2da23600323472b9bc6de30 = struct {
    items: []const u8,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = struct {
    items: []const u32,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_41c76dfb2d7de70873a1c62b1a5977a8f8a328883c1a1a9fbf8b387a4cfb87c0 = struct {
    items: []const []const u8,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738 = struct {
    floating: bool,
    id: u32,
    integer: bool,
    signed: bool,
    single: bool,
    zx_origin: ?*const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce = null,
};

pub const view_value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738 = value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738;

pub const value_c1f88584497e8043b33bc6a9938968d50b9dcb755a24e0dccc26402c6f347720 = struct {
    items: []const *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560 = struct {
    items: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = struct {
    items: []const u64,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_ffd6af4eafe66a12b4cba10a9b1069bdde2ca651c83266643262c2faea5335b3 = struct {
    items: []const f64,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = struct {
    items: []const bool,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_b8ea717cda72ad08ac35fe2f8331f4964e8bca4c497ee3e8c7047be8798c4793 = struct {
    items: []const ?u32,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_79b50db8e619a2796f4312458a47bcb2ed257845ccc4c3e0120657c17dcc3bc4 = struct {
    items: []const zx_type_5f1d726b49a72852da9b9f20e25f8aeb68ceee87ffd03cc9ce985e80448bd8af,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_e13d62c13d149e68a7b638e197379accb421716582cba892f8a27250bc6e6cb5 = struct {
    items: []const zx_type_e76202ba7e8fa459e4363bda9b871257e2b192c42640e03e65c79eedcb6527f5,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_4aeb0f04ea90442a22de66890a9b236cc87f1fc6b88c63e19d4f83b55696abcc = struct {
    items: []const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_afdb6cf272ccd93fb315fcf58e0970257143c4cb8667b3f40876fabd39b23d91 = struct {
    items: []const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e = struct {
    expected: ?u32,
    floating: bool,
    negative: bool,
    zx_origin: ?*const zx_type_aa5186cf7ed833c23cde6e3df277bc296171f23ebbf833ea84d2f62346febac3 = null,
};

pub const view_value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e = value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e;

pub const value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26 = struct {
    comparison: bool,
    equality: bool,
    logical: bool,
    zx_origin: ?*const zx_type_c47d0fc0fbede5d5ffc4e8d470a13ba4d11b3768bf927c8ac18e7e9635f0c30b = null,
};

pub const view_value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26 = value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26;

pub const value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521 = struct {
    left: f64,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: f64,
    single: bool,
    zx_origin: ?*const zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd = null,
};

pub const view_value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521 = value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521;

pub const value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82 = struct {
    id: u32,
    negative: bool,
    zx_origin: ?*const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = null,
};

pub const view_value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82 = value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82;

pub const value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e = null,
};

pub const view_value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7 = value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7;

pub const value_3c2c25c531f76ae0ce46b5229f7a1cf2ae81d1cad68ee7435b0c31a94b5bac4a = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    start: u64,
    zx_origin: ?*const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005 = null,
};

pub const view_value_3c2c25c531f76ae0ce46b5229f7a1cf2ae81d1cad68ee7435b0c31a94b5bac4a = value_3c2c25c531f76ae0ce46b5229f7a1cf2ae81d1cad68ee7435b0c31a94b5bac4a;

pub const value_06043e925eed96fa2d6eb5eeb315a24b543d0fd3a8df65bbeaf794351f43922b = struct {
    items: []const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_29af4ec67a09b4a8f741e11de51ad063b7b5539433e840a7ec31564241da1b13 = struct {
    items: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_52685d134bb92dfe560da76f38861ad7640ce438e16be3f50ce96a1e22fe9b00 = struct {
    items: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_ad5e85b06317640c7759b795bdea0834f6cbff3dc8ad23a88775c5676c61143b = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: value_52685d134bb92dfe560da76f38861ad7640ce438e16be3f50ce96a1e22fe9b00,
    depth: u64,
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    dollar: bool,
    frames: value_06043e925eed96fa2d6eb5eeb315a24b543d0fd3a8df65bbeaf794351f43922b,
    keyword_state: u64,
    line_break: bool,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    number: *const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2,
    tokens: value_29af4ec67a09b4a8f741e11de51ad063b7b5539433e840a7ec31564241da1b13,
    warmed: u8,
    zx_origin: ?*const zx_type_236347990c6302cbba81ab192964858c9461a680bac0f1f51c3da4e720fa53c4 = null,
};

pub const view_value_ad5e85b06317640c7759b795bdea0834f6cbff3dc8ad23a88775c5676c61143b = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    depth: u64,
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    dollar: bool,
    frames: []const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    keyword_state: u64,
    line_break: bool,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    number: *const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2,
    tokens: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
    warmed: u8,
    zx_origin: ?*const zx_type_236347990c6302cbba81ab192964858c9461a680bac0f1f51c3da4e720fa53c4 = null,
};

pub const value_fcd4dba4279a3a050c9ed977ff07dd7421747da04901422933fe3132e229d8ea = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_ad5e85b06317640c7759b795bdea0834f6cbff3dc8ad23a88775c5676c61143b,
    zx_origin: ?*const zx_type_57e31919cc7e828326c51c8148292fc6ce529567616ade4182868401ab08c2a8 = null,
};

pub const view_value_fcd4dba4279a3a050c9ed977ff07dd7421747da04901422933fe3132e229d8ea = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: view_value_ad5e85b06317640c7759b795bdea0834f6cbff3dc8ad23a88775c5676c61143b,
    zx_origin: ?*const zx_type_57e31919cc7e828326c51c8148292fc6ce529567616ade4182868401ab08c2a8 = null,
};

pub const value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2 = struct {
    magnitude: u64,
    negative: bool,
    zx_origin: ?*const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78 = null,
};

pub const view_value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2 = value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2;

pub const value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762 = struct {
    left: value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2,
    target: value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738,
    zx_origin: ?*const zx_type_0a4f4736fab8b70e6704149509fbcef96f5940930b96cade1bb4740d1067ae5f = null,
};

pub const view_value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762 = value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762;

pub const value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d = struct {
    message: []const u8,
    value: value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2,
    zx_origin: ?*const zx_type_d97e9881bb57ab90dad7ca756824034566dfbfaf9e79c079546d4d78484f56a3 = null,
};

pub const view_value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d = value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d;

pub const value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549 = struct {
    left: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    type_id: u32,
    zx_origin: ?*const zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = null,
};

pub const view_value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549 = value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549;

pub const value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 = struct {
    message: []const u8,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_374d081f355fd18c68751135bfa3a434f73641e64e935769510631d75221641f = null,
};

pub const view_value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 = value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079;

pub const value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d = struct {
    items: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db = struct {
    items: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    storage: enum(usize) { plain, owned, shared, exclusive, },
};

pub const value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e = struct {
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    frames: value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d,
    values: value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const view_value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e = struct {
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    frames: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    values: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = struct {
    cursor: value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
    zx_origin: ?*const zx_type_550547f55176da255cb842b27a44e80bb2675265940072376b7bff47239cb259 = null,
};

pub const view_value_254caf6399ed8e4b48d918595ddb24283a7a28081b15798cd26b4b8249685579 = struct {
    cursor: view_value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
    zx_origin: ?*const zx_type_550547f55176da255cb842b27a44e80bb2675265940072376b7bff47239cb259 = null,
};

pub const value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = null,
};

pub const view_value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b = value_e93d0da4f028ff1d439a2f639c401f42a4679005965e9bf927a46cf8ffaac12b;

pub const value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9 = struct {
    cursor: value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
    zx_origin: ?*const zx_type_3c0a16f48a75e75b07ffa018632eb8b3639bd59370a97c563f92023fa4b12e3e = null,
};

pub const view_value_76a8b25a9f1d95be38980855f4e0043a6a71b9161d0f6500542e67f619d782d9 = struct {
    cursor: view_value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
    zx_origin: ?*const zx_type_3c0a16f48a75e75b07ffa018632eb8b3639bd59370a97c563f92023fa4b12e3e = null,
};

pub const value_30831d8909e192c879155414d2db1232cef8e82430da37917fdb3c9bffcfbe74 = struct {
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = null,
};

pub const view_value_30831d8909e192c879155414d2db1232cef8e82430da37917fdb3c9bffcfbe74 = value_30831d8909e192c879155414d2db1232cef8e82430da37917fdb3c9bffcfbe74;

pub const value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = null,
};

pub const view_value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c = value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c;

pub const value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe = struct {
    id: u32,
    input: *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd,
    zx_origin: ?*const zx_type_e309d9489e8deea9b46aa4153d8bc1e52e4b7c7a6aa2b0d84c6b8da83ab5fe9a = null,
};

pub const view_value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe = value_898462376b4cd5f2624998997dbbc7c602e453b3202689665149b85ef1679dfe;

pub const value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea = struct {
    index: u64,
    result: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    source: value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const view_value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0 = struct { value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };
pub const view_value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0 = struct { []const bool, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };

pub const value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = struct {
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    expressions: *const zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd,
    index: u64,
    required: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    root: u64,
    zx_origin: ?*const zx_type_8374de7cf3dd33c653c80a97f5574b01d205ac9583066dacbd9728705af9377c = null,
};

pub const view_value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = struct {
    diagnostic: value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7,
    expressions: *const zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd,
    index: u64,
    required: []const bool,
    root: u64,
    zx_origin: ?*const zx_type_8374de7cf3dd33c653c80a97f5574b01d205ac9583066dacbd9728705af9377c = null,
};

pub const value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54 = struct {
    conditions: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    end: u64,
    index: u64,
    required: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    results: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const view_value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54 = struct {
    conditions: []const u32,
    end: u64,
    index: u64,
    required: []const bool,
    results: []const u32,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176 = struct {
    index: u64,
    result: value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db,
    source: value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const view_value_08eb67706805e7996074d86e4f274d7b4bd2f17ba7cb49e624514c51ef7eb176 = struct {
    index: u64,
    result: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const value_8e48239a6f4c2de4c5470242fd7bbf1672af768c61d6efd968c0d001656a0e0c = struct { value_3c5cf9f4d0b84f4aaefb5e02f1f1622091b1c81552c2639dbc68e2761e1d89db, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const view_value_8e48239a6f4c2de4c5470242fd7bbf1672af768c61d6efd968c0d001656a0e0c = struct { []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const value_30171d09e8eae29f60d074b9dcbdb99d3a5142b2495ac6a632bb64ff022c4faf = struct { value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const view_value_30171d09e8eae29f60d074b9dcbdb99d3a5142b2495ac6a632bb64ff022c4faf = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const value_f77f88e85b2a7f61509ed5cbd0a601f686b428bbbcde6e49a03e4de67adb65f8 = struct { value_3503955f66f4e18f4ccc289c0e9b2ea39b753caf9a9c1bb6dada1768c9f1bc6d, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const view_value_f77f88e85b2a7f61509ed5cbd0a601f686b428bbbcde6e49a03e4de67adb65f8 = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const value_d8c9f15f996c0daf19eca18a3756002e101546660de4cfc0fd716477d4fa8bfc = struct { *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd, ?*const zx_type_700f489e074c6e71f789910e2bfa494cb1322b1b9bdb111f67a4ad7f50f3700b, };
pub const view_value_d8c9f15f996c0daf19eca18a3756002e101546660de4cfc0fd716477d4fa8bfc = value_d8c9f15f996c0daf19eca18a3756002e101546660de4cfc0fd716477d4fa8bfc;
pub const value_0eefa9e3ce8935b3d4c2b403717320296b48740a7a4a8769871c2fb851f8c697 = struct { value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, ?*const zx_type_f8b8aacb1d2e68f6af399129b1cea0eded5b91883e14853468c6150600bd2b2b, };
pub const view_value_0eefa9e3ce8935b3d4c2b403717320296b48740a7a4a8769871c2fb851f8c697 = value_0eefa9e3ce8935b3d4c2b403717320296b48740a7a4a8769871c2fb851f8c697;
pub const value_67a580ca373931ed0db9c90d734a2c54e0906f80fdf407d2ca89f4422e837ef3 = struct { *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd, value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, ?*const zx_type_71cb0e04e016d0c659bc24ea1f0a750335b31002edcd7b88c91728aa7d4b1f22, };
pub const view_value_67a580ca373931ed0db9c90d734a2c54e0906f80fdf407d2ca89f4422e837ef3 = struct { *const zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd, view_value_05b4395a7d2778b0e994bf2648502f830871c36be25bf094004c7ec3f467af2e, ?*const zx_type_71cb0e04e016d0c659bc24ea1f0a750335b31002edcd7b88c91728aa7d4b1f22, };
pub const value_916606278f6120b801def1927ed8b6355dd61515b2acc9575b37f24f17a96bd3 = struct { value_30831d8909e192c879155414d2db1232cef8e82430da37917fdb3c9bffcfbe74, ?*const zx_type_9198b7a0e61d41e684312e75f451685a07375e583a6da23ca8ce103efcd895e5, };
pub const view_value_916606278f6120b801def1927ed8b6355dd61515b2acc9575b37f24f17a96bd3 = value_916606278f6120b801def1927ed8b6355dd61515b2acc9575b37f24f17a96bd3;

pub const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

pub inline fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{ OutOfMemory, }![]T {
    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    return (try zxAllocate(T, allocator, items, count, false, 0));
}

pub inline fn zxReserveBounded(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, minimum: usize) error{ OutOfMemory, }![]T {
    if (((items).len == 0)) {
        return (try zxAllocate(T, allocator, items, count, true, minimum));
    }

    return (try zxReserve(T, allocator, items, count, true));
}

pub fn zxAllocate(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime exact: bool, minimum: usize) error{ OutOfMemory, }![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));
    const capacity: usize = (if ((exact or (@max(count, minimum) == 0))) @max(count, minimum) else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(@max(count, minimum), 8)));

    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (((@import("std")).math).add(usize, offset, (((@import("std")).math).mul(usize, capacity, @sizeOf(T)) catch {
        return error.OutOfMemory;
    })) catch {
        return error.OutOfMemory;
    })));

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

pub fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8, comptime exact: bool) error{ OutOfMemory, }!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path, exact));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path, exact));
                (target).* = fresh;
            }
        } else {
            if (((path).len == 0)) {
                if ((!(((target).*).storage == .exclusive))) {
                    ((target).*).items = (try zxAllocate(((@typeInfo(@TypeOf(((target).*).items))).pointer).child, allocator, ((target).*).items, (((target).*).items).len, exact, 0));
                    ((target).*).storage = .exclusive;
                }
            } else {
                if (@hasField(V, ((path)[0])[1])) {
                    @field((target).*, ((path)[0])[1]) = null;
                }

                (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..], exact));
            }
        }
    }
}

pub const native = struct {
    pub const @"std:float" = struct {
        pub const bits = struct {
            pub const Input = f64;
            pub const Output = u64;
            pub const InputValue = f64;
            pub const OutputValue = u64;
        };
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
        pub const widenShort = struct {
            pub const Input = u16;
            pub const Output = u64;
            pub const InputValue = u16;
            pub const OutputValue = u64;
        };
        pub const widenByte = struct {
            pub const Input = u8;
            pub const Output = u64;
            pub const InputValue = u8;
            pub const OutputValue = u64;
        };
        pub const widenSigned = struct {
            pub const Input = u32;
            pub const Output = i64;
            pub const InputValue = u32;
            pub const OutputValue = i64;
        };
        pub const narrow = struct {
            pub const Input = u64;
            pub const Output = u32;
            pub const InputValue = u64;
            pub const OutputValue = u32;
        };
        pub const narrowByte = struct {
            pub const Input = u64;
            pub const Output = u8;
            pub const InputValue = u64;
            pub const OutputValue = u8;
        };
        pub const narrowSigned = struct {
            pub const Input = i64;
            pub const Output = u32;
            pub const InputValue = i64;
            pub const OutputValue = u32;
        };
        pub const bitMask = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
        pub const andBits = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const orBits = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const shiftLeft = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const hash = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
        pub const hash32 = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
    };
};

pub const layouts = struct {
    pub const @"std:float" = struct {
    };
    pub const @"std:integer" = struct {
    };
};
