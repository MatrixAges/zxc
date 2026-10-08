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
    plan: *const zx_type_29,
    table: *const zx_type_15,
};

pub const zx_type_33 = struct {
    index: u64,
    member: u64,
    plan: *const zx_type_29,
    source: *const zx_type_15,
    table: *const zx_type_15,
};

pub const zx_type_34 = struct { []const u8, void, };
pub const zx_type_35 = struct { []const u32, void, };
pub const zx_type_36 = struct { []const []const u8, void, };

pub const zx_type_37 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
};

pub const zx_type_38 = struct {
    index: u64,
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    source: *const zx_type_23,
};

pub const zx_type_43 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
};

pub const zx_type_48 = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
};

pub const zx_type_49 = struct {
    modules: *const zx_type_43,
    table: *const zx_type_15,
};

pub const zx_type_50 = struct {
    functions: *const zx_type_48,
    index: u64,
    modules: *const zx_type_43,
};

pub const zx_type_51 = struct {
    index: u64,
    modules: *const zx_type_43,
};

pub const zx_type_52 = struct {
    ids: []const u64,
    ready: []const bool,
};

pub const zx_type_53 = struct {
    index: u64,
    pending: *const zx_type_52,
    table: *const zx_type_15,
};

pub const zx_type_54 = struct { []const u64, void, };
pub const zx_type_55 = struct { []const bool, void, };

pub const zx_type_56 = struct {
    first: u64,
    pending: *const zx_type_52,
    remaining: u64,
    values: []const u32,
};

pub const zx_type_57 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
};

pub const zx_type_58 = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
};

pub const zx_type_59 = struct {
    index: u64,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_60 = struct {
    pending: *const zx_type_52,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_62 = struct { []const u64, ?u64, };
pub const zx_type_64 = struct { []const bool, ?bool, };

pub const zx_type_65 = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
};

pub const zx_type_66 = struct {
    is_native: []const bool,
    keys: []const []const u8,
};

pub const zx_type_67 = struct {
    index: u64,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_68 = struct {
    natives: *const zx_type_65,
    state: *const zx_type_29,
};

pub const zx_type_69 = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: *const zx_type_31,
    values: []const u32,
};

pub const zx_type_70 = struct {
    dependencies: *const zx_type_66,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_71 = struct {
    dependencies: *const zx_type_66,
    found: bool,
    index: u64,
    module: u64,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_72 = struct {
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_73 = struct {
    index: u64,
    member: u64,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_74 = struct {
    inputs: []const u32,
    native_modules: []const ?u32,
    outputs: []const u32,
};

pub const zx_type_75 = struct {
    ids: []const u32,
    inputs: []const u32,
    outputs: []const u32,
};

pub const zx_type_76 = struct {
    functions: *const zx_type_65,
    natives: *const zx_type_65,
    state: *const zx_type_29,
};

pub const zx_type_77 = struct {
    imports: *const zx_type_75,
    plan: *const zx_type_76,
    signatures: *const zx_type_74,
};

pub const zx_type_78 = struct {
    index: u64,
    modules: *const zx_type_43,
    plan: *const zx_type_76,
    request: *const zx_type_31,
    signatures: *const zx_type_74,
};

pub const zx_type_79 = struct {
    imports: *const zx_type_75,
    modules: *const zx_type_43,
    plan: *const zx_type_76,
    request: *const zx_type_31,
    signatures: *const zx_type_74,
};

pub const zx_type_80 = struct {
    imports: *const zx_type_75,
    index: u64,
    modules: *const zx_type_43,
    plan: *const zx_type_76,
    request: *const zx_type_31,
    signatures: *const zx_type_74,
};

pub const zx_type_81 = struct {
    ids: []const u32,
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_82 = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_83 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_84 = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
};

pub const zx_type_85 = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
};

pub const zx_type_86 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_87 = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
};

pub const zx_type_88 = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
};

pub const zx_type_89 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_90 = struct {
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_91 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_92 = struct {
    inputs: []const u32,
};

pub const zx_type_93 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
};

pub const zx_type_94 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
};

pub const zx_type_95 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
};

pub const zx_type_96 = struct {
    dependencies: *const zx_type_66,
    function_imports: *const zx_type_75,
    modules: *const zx_type_43,
    request: *const zx_type_31,
    signatures: *const zx_type_74,
    type_imports: []const u32,
};

