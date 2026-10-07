pub const zx_type_11 = enum { Exited, Signal, Stopped, Unknown, };

pub const zx_type_12 = struct {
    name: []const u8,
    value: []const u8,
};

pub const zx_type_17 = struct {
    args: []const []const u8,
    command: []const u8,
    cwd: ?[]const u8,
    env: ?[]const *const zx_type_12,
    max_stderr_bytes: u64,
    max_stdout_bytes: u64,
};

pub const zx_type_19 = struct {
    input: []const u8,
    options: *const zx_type_17,
};

pub const zx_type_20 = struct {
    code: u32,
    kind: zx_type_11,
    stderr: []const u8,
    stdout: []const u8,
};

pub const zx_type_21 = struct {
    block_size: u32,
    cost: u32,
    length: u32,
    max_memory: u64,
    parallelism: u32,
    password: []const u8,
    salt: []const u8,
};

pub const zx_type_22 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_23 = struct {
    data: []const u8,
    key: []const u8,
    tag: []const u8,
};

pub const zx_type_24 = struct {
    data: []const u8,
    key: []const u8,
};

pub const zx_type_25 = struct {
    info: []const u8,
    key: []const u8,
    length: u32,
    salt: []const u8,
};

pub const zx_type_26 = struct {
    iterations: u32,
    length: u32,
    password: []const u8,
    salt: []const u8,
};

pub const zx_type_27 = struct {
    aad: []const u8,
    data: []const u8,
    key: []const u8,
    nonce: []const u8,
};

pub const zx_type_28 = struct {
    ciphertext: []const u8,
    tag: []const u8,
};

pub const zx_type_29 = struct {
    aad: []const u8,
    ciphertext: []const u8,
    key: []const u8,
    nonce: []const u8,
    tag: []const u8,
};

pub const zx_type_30 = enum { File, Directory, SymbolicLink, BlockDevice, CharacterDevice, Fifo, Socket, Unknown, };

pub const zx_type_32 = struct {
    atime_ms: ?i64,
    ctime_ms: i64,
    kind: zx_type_30,
    mtime_ms: i64,
    size: u64,
};

pub const zx_type_33 = struct {
    max_bytes: u64,
    path: []const u8,
};

pub const zx_type_34 = struct {
    data: []const u8,
    path: []const u8,
};

pub const zx_type_35 = struct {
    path: []const u8,
    text: []const u8,
};

pub const zx_type_36 = struct {
    length: u64,
    path: []const u8,
};

pub const zx_type_37 = struct {
    path: []const u8,
    recursive: bool,
};

pub const zx_type_38 = struct {
    from: []const u8,
    to: []const u8,
};

pub const zx_type_39 = struct {
    exclusive: bool,
    from: []const u8,
    to: []const u8,
};

pub const zx_type_40 = enum { Get, Head, Post, Put, Patch, Delete, Options, };

pub const zx_type_41 = struct {
    name: []const u8,
    value: []const u8,
};

pub const zx_type_44 = struct {
    body: ?[]const u8,
    headers: []const *const zx_type_41,
    max_body_bytes: u64,
    max_header_bytes: u64,
    method: zx_type_40,
    url: []const u8,
};

pub const zx_type_45 = struct {
    body: []const u8,
    headers: []const *const zx_type_41,
    status: u16,
};

pub const zx_type_46 = struct {
    base: []const u8,
    dir: []const u8,
    ext: []const u8,
    name: []const u8,
    root: []const u8,
};

pub const zx_type_47 = struct {
    cwd: []const u8,
    paths: []const []const u8,
};

pub const zx_type_48 = struct {
    cwd: []const u8,
    from: []const u8,
    to: []const u8,
};

pub const zx_type_49 = struct {
    key: []const u8,
    value: []const u8,
};

pub const zx_type_50 = struct {
    assignment: []const u8,
    max_keys: u32,
    query: []const u8,
    separator: []const u8,
};

