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
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_24 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_25 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
};

pub const zx_type_26 = struct {
    id: u32,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_27 = struct {
    found: bool,
    index: u64,
    limit: u64,
    tables: *const zx_type_16,
    target: zx_type_11,
};

pub const zx_type_28 = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    tables: *const zx_type_16,
};

pub const zx_type_29 = struct { []const bool, void, };

pub const zx_type_30 = struct {
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

pub const zx_type_31 = struct {
    left: *const zx_type_30,
    right: *const zx_type_30,
};

pub const zx_type_32 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_30,
    right: *const zx_type_30,
};

pub const zx_type_33 = struct {
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_34 = struct {
    candidate: *const zx_type_19,
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_35 = struct {
    candidate: *const zx_type_19,
    tables: *const zx_type_16,
};

pub const zx_type_36 = struct {
    candidate: *const zx_type_19,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_37 = struct {
    candidate: *const zx_type_19,
    delta: *const zx_type_15,
};

pub const zx_type_38 = struct { []const u8, void, };
pub const zx_type_39 = struct { []const u32, void, };
pub const zx_type_40 = struct { []const []const u8, void, };

pub const zx_type_41 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_42 = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
};

pub const zx_type_43 = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
};

pub const zx_type_44 = struct {
    code: []const u8,
    message: []const u8,
};

pub const zx_type_45 = struct {
    candidate: *const zx_type_19,
    table: *const zx_type_15,
};

pub const zx_type_46 = struct {
    delta: *const zx_type_15,
    diagnostic: *const zx_type_44,
    id: u32,
};

pub const zx_type_47 = enum { None, TaskContainer, VoidList, TaskTuple, TaskObject, };

pub const zx_type_48 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_49 = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_44,
    ids: []const u32,
};

pub const zx_type_50 = struct {
    candidate: *const zx_type_19,
    state: *const zx_type_49,
};

pub const zx_type_52 = struct {
    base: *const zx_type_15,
    candidates: []const *const zx_type_19,
    delta: *const zx_type_15,
    query_id: u32,
};

pub const zx_type_53 = struct {
    contains_list: bool,
    contains_native: bool,
    delta: *const zx_type_15,
    diagnostic: *const zx_type_44,
    ids: []const u32,
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

pub const value_zx_type_22_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_24_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = struct {
    flags: []const bool,
    index: u64,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    children: []const u32,
    count: u64,
    flags: []const bool,
    found: bool,
    index: u64,
    offset: u64,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_152936f5b3ece57cfa1afaff5c987671dc1de239be81c121450e61f890947569 = struct {
    id: u32,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = struct {
    found: bool,
    index: u64,
    limit: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    target: zx_type_11,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = struct {
    first: u64,
    flags: []const bool,
    index: u64,
    limit: u64,
    native_references: bool,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_29, };

pub const value_zx_type_31_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: *const zx_type_30,
    right: *const zx_type_30,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_30,
    right: *const zx_type_30,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_152936f5b3ece57cfa1afaff5c987671dc1de239be81c121450e61f890947569 = struct {
    candidate: *const zx_type_19,
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_34 = null,
};

pub const value_zx_type_35_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    candidate: *const zx_type_19,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_36_6e5d8df28d3f9d3f54b015a56c712ed50d53e34e5758a188236df6cc77eaf77e = struct {
    candidate: *const zx_type_19,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    candidate: *const zx_type_19,
    delta: *const zx_type_15,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_38, };
pub const value_zx_type_39_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_39, };
pub const value_zx_type_40_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_40, };

pub const value_zx_type_41_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: []const u8,
    right: []const u8,
    zx_origin: ?*const zx_type_41 = null,
};

pub const value_zx_type_42_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    equal: bool,
    index: u64,
    left: []const u8,
    limit: u64,
    right: []const u8,
    zx_origin: ?*const zx_type_42 = null,
};

pub const value_zx_type_43_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    building: bool,
    count: u64,
    names: []const []const u8,
    remaining: u64,
    root: u64,
    sifting: bool,
    types: []const u32,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    code: []const u8,
    message: []const u8,
    zx_origin: ?*const zx_type_44 = null,
};

pub const value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    candidate: *const zx_type_19,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_45 = null,
};

pub const value_zx_type_46_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    delta: *const zx_type_15,
    diagnostic: value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    id: u32,
    zx_origin: ?*const zx_type_46 = null,
};

pub const value_zx_type_48_45bed241fe4e2523b208ec60e7bff7103d776329866b5ac3be4ba8d2df1b6363 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_48 = null,
};

pub const value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
    diagnostic: value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    ids: []const u32,
    zx_origin: ?*const zx_type_49 = null,
};

pub const value_zx_type_50_32479f9b811a64f382540596a83874e8d9ca00ed002899c5fc826fe5ec3ebd2e = struct {
    candidate: *const zx_type_19,
    state: value_zx_type_49_e56a90d42475a751c5ed628643fff0fe5a142d2a829bd3d374a58d0030c2c97f,
    zx_origin: ?*const zx_type_50 = null,
};

pub const value_zx_type_52_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    base: *const zx_type_15,
    candidates: []const *const zx_type_19,
    delta: *const zx_type_15,
    query_id: u32,
    zx_origin: ?*const zx_type_52 = null,
};

pub const value_zx_type_53_eae2123bf93423943f2172cdbbc64d8891f5c5aa82b7fb019a459ba0c881d5bc = struct {
    contains_list: bool,
    contains_native: bool,
    delta: *const zx_type_15,
    diagnostic: value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    ids: []const u32,
    zx_origin: ?*const zx_type_53 = null,
};

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_fa5740cadd8ce63d5afc271b40ead6207d62ec22521aab1e29836a853b99faa0" = struct {
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

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_fa5740cadd8ce63d5afc271b40ead6207d62ec22521aab1e29836a853b99faa0" = struct {
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_fa5740cadd8ce63d5afc271b40ead6207d62ec22521aab1e29836a853b99faa0";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_fa5740cadd8ce63d5afc271b40ead6207d62ec22521aab1e29836a853b99faa0";
};
