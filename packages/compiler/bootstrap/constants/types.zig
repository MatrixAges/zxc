pub const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = enum { Integer, NegativeInteger, Float, String, Boolean, None, Unit, Some, Capture, Task, AwaitTask, CancelTask, Parallel, OptionalValue, EnumValue, ErrorValue, Reference, StoreGet, Field, Index, Length, List, Tuple, TupleField, Template, ListOperation, Transform, Scope, Iteration, ListUpdate, Call, Unary, Binary, Conditional, Match, Object, };
pub const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d = enum { Push, Pop, Sort, Reverse, Splice, Concat, };
pub const zx_type_e76202ba7e8fa459e4363bda9b871257e2b192c42640e03e65c79eedcb6527f5 = enum { Map, Filter, Reduce, Every, Some, Sort, };
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

pub const zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78 = struct {
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

pub const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c = struct {
    expressions: *const zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78,
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

pub const zx_type_3528180fd373a5a0c276e40ab64970a4c5db15f49dd01fd3379db0094362ba3b = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
};

pub const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_835ea50a6ad051379c0d8291161ef08349e18c68fab315f7214f8609612b8882 = struct {
    cursor: *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
};

pub const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
};

pub const zx_type_c22bc6bb44c823f09c9998e1942a4719f164fbdf3623e4af03459af19b95be16 = struct {
    id: u32,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
};

pub const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
};

pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct { []const bool, void, };

pub const zx_type_55be29164d191b55b126929541840511f2cfd9042570da147e26123a097e0c3f = struct {
    diagnostic: *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e,
    expressions: *const zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78,
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
pub const zx_type_75b1e354d2e30aacdacc30268840f689c5552c6eff6369dddca99de7117a7a93 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, };
pub const zx_type_f909de019b2067fc86d685f082fd5e36978fbcf8fa6d9b20a9e43e8feaeca670 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, };
pub const zx_type_39eb6105f64e4b55d5c5e092d3486512b60e3e497e12c559c203446b09c9cb10 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_9a6706d126b3210e2c94950ab4d90dafe897b901e016959d5427ff42fd34fe78 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, };
pub const zx_type_bc214a1fbe80bb76365953a0a04d0157faced655a8df60d37bed4e1fb8a434f2 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, *const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872, *const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8, };

pub const value_4ae5d85f1854ef8438f79c8e2a34690101e11594d44d507f9e5d0fe976d713ba = struct {
    floating: bool,
    id: u32,
    integer: bool,
    signed: bool,
    single: bool,
    zx_origin: ?*const zx_type_8dd5732202898334ee807f5723a53d8c4b095735e131ae1eb7ac2595144fe0ce = null,
};

pub const view_value_4ae5d85f1854ef8438f79c8e2a34690101e11594d44d507f9e5d0fe976d713ba = value_4ae5d85f1854ef8438f79c8e2a34690101e11594d44d507f9e5d0fe976d713ba;

