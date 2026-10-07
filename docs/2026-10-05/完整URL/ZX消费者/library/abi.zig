pub const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5 = struct {
    fragment: ?[]const u8,
    host: ?[]const u8,
    opaque_path: ?[]const u8,
    password: []const u8,
    path: []const []const u8,
    port: ?u16,
    query: ?[]const u8,
    scheme: []const u8,
    username: []const u8,
};

pub const zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd = struct {
    base: ?[]const u8,
    input: []const u8,
};

pub const zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16 = enum { Posix, Windows, };

pub const zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078 = struct {
    cwd: []const u8,
    path: []const u8,
    platform: zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16,
};

pub const zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54 = struct {
    platform: zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16,
    url: *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5,
};

pub const zx_type_a33b5217e8b3fc5301bcb6269d51e6aeb8bf78522132544102991082fdaf6b17 = struct {
    address: []const u8,
    cwd: []const u8,
    domain: []const u8,
    file_path: []const u8,
    invalid: []const u8,
    relative: []const u8,
};

pub const zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192 = struct {
    ascii: []const u8,
    file_bytes: []const u8,
    file_path: []const u8,
    file_url: []const u8,
    invalid: ?*const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5,
    origin: []const u8,
    parsed: *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5,
    pathname: []const u8,
    resolved: []const u8,
    serialized: []const u8,
    unicode: []const u8,
    valid: bool,
};

pub const native = struct {
    pub const @"std:url" = struct {
        pub const Url = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
        pub const Resolve = *const zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
        pub const Platform = zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16;
        pub const FilePath = *const zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078;
        pub const FileUrl = *const zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
        };
        pub const resolve = struct {
            pub const Input = *const zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const Output = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const InputValue = zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const OutputValue = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
        };
        pub const tryParse = struct {
            pub const Input = *const zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const Output = ?*const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const InputValue = zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const OutputValue = ?*const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
        };
        pub const canParse = struct {
            pub const Input = *const zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const Output = bool;
            pub const InputValue = zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
            pub const OutputValue = bool;
        };
        pub const stringify = struct {
            pub const Input = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const Output = []const u8;
            pub const InputValue = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const OutputValue = []const u8;
        };
        pub const pathname = struct {
            pub const Input = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const Output = []const u8;
            pub const InputValue = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const OutputValue = []const u8;
        };
        pub const origin = struct {
            pub const Input = *const zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const Output = []const u8;
            pub const InputValue = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
            pub const OutputValue = []const u8;
        };
        pub const domainToASCII = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const domainToUnicode = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const pathToFileURL = struct {
            pub const Input = *const zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078;
            pub const Output = []const u8;
            pub const InputValue = zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078;
            pub const OutputValue = []const u8;
        };
        pub const fileURLToPath = struct {
            pub const Input = *const zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
            pub const Output = []const u8;
            pub const InputValue = zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
            pub const OutputValue = []const u8;
        };
        pub const fileURLToBytes = struct {
            pub const Input = *const zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
            pub const Output = []const u8;
            pub const InputValue = zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
            pub const OutputValue = []const u8;
        };
    };
};

pub const layouts = struct {
    pub const @"std:url" = struct {
        pub const Url = zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5;
        pub const Resolve = zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd;
        pub const Platform = zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16;
        pub const FilePath = zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078;
        pub const FileUrl = zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54;
    };
};

