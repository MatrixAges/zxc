pub const zx_type_b24b96df760e948fe94b8509870b2d4b35a71016f534325f8daf86953a8b7c88 = enum { Exited, Signal, Stopped, Unknown, };

pub const zx_type_50da5854cf974eee796ae4b6139ce16d102d25bce4965db7e0498a998d40f4ca = struct {
    name: []const u8,
    value: []const u8,
};

pub const zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92 = struct {
    args: []const []const u8,
    command: []const u8,
    cwd: ?[]const u8,
    env: ?[]const *const zx_type_50da5854cf974eee796ae4b6139ce16d102d25bce4965db7e0498a998d40f4ca,
    max_stderr_bytes: u64,
    max_stdout_bytes: u64,
};

pub const zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c = struct {
    input: []const u8,
    options: *const zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92,
};

pub const zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507 = struct {
    code: u32,
    kind: zx_type_b24b96df760e948fe94b8509870b2d4b35a71016f534325f8daf86953a8b7c88,
    stderr: []const u8,
    stdout: []const u8,
};

pub const zx_type_03c6b28a19ffdb116d6e82f6451a3651ac63375558a3ba1c4d24d44c1d6db49f = struct { *const zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c, };
pub const zx_type_f377d2e60d63f751d66e59e6e775d42995df4309116a2dc841afa2d3e1397cb6 = struct { *const zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c, *const zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507, };

pub const native = struct {
    pub const @"std:child_process" = struct {
        pub const TerminationKind = zx_type_b24b96df760e948fe94b8509870b2d4b35a71016f534325f8daf86953a8b7c88;
        pub const EnvironmentEntry = *const zx_type_50da5854cf974eee796ae4b6139ce16d102d25bce4965db7e0498a998d40f4ca;
        pub const Options = *const zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92;
        pub const InputOptions = *const zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c;
        pub const Result = *const zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
        pub const spawnSync = struct {
            pub const Input = *const zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92;
            pub const Output = *const zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
            pub const InputValue = zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92;
            pub const OutputValue = zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
        };
        pub const spawnSyncWithInput = struct {
            pub const Input = *const zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c;
            pub const Output = *const zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
            pub const InputValue = zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c;
            pub const OutputValue = zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
        };
    };
};

pub const layouts = struct {
    pub const @"std:child_process" = struct {
        pub const TerminationKind = zx_type_b24b96df760e948fe94b8509870b2d4b35a71016f534325f8daf86953a8b7c88;
        pub const EnvironmentEntry = zx_type_50da5854cf974eee796ae4b6139ce16d102d25bce4965db7e0498a998d40f4ca;
        pub const Options = zx_type_513e7099b4d5095fbd33440f9919c80a4f1ae9865da6c197fbc78fc5e4703e92;
        pub const InputOptions = zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c;
        pub const Result = zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
    };
};

