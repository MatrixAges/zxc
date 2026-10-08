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
    mapping: []const u64,
    values: []const u32,
};

pub const zx_type_85 = struct {
    index: u64,
    mapping: []const u64,
    source: []const u32,
    valid: bool,
    values: []const u32,
};

pub const zx_type_86 = struct {
    mapping: []const u64,
    modules: *const zx_type_43,
    plan: *const zx_type_65,
};

pub const zx_type_88 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    index: u64,
    mapping: []const u64,
    plan: *const zx_type_65,
    source: *const zx_type_43,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    valid: bool,
};

pub const zx_type_89 = struct { []const ?[]const u8, void, };
pub const zx_type_90 = struct { []const []const u32, void, };
pub const zx_type_91 = struct { []const []const []const u8, void, };

pub const zx_type_92 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_93 = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
};

pub const zx_type_94 = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
};

pub const zx_type_95 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_96 = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
};

pub const zx_type_97 = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
};

pub const zx_type_98 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_99 = struct {
    request: *const zx_type_31,
    state: *const zx_type_29,
};

pub const zx_type_100 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: *const zx_type_31,
};

pub const zx_type_101 = struct {
    inputs: []const u32,
};

pub const zx_type_102 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
};

pub const zx_type_103 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
};

pub const zx_type_104 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
};

pub const zx_type_105 = struct {
    dependencies: *const zx_type_66,
    function_imports: *const zx_type_75,
    modules: *const zx_type_43,
    request: *const zx_type_31,
    signatures: *const zx_type_74,
    type_imports: []const u32,
};

pub const zx_type_106 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    table: *const zx_type_15,
};

pub const zx_type_108 = struct {
    natives: ?*const zx_type_43,
    plan: *const zx_type_76,
    value: ?*const zx_type_104,
};

pub const zx_type_109 = struct {
    dependencies: *const zx_type_66,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: *const zx_type_31,
    state: *const zx_type_29,
    type_imports: []const u32,
};

pub const zx_type_110 = struct { *const zx_type_106, };
pub const zx_type_111 = struct { *const zx_type_106, *const zx_type_15, };
pub const zx_type_112 = struct { *const zx_type_106, *const zx_type_15, *const zx_type_23, };
pub const zx_type_113 = struct { *const zx_type_70, };
pub const zx_type_114 = struct { *const zx_type_70, bool, };
pub const zx_type_115 = struct { *const zx_type_70, bool, *const zx_type_68, };
pub const zx_type_116 = struct { *const zx_type_72, };
pub const zx_type_117 = struct { *const zx_type_72, bool, };
pub const zx_type_118 = struct { *const zx_type_72, bool, *const zx_type_68, };
pub const zx_type_119 = struct { *const zx_type_79, };
pub const zx_type_120 = struct { *const zx_type_79, *const zx_type_76, };
pub const zx_type_121 = struct { *const zx_type_79, *const zx_type_76, bool, };
pub const zx_type_122 = struct { *const zx_type_79, *const zx_type_76, bool, *const zx_type_76, };
pub const zx_type_123 = struct { *const zx_type_109, };
pub const zx_type_124 = struct { *const zx_type_109, bool, };
pub const zx_type_125 = struct { *const zx_type_109, bool, *const zx_type_29, };
pub const zx_type_126 = struct { *const zx_type_109, bool, *const zx_type_29, *const zx_type_68, };
pub const zx_type_127 = struct { *const zx_type_105, };
pub const zx_type_128 = struct { *const zx_type_105, *const zx_type_65, };
pub const zx_type_129 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, };
pub const zx_type_130 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, *const zx_type_29, };
pub const zx_type_131 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, };
pub const zx_type_132 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, };
pub const zx_type_133 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, };
pub const zx_type_134 = struct { *const zx_type_105, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, *const zx_type_76, };
pub const zx_type_135 = struct { *const zx_type_105, *const zx_type_76, };
pub const zx_type_136 = struct { *const zx_type_105, *const zx_type_76, bool, };
pub const zx_type_137 = struct { *const zx_type_105, *const zx_type_76, bool, *const zx_type_104, };
pub const zx_type_138 = struct { *const zx_type_105, *const zx_type_76, bool, *const zx_type_104, ?*const zx_type_43, };

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

