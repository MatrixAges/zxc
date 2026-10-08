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

pub const zx_type_36 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
};

pub const zx_type_41 = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
};

pub const zx_type_42 = struct {
    modules: *const zx_type_36,
    table: *const zx_type_15,
};

pub const zx_type_43 = struct {
    functions: *const zx_type_41,
    index: u64,
    modules: *const zx_type_36,
};

pub const zx_type_44 = struct {
    index: u64,
    modules: *const zx_type_36,
};

pub const zx_type_45 = struct {
    ids: []const u64,
    ready: []const bool,
};

pub const zx_type_46 = struct {
    index: u64,
    pending: *const zx_type_45,
    table: *const zx_type_15,
};

pub const zx_type_47 = struct { []const u64, void, };
pub const zx_type_48 = struct { []const bool, void, };

pub const zx_type_49 = struct {
    first: u64,
    pending: *const zx_type_45,
    remaining: u64,
    values: []const u32,
};

pub const zx_type_50 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
};

pub const zx_type_51 = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
};

pub const zx_type_52 = struct {
    index: u64,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_53 = struct {
    pending: *const zx_type_45,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_55 = struct { []const u64, ?u64, };
pub const zx_type_57 = struct { []const bool, ?bool, };

pub const zx_type_58 = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
};

pub const zx_type_59 = struct {
    is_native: []const bool,
    keys: []const []const u8,
};

pub const zx_type_60 = struct {
    index: u64,
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_61 = struct {
    natives: *const zx_type_58,
    state: *const zx_type_29,
};

pub const zx_type_62 = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: *const zx_type_31,
    values: []const u32,
};

pub const zx_type_63 = struct {
    dependencies: *const zx_type_59,
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_64 = struct {
    dependencies: *const zx_type_59,
    found: bool,
    index: u64,
    module: u64,
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_65 = struct {
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_66 = struct {
    index: u64,
    member: u64,
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_67 = struct {
    ids: []const u32,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_68 = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_69 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_70 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_71 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_72 = struct {
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_73 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_74 = struct {
    dependencies: *const zx_type_59,
    modules: *const zx_type_36,
    natives: *const zx_type_58,
    request: *const zx_type_31,
    state: *const zx_type_29,
    type_imports: []const u32,
};

pub const zx_type_75 = struct {
    dependencies: *const zx_type_59,
    modules: *const zx_type_36,
    request: *const zx_type_31,
    type_imports: []const u32,
};

pub const zx_type_76 = struct { *const zx_type_63, };
pub const zx_type_77 = struct { *const zx_type_63, bool, };
pub const zx_type_78 = struct { *const zx_type_63, bool, *const zx_type_61, };
pub const zx_type_79 = struct { *const zx_type_65, };
pub const zx_type_80 = struct { *const zx_type_65, bool, };
pub const zx_type_81 = struct { *const zx_type_65, bool, *const zx_type_61, };
pub const zx_type_82 = struct { *const zx_type_74, };
pub const zx_type_83 = struct { *const zx_type_74, bool, };
pub const zx_type_84 = struct { *const zx_type_74, bool, *const zx_type_29, };
pub const zx_type_85 = struct { *const zx_type_74, bool, *const zx_type_29, *const zx_type_61, };
pub const zx_type_86 = struct { *const zx_type_75, };
pub const zx_type_87 = struct { *const zx_type_75, *const zx_type_58, };
pub const zx_type_88 = struct { *const zx_type_75, *const zx_type_58, *const zx_type_29, };
pub const zx_type_89 = struct { *const zx_type_75, *const zx_type_58, *const zx_type_29, *const zx_type_29, };
pub const zx_type_90 = struct { *const zx_type_75, *const zx_type_58, *const zx_type_29, *const zx_type_29, *const zx_type_61, };
pub const zx_type_91 = struct { *const zx_type_75, *const zx_type_58, *const zx_type_29, *const zx_type_29, *const zx_type_61, *const zx_type_61, };

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

pub const value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_41_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
    zx_origin: ?*const zx_type_41 = null,
};

pub const value_zx_type_42_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_42 = null,
};

pub const value_zx_type_43_1dad68e6b0d0122b1476653abf673933ed027adc2ebd5fd855aec9b533a7b0ea = struct {
    functions: value_zx_type_41_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    index: u64,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_44_68bebc01d99f6879dc43b8e7adb1a3f45ef4366c6f107510d452df8f6f575699 = struct {
    index: u64,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_44 = null,
};

pub const value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    ids: []const u64,
    ready: []const bool,
    zx_origin: ?*const zx_type_45 = null,
};

pub const value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    pending: value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_46 = null,
};

pub const value_zx_type_47_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_47, };
pub const value_zx_type_48_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_48, };

pub const value_zx_type_49_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = struct {
    first: u64,
    pending: value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    remaining: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_49 = null,
};

pub const value_zx_type_50_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    zx_origin: ?*const zx_type_50 = null,
};

pub const value_zx_type_51_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_51 = null,
};

pub const value_zx_type_52_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    index: u64,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_52 = null,
};

pub const value_zx_type_53_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = struct {
    pending: value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_53 = null,
};