pub const zx_type_97 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    table: *const zx_type_15,
};

pub const zx_type_99 = struct {
    plan: *const zx_type_76,
    value: ?*const zx_type_95,
};

pub const zx_type_100 = struct {
    dependencies: *const zx_type_66,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: *const zx_type_31,
    state: *const zx_type_29,
    type_imports: []const u32,
};

pub const zx_type_101 = struct { *const zx_type_97, };
pub const zx_type_102 = struct { *const zx_type_97, *const zx_type_15, };
pub const zx_type_103 = struct { *const zx_type_97, *const zx_type_15, *const zx_type_23, };
pub const zx_type_104 = struct { *const zx_type_70, };
pub const zx_type_105 = struct { *const zx_type_70, bool, };
pub const zx_type_106 = struct { *const zx_type_70, bool, *const zx_type_68, };
pub const zx_type_107 = struct { *const zx_type_72, };
pub const zx_type_108 = struct { *const zx_type_72, bool, };
pub const zx_type_109 = struct { *const zx_type_72, bool, *const zx_type_68, };
pub const zx_type_110 = struct { *const zx_type_79, };
pub const zx_type_111 = struct { *const zx_type_79, *const zx_type_76, };
pub const zx_type_112 = struct { *const zx_type_79, *const zx_type_76, bool, };
pub const zx_type_113 = struct { *const zx_type_79, *const zx_type_76, bool, *const zx_type_76, };
pub const zx_type_114 = struct { *const zx_type_100, };
pub const zx_type_115 = struct { *const zx_type_100, bool, };
pub const zx_type_116 = struct { *const zx_type_100, bool, *const zx_type_29, };
pub const zx_type_117 = struct { *const zx_type_100, bool, *const zx_type_29, *const zx_type_68, };
pub const zx_type_118 = struct { *const zx_type_96, };
pub const zx_type_119 = struct { *const zx_type_96, *const zx_type_65, };
pub const zx_type_120 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, };
pub const zx_type_121 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, *const zx_type_29, };
pub const zx_type_122 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, };
pub const zx_type_123 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, };
pub const zx_type_124 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, };
pub const zx_type_125 = struct { *const zx_type_96, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, *const zx_type_76, };
pub const zx_type_126 = struct { *const zx_type_96, *const zx_type_76, };
pub const zx_type_127 = struct { *const zx_type_96, *const zx_type_76, bool, };
pub const zx_type_128 = struct { *const zx_type_96, *const zx_type_76, bool, *const zx_type_95, };

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
    plan: *const zx_type_29,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    member: u64,
    plan: *const zx_type_29,
    source: *const zx_type_15,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_34, };
pub const value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_35, };
pub const value_zx_type_36_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_36, };

pub const value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    source: *const zx_type_23,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_48_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
    zx_origin: ?*const zx_type_48 = null,
};

pub const value_zx_type_49_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_49 = null,
};

pub const value_zx_type_50_1dad68e6b0d0122b1476653abf673933ed027adc2ebd5fd855aec9b533a7b0ea = struct {
    functions: value_zx_type_48_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    index: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_50 = null,
};

pub const value_zx_type_51_68bebc01d99f6879dc43b8e7adb1a3f45ef4366c6f107510d452df8f6f575699 = struct {
    index: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_51 = null,
};

pub const value_zx_type_52_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    ids: []const u64,
    ready: []const bool,
    zx_origin: ?*const zx_type_52 = null,
};

pub const value_zx_type_53_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    pending: value_zx_type_52_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_53 = null,
};

pub const value_zx_type_54_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_54, };
pub const value_zx_type_55_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_55, };

pub const value_zx_type_56_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = struct {
    first: u64,
    pending: value_zx_type_52_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    remaining: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_56 = null,
};

pub const value_zx_type_57_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    zx_origin: ?*const zx_type_57 = null,
};

pub const value_zx_type_58_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_23,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_58 = null,
};

pub const value_zx_type_59_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    index: u64,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_59 = null,
};

pub const value_zx_type_60_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = struct {
    pending: value_zx_type_52_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_60 = null,
};

pub const value_zx_type_62_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_62, };
pub const value_zx_type_64_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const bool, ?bool, ?*const zx_type_64, };

