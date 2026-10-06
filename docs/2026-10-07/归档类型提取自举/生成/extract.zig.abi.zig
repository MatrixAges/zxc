pub const zx_type_11 = opaque {};
pub const zx_type_12 = struct { *const zx_type_11, u64, };
pub const zx_type_13 = struct { *const zx_type_11, u64, u64, };
pub const zx_type_14 = struct { *const zx_type_11, u64, bool, };
pub const zx_type_15 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_19 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_20 = struct {
    base: *const zx_type_19,
    delta: *const zx_type_19,
};

pub const zx_type_21 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_15,
    label: []const u8,
    second: u32,
};

pub const zx_type_22 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_23 = struct {
    children: []const u32,
    fields: *const zx_type_22,
    first: u32,
    kind: zx_type_15,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_24 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_25 = struct {
    delta: *const zx_type_19,
    id: u32,
};

pub const zx_type_26 = opaque {};
pub const zx_type_27 = struct { *const zx_type_26, u32, };
pub const zx_type_28 = struct { *const zx_type_26, u64, u32, };

pub const zx_type_29 = struct {
    buffer: *const zx_type_26,
    index: u64,
    table: *const zx_type_19,
};

pub const zx_type_30 = struct {
    buffer: *const zx_type_26,
    count: u64,
    first: u64,
    index: u64,
    values: []const u32,
};

pub const zx_type_31 = struct {
    index: u64,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
};

pub const zx_type_32 = struct {
    first: u64,
    remaining: u64,
    values: []const u32,
    workspace: *const zx_type_11,
};

pub const zx_type_33 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
};

pub const zx_type_34 = struct {
    ids: []const u32,
    kinds: []const u8,
    members: []const []const u8,
    owners: []const []const u8,
};

pub const zx_type_35 = struct {
    base: *const zx_type_34,
    delta: *const zx_type_34,
};

pub const zx_type_36 = enum { Missing, Found, Conflict, };

pub const zx_type_37 = struct {
    id: u32,
    status: zx_type_36,
};

pub const zx_type_38 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_34,
};

pub const zx_type_39 = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_34,
    result: u64,
    valid: bool,
};

pub const zx_type_40 = struct {
    buffer: *const zx_type_26,
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_34,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
};

pub const zx_type_41 = struct {
    buffer: *const zx_type_26,
    names: []const []const u8,
    origins: *const zx_type_34,
    status: u64,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
};

pub const zx_type_42 = struct { *const zx_type_40, };
pub const zx_type_43 = struct { *const zx_type_40, u64, };

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_19,
    delta: *const zx_type_19,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_15,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_15,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_19,
    id: u32,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_29_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    buffer: *const zx_type_26,
    index: u64,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    buffer: *const zx_type_26,
    count: u64,
    first: u64,
    index: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    first: u64,
    remaining: u64,
    values: []const u32,
    workspace: *const zx_type_11,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_34,
    delta: *const zx_type_34,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_37_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    id: u32,
    status: zx_type_36,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_34,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_39_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_34,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    buffer: *const zx_type_26,
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_34,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_41_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    buffer: *const zx_type_26,
    names: []const []const u8,
    origins: *const zx_type_34,
    status: u64,
    table: *const zx_type_19,
    workspace: *const zx_type_11,
    zx_origin: ?*const zx_type_41 = null,
};

