pub const zx_type_b907b849c4e19e55a72198a3d48c92fe80646068662deb56400281e428404923 = struct { []const u8, };

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
        pub const readStdin = struct {
            pub const Input = u64;
            pub const Output = []const u8;
            pub const InputValue = u64;
            pub const OutputValue = []const u8;
        };
        pub const readStdinText = struct {
            pub const Input = u64;
            pub const Output = []const u8;
            pub const InputValue = u64;
            pub const OutputValue = []const u8;
        };
        pub const writeStdout = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
        pub const writeStdoutText = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
        pub const writeStderr = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
        pub const writeStderrText = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
    };
};

pub const layouts = struct {
    pub const @"std:process" = struct {
    };
};