pub const zx_type_52 = struct {
    assignment: []const u8,
    entries: []const *const zx_type_49,
    separator: []const u8,
};

pub const zx_type_54 = struct {
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

pub const zx_type_55 = struct {
    base: ?[]const u8,
    input: []const u8,
};

pub const zx_type_56 = enum { Posix, Windows, };

pub const zx_type_57 = struct {
    cwd: []const u8,
    path: []const u8,
    platform: zx_type_56,
};

pub const zx_type_58 = struct {
    platform: zx_type_56,
    url: *const zx_type_54,
};

pub const zx_type_60 = struct {
    entries: []const *const zx_type_49,
    key: []const u8,
};

pub const zx_type_61 = struct {
    entries: []const *const zx_type_49,
    key: []const u8,
    value: ?[]const u8,
};

pub const zx_type_62 = struct {
    entries: []const *const zx_type_49,
    key: []const u8,
    value: []const u8,
};

pub const zx_type_63 = struct {
    data: []const u8,
    max_output_length: u32,
};

pub const zx_type_64 = struct {
    data: []const u8,
    max_output_length: u32,
    max_window_length: u32,
};

pub const zx_type_65 = struct {
    data: []const u8,
    level: i32,
};

pub const native = struct {
    pub const @"std:child_process" = struct {
        pub const TerminationKind = zx_type_11;
        pub const EnvironmentEntry = *const zx_type_12;
        pub const Options = *const zx_type_17;
        pub const InputOptions = *const zx_type_19;
        pub const Result = *const zx_type_20;
        pub const spawnSync = struct {
            pub const Input = *const zx_type_17;
            pub const Output = *const zx_type_20;
            pub const InputValue = zx_type_17;
            pub const OutputValue = zx_type_20;
        };
        pub const spawnSyncWithInput = struct {
            pub const Input = *const zx_type_19;
            pub const Output = *const zx_type_20;
            pub const InputValue = zx_type_19;
            pub const OutputValue = zx_type_20;
        };
    };
    pub const @"std:crypto" = struct {
        pub const ScryptOptions = *const zx_type_21;
        pub const sha256 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const sha512 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const timingSafeEqual = struct {
            pub const Input = *const zx_type_22;
            pub const Output = bool;
            pub const InputValue = zx_type_22;
            pub const OutputValue = bool;
        };
        pub const verifyHmacSha256 = struct {
            pub const Input = *const zx_type_23;
            pub const Output = bool;
            pub const InputValue = zx_type_23;
            pub const OutputValue = bool;
        };
        pub const verifyHmacSha512 = struct {
            pub const Input = *const zx_type_23;
            pub const Output = bool;
            pub const InputValue = zx_type_23;
            pub const OutputValue = bool;
        };
        pub const hmacSha256 = struct {
            pub const Input = *const zx_type_24;
            pub const Output = []const u8;
            pub const InputValue = zx_type_24;
            pub const OutputValue = []const u8;
        };
        pub const hmacSha512 = struct {
            pub const Input = *const zx_type_24;
            pub const Output = []const u8;
            pub const InputValue = zx_type_24;
            pub const OutputValue = []const u8;
        };
        pub const hkdfSha256 = struct {
            pub const Input = *const zx_type_25;
            pub const Output = []const u8;
            pub const InputValue = zx_type_25;
            pub const OutputValue = []const u8;
        };
        pub const hkdfSha512 = struct {
            pub const Input = *const zx_type_25;
            pub const Output = []const u8;
            pub const InputValue = zx_type_25;
            pub const OutputValue = []const u8;
        };
        pub const pbkdf2Sha256 = struct {
            pub const Input = *const zx_type_26;
            pub const Output = []const u8;
            pub const InputValue = zx_type_26;
            pub const OutputValue = []const u8;
        };
        pub const pbkdf2Sha512 = struct {
            pub const Input = *const zx_type_26;
            pub const Output = []const u8;
            pub const InputValue = zx_type_26;
            pub const OutputValue = []const u8;
        };
        pub const encryptAes128Gcm = struct {
            pub const Input = *const zx_type_27;
            pub const Output = *const zx_type_28;
            pub const InputValue = zx_type_27;
            pub const OutputValue = zx_type_28;
        };
        pub const decryptAes128Gcm = struct {
            pub const Input = *const zx_type_29;
            pub const Output = []const u8;
            pub const InputValue = zx_type_29;
            pub const OutputValue = []const u8;
        };
        pub const encryptAes256Gcm = struct {
            pub const Input = *const zx_type_27;
            pub const Output = *const zx_type_28;
            pub const InputValue = zx_type_27;
            pub const OutputValue = zx_type_28;
        };
        pub const decryptAes256Gcm = struct {
            pub const Input = *const zx_type_29;
            pub const Output = []const u8;
            pub const InputValue = zx_type_29;
            pub const OutputValue = []const u8;
        };
        pub const encryptChaCha20Poly1305 = struct {
            pub const Input = *const zx_type_27;
            pub const Output = *const zx_type_28;
            pub const InputValue = zx_type_27;
            pub const OutputValue = zx_type_28;
        };
        pub const decryptChaCha20Poly1305 = struct {
            pub const Input = *const zx_type_29;
            pub const Output = []const u8;
            pub const InputValue = zx_type_29;
            pub const OutputValue = []const u8;
        };
        pub const scrypt = struct {
            pub const Input = *const zx_type_21;
            pub const Output = []const u8;
            pub const InputValue = zx_type_21;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:encoding" = struct {
        pub const encodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:fs" = struct {
        pub const Kind = zx_type_30;
        pub const Stat = *const zx_type_32;
        pub const readFile = struct {
            pub const Input = *const zx_type_33;
            pub const Output = []const u8;
            pub const InputValue = zx_type_33;
            pub const OutputValue = []const u8;
        };
        pub const readText = struct {
            pub const Input = *const zx_type_33;
            pub const Output = []const u8;
            pub const InputValue = zx_type_33;
            pub const OutputValue = []const u8;
        };
        pub const writeFile = struct {
            pub const Input = *const zx_type_34;
            pub const Output = void;
            pub const InputValue = zx_type_34;
            pub const OutputValue = void;
        };
        pub const writeText = struct {
            pub const Input = *const zx_type_35;
            pub const Output = void;
            pub const InputValue = zx_type_35;
            pub const OutputValue = void;
        };
        pub const truncate = struct {
            pub const Input = *const zx_type_36;
            pub const Output = void;
            pub const InputValue = zx_type_36;
            pub const OutputValue = void;
        };
        pub const mkdir = struct {
            pub const Input = *const zx_type_37;
            pub const Output = void;
            pub const InputValue = zx_type_37;
            pub const OutputValue = void;
        };
        pub const readdir = struct {
            pub const Input = []const u8;
            pub const Output = []const []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const []const u8;
        };
        pub const rmdir = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
        pub const unlink = struct {
            pub const Input = []const u8;
            pub const Output = void;
            pub const InputValue = []const u8;
            pub const OutputValue = void;
        };
        pub const rename = struct {
            pub const Input = *const zx_type_38;
            pub const Output = void;
            pub const InputValue = zx_type_38;
            pub const OutputValue = void;
        };
        pub const copyFile = struct {
            pub const Input = *const zx_type_39;
            pub const Output = void;
            pub const InputValue = zx_type_39;
            pub const OutputValue = void;
        };
        pub const realpath = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const readlink = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const stat = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_32;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_32;
        };
        pub const lstat = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_32;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_32;
        };
    };
    pub const @"std:http" = struct {
        pub const Method = zx_type_40;
        pub const Header = *const zx_type_41;
        pub const Options = *const zx_type_44;
        pub const Response = *const zx_type_45;
        pub const request = struct {
            pub const Input = *const zx_type_44;
            pub const Output = *const zx_type_45;
            pub const InputValue = zx_type_44;
            pub const OutputValue = zx_type_45;
        };
    };
    pub const @"std:os" = struct {
        pub const arch = struct {
            pub const Input = void;
            pub const Output = []const u8;
            pub const InputValue = void;
            pub const OutputValue = []const u8;
        };
        pub const platform = struct {
            pub const Input = void;
            pub const Output = []const u8;
            pub const InputValue = void;
            pub const OutputValue = []const u8;
        };
        pub const endianness = struct {
            pub const Input = void;
            pub const Output = []const u8;
            pub const InputValue = void;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:path" = struct {
        pub const Parts = *const zx_type_46;

        pub const isAbsolute = struct {
            pub const Input = []const u8;
            pub const Output = bool;
            pub const InputValue = []const u8;
            pub const OutputValue = bool;
        };
        pub const basename = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const dirname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const extname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_46;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_46;
        };
        pub const format = struct {
            pub const Input = *const zx_type_46;
            pub const Output = []const u8;
            pub const InputValue = zx_type_46;
            pub const OutputValue = []const u8;
        };
        pub const normalize = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const join = struct {
            pub const Input = []const []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const []const u8;
            pub const OutputValue = []const u8;
        };
        pub const resolve = struct {
            pub const Input = *const zx_type_47;
            pub const Output = []const u8;
            pub const InputValue = zx_type_47;
            pub const OutputValue = []const u8;
        };
        pub const relative = struct {
            pub const Input = *const zx_type_48;
            pub const Output = []const u8;
            pub const InputValue = zx_type_48;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:path/posix" = struct {
        pub const Parts = *const zx_type_46;

        pub const isAbsolute = struct {
            pub const Input = []const u8;
            pub const Output = bool;
            pub const InputValue = []const u8;
            pub const OutputValue = bool;
        };
        pub const basename = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const dirname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const extname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_46;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_46;
        };
        pub const format = struct {
            pub const Input = *const zx_type_46;
            pub const Output = []const u8;
            pub const InputValue = zx_type_46;
            pub const OutputValue = []const u8;
        };
        pub const normalize = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const join = struct {
            pub const Input = []const []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const []const u8;
            pub const OutputValue = []const u8;
        };
        pub const resolve = struct {
            pub const Input = *const zx_type_47;
            pub const Output = []const u8;
            pub const InputValue = zx_type_47;
            pub const OutputValue = []const u8;
        };
        pub const relative = struct {
            pub const Input = *const zx_type_48;
            pub const Output = []const u8;
            pub const InputValue = zx_type_48;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:path/win32" = struct {
        pub const Parts = *const zx_type_46;

        pub const isAbsolute = struct {
            pub const Input = []const u8;
            pub const Output = bool;
            pub const InputValue = []const u8;
            pub const OutputValue = bool;
        };
        pub const basename = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const dirname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const extname = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_46;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_46;
        };
        pub const format = struct {
            pub const Input = *const zx_type_46;
            pub const Output = []const u8;
            pub const InputValue = zx_type_46;
            pub const OutputValue = []const u8;
        };
        pub const normalize = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const join = struct {
            pub const Input = []const []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const []const u8;
            pub const OutputValue = []const u8;
        };
        pub const resolve = struct {
            pub const Input = *const zx_type_47;
            pub const Output = []const u8;
            pub const InputValue = zx_type_47;
            pub const OutputValue = []const u8;
        };
        pub const relative = struct {
            pub const Input = *const zx_type_48;
            pub const Output = []const u8;
            pub const InputValue = zx_type_48;
            pub const OutputValue = []const u8;
        };
    };
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
    pub const @"std:querystring" = struct {
        pub const Entry = *const zx_type_49;
        pub const ParseOptions = *const zx_type_50;
        pub const StringifyOptions = *const zx_type_52;
        pub const escape = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const unescape = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = []const u8;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const parseWith = struct {
            pub const Input = *const zx_type_50;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = zx_type_50;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const stringify = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = []const u8;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = []const u8;
        };
        pub const stringifyWith = struct {
            pub const Input = *const zx_type_52;
            pub const Output = []const u8;
            pub const InputValue = zx_type_52;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:url" = struct {
        pub const Url = *const zx_type_54;
        pub const Resolve = *const zx_type_55;
        pub const Platform = zx_type_56;
        pub const FilePath = *const zx_type_57;
        pub const FileUrl = *const zx_type_58;
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = *const zx_type_54;
            pub const InputValue = []const u8;
            pub const OutputValue = zx_type_54;
        };
        pub const resolve = struct {
            pub const Input = *const zx_type_55;
            pub const Output = *const zx_type_54;
            pub const InputValue = zx_type_55;
            pub const OutputValue = zx_type_54;
        };
        pub const tryParse = struct {
            pub const Input = *const zx_type_55;
            pub const Output = ?*const zx_type_54;
            pub const InputValue = zx_type_55;
            pub const OutputValue = ?*const zx_type_54;
        };
        pub const canParse = struct {
            pub const Input = *const zx_type_55;
            pub const Output = bool;
            pub const InputValue = zx_type_55;
            pub const OutputValue = bool;
        };
        pub const stringify = struct {
            pub const Input = *const zx_type_54;
            pub const Output = []const u8;
            pub const InputValue = zx_type_54;
            pub const OutputValue = []const u8;
        };
        pub const pathname = struct {
            pub const Input = *const zx_type_54;
            pub const Output = []const u8;
            pub const InputValue = zx_type_54;
            pub const OutputValue = []const u8;
        };
        pub const origin = struct {
            pub const Input = *const zx_type_54;
            pub const Output = []const u8;
            pub const InputValue = zx_type_54;
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
            pub const Input = *const zx_type_57;
            pub const Output = []const u8;
            pub const InputValue = zx_type_57;
            pub const OutputValue = []const u8;
        };
        pub const fileURLToPath = struct {
            pub const Input = *const zx_type_58;
            pub const Output = []const u8;
            pub const InputValue = zx_type_58;
            pub const OutputValue = []const u8;
        };
        pub const fileURLToBytes = struct {
            pub const Input = *const zx_type_58;
            pub const Output = []const u8;
            pub const InputValue = zx_type_58;
            pub const OutputValue = []const u8;
        };
    };
    pub const @"std:url/search_params" = struct {
        pub const Entry = *const zx_type_49;
        pub const Lookup = *const zx_type_60;
        pub const Match = *const zx_type_61;
        pub const Update = *const zx_type_62;
        pub const parse = struct {
            pub const Input = []const u8;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = []const u8;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const stringify = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = []const u8;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = []const u8;
        };
        pub const get = struct {
            pub const Input = *const zx_type_60;
            pub const Output = ?[]const u8;
            pub const InputValue = zx_type_60;
            pub const OutputValue = ?[]const u8;
        };
        pub const getAll = struct {
            pub const Input = *const zx_type_60;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_60;
            pub const OutputValue = []const []const u8;
        };
        pub const has = struct {
            pub const Input = *const zx_type_61;
            pub const Output = bool;
            pub const InputValue = zx_type_61;
            pub const OutputValue = bool;
        };
        pub const append = struct {
            pub const Input = *const zx_type_62;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = zx_type_62;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const set = struct {
            pub const Input = *const zx_type_62;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = zx_type_62;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const remove = struct {
            pub const Input = *const zx_type_61;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = zx_type_61;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const sort = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = []const *const zx_type_49;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = []const *const zx_type_49;
        };
        pub const keys = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = []const []const u8;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = []const []const u8;
        };
        pub const values = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = []const []const u8;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = []const []const u8;
        };
        pub const size = struct {
            pub const Input = []const *const zx_type_49;
            pub const Output = u64;
            pub const InputValue = []const *const zx_type_49;
            pub const OutputValue = u64;
        };
    };
    pub const @"std:zlib" = struct {
        pub const DecompressOptions = *const zx_type_63;
        pub const ZstdDecompressOptions = *const zx_type_64;
        pub const CompressOptions = *const zx_type_65;
        pub const gzip = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const deflate = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const deflateRaw = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const gzipWith = struct {
            pub const Input = *const zx_type_65;
            pub const Output = []const u8;
            pub const InputValue = zx_type_65;
            pub const OutputValue = []const u8;
        };
        pub const deflateWith = struct {
            pub const Input = *const zx_type_65;
            pub const Output = []const u8;
            pub const InputValue = zx_type_65;
            pub const OutputValue = []const u8;
        };
        pub const deflateRawWith = struct {
            pub const Input = *const zx_type_65;
            pub const Output = []const u8;
            pub const InputValue = zx_type_65;
            pub const OutputValue = []const u8;
        };
        pub const gunzip = struct {
            pub const Input = *const zx_type_63;
            pub const Output = []const u8;
            pub const InputValue = zx_type_63;
            pub const OutputValue = []const u8;
        };
        pub const inflate = struct {
            pub const Input = *const zx_type_63;
            pub const Output = []const u8;
            pub const InputValue = zx_type_63;
            pub const OutputValue = []const u8;
        };
        pub const inflateRaw = struct {
            pub const Input = *const zx_type_63;
            pub const Output = []const u8;
            pub const InputValue = zx_type_63;
            pub const OutputValue = []const u8;
        };
        pub const zstdDecompress = struct {
            pub const Input = *const zx_type_64;
            pub const Output = []const u8;
            pub const InputValue = zx_type_64;
            pub const OutputValue = []const u8;
        };
    };
};

