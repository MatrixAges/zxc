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

pub const zx_type_31 = struct {
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    roots: []const bool,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_32 = struct {
    ids: []const u64,
    ready: []const bool,
};

pub const zx_type_33 = struct {
    index: u64,
    pending: *const zx_type_32,
    table: *const zx_type_15,
};

pub const zx_type_34 = struct { []const u64, void, };
pub const zx_type_35 = struct { []const bool, void, };

pub const zx_type_36 = struct {
    first: u64,
    pending: *const zx_type_32,
    remaining: u64,
    values: []const u32,
};

pub const zx_type_37 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
};

pub const zx_type_38 = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
};

pub const zx_type_39 = struct {
    index: u64,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_40 = struct {
    pending: *const zx_type_32,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_42 = struct { []const u64, ?u64, };
pub const zx_type_44 = struct { []const bool, ?bool, };

pub const zx_type_49 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
};

pub const zx_type_54 = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
};

pub const zx_type_55 = struct {
    modules: *const zx_type_49,
    table: *const zx_type_15,
};

pub const zx_type_56 = struct {
    functions: *const zx_type_54,
    index: u64,
    modules: *const zx_type_49,
};

pub const zx_type_57 = struct {
    modules: *const zx_type_49,
    request: *const zx_type_31,
    selected: []const bool,
    state: *const zx_type_29,
};

pub const zx_type_58 = struct {
    selected: []const bool,
    state: *const zx_type_29,
};

pub const zx_type_59 = struct {
    including: bool,
    index: u64,
    member: u64,
    modules: *const zx_type_49,
    plan: *const zx_type_29,
    request: *const zx_type_31,
    selected: []const bool,
};

pub const zx_type_60 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_61 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_62 = struct {
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_63 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_64 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_65 = struct {
    modules: *const zx_type_49,
    request: *const zx_type_31,
};

pub const zx_type_66 = struct { *const zx_type_57, };
pub const zx_type_67 = struct { *const zx_type_57, bool, };
pub const zx_type_68 = struct { *const zx_type_57, bool, *const zx_type_58, };
pub const zx_type_69 = struct { *const zx_type_65, };
pub const zx_type_70 = struct { *const zx_type_65, *const zx_type_29, };
pub const zx_type_71 = struct { *const zx_type_65, *const zx_type_29, *const zx_type_29, };
pub const zx_type_72 = struct { *const zx_type_65, *const zx_type_29, *const zx_type_29, []const bool, };
pub const zx_type_73 = struct { *const zx_type_65, *const zx_type_29, *const zx_type_29, []const bool, *const zx_type_58, };

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

pub const value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    roots: []const bool,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    ids: []const u64,
    ready: []const bool,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    pending: value_zx_type_32_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_34, };
pub const value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_35, };

pub const value_zx_type_36_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = struct {
    first: u64,
    pending: value_zx_type_32_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    remaining: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_39_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    index: u64,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = struct {
    pending: value_zx_type_32_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_42_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_42, };
pub const value_zx_type_44_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const bool, ?bool, ?*const zx_type_44, };

pub const value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    zx_origin: ?*const zx_type_49 = null,
};

pub const value_zx_type_54_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
    zx_origin: ?*const zx_type_54 = null,
};

pub const value_zx_type_55_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    modules: value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_55 = null,
};

pub const value_zx_type_56_1dad68e6b0d0122b1476653abf673933ed027adc2ebd5fd855aec9b533a7b0ea = struct {
    functions: value_zx_type_54_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    index: u64,
    modules: value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_56 = null,
};

pub const value_zx_type_57_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0 = struct {
    modules: value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    selected: []const bool,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_57 = null,
};

pub const value_zx_type_58_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    selected: []const bool,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_58 = null,
};

pub const value_zx_type_59_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = struct {
    including: bool,
    index: u64,
    member: u64,
    modules: value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    selected: []const bool,
    zx_origin: ?*const zx_type_59 = null,
};

pub const value_zx_type_60_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_60 = null,
};

pub const value_zx_type_61_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_61 = null,
};

pub const value_zx_type_62_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_62 = null,
};

pub const value_zx_type_63_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_63 = null,
};

pub const value_zx_type_64_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_64 = null,
};

pub const value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420 = struct {
    modules: value_zx_type_49_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_65 = null,
};

pub const value_zx_type_66_dac9ba8687978d9ffb0eb052e3f6ae7d521e650e450750dbb67fdd4751cbc531 = struct { value_zx_type_57_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, ?*const zx_type_66, };
pub const value_zx_type_67_2285c4cde9fb0898f4554d4360971713477b056f9b9a04577986492b58877f5a = struct { value_zx_type_57_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, bool, ?*const zx_type_67, };
pub const value_zx_type_68_7af08bfd7add2d7c9efd8ec9c0af55045720978afe3e10a67ef5aa69d9149d6a = struct { value_zx_type_57_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, bool, value_zx_type_58_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_68, };
pub const value_zx_type_69_d793c03486993bd03513fd063427e911d2e1da19cd778de268e674560c322001 = struct { value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, ?*const zx_type_69, };
pub const value_zx_type_70_f0fa6b51541720230634bee8e095d5016a5c2df914f8741f5ea3ff22223d9297 = struct { value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_29, ?*const zx_type_70, };
pub const value_zx_type_71_33767f0c35ae583a4e366333ab584bc92ee951eaaac4d2fb775642ad614a8152 = struct { value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_29, *const zx_type_29, ?*const zx_type_71, };
pub const value_zx_type_72_204652f06f5fed163853ae5a5979b56274ba97129482411bba2c818e22cdaf2b = struct { value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_29, *const zx_type_29, []const bool, ?*const zx_type_72, };
pub const value_zx_type_73_3e9e95181de45f44227bec13aa232f6e6be6f9e34fc9fab4a480b972c32e8abe = struct { value_zx_type_65_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_29, *const zx_type_29, []const bool, value_zx_type_58_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_73, };

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

