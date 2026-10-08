pub const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3 = struct {
    active: bool,
    left: []const i64,
    right: []const i64,
};

pub const zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3 = struct { i64, *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3, };

pub const zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521 = struct {
    context: *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3,
    items: []const i64,
};

pub const zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6 = struct { *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3, };

pub const zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0 = struct {
    captures: *const zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6,
    index: u64,
    result: bool,
    source: []const i64,
};

pub const value_zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    context: *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3,
    items: []const i64,
    zx_origin: ?*const zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521 = null,
};

pub const value_zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3, ?*const zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6, };

pub const value_zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813 = struct {
    captures: value_zx_type_20f050cfc26df403199813deac41e73907c825a8b25f1edccff80115fc1edec6_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    index: u64,
    result: bool,
    source: []const i64,
    zx_origin: ?*const zx_type_8f537a53069fc580ab16104ceda01f66c26e80c329714f2ac0e6a3de2e25cfa0 = null,
};

pub const native_by_identity = struct {
    pub const @"library:10:borrowed@1:zig:host" = struct {
        pub const Context = *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;

        pub const echo = struct {
            pub const Input = *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;
            pub const Output = *const zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;
            pub const InputValue = zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;
            pub const OutputValue = zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;
        };
        pub const mapValue = struct {
            pub const Input = *const zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3;
            pub const Output = i64;
            pub const InputValue = zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3;
            pub const OutputValue = i64;
        };
        pub const predicate = struct {
            pub const Input = *const zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3;
            pub const Output = bool;
            pub const InputValue = zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3;
            pub const OutputValue = bool;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"library:10:borrowed@1:zig:host" = struct {
        pub const Context = zx_type_621c5078f74fc0a9222f36935ec2bc6c3488c2caed46189d78084b21a67008e3;
    };
};