pub const layouts = struct {
    pub const @"std:child_process" = struct {
        pub const TerminationKind = zx_type_11;
        pub const EnvironmentEntry = zx_type_12;
        pub const Options = zx_type_17;
        pub const InputOptions = zx_type_19;
        pub const Result = zx_type_20;
    };
    pub const @"std:crypto" = struct {
        pub const ScryptOptions = zx_type_21;
    };
    pub const @"std:encoding" = struct {
    };
    pub const @"std:fs" = struct {
        pub const Kind = zx_type_30;
        pub const Stat = zx_type_32;
    };
    pub const @"std:http" = struct {
        pub const Method = zx_type_40;
        pub const Header = zx_type_41;
        pub const Options = zx_type_44;
        pub const Response = zx_type_45;
    };
    pub const @"std:os" = struct {
    };
    pub const @"std:path" = struct {
        pub const Parts = zx_type_46;
    };
    pub const @"std:path/posix" = struct {
        pub const Parts = zx_type_46;
    };
    pub const @"std:path/win32" = struct {
        pub const Parts = zx_type_46;
    };
    pub const @"std:process" = struct {
    };
    pub const @"std:querystring" = struct {
        pub const Entry = zx_type_49;
        pub const ParseOptions = zx_type_50;
        pub const StringifyOptions = zx_type_52;
    };
    pub const @"std:url" = struct {
        pub const Url = zx_type_54;
        pub const Resolve = zx_type_55;
        pub const Platform = zx_type_56;
        pub const FilePath = zx_type_57;
        pub const FileUrl = zx_type_58;
    };
    pub const @"std:url/search_params" = struct {
        pub const Entry = zx_type_49;
        pub const Lookup = zx_type_60;
        pub const Match = zx_type_61;
        pub const Update = zx_type_62;
    };
    pub const @"std:zlib" = struct {
        pub const DecompressOptions = zx_type_63;
        pub const ZstdDecompressOptions = zx_type_64;
        pub const CompressOptions = zx_type_65;
    };
};

