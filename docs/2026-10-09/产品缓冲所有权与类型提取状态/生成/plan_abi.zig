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

pub const zx_type_22 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
};

pub const zx_type_23 = struct {
    ids: []const u32,
    kinds: []const u8,
    members: []const []const u8,
    owners: []const []const u8,
};

pub const zx_type_24 = struct {
    base: *const zx_type_23,
    delta: *const zx_type_23,
};

pub const zx_type_25 = enum { Missing, Found, Conflict, };

pub const zx_type_26 = struct {
    id: u32,
    status: zx_type_25,
};

pub const zx_type_27 = enum { Invalid, MissingOrigin, Ready, };

pub const zx_type_29 = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
    origins: []const u64,
    status: zx_type_27,
};

pub const zx_type_30 = struct {
    index: u64,
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_31 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_32 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_34 = struct {
    ids: []const u64,
    ready: []const bool,
};

pub const zx_type_35 = struct {
    index: u64,
    pending: *const zx_type_34,
    table: *const zx_type_15,
};

pub const zx_type_36 = struct { []const u64, void, };
pub const zx_type_37 = struct { []const bool, void, };

pub const zx_type_38 = struct {
    first: u64,
    pending: *const zx_type_34,
    remaining: u64,
    values: []const u32,
};

pub const zx_type_39 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
};

pub const zx_type_40 = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
};

pub const zx_type_41 = struct {
    request: *const zx_type_30,
    state: *const zx_type_29,
};

pub const zx_type_42 = struct {
    pending: *const zx_type_34,
    plan: *const zx_type_29,
    request: *const zx_type_30,
};

pub const zx_type_44 = struct { []const u64, ?u64, };
pub const zx_type_46 = struct { []const bool, ?bool, };

pub const zx_type_47 = struct {
    maximum_count: u64,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_48 = struct {
    child_end: u64,
    field_end: u64,
    index: u64,
    name_end: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
};

pub const zx_type_49 = enum { Value, Callable, TypeDecl, };

pub const zx_type_50 = struct {
    kind: zx_type_49,
    name: []const u8,
};

pub const zx_type_51 = struct {
    after_underscore: bool,
    index: u64,
    kind: zx_type_49,
    name: []const u8,
    valid: bool,
};

pub const zx_type_52 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_53 = struct {
    ascending: bool,
    equal: bool,
    index: u64,
    left: []const u8,
    right: []const u8,
};

pub const zx_type_54 = struct {
    count: u64,
    first: u64,
    index: u64,
    object: bool,
    table: *const zx_type_15,
};

pub const zx_type_55 = struct {
    count: u64,
    first: u64,
    index: u64,
    object: bool,
    owner: u64,
    table: *const zx_type_15,
    valid: bool,
    values: []const u32,
};

pub const zx_type_56 = struct {
    count: u64,
    errors: bool,
    first: u64,
    values: []const []const u8,
};

pub const zx_type_57 = struct {
    count: u64,
    errors: bool,
    first: u64,
    index: u64,
    valid: bool,
    values: []const []const u8,
};

pub const zx_type_58 = struct {
    count: u64,
    first: u64,
    index: u64,
    member: []const u8,
    unique: bool,
    values: []const []const u8,
};

pub const zx_type_59 = struct {
    index: u64,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_60 = struct {
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_61 = struct {
    index: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
};

pub const zx_type_63 = struct { *const zx_type_30, };
pub const zx_type_64 = struct { *const zx_type_30, *const zx_type_29, };
pub const zx_type_65 = struct { *const zx_type_30, *const zx_type_29, *const zx_type_29, };
pub const zx_type_66 = struct { *const zx_type_47, };
pub const zx_type_67 = struct { *const zx_type_47, bool, };
pub const zx_type_68 = struct { *const zx_type_47, bool, bool, };
pub const zx_type_69 = struct { *const zx_type_30, bool, };
pub const zx_type_70 = struct { *const zx_type_30, bool, bool, };
pub const zx_type_71 = struct { *const zx_type_30, bool, bool, *const zx_type_29, };

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

pub const value_zx_type_22_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_23,
    delta: *const zx_type_23,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    id: u32,
    status: zx_type_25,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    index: u64,
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    ids: []const u64,
    ready: []const bool,
    zx_origin: ?*const zx_type_34 = null,
};

pub const value_zx_type_35_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    pending: value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_36, };
pub const value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_37, };