pub const value_zx_type_49_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    modules: *const zx_type_43,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_49 = null,
};

pub const value_zx_type_50_e1a3efb1661a55082d96026e298239963014feef940e12b8f12b12b89508e175 = struct {
    functions: value_zx_type_48_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    index: u64,
    modules: *const zx_type_43,
    zx_origin: ?*const zx_type_50 = null,
};

pub const value_zx_type_51_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    modules: *const zx_type_43,
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

pub const value_zx_type_67_630fa99cb95970422a44889a960facc6e5e88980197a66b915a2226110e6e6f4 = struct {
    index: u64,
    modules: *const zx_type_43,
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

pub const value_zx_type_70_237b32283807d6b6afbb83a53457fa6a4813cc22e17ad49517c340268057dc46 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_70 = null,
};

pub const value_zx_type_71_0c44cdea8922b5faeecabe2217e1a3ac9521f8307c441e1e1cafa9915470b299 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    found: bool,
    index: u64,
    module: u64,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_71 = null,
};

pub const value_zx_type_72_56b664a23dccb3b4c9c1dea493fb95e98960a53ecfef31ef7b2460404f2aed8c = struct {
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_72 = null,
};

pub const value_zx_type_73_5b552fc74de17f97257d6512f5b5ff1b1262814968dcba16eea9cc6466a3595f = struct {
    index: u64,
    member: u64,
    modules: *const zx_type_43,
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

pub const value_zx_type_78_aec0a3f001a1f94c3da4acda851f97fe60c99789105795d73747e6ae052ee2f4 = struct {
    index: u64,
    modules: *const zx_type_43,
    plan: *const zx_type_76,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_78 = null,
};

pub const value_zx_type_79_47a759fc6c52f2f5db23e6f7930ff8896f7f2d6479a5f3b088cb77e479a54a81 = struct {
    imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: *const zx_type_43,
    plan: *const zx_type_76,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_79 = null,
};

pub const value_zx_type_80_797b84af1f613014bf0104d8f44a10323f58c82a39372f2936c00f496a1658c5 = struct {
    imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    index: u64,
    modules: *const zx_type_43,
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

pub const value_zx_type_83_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    mapping: []const u64,
    values: []const u32,
    zx_origin: ?*const zx_type_83 = null,
};

pub const value_zx_type_85_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    mapping: []const u64,
    source: []const u32,
    valid: bool,
    values: []const u32,
    zx_origin: ?*const zx_type_85 = null,
};

pub const value_zx_type_86_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    mapping: []const u64,
    modules: *const zx_type_43,
    plan: *const zx_type_65,
    zx_origin: ?*const zx_type_86 = null,
};

pub const value_zx_type_88_e94c22d54df2577542e5f7da583caa35b601e7dc58d30f5a71ec9a9dd45d3f6d = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    index: u64,
    mapping: []const u64,
    plan: *const zx_type_65,
    source: *const zx_type_43,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    valid: bool,
    zx_origin: ?*const zx_type_88 = null,
};

pub const value_zx_type_89_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const ?[]const u8, void, ?*const zx_type_89, };
pub const value_zx_type_90_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u32, void, ?*const zx_type_90, };
pub const value_zx_type_91_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const []const u8, void, ?*const zx_type_91, };

pub const value_zx_type_92_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_92 = null,
};

pub const value_zx_type_93_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
    zx_origin: ?*const zx_type_93 = null,
};

pub const value_zx_type_94_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
    zx_origin: ?*const zx_type_94 = null,
};

pub const value_zx_type_95_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_95 = null,
};

pub const value_zx_type_96_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
    zx_origin: ?*const zx_type_96 = null,
};

pub const value_zx_type_97_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
    zx_origin: ?*const zx_type_97 = null,
};

pub const value_zx_type_98_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_98 = null,
};

pub const value_zx_type_99_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    zx_origin: ?*const zx_type_99 = null,
};

pub const value_zx_type_100_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = struct {
    index: u64,
    plan: *const zx_type_29,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_100 = null,
};

pub const value_zx_type_101_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    inputs: []const u32,
    zx_origin: ?*const zx_type_101 = null,
};

pub const value_zx_type_102_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
    zx_origin: ?*const zx_type_102 = null,
};

