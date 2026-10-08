pub const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5 = struct {
    limit: i64,
    payload: []const i64,
};

pub const zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e = struct { i64, *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5, };

pub const zx_type_28d2fa0fb1227bf8e5cc5dd840df0fe27094506db43348afe42fcbe1a1b0f786 = struct {
    context: *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5,
    items: []const i64,
};

pub const zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794 = struct { *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5, };

pub const zx_type_05954d46a17fac061cf486fb7f1626d564c26cface019feb81bae64ae2265475 = struct {
    captures: *const zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794,
    index: u64,
    result: []const i64,
    source: []const i64,
};

pub const zx_type_6dc613f5d836d29f343ecd2a2d7cb4564750ac7abca6e702eb6d700f37c1d5d4 = struct { []const i64, void, };

pub const value_zx_type_28d2fa0fb1227bf8e5cc5dd840df0fe27094506db43348afe42fcbe1a1b0f786_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    context: *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5,
    items: []const i64,
    zx_origin: ?*const zx_type_28d2fa0fb1227bf8e5cc5dd840df0fe27094506db43348afe42fcbe1a1b0f786 = null,
};

pub const value_zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5, ?*const zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794, };

pub const value_zx_type_05954d46a17fac061cf486fb7f1626d564c26cface019feb81bae64ae2265475_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813 = struct {
    captures: value_zx_type_6e28b185a3038794af875043d43596ac4310b55499771f8edb6d1ebe2e2e3794_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    index: u64,
    result: []const i64,
    source: []const i64,
    zx_origin: ?*const zx_type_05954d46a17fac061cf486fb7f1626d564c26cface019feb81bae64ae2265475 = null,
};

pub const value_zx_type_6dc613f5d836d29f343ecd2a2d7cb4564750ac7abca6e702eb6d700f37c1d5d4_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const i64, void, ?*const zx_type_6dc613f5d836d29f343ecd2a2d7cb4564750ac7abca6e702eb6d700f37c1d5d4, };

pub const native = struct {
    pub const @"zig:host" = struct {
        pub const Context = *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;

        pub const echo = struct {
            pub const Input = *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;
            pub const Output = *const zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;
            pub const InputValue = zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;
            pub const OutputValue = zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;
        };
        pub const mapValue = struct {
            pub const Input = *const zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e;
            pub const Output = i64;
            pub const InputValue = zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e;
            pub const OutputValue = i64;
        };
        pub const predicate = struct {
            pub const Input = *const zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e;
            pub const Output = bool;
            pub const InputValue = zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e;
            pub const OutputValue = bool;
        };
    };
};

pub const layouts = struct {
    pub const @"zig:host" = struct {
        pub const Context = zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5;
    };
};

