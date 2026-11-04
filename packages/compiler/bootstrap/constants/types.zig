pub const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = enum { Integer, NegativeInteger, Float, String, Boolean, None, Unit, Some, Capture, Task, AwaitTask, CancelTask, Parallel, OptionalValue, EnumValue, ErrorValue, Reference, StoreGet, Field, Index, Length, List, Tuple, TupleField, Template, ListOperation, Transform, Scope, Iteration, ListUpdate, Call, Unary, Binary, Conditional, Match, Object, };
pub const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d = enum { Push, Pop, Sort, Reverse, Splice, Concat, };
pub const zx_type_fc8f584736df01963691da707910bd2c2c5e985c675abce771f0b48d679f9ea8 = enum { Map, Filter, Reduce, Every, Some, };
pub const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc = enum { Negate, Not, };
pub const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a = enum { Coalesce, Add, Subtract, Multiply, Divide, Remainder, Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual, LogicalAnd, LogicalOr, };
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

pub const zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb = struct {
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

pub const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f = struct {
    expressions: *const zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb,
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

pub const zx_type_d374c65fa05c48ddd6bb079887a44fec10d4fc6dcf600a90427f98c1a8b60dff = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
};

pub const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_63dae22256c354d358c41481ff8affd6d7b8f7f1ebb05c59cffd7fb79d7246ff = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
};

pub const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_70cc73e2d4def4cea2ef2031e5a44f78bd47edce381ada1465ee5b5bfd0992e2 = struct {
    id: u32,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
};

pub const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
};

pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct { []const bool, void, };

pub const zx_type_d6435da976d23bf9746a320dccebec25c7ace68f4eea10815dda1261b4156f9e = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    expressions: *const zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb,
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
pub const zx_type_8bea333d4e0c31b925cf97af7051cbbb0e40b04ad0fd2948d3a6594dafd963cd = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, };
pub const zx_type_5ba03adb733bf20793003aa30a56fc053319db4aaf2881192385747967c33645 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, };
pub const zx_type_2935d1ef5da18cd52921455a2d8c87f333838dd6f17b03c138c3cb207463fe3d = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_f69d03c0af5d7e54d270d1b4013392d37823ed00fb565102249cc68dcd5890c7 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_f33836a955bfb699893a25e3fc04308b2fcd70c576af3a6bb06b9114b12ebad8 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8, };

pub const value_f4aa2c599c0bc18901c2f6c9db2138425ca0ee4d492c27be8e2673ef09da1577 = struct {
    floating: bool,
    id: u32,
    integer: bool,
    signed: bool,
    single: bool,
    zx_origin: ?*const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce = null,
};

pub const view_value_f4aa2c599c0bc18901c2f6c9db2138425ca0ee4d492c27be8e2673ef09da1577 = value_f4aa2c599c0bc18901c2f6c9db2138425ca0ee4d492c27be8e2673ef09da1577;

pub const value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba = struct {
    items: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    headered: bool,
};

pub const value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1 = struct {
    items: []const u32,
    headered: bool,
};

pub const value_7e61193154602caa91ad3929d87903c716c94593e4f5dab1a68ccd4f688177b7 = struct {
    items: []const u64,
    headered: bool,
};

pub const value_e402d2c3c8c2bb696f40de34d87de1ef215a27350619e43c69fbfdf8cfd140e9 = struct {
    items: []const f64,
    headered: bool,
};

pub const value_5aa155b7163a2406278d1a4d745137c429abcba5974c727364036e4b06366865 = struct {
    items: []const []const u8,
    headered: bool,
};

pub const value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = struct {
    items: []const bool,
    headered: bool,
};

pub const value_5864f652538d34059d1cbcbb3e39d60c475295118b845c67b6c3d91d7db981b2 = struct {
    items: []const ?u32,
    headered: bool,
};

pub const value_1045a9ea40b68d7cc28c6e33274e088be414d14b4f4cb6ccc9ee13d7b7b6cc85 = struct {
    items: []const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d,
    headered: bool,
};

pub const value_b10d30f42e1cad555b2a863b858978bc32e9e654c7d6d14f2efab90dc5216a3e = struct {
    items: []const zx_type_fc8f584736df01963691da707910bd2c2c5e985c675abce771f0b48d679f9ea8,
    headered: bool,
};

pub const value_dda368664049d7230ce3d6a35ef33a87479d4bff865ca4355d9311051eb1269c = struct {
    items: []const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    headered: bool,
};