pub const value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080 = struct {
    items: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6 = struct {
    items: []const u32,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_3224132989508ee2f68c19f842180f53cac2aac2ba04828dc887aca75b56bf7e = struct {
    items: []const u64,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_165c4106406af1bd4eb68a86b6391eb0cd946c8f785b06760d1650ed1f07c55e = struct {
    items: []const f64,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_d69f4aae647c573ca8063979760fa78bcb70659168beea803671fe33e3700835 = struct {
    items: []const []const u8,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = struct {
    items: []const bool,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_d175ce74dbe65e230b7918197f66d02d187ed19fc13da28d5b5782026e4b5529 = struct {
    items: []const ?u32,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_927f6addc7d7aa31fbf38771fe9bc73433938e7c9d676fa276676bc77ffe4ca2 = struct {
    items: []const zx_type_8bd4167dcd5728435999e737ef2b1a179e96481385b73d70247081fd6402bb6d,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_75ca53cd3ea4ef534e40e41ad99fcd468beea6263a11b3ccbb77cb14a85006e3 = struct {
    items: []const zx_type_e76202ba7e8fa459e4363bda9b871257e2b192c42640e03e65c79eedcb6527f5,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_7f68867670f702c072bc9621ea4ac7465958aab9a186fc6231b1cdaccbd5803a = struct {
    items: []const zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_2fc3a0e629e2ebb906be69d71f60f9d715668cf471cff4f8fc9417a7675f0d42 = struct {
    items: []const zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_0b3bdb04ce56dbb816aa5a61afab5d5e3f769b10ddac57c77e312ae03dbc25df = struct {
    items: []const *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_56204d00921c77db48327c86c39a353531ec7fb63ae311b6628ea40dcbe3e37a = struct {
    expected: ?u32,
    floating: bool,
    negative: bool,
    zx_origin: ?*const zx_type_aa5186cf7ed833c23cde6e3df277bc296171f23ebbf833ea84d2f62346febac3 = null,
};

pub const view_value_56204d00921c77db48327c86c39a353531ec7fb63ae311b6628ea40dcbe3e37a = value_56204d00921c77db48327c86c39a353531ec7fb63ae311b6628ea40dcbe3e37a;

pub const value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74 = struct {
    comparison: bool,
    equality: bool,
    logical: bool,
    zx_origin: ?*const zx_type_c47d0fc0fbede5d5ffc4e8d470a13ba4d11b3768bf927c8ac18e7e9635f0c30b = null,
};

pub const view_value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74 = value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74;

pub const value_256208685e5aaa3abd3392807f3bc902fc360c2562ad171b98c84aa364a2b6b5 = struct {
    items: []const u8,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_3306f97079931f3fe098a751ca79a1948cc526d3ad1a3aa19c07b173b2f73211 = struct {
    left: f64,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: f64,
    single: bool,
    zx_origin: ?*const zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd = null,
};

pub const view_value_3306f97079931f3fe098a751ca79a1948cc526d3ad1a3aa19c07b173b2f73211 = value_3306f97079931f3fe098a751ca79a1948cc526d3ad1a3aa19c07b173b2f73211;

pub const value_233907d63587384573101be8406d9f5996afd62986d63d6bdd1304ebd096a48a = struct {
    id: u32,
    negative: bool,
    zx_origin: ?*const zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3 = null,
};

pub const view_value_233907d63587384573101be8406d9f5996afd62986d63d6bdd1304ebd096a48a = value_233907d63587384573101be8406d9f5996afd62986d63d6bdd1304ebd096a48a;

pub const value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808 = struct {
    code: []const u8,
    end: u64,
    message: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_94edbd569400ac1cc31d4b0416b2cb474e31926b1eb22311b10d54062266950e = null,
};

pub const view_value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808 = value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808;

pub const value_3bf53d3a03b7e4c880838f1068a9c20f44989a11b40f059ba75482c493abe02f = struct {
    braces: u64,
    depth: u64,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    start: u64,
    zx_origin: ?*const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005 = null,
};

pub const view_value_3bf53d3a03b7e4c880838f1068a9c20f44989a11b40f059ba75482c493abe02f = value_3bf53d3a03b7e4c880838f1068a9c20f44989a11b40f059ba75482c493abe02f;

pub const value_7f8148048367d99b0847825125c8929f61f8d19eeb5de553f59f44fabca8686e = struct {
    items: []const zx_type_559bd2c4290cfe94ac1396a025d3ee4c6afa0eaed3781a98f1950b8cde0ee005,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_801cdbd1a3aedcc1f03731a6d1e03b0f9773f31e04f8f2044ce1b7e8f8e6d5ac = struct {
    items: []const *const zx_type_7ab04c4134c734d3f48a1e6006346970e06231721631cbc913ff9aac5cf8bade,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_73a50403a3dd2142645c07e043ea92990671d1a960d48eaffa082e0982ce9235 = struct {
    items: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_0ed333f01f927261cdb32efaf0ad31c885486680fd4f195515e9b1fef16d90e5 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: value_73a50403a3dd2142645c07e043ea92990671d1a960d48eaffa082e0982ce9235,
    depth: u64,
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    dollar: bool,
    frames: value_7f8148048367d99b0847825125c8929f61f8d19eeb5de553f59f44fabca8686e,
    keyword_state: u64,
    line_break: bool,
    mode: zx_type_c869618c7e3f17a1c2362d2f314b70899c6c14ea6b593518bca68e66b4dee6a5,
    number: *const zx_type_4b19569d4fbf3c9adcc1a15013e3a2eb5135e6763b5a0fda02bb1e2dd408977d,
    offset: u64,
    skip_until: u64,
    source_length: u64,
    start: u64,
    symbol: zx_type_635c3b78ff481dd9bd161d064baf758b5895083287e43efd9d46b5291e4c9aa2,
    tokens: value_801cdbd1a3aedcc1f03731a6d1e03b0f9773f31e04f8f2044ce1b7e8f8e6d5ac,
    warmed: u8,
    zx_origin: ?*const zx_type_236347990c6302cbba81ab192964858c9461a680bac0f1f51c3da4e720fa53c4 = null,
};

pub const view_value_0ed333f01f927261cdb32efaf0ad31c885486680fd4f195515e9b1fef16d90e5 = struct {
    ahead_one: u8,
    ahead_two: u8,
    braces: u64,
    comments: []const *const zx_type_b50367e564b9195aeea252f9613f88cf771e9f744be16af53d723d2cea11554b,
    depth: u64,
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
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

pub const value_aee8d13fcff65359ca8b1bc12dd1015843eaf8243abcdf83f0d95f7c225814c3 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: value_0ed333f01f927261cdb32efaf0ad31c885486680fd4f195515e9b1fef16d90e5,
    zx_origin: ?*const zx_type_57e31919cc7e828326c51c8148292fc6ce529567616ade4182868401ab08c2a8 = null,
};

pub const view_value_aee8d13fcff65359ca8b1bc12dd1015843eaf8243abcdf83f0d95f7c225814c3 = struct {
    after: u8,
    byte: u8,
    has_after: bool,
    has_next: bool,
    next: u8,
    state: view_value_0ed333f01f927261cdb32efaf0ad31c885486680fd4f195515e9b1fef16d90e5,
    zx_origin: ?*const zx_type_57e31919cc7e828326c51c8148292fc6ce529567616ade4182868401ab08c2a8 = null,
};

pub const value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7 = struct {
    magnitude: u64,
    negative: bool,
    zx_origin: ?*const zx_type_1f2f9f7161ee72aa8644f406f749379b041af7e0336f63be0551449cc4818a78 = null,
};

pub const view_value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7 = value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7;

pub const value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3 = struct {
    left: value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7,
    target: value_4ae5d85f1854ef8438f79c8e2a34690101e11594d44d507f9e5d0fe976d713ba,
    zx_origin: ?*const zx_type_0a4f4736fab8b70e6704149509fbcef96f5940930b96cade1bb4740d1067ae5f = null,
};

pub const view_value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3 = value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3;

pub const value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64 = struct {
    message: []const u8,
    value: value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7,
    zx_origin: ?*const zx_type_d97e9881bb57ab90dad7ca756824034566dfbfaf9e79c079546d4d78484f56a3 = null,
};

pub const view_value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64 = value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64;

pub const value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24 = struct {
    left: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    operator: zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a,
    right: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    type_id: u32,
    zx_origin: ?*const zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = null,
};

pub const view_value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24 = value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24;

pub const value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 = struct {
    message: []const u8,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_374d081f355fd18c68751135bfa3a434f73641e64e935769510631d75221641f = null,
};

pub const view_value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 = value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801;

pub const value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11 = struct {
    items: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3 = struct {
    items: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    storage: enum { plain, owned, shared, exclusive, },
};

pub const value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 = struct {
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    frames: value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11,
    values: value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 = struct {
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    frames: []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    values: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_747aec58ab0a369e096dbf03c4b1be971405ed683dc5acaf4e98157d277d0872 = null,
};

pub const value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = struct {
    cursor: value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
    zx_origin: ?*const zx_type_3528180fd373a5a0c276e40ab64970a4c5db15f49dd01fd3379db0094362ba3b = null,
};

pub const view_value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7 = struct {
    cursor: view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
    zx_origin: ?*const zx_type_3528180fd373a5a0c276e40ab64970a4c5db15f49dd01fd3379db0094362ba3b = null,
};

pub const value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969 = struct {
    child: ?u32,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    message: []const u8,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_9ed7f5af41f537487554989df0f857074eb02932b19018890a5b1672aaa5e4c6 = null,
};

pub const view_value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969 = value_629fd55d01eced1adea080e74d2d6104120cc49ea2a7ea4baf0c0cef5ae2d969;

pub const value_d5a2abbc372f76159966b3930c9c4c5a4acd842be2767b076d686112aa34e82e = struct {
    cursor: value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
    zx_origin: ?*const zx_type_835ea50a6ad051379c0d8291161ef08349e18c68fab315f7214f8609612b8882 = null,
};

pub const view_value_d5a2abbc372f76159966b3930c9c4c5a4acd842be2767b076d686112aa34e82e = struct {
    cursor: view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3,
    frame: *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
    zx_origin: ?*const zx_type_835ea50a6ad051379c0d8291161ef08349e18c68fab315f7214f8609612b8882 = null,
};

pub const value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4 = struct {
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    value: ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_2731b098b3f87d364f2c1490adb4af73651edf53c240b37e0c984c0a5d80def8 = null,
};

pub const view_value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4 = value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4;

pub const value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035 = struct {
    operator: zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc,
    value: *const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    zx_origin: ?*const zx_type_4833834b8ed594421fbc1c3875afdf368d94a20f770e0cbcf8a5f613ed036622 = null,
};

pub const view_value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035 = value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035;

pub const value_21db31953bd47b48935cb8043a96d297355441b1130768304d9d639e3e4fdb55 = struct {
    id: u32,
    input: *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c,
    zx_origin: ?*const zx_type_c22bc6bb44c823f09c9998e1942a4719f164fbdf3623e4af03459af19b95be16 = null,
};

pub const view_value_21db31953bd47b48935cb8043a96d297355441b1130768304d9d639e3e4fdb55 = value_21db31953bd47b48935cb8043a96d297355441b1130768304d9d639e3e4fdb55;

pub const value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6 = struct {
    index: u64,
    result: value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9,
    source: value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const view_value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6 = struct {
    index: u64,
    result: []const bool,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
};

pub const value_03820fc4aa3f9b6144cbcf8d718ea27ff53eb9c555fb4f164ffecf2faa07befb = struct { value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };
pub const view_value_03820fc4aa3f9b6144cbcf8d718ea27ff53eb9c555fb4f164ffecf2faa07befb = struct { []const bool, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };

pub const value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = struct {
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    expressions: *const zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78,
    index: u64,
    required: value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9,
    root: u64,
    zx_origin: ?*const zx_type_55be29164d191b55b126929541840511f2cfd9042570da147e26123a097e0c3f = null,
};

pub const view_value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = struct {
    diagnostic: value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808,
    expressions: *const zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78,
    index: u64,
    required: []const bool,
    root: u64,
    zx_origin: ?*const zx_type_55be29164d191b55b126929541840511f2cfd9042570da147e26123a097e0c3f = null,
};

pub const value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182 = struct {
    conditions: value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6,
    end: u64,
    index: u64,
    required: value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9,
    results: value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const view_value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182 = struct {
    conditions: []const u32,
    end: u64,
    index: u64,
    required: []const bool,
    results: []const u32,
    zx_origin: ?*const zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
};

pub const value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed = struct {
    index: u64,
    result: value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3,
    source: value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const view_value_48d362bf81c0e43769ec8adf253c78b7a0943a321c6f3546bf54d5bd5467a4ed = struct {
    index: u64,
    result: []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6,
    source: []const zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5,
    zx_origin: ?*const zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
};

pub const value_13356d39ddf3177e39325fb4aa979982608a3684af70f02e17d123aa2f8b3283 = struct { value_5f1583f2aba3e82ab92c5d7c1d88020cbc8cd72820181108872a12696a157af3, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const view_value_13356d39ddf3177e39325fb4aa979982608a3684af70f02e17d123aa2f8b3283 = struct { []const ?*const zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, void, ?*const zx_type_b79feea7225ae16d3b76a61c59724050e86633ebc4eae2fc4bce2edf1904b799, };
pub const value_58e1795fdb635db9100e922c52e097020ab7211a8b685583f9bcc2429e02160a = struct { value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const view_value_58e1795fdb635db9100e922c52e097020ab7211a8b685583f9bcc2429e02160a = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, void, ?*const zx_type_5ca1fc038738f67879719d537d111e5c64acab8474552600c933d54e8ab3a2e2, };
pub const value_f5683dc6904c174d83434650b9f32edae81bfd9d82b6497a3db2c60195d534c5 = struct { value_938b5aee96af2513a39c6c9580bfb4ce07898d210cdab6b831936ec6fed92a11, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const view_value_f5683dc6904c174d83434650b9f32edae81bfd9d82b6497a3db2c60195d534c5 = struct { []const *const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, ?*const zx_type_3d159c37008af2e57685ac6b4e5de89ab1ab609e4823dd7ab4303f3a49fd4087, };
pub const value_00dba8fdb15fc43173cd482b0a8b1a523dc0bfe811d661eba1d3c827a04d20fe = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, ?*const zx_type_75b1e354d2e30aacdacc30268840f689c5552c6eff6369dddca99de7117a7a93, };
pub const view_value_00dba8fdb15fc43173cd482b0a8b1a523dc0bfe811d661eba1d3c827a04d20fe = value_00dba8fdb15fc43173cd482b0a8b1a523dc0bfe811d661eba1d3c827a04d20fe;
pub const value_f398b6fd0274d7ba57b70e402fbdaccd025f3b02e11767b6da93560f501362ed = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, ?*const zx_type_f909de019b2067fc86d685f082fd5e36978fbcf8fa6d9b20a9e43e8feaeca670, };
pub const view_value_f398b6fd0274d7ba57b70e402fbdaccd025f3b02e11767b6da93560f501362ed = value_f398b6fd0274d7ba57b70e402fbdaccd025f3b02e11767b6da93560f501362ed;
pub const value_f652704343f81bd2b4671ac38b7d5d03f188b0c6ba716f18cedac5a1db4f028a = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, ?*const zx_type_39eb6105f64e4b55d5c5e092d3486512b60e3e497e12c559c203446b09c9cb10, };
pub const view_value_f652704343f81bd2b4671ac38b7d5d03f188b0c6ba716f18cedac5a1db4f028a = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, ?*const zx_type_39eb6105f64e4b55d5c5e092d3486512b60e3e497e12c559c203446b09c9cb10, };
pub const value_31af4c0ce00546d0f027ab553bc419968f78d0724ee273290f3ad340460e6089 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, ?*const zx_type_9a6706d126b3210e2c94950ab4d90dafe897b901e016959d5427ff42fd34fe78, };
pub const view_value_31af4c0ce00546d0f027ab553bc419968f78d0724ee273290f3ad340460e6089 = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, ?*const zx_type_9a6706d126b3210e2c94950ab4d90dafe897b901e016959d5427ff42fd34fe78, };
pub const value_ff01e1c4700df889ee729ed6a35ca51024b576cd5350b1781097ea861c22d6ec = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, ?*const zx_type_bc214a1fbe80bb76365953a0a04d0157faced655a8df60d37bed4e1fb8a434f2, };
pub const view_value_ff01e1c4700df889ee729ed6a35ca51024b576cd5350b1781097ea861c22d6ec = struct { *const zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c, value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, view_value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3, value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, ?*const zx_type_bc214a1fbe80bb76365953a0a04d0157faced655a8df60d37bed4e1fb8a434f2, };

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
    };
};

pub const layouts = struct {
    pub const @"std:float" = struct {
    };
    pub const @"std:integer" = struct {
    };
};