pub const value_zx_type_55_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_55, };
pub const value_zx_type_57_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const bool, ?bool, ?*const zx_type_57, };

pub const value_zx_type_59_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    is_native: []const bool,
    keys: []const []const u8,
    zx_origin: ?*const zx_type_59 = null,
};

pub const value_zx_type_60_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06 = struct {
    index: u64,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_60 = null,
};

pub const value_zx_type_62_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    values: []const u32,
    zx_origin: ?*const zx_type_62 = null,
};

pub const value_zx_type_63_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd = struct {
    dependencies: value_zx_type_59_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_63 = null,
};

pub const value_zx_type_64_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = struct {
    dependencies: value_zx_type_59_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    found: bool,
    index: u64,
    module: u64,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_64 = null,
};

pub const value_zx_type_65_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319 = struct {
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_65 = null,
};

pub const value_zx_type_66_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = struct {
    index: u64,
    member: u64,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_66 = null,
};

pub const value_zx_type_67_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    ids: []const u32,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_67 = null,
};

pub const value_zx_type_68_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_68 = null,
};

pub const value_zx_type_69_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_69 = null,
};

pub const value_zx_type_70_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_70 = null,
};

pub const value_zx_type_71_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_71 = null,
};

pub const value_zx_type_72_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_72 = null,
};

pub const value_zx_type_73_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_73 = null,
};

pub const value_zx_type_74_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1 = struct {
    dependencies: value_zx_type_59_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_58,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_74 = null,
};

pub const value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c = struct {
    dependencies: value_zx_type_59_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_36_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_75 = null,
};

pub const value_zx_type_76_6d9e1750b9dc48c0938aa2ac30bab75b173d85436f941cb6b1e6a70893b3b46a = struct { value_zx_type_63_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, ?*const zx_type_76, };
pub const value_zx_type_77_47fda4d3f05483967cdab92aa39f1b1a8a628d748940a28659fde352c6b33168 = struct { value_zx_type_63_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, ?*const zx_type_77, };
pub const value_zx_type_78_f65b384d705929099a04ca81a260f41b0833337a4c4982b958cbd0bbc226ca1a = struct { value_zx_type_63_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, *const zx_type_61, ?*const zx_type_78, };
pub const value_zx_type_79_ba7117c8189198b145774a1deb80e8c00c3b3955ad3770683638b4c34cd56d85 = struct { value_zx_type_65_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, ?*const zx_type_79, };
pub const value_zx_type_80_b4bdce0c22ba9fcd21b035f595a1e6ff422801720f1e9dbb9052ede6e014123e = struct { value_zx_type_65_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, ?*const zx_type_80, };
pub const value_zx_type_81_bcc77718ef8753ce2292cc1cfc53c0bc5181c8ace3e3d831b55abd3283313abf = struct { value_zx_type_65_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, *const zx_type_61, ?*const zx_type_81, };
pub const value_zx_type_82_2453b88f9ff0f058cf67f3e2aae4b57b1f792f4aa4bc8106ea9423849dc5da26 = struct { value_zx_type_74_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, ?*const zx_type_82, };
pub const value_zx_type_83_80056fe358733769c185dbbb4338a2e514aa1d61e1d5a42da77a4fc33ee43ea0 = struct { value_zx_type_74_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, ?*const zx_type_83, };
pub const value_zx_type_84_f2331b184dede23b05aaaed7691fef17c09f05dda3b0cf700a00d066d31fe693 = struct { value_zx_type_74_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_29, ?*const zx_type_84, };
pub const value_zx_type_85_aec30df4a6153f7fd1820ce13f1852801e3a92d905e0b06996038115c38ad70b = struct { value_zx_type_74_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_29, *const zx_type_61, ?*const zx_type_85, };
pub const value_zx_type_86_650a06221519b1c0a8bfe7eeff05c4ec68a5b359688c9b8eaa164cb686cb4a09 = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, ?*const zx_type_86, };
pub const value_zx_type_87_384a0312826a4390b187be87aa813ba021080bcb4e6a51025feee70a229d6b96 = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_58, ?*const zx_type_87, };
pub const value_zx_type_88_b42e7e8ebd73bbbb5f4dca636519f09a1e235eb6744d84d7515a46b83718007b = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_58, *const zx_type_29, ?*const zx_type_88, };
pub const value_zx_type_89_36c50fa60bcec728ddc8218a863082832789cf39f23fa7cbcb1190b530106ffe = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_58, *const zx_type_29, *const zx_type_29, ?*const zx_type_89, };
pub const value_zx_type_90_e3a8209e2e11b2669766ea7f885de8bfc8af2dda92cb45f3e161bde7effb80d3 = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_58, *const zx_type_29, *const zx_type_29, *const zx_type_61, ?*const zx_type_90, };
pub const value_zx_type_91_4f2bc43c2426ab210b256eb07bec1ecc5ae3f3917ae8f7660aef7516e4e0747a = struct { value_zx_type_75_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_58, *const zx_type_29, *const zx_type_29, *const zx_type_61, *const zx_type_61, ?*const zx_type_91, };

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