pub const value_1b37f4ddb87f3dbf00a1e1f28fda29d893611ffde7f109018d7b8ca921199b91 = struct {
    items: []const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    headered: bool,
};

pub const value_7a871c3b631b7fdbf31ef0ffcdfe77ba51faeb79b4306a221683d32323f01305 = struct {
    items: []const *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    headered: bool,
};

pub const value_a60fc848d63560267d7cbaba3ba3f9684317a56cd59f9496d15d08627d620965 = struct {
    expected: ?u32,
    floating: bool,
    negative: bool,
    zx_origin: ?*const zx_type_aa5186cf7ed833c23cde6e3df277bc296171f23ebbf833ea84d2f62346febac3 = null,
};

pub const view_value_a60fc848d63560267d7cbaba3ba3f9684317a56cd59f9496d15d08627d620965 = value_a60fc848d63560267d7cbaba3ba3f9684317a56cd59f9496d15d08627d620965;

pub const value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123 = struct {
    comparison: bool,
    equality: bool,
    logical: bool,
    zx_origin: ?*const zx_type_c47d0fc0fbede5d5ffc4e8d470a13ba4d11b3768bf927c8ac18e7e9635f0c30b = null,
};

pub const view_value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123 = value_6486f8f42834a1fcf300f4901a4d6183cb4c4d0ef3b622b76393808c096fd123;

pub const value_2fda5b7293c4a50cd8ca07bfc2f6c8847fcba96d1a531c51e5cf8fb2d91f0a7d = struct {
    items: []const u8,
    headered: bool,
};

pub const value_206a15237c8af47285e725802a32143935d732d6ec7fc59e6664e36a01e12bf5 = struct {
    left: f64,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: f64,
    single: bool,
    zx_origin: ?*const zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd = null,
};

pub const view_value_206a15237c8af47285e725802a32143935d732d6ec7fc59e6664e36a01e12bf5 = value_206a15237c8af47285e725802a32143935d732d6ec7fc59e6664e36a01e12bf5;

pub const value_defd8c9e22b8446d9338f20015137bcc4f67988eda2b69e5fd65ef522f0db8f5 = struct {
    id: u32,
    negative: bool,
    zx_origin: ?*const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = null,
};

pub const view_value_defd8c9e22b8446d9338f20015137bcc4f67988eda2b69e5fd65ef522f0db8f5 = value_defd8c9e22b8446d9338f20015137bcc4f67988eda2b69e5fd65ef522f0db8f5;

pub const value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e = null,
};

pub const view_value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de = value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de;

pub const value_3595b9137d7a6c5736dd47cf6633f8eb71d34173497c5292980cf373581273b0 = struct {
    items: []const *const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    headered: bool,
};

pub const value_8f770a2b876353c39559f600628fbcaef361f8ed144d7d911b3894b1e5483c5d = struct {
    items: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
    headered: bool,
};

pub const value_cbc3bd3297089cd7d22ff5305996117cd1efb17f1d2f1346b5d4af01d1d7ec4d = struct {
    items: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    headered: bool,
};

pub const value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8 = struct {
    magnitude: u64,
    negative: bool,
    zx_origin: ?*const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78 = null,
};

pub const view_value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8 = value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8;

pub const value_8ba89f6fd24b0d685288fcbd2d68ba4f61dabc30ebd626fb829a319904883aba = struct {
    left: value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8,
    target: value_f4aa2c599c0bc18901c2f6c9db2138425ca0ee4d492c27be8e2673ef09da1577,
    zx_origin: ?*const zx_type_0a4f4736fab8b70e6704149509fbcef96f5940930b96cade1bb4740d1067ae5f = null,
};

pub const view_value_8ba89f6fd24b0d685288fcbd2d68ba4f61dabc30ebd626fb829a319904883aba = value_8ba89f6fd24b0d685288fcbd2d68ba4f61dabc30ebd626fb829a319904883aba;

pub const value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22 = struct {
    message: []const u8,
    value: value_fc38e1f7fc73d0600fb854b11cd42411216908ef592d60497594b82b992070a8,
    zx_origin: ?*const zx_type_d97e9881bb57ab90dad7ca756824034566dfbfaf9e79c079546d4d78484f56a3 = null,
};

pub const view_value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22 = value_368995f44f4ef4a2eb1f30d8e31e16c607e34b7636afa681c693d0d17558fb22;

pub const value_542fb942b5e80bc6beb01a9ddd5b7761705bd8bb086ab54502b68ad08ec8495f = struct {
    left: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    type_id: u32,
    zx_origin: ?*const zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = null,
};