pub const value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    is_native: []const bool,
    keys: []const []const u8,
    zx_origin: ?*const zx_type_66 = null,
};

pub const value_zx_type_67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06 = struct {
    index: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_67 = null,
};

pub const value_zx_type_69_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    values: []const u32,
    zx_origin: ?*const zx_type_69 = null,
};

pub const value_zx_type_70_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_70 = null,
};

pub const value_zx_type_71_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    found: bool,
    index: u64,
    module: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_71 = null,
};

pub const value_zx_type_72_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319 = struct {
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_72 = null,
};

pub const value_zx_type_73_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = struct {
    index: u64,
    member: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_73 = null,
};

pub const value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    inputs: []const u32,
    native_modules: []const ?u32,
    outputs: []const u32,
    zx_origin: ?*const zx_type_74 = null,
};

pub const value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    ids: []const u32,
    inputs: []const u32,
    outputs: []const u32,
    zx_origin: ?*const zx_type_75 = null,
};

pub const value_zx_type_77_31a2a617a7f259541cad3eb5e55b88b3dd05fe2d30b0430d2baab53409fdc15d = struct {
    imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    plan: *const zx_type_76,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_77 = null,
};

pub const value_zx_type_78_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7 = struct {
    index: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_76,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_78 = null,
};

pub const value_zx_type_79_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77 = struct {
    imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_76,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_79 = null,
};

pub const value_zx_type_80_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = struct {
    imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    index: u64,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_76,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_80 = null,
};

pub const value_zx_type_81_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    ids: []const u32,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_81 = null,
};

pub const value_zx_type_82_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_82 = null,
};

pub const value_zx_type_83_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_83 = null,
};

pub const value_zx_type_84_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
    zx_origin: ?*const zx_type_84 = null,
};

pub const value_zx_type_85_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
    zx_origin: ?*const zx_type_85 = null,
};

pub const value_zx_type_86_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_86 = null,
};

pub const value_zx_type_87_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
    zx_origin: ?*const zx_type_87 = null,
};

pub const value_zx_type_88_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
    zx_origin: ?*const zx_type_88 = null,
};

pub const value_zx_type_89_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_89 = null,
};

pub const value_zx_type_90_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_90 = null,
};

pub const value_zx_type_91_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_91 = null,
};

pub const value_zx_type_92_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    inputs: []const u32,
    zx_origin: ?*const zx_type_92 = null,
};

pub const value_zx_type_93_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
    zx_origin: ?*const zx_type_93 = null,
};

pub const value_zx_type_94_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
    zx_origin: ?*const zx_type_94 = null,
};

pub const value_zx_type_95_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_95 = null,
};

pub const value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    function_imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_96 = null,
};

pub const value_zx_type_97_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_97 = null,
};

pub const value_zx_type_99_097191092d3b2345839c9861eb89c2c5380d67570e01bfa6769cebfaa0c9e60c = struct {
    plan: *const zx_type_76,
    value: ?value_zx_type_95_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_99 = null,
};

pub const value_zx_type_100_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_43_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_100 = null,
};