pub const value_zx_type_38_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = struct {
    first: u64,
    pending: value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    remaining: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_39_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_41_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_41 = null,
};

pub const value_zx_type_42_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = struct {
    pending: value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    plan: *const zx_type_29,
    request: value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_42 = null,
};

pub const value_zx_type_44_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_44, };
pub const value_zx_type_46_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const bool, ?bool, ?*const zx_type_46, };

pub const value_zx_type_47_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    maximum_count: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_47 = null,
};

pub const value_zx_type_48_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    child_end: u64,
    field_end: u64,
    index: u64,
    name_end: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
    zx_origin: ?*const zx_type_48 = null,
};

pub const value_zx_type_50_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kind: zx_type_49,
    name: []const u8,
    zx_origin: ?*const zx_type_50 = null,
};

pub const value_zx_type_51_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    after_underscore: bool,
    index: u64,
    kind: zx_type_49,
    name: []const u8,
    valid: bool,
    zx_origin: ?*const zx_type_51 = null,
};

pub const value_zx_type_52_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: []const u8,
    right: []const u8,
    zx_origin: ?*const zx_type_52 = null,
};

pub const value_zx_type_53_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    ascending: bool,
    equal: bool,
    index: u64,
    left: []const u8,
    right: []const u8,
    zx_origin: ?*const zx_type_53 = null,
};

pub const value_zx_type_54_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    count: u64,
    first: u64,
    index: u64,
    object: bool,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_54 = null,
};

pub const value_zx_type_55_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    count: u64,
    first: u64,
    index: u64,
    object: bool,
    owner: u64,
    table: *const zx_type_15,
    valid: bool,
    values: []const u32,
    zx_origin: ?*const zx_type_55 = null,
};

pub const value_zx_type_56_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    count: u64,
    errors: bool,
    first: u64,
    values: []const []const u8,
    zx_origin: ?*const zx_type_56 = null,
};

pub const value_zx_type_57_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    errors: bool,
    first: u64,
    index: u64,
    valid: bool,
    values: []const []const u8,
    zx_origin: ?*const zx_type_57 = null,
};

pub const value_zx_type_58_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    first: u64,
    index: u64,
    member: []const u8,
    unique: bool,
    values: []const []const u8,
    zx_origin: ?*const zx_type_58 = null,
};

pub const value_zx_type_59_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_59 = null,
};

pub const value_zx_type_60_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_60 = null,
};

pub const value_zx_type_61_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
    zx_origin: ?*const zx_type_61 = null,
};

pub const value_zx_type_63_efdd75a5e607c61dffb07c66411d75c96f1f2b811307e711dcc2093faf9ae2b2 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, ?*const zx_type_63, };
pub const value_zx_type_64_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, *const zx_type_29, ?*const zx_type_64, };
pub const value_zx_type_65_5160eb1c7b96ef87a1dc62bbd174d33f7e1457b4aa84245e3745977fb48f4d06 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, *const zx_type_29, *const zx_type_29, ?*const zx_type_65, };
pub const value_zx_type_66_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_47_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_66, };
pub const value_zx_type_67_654b20ccf64f2ca64b6802425f9952e8447842f7a750a25aaabc98a2fcd9a52f = struct { value_zx_type_47_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, bool, ?*const zx_type_67, };
pub const value_zx_type_68_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = struct { value_zx_type_47_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, bool, bool, ?*const zx_type_68, };
pub const value_zx_type_69_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, bool, ?*const zx_type_69, };
pub const value_zx_type_70_5160eb1c7b96ef87a1dc62bbd174d33f7e1457b4aa84245e3745977fb48f4d06 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, bool, bool, ?*const zx_type_70, };
pub const value_zx_type_71_57f85255c4e0f481bb9dba6f1c5c53a3c79606b4646e8359ba48db8ca9d7abe8 = struct { value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, bool, bool, *const zx_type_29, ?*const zx_type_71, };

pub const native = struct {
    pub const @"zig:integers" = struct {
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
    pub const @"zig:integers" = struct {
    };
};