pub const view_value_542fb942b5e80bc6beb01a9ddd5b7761705bd8bb086ab54502b68ad08ec8495f = value_542fb942b5e80bc6beb01a9ddd5b7761705bd8bb086ab54502b68ad08ec8495f;

pub const value_47783bf8208b4a49087ce11f44967652d7dc3f4bd9d296ac7cc5fc8d83b84420 = struct {
    message: []const u8,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_374d081f355fd18c68751135bfa3a434f73641e64e935769510631d75221641f = null,
};

pub const view_value_47783bf8208b4a49087ce11f44967652d7dc3f4bd9d296ac7cc5fc8d83b84420 = value_47783bf8208b4a49087ce11f44967652d7dc3f4bd9d296ac7cc5fc8d83b84420;

pub const value_9abd23e7675966d9bb975045a789abcb353fb365db04f01d35777c2ef0a68d56 = struct {
    items: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    headered: bool,
};

pub const value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58 = struct {
    items: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    headered: bool,
};

pub const value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000 = struct {
    diagnostic: value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de,
    frames: value_9abd23e7675966d9bb975045a789abcb353fb365db04f01d35777c2ef0a68d56,
    values: value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000 = struct {
    diagnostic: value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de,
    frames: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    values: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1 = struct {
    cursor: value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
    zx_origin: ?*const zx_type_d374c65fa05c48ddd6bb079887a44fec10d4fc6dcf600a90427f98c1a8b60dff = null,
};

pub const view_value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1 = struct {
    cursor: view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
    zx_origin: ?*const zx_type_d374c65fa05c48ddd6bb079887a44fec10d4fc6dcf600a90427f98c1a8b60dff = null,
};

pub const value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = null,
};

pub const view_value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60 = value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60;

pub const value_19ebf3d3daa1235aa9ca0e94693f070406096da386675c891f585ac3f6cab6cf = struct {
    cursor: value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
    zx_origin: ?*const zx_type_63dae22256c354d358c41481ff8affd6d7b8f7f1ebb05c59cffd7fb79d7246ff = null,
};

pub const view_value_19ebf3d3daa1235aa9ca0e94693f070406096da386675c891f585ac3f6cab6cf = struct {
    cursor: view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
    zx_origin: ?*const zx_type_63dae22256c354d358c41481ff8affd6d7b8f7f1ebb05c59cffd7fb79d7246ff = null,
};

pub const value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191 = struct {
    diagnostic: value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = null,
};

pub const view_value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191 = value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191;

pub const value_bfe548552bdbc7afbd8c37ac2329ed6c5cacb808510796bb6bee50e007551f9f = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = null,
};

pub const view_value_bfe548552bdbc7afbd8c37ac2329ed6c5cacb808510796bb6bee50e007551f9f = value_bfe548552bdbc7afbd8c37ac2329ed6c5cacb808510796bb6bee50e007551f9f;

pub const value_1323d051ef2b29690bf3e0d5973157e37a2ee5ed38a6c2349631e1e356aa78df = struct {
    id: u32,
    input: *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f,
    zx_origin: ?*const zx_type_70cc73e2d4def4cea2ef2031e5a44f78bd47edce381ada1465ee5b5bfd0992e2 = null,
};

pub const view_value_1323d051ef2b29690bf3e0d5973157e37a2ee5ed38a6c2349631e1e356aa78df = value_1323d051ef2b29690bf3e0d5973157e37a2ee5ed38a6c2349631e1e356aa78df;

