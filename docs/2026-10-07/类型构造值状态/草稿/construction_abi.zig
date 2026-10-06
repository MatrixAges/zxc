pub const zx_type_11 = enum {
    Scalar,
    Object,
    Optional,
    List,
    Tuple,
    ErrorSet,
    Task,
    Enumeration,
    NativeReference,
};

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

pub const zx_type_22 = struct {
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

pub const zx_type_23 = struct {
    left: *const zx_type_22,
    right: *const zx_type_22,
};

pub const zx_type_24 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_22,
    right: *const zx_type_22,
};

pub const zx_type_25 = struct {
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_26 = struct {
    candidate: *const zx_type_19,
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_27 = struct {
    candidate: *const zx_type_19,
    tables: *const zx_type_16,
};

pub const zx_type_28 = struct {
    candidate: *const zx_type_19,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_29 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_30 = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
};

pub const zx_type_31 = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
};

pub const zx_type_33 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    table: *const zx_type_15,
};

pub const zx_type_34 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
};

pub const zx_type_35 = struct {
    id: u32,
    native_references: bool,
    table: *const zx_type_15,
};

pub const zx_type_36 = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_15,
    target: zx_type_11,
};

pub const zx_type_37 = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_15,
};

pub const zx_type_38 = struct {
    []const bool,
    void,
};

pub const zx_type_39 = enum {
    None,
    TaskContainer,
    VoidList,
    TaskTuple,
    TaskObject,
};

pub const zx_type_40 = struct {
    candidate: *const zx_type_19,
    table: *const zx_type_15,
};

pub const zx_type_41 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_42 = struct {
    code: []const u8,
    message: []const u8,
};

pub const zx_type_43 = struct {
    delta: *const zx_type_15,
    diagnostic: *const zx_type_42,
    id: u32,
};

pub const zx_type_44 = struct {
    []const []const u8,
    void,
};

pub const zx_type_45 = struct {
    *const zx_type_40,
};

pub const zx_type_46 = struct {
    *const zx_type_40,
    *const zx_type_43,
};

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

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_18 = null,
};

pub const value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
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

pub const value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: *const zx_type_22,
    right: *const zx_type_22,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_22,
    right: *const zx_type_22,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22 = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: []const u8,
    right: []const u8,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
    zx_origin: ?*const zx_type_34 = null,
};

pub const value_zx_type_35_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    id: u32,
    native_references: bool,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_36_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_15,
    target: zx_type_11,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const bool,
    void,
    ?*const zx_type_38,
};

pub const value_zx_type_40_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85 = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_41_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_41 = null,
};

pub const value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    code: []const u8,
    message: []const u8,
    zx_origin: ?*const zx_type_42 = null,
};

pub const value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    delta: *const zx_type_15,
    diagnostic: value_zx_type_42_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    id: u32,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const []const u8,
    void,
    ?*const zx_type_44,
};

pub const value_zx_type_45_c120c990575957810e275d0b81efeeb6df6ef29da7764f902a24293e82a7db22 = struct {
    value_zx_type_40_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85,
    ?*const zx_type_45,
};

pub const value_zx_type_46_8cbae8382951ddbfd95211d6cfcb289bccbd69ec319c254d6b394146661e4075 = struct {
    value_zx_type_40_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85,
    value_zx_type_43_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1,
    ?*const zx_type_46,
};

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
    pub const @"zig:integers" = struct {};
};
