pub const zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec = struct {
    args: []const []const u8,
    directory: []const u8,
    value: ?[]const u8,
};

pub const native = struct {
    pub const @"std:process" = struct {
        pub const argv = struct {
            pub const Input = void;
            pub const Output = []const []const u8;
            pub const InputValue = void;
            pub const OutputValue = []const []const u8;
        };
        pub const getEnv = struct {
            pub const Input = []const u8;
            pub const Output = ?[]const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = ?[]const u8;
        };
        pub const cwd = struct {
            pub const Input = void;
            pub const Output = []const u8;
            pub const InputValue = void;
            pub const OutputValue = []const u8;
        };
    };
};

pub const layouts = struct {
    pub const @"std:process" = struct {
    };
};