pub const value_zx_type_101_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_97_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_101, };
pub const value_zx_type_102_654b20ccf64f2ca64b6802425f9952e8447842f7a750a25aaabc98a2fcd9a52f = struct { value_zx_type_97_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, *const zx_type_15, ?*const zx_type_102, };
pub const value_zx_type_103_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = struct { value_zx_type_97_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, *const zx_type_15, *const zx_type_23, ?*const zx_type_103, };
pub const value_zx_type_104_6d9e1750b9dc48c0938aa2ac30bab75b173d85436f941cb6b1e6a70893b3b46a = struct { value_zx_type_70_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, ?*const zx_type_104, };
pub const value_zx_type_105_47fda4d3f05483967cdab92aa39f1b1a8a628d748940a28659fde352c6b33168 = struct { value_zx_type_70_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, ?*const zx_type_105, };
pub const value_zx_type_106_f65b384d705929099a04ca81a260f41b0833337a4c4982b958cbd0bbc226ca1a = struct { value_zx_type_70_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, *const zx_type_68, ?*const zx_type_106, };
pub const value_zx_type_107_ba7117c8189198b145774a1deb80e8c00c3b3955ad3770683638b4c34cd56d85 = struct { value_zx_type_72_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, ?*const zx_type_107, };
pub const value_zx_type_108_b4bdce0c22ba9fcd21b035f595a1e6ff422801720f1e9dbb9052ede6e014123e = struct { value_zx_type_72_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, ?*const zx_type_108, };
pub const value_zx_type_109_bcc77718ef8753ce2292cc1cfc53c0bc5181c8ace3e3d831b55abd3283313abf = struct { value_zx_type_72_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, *const zx_type_68, ?*const zx_type_109, };
pub const value_zx_type_110_2682cedb643d4921b472cd8ebcd27a7fcee8c27053a5b8da474fef72311ce312 = struct { value_zx_type_79_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, ?*const zx_type_110, };
pub const value_zx_type_111_c1053b537205caa78f705636bd0b6d46385c930e3dcd229220ae7b4cf28c678c = struct { value_zx_type_79_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_76, ?*const zx_type_111, };
pub const value_zx_type_112_cd624e99c1c7fdf5d63e6e5fc52c80f8a1ce1ef0a9db9dde81696b1cf14bd590 = struct { value_zx_type_79_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_76, bool, ?*const zx_type_112, };
pub const value_zx_type_113_a10943e2c45184fc503e34a2f575567115f10674db8e3aac1ea46cfaa3228089 = struct { value_zx_type_79_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_76, bool, *const zx_type_76, ?*const zx_type_113, };
pub const value_zx_type_114_2453b88f9ff0f058cf67f3e2aae4b57b1f792f4aa4bc8106ea9423849dc5da26 = struct { value_zx_type_100_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, ?*const zx_type_114, };
pub const value_zx_type_115_80056fe358733769c185dbbb4338a2e514aa1d61e1d5a42da77a4fc33ee43ea0 = struct { value_zx_type_100_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, ?*const zx_type_115, };
pub const value_zx_type_116_f2331b184dede23b05aaaed7691fef17c09f05dda3b0cf700a00d066d31fe693 = struct { value_zx_type_100_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_29, ?*const zx_type_116, };
pub const value_zx_type_117_aec30df4a6153f7fd1820ce13f1852801e3a92d905e0b06996038115c38ad70b = struct { value_zx_type_100_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_29, *const zx_type_68, ?*const zx_type_117, };
pub const value_zx_type_118_1529af9371ba522b576cd37653d0ebf6ce58d694b97ef1712f18b581d52cfe7b = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, ?*const zx_type_118, };
pub const value_zx_type_119_6c27cf42060f86f038a84b808aa72e941dc14d0fa441094472b0d87496dc6fad = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, ?*const zx_type_119, };
pub const value_zx_type_120_cec7910b5923aa6cf291abf7c4f89cd27ee5770968cd46d62e1ec46593435364 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, ?*const zx_type_120, };
pub const value_zx_type_121_5369a22f6ea316cc94ece3afc064f7ba7c6cfdd267121a4df591f8bf80749a7f = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, *const zx_type_29, ?*const zx_type_121, };
pub const value_zx_type_122_9f02de83a025d33c1b17ca82eb27e0f65f1cc5f50e734fbef35fdf37d2a475f4 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, ?*const zx_type_122, };
pub const value_zx_type_123_d389aaf94842ee6fce1b915722f134d796d29f0c829621b52ac524d5cc138ca5 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, ?*const zx_type_123, };
pub const value_zx_type_124_4d532ff75d71bdd009eaea2aad366fccf531762fc1436da20f87e39a079ecf03 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, ?*const zx_type_124, };
pub const value_zx_type_125_4156b17414b3df07a073d3eb72552530fc37cdd7c58885ee7815d8480d260778 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, *const zx_type_76, ?*const zx_type_125, };
pub const value_zx_type_126_6c27cf42060f86f038a84b808aa72e941dc14d0fa441094472b0d87496dc6fad = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_76, ?*const zx_type_126, };
pub const value_zx_type_127_cec7910b5923aa6cf291abf7c4f89cd27ee5770968cd46d62e1ec46593435364 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_76, bool, ?*const zx_type_127, };
pub const value_zx_type_128_503b3427439154ce0c436a1d19c97c903ddfb0933e9d9cd8d8c9c6fed2647f95 = struct { value_zx_type_96_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_76, bool, value_zx_type_95_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_128, };

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