pub const value_zx_type_42_efdd75a5e607c61dffb07c66411d75c96f1f2b811307e711dcc2093faf9ae2b2 = struct { value_zx_type_40_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, ?*const zx_type_42, };
pub const value_zx_type_43_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct { value_zx_type_40_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, u64, ?*const zx_type_43, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_e578efd7113f927dedf7b7b2bc8a37b4203522f2acf106faac36fb9c77544cbb" = struct {
        pub const Workspace = *const zx_type_11;
        pub const hasMapping = struct {
            pub const Input = *const zx_type_12;
            pub const Output = bool;
            pub const InputValue = zx_type_12;
            pub const OutputValue = bool;
        };
        pub const getMapping = struct {
            pub const Input = *const zx_type_12;
            pub const Output = u64;
            pub const InputValue = zx_type_12;
            pub const OutputValue = u64;
        };
        pub const setMapping = struct {
            pub const Input = *const zx_type_13;
            pub const Output = void;
            pub const InputValue = zx_type_13;
            pub const OutputValue = void;
        };
        pub const push = struct {
            pub const Input = *const zx_type_14;
            pub const Output = void;
            pub const InputValue = zx_type_14;
            pub const OutputValue = void;
        };
        pub const length = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u64;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u64;
        };
        pub const lastId = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u64;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u64;
        };
        pub const lastReady = struct {
            pub const Input = *const zx_type_11;
            pub const Output = bool;
            pub const InputValue = zx_type_11;
            pub const OutputValue = bool;
        };
        pub const pop = struct {
            pub const Input = *const zx_type_11;
            pub const Output = void;
            pub const InputValue = zx_type_11;
            pub const OutputValue = void;
        };
        pub const prepareReferences = struct {
            pub const Input = *const zx_type_14;
            pub const Output = void;
            pub const InputValue = zx_type_14;
            pub const OutputValue = void;
        };
        pub const appendType = struct {
            pub const Input = *const zx_type_12;
            pub const Output = u64;
            pub const InputValue = zx_type_12;
            pub const OutputValue = u64;
        };
        pub const appendOrigin = struct {
            pub const Input = *const zx_type_13;
            pub const Output = void;
            pub const InputValue = zx_type_13;
            pub const OutputValue = void;
        };
    };
    pub const @"zig:zxc_native_f0ec03197898b901df36b74cb5a1e827af77cfc6c4cb47afac6bebc006d577d8" = struct {
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
    pub const @"zig:zxc_native_79737f5f5cc0ae0e45a9b3a8b828033cd5f6b0f24ffc024abaaff1c7c62eb04b" = struct {
        pub const Buffer = *const zx_type_26;

        pub const get = struct {
            pub const Input = *const zx_type_27;
            pub const Output = u32;
            pub const InputValue = zx_type_27;
            pub const OutputValue = u32;
        };
        pub const set = struct {
            pub const Input = *const zx_type_28;
            pub const Output = void;
            pub const InputValue = zx_type_28;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_e578efd7113f927dedf7b7b2bc8a37b4203522f2acf106faac36fb9c77544cbb" = struct {
        pub const Workspace = zx_type_11;
    };
    pub const @"zig:zxc_native_f0ec03197898b901df36b74cb5a1e827af77cfc6c4cb47afac6bebc006d577d8" = struct {
    };
    pub const @"zig:zxc_native_79737f5f5cc0ae0e45a9b3a8b828033cd5f6b0f24ffc024abaaff1c7c62eb04b" = struct {
        pub const Buffer = zx_type_26;
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_f0ec03197898b901df36b74cb5a1e827af77cfc6c4cb47afac6bebc006d577d8";
    pub const @"zig:references" = (native_by_identity).@"zig:zxc_native_79737f5f5cc0ae0e45a9b3a8b828033cd5f6b0f24ffc024abaaff1c7c62eb04b";
    pub const @"zig:extract_workspace" = (native_by_identity).@"zig:zxc_native_e578efd7113f927dedf7b7b2bc8a37b4203522f2acf106faac36fb9c77544cbb";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_f0ec03197898b901df36b74cb5a1e827af77cfc6c4cb47afac6bebc006d577d8";
    pub const @"zig:references" = (layouts_by_identity).@"zig:zxc_native_79737f5f5cc0ae0e45a9b3a8b828033cd5f6b0f24ffc024abaaff1c7c62eb04b";
    pub const @"zig:extract_workspace" = (layouts_by_identity).@"zig:zxc_native_e578efd7113f927dedf7b7b2bc8a37b4203522f2acf106faac36fb9c77544cbb";
};