pub const value_zx_type_103_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
    zx_origin: ?*const zx_type_103 = null,
};

pub const value_zx_type_104_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_104 = null,
};

pub const value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    function_imports: value_zx_type_75_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: *const zx_type_43,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_74_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_105 = null,
};

pub const value_zx_type_106_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_106 = null,
};

pub const value_zx_type_108_9ec5b1ecf35ba5c1d675ae1eb7fabd4c780ff50107a9e55c49271710b053bed6 = struct {
    natives: ?*const zx_type_43,
    plan: *const zx_type_76,
    value: ?value_zx_type_104_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_108 = null,
};

pub const value_zx_type_109_49db844729b0e75ea1c075ada49195e7004d3f4e3c991162f880566114acd635 = struct {
    dependencies: value_zx_type_66_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: *const zx_type_43,
    natives: *const zx_type_65,
    request: value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_29,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_109 = null,
};

pub const value_zx_type_110_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_106_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_110, };
pub const value_zx_type_111_654b20ccf64f2ca64b6802425f9952e8447842f7a750a25aaabc98a2fcd9a52f = struct { value_zx_type_106_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, *const zx_type_15, ?*const zx_type_111, };
pub const value_zx_type_112_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = struct { value_zx_type_106_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, *const zx_type_15, *const zx_type_23, ?*const zx_type_112, };
pub const value_zx_type_113_be79f2597a3735aad62bbd549fa360e3dea08a8c62cfb86eb1af4091ccc938e5 = struct { value_zx_type_70_237b32283807d6b6afbb83a53457fa6a4813cc22e17ad49517c340268057dc46, ?*const zx_type_113, };
pub const value_zx_type_114_f23a59418fa9ec6a8017d20857e5b25ab6e01c92c442d9f4088b1d19ebc995b6 = struct { value_zx_type_70_237b32283807d6b6afbb83a53457fa6a4813cc22e17ad49517c340268057dc46, bool, ?*const zx_type_114, };
pub const value_zx_type_115_8c1fe924b0530b5c76625a843600c5d5d3916e0518768f291710aeea0d2ee4e7 = struct { value_zx_type_70_237b32283807d6b6afbb83a53457fa6a4813cc22e17ad49517c340268057dc46, bool, *const zx_type_68, ?*const zx_type_115, };
pub const value_zx_type_116_f382ef1a2c8cbfecec6b40dee6409bd3a5470743a9426f40c0842f90f55e9933 = struct { value_zx_type_72_56b664a23dccb3b4c9c1dea493fb95e98960a53ecfef31ef7b2460404f2aed8c, ?*const zx_type_116, };
pub const value_zx_type_117_061f6cf2c76369efab6d5f0aacd2997aa71dfd95f4a09e2c42f40ed58cee6ae2 = struct { value_zx_type_72_56b664a23dccb3b4c9c1dea493fb95e98960a53ecfef31ef7b2460404f2aed8c, bool, ?*const zx_type_117, };
pub const value_zx_type_118_188bba541b402665dfa5b5bf58b9db631811e4874db6666a89b488b57b3c00af = struct { value_zx_type_72_56b664a23dccb3b4c9c1dea493fb95e98960a53ecfef31ef7b2460404f2aed8c, bool, *const zx_type_68, ?*const zx_type_118, };
pub const value_zx_type_119_3f7d7cfec3c0c9200e4f793fd97038c5c5749c8e6996c7afe9405b5f4652e7c6 = struct { value_zx_type_79_47a759fc6c52f2f5db23e6f7930ff8896f7f2d6479a5f3b088cb77e479a54a81, ?*const zx_type_119, };
pub const value_zx_type_120_ba563826a7bd55a8786070543d3d5258825f4cecfa8e9e4951a5e8edffa0bbf6 = struct { value_zx_type_79_47a759fc6c52f2f5db23e6f7930ff8896f7f2d6479a5f3b088cb77e479a54a81, *const zx_type_76, ?*const zx_type_120, };
pub const value_zx_type_121_e64dca08127468864e33e0087042c6050b58dd28182c2e086a8231f5695a6247 = struct { value_zx_type_79_47a759fc6c52f2f5db23e6f7930ff8896f7f2d6479a5f3b088cb77e479a54a81, *const zx_type_76, bool, ?*const zx_type_121, };
pub const value_zx_type_122_4ee49ac143f3b4dc9105b48f26a039979153940847e3bd12d714d345dc01e302 = struct { value_zx_type_79_47a759fc6c52f2f5db23e6f7930ff8896f7f2d6479a5f3b088cb77e479a54a81, *const zx_type_76, bool, *const zx_type_76, ?*const zx_type_122, };
pub const value_zx_type_123_f744449a0cfb12119de08881e98f347d082a7e1a1b2c66aa4150a26f507c34d0 = struct { value_zx_type_109_49db844729b0e75ea1c075ada49195e7004d3f4e3c991162f880566114acd635, ?*const zx_type_123, };
pub const value_zx_type_124_1d03157b5fd84a50b2ca008e9d01b39c3094df37fe5db8f413382665c560fa94 = struct { value_zx_type_109_49db844729b0e75ea1c075ada49195e7004d3f4e3c991162f880566114acd635, bool, ?*const zx_type_124, };
pub const value_zx_type_125_b6027250301adc0220af064b6145cee636c913bfaf439972bb802743f9f0447e = struct { value_zx_type_109_49db844729b0e75ea1c075ada49195e7004d3f4e3c991162f880566114acd635, bool, *const zx_type_29, ?*const zx_type_125, };
pub const value_zx_type_126_cf8640702141201c15622fbe52f2839a8d2146ccef774df29c86bc3ef2b4dfe4 = struct { value_zx_type_109_49db844729b0e75ea1c075ada49195e7004d3f4e3c991162f880566114acd635, bool, *const zx_type_29, *const zx_type_68, ?*const zx_type_126, };
pub const value_zx_type_127_a10bee8592d4906251d866948b08304bc746746c64b6a1fa3708c6598be968af = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, ?*const zx_type_127, };
pub const value_zx_type_128_a88823e665cfcac8d63b0472b4a524fe216cdb23043c85c770e83ad3565392f2 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, ?*const zx_type_128, };
pub const value_zx_type_129_87e8c6cb7a700475dd5aacb683544792c2787ba56d71aa078b385fc4e1b71100 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, ?*const zx_type_129, };
pub const value_zx_type_130_e6f3a49dd1da10fc9c6976bb24cdfce20adc0d1c1d64bfec330d1cfe638ecc23 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, *const zx_type_29, ?*const zx_type_130, };
pub const value_zx_type_131_b9c3c5f0438e1a68b61de15f657b505f65f4b6d2db4c4d1f302eb7ce7df2bd80 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, ?*const zx_type_131, };
pub const value_zx_type_132_72eeed3f91557e9b9149d5e24a1fab8d9c84ab1924e8aa6ae5daddc2d780aa4c = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, ?*const zx_type_132, };
pub const value_zx_type_133_8922019ae46a6f52d73c4971fff17036595d462a0859cd343d25a98ecc5d53c0 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, ?*const zx_type_133, };
pub const value_zx_type_134_a0e16a424ab77493352b05fa97470f1c7561821c268c0d4273af091fecb3772a = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_65, *const zx_type_29, *const zx_type_29, *const zx_type_68, *const zx_type_68, *const zx_type_65, *const zx_type_76, ?*const zx_type_134, };
pub const value_zx_type_135_a88823e665cfcac8d63b0472b4a524fe216cdb23043c85c770e83ad3565392f2 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_76, ?*const zx_type_135, };
pub const value_zx_type_136_87e8c6cb7a700475dd5aacb683544792c2787ba56d71aa078b385fc4e1b71100 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_76, bool, ?*const zx_type_136, };
pub const value_zx_type_137_50cf0900a931ac745941ea7917eeaea01a18a9a318497c5d8bcd5c2cda53bbc3 = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_76, bool, value_zx_type_104_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_137, };
pub const value_zx_type_138_faec1587a08c40dd112f5196b18b47f4968b1360dce2b49fe5b6b03adffa3f2b = struct { value_zx_type_105_8e2626fa5c7da294d047269a21dc4977971bef317161a14affef5f8f5f46a522, *const zx_type_76, bool, value_zx_type_104_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_43, ?*const zx_type_138, };

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