pub const value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00 = struct {
    index: u64,
    result: value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90,
    source: value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const view_value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00 = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const value_54590184f9eb36a4fbb5d772684604367e64a000990366136f68960087bda66c = struct { value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };
pub const view_value_54590184f9eb36a4fbb5d772684604367e64a000990366136f68960087bda66c = struct { []const bool, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };

pub const value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = struct {
    diagnostic: value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de,
    expressions: *const zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb,
    index: u64,
    required: value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90,
    root: u64,
    zx_origin: ?*const zx_type_d6435da976d23bf9746a320dccebec25c7ace68f4eea10815dda1261b4156f9e = null,
};

pub const view_value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = struct {
    diagnostic: value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de,
    expressions: *const zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb,
    index: u64,
    required: []const bool,
    root: u64,
    zx_origin: ?*const zx_type_d6435da976d23bf9746a320dccebec25c7ace68f4eea10815dda1261b4156f9e = null,
};

pub const value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d = struct {
    conditions: value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1,
    end: u64,
    index: u64,
    required: value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90,
    results: value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const view_value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d = struct {
    conditions: []const u32,
    end: u64,
    index: u64,
    required: []const bool,
    results: []const u32,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210 = struct {
    index: u64,
    result: value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58,
    source: value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const view_value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210 = struct {
    index: u64,
    result: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const value_728d2383a7b5714f531290e6953ef3a173b85b9ab82a32fc253477fa434524db = struct { value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const view_value_728d2383a7b5714f531290e6953ef3a173b85b9ab82a32fc253477fa434524db = struct { []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const value_eaa664eee2bb19c07a88ce57ebf6c4dea99531bcff79b1fe1da0be5688f7dfc3 = struct { value_9abd23e7675966d9bb975045a789abcb353fb365db04f01d35777c2ef0a68d56, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const view_value_eaa664eee2bb19c07a88ce57ebf6c4dea99531bcff79b1fe1da0be5688f7dfc3 = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const value_d90f189322805b7fdb2e3387b8aa8810a25451eb3c4a02836900ff6ad2dc0a0f = struct { value_9abd23e7675966d9bb975045a789abcb353fb365db04f01d35777c2ef0a68d56, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const view_value_d90f189322805b7fdb2e3387b8aa8810a25451eb3c4a02836900ff6ad2dc0a0f = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const value_5284a695d3fd1af3bb301f2dcb48c66da960f451b43c0cd6a3a238e696c7938d = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, ?*const zx_type_8bea333d4e0c31b925cf97af7051cbbb0e40b04ad0fd2948d3a6594dafd963cd, };
pub const view_value_5284a695d3fd1af3bb301f2dcb48c66da960f451b43c0cd6a3a238e696c7938d = value_5284a695d3fd1af3bb301f2dcb48c66da960f451b43c0cd6a3a238e696c7938d;
pub const value_cac4fa4047e7ce56bb20b223cf2f7b50f84c98edead5962dc79577d091843852 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, ?*const zx_type_5ba03adb733bf20793003aa30a56fc053319db4aaf2881192385747967c33645, };
pub const view_value_cac4fa4047e7ce56bb20b223cf2f7b50f84c98edead5962dc79577d091843852 = value_cac4fa4047e7ce56bb20b223cf2f7b50f84c98edead5962dc79577d091843852;
pub const value_26dff3d33f63fc195c322ffd755955ef3a76393255506aef0574645d2c11aed2 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, ?*const zx_type_2935d1ef5da18cd52921455a2d8c87f333838dd6f17b03c138c3cb207463fe3d, };
pub const view_value_26dff3d33f63fc195c322ffd755955ef3a76393255506aef0574645d2c11aed2 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, ?*const zx_type_2935d1ef5da18cd52921455a2d8c87f333838dd6f17b03c138c3cb207463fe3d, };
pub const value_e9274dda57ba7f5ca622c89079ad36f2fea083d36f17a77fa326ea858dfa847e = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, ?*const zx_type_f69d03c0af5d7e54d270d1b4013392d37823ed00fb565102249cc68dcd5890c7, };
pub const view_value_e9274dda57ba7f5ca622c89079ad36f2fea083d36f17a77fa326ea858dfa847e = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, ?*const zx_type_f69d03c0af5d7e54d270d1b4013392d37823ed00fb565102249cc68dcd5890c7, };
pub const value_4bbf26bb46476cae7c61de9608a2e1e344d00929f75777262509fc8a803dec92 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, ?*const zx_type_f33836a955bfb699893a25e3fc04308b2fcd70c576af3a6bb06b9114b12ebad8, };
pub const view_value_4bbf26bb46476cae7c61de9608a2e1e344d00929f75777262509fc8a803dec92 = struct { *const zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f, value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, view_value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, ?*const zx_type_f33836a955bfb699893a25e3fc04308b2fcd70c576af3a6bb06b9114b12ebad8, };

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

    return (try zxAllocate(T, allocator, items, count));
}

pub fn zxAllocate(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize) error{ OutOfMemory, }![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));
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
            if (((path).len == 0)) {
                ((target).*).items = (try zxReserve(((@typeInfo(@TypeOf(((target).*).items))).pointer).child, allocator, ((target).*).items, (((target).*).items).len, false));
                ((target).*).headered = true;
            } else {
                if (@hasField(V, ((path)[0])[1])) {
                    @field((target).*, ((path)[0])[1]) = null;
                }

                (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..]));
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
    };
};

pub const layouts = struct {
    pub const @"std:float" = struct {
    };
    pub const @"std:integer" = struct {
    };
};

