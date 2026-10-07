pub const zx_type_12 = struct {
    block_size: u32,
    cost: u32,
    length: u32,
    max_memory: u64,
    parallelism: u32,
    password: []const u8,
    salt: []const u8,
};

pub const zx_type_13 = struct {
    left: []const u8,
    right: []const u8,
};

pub const zx_type_14 = struct {
    data: []const u8,
    key: []const u8,
    tag: []const u8,
};

pub const zx_type_15 = struct {
    data: []const u8,
    key: []const u8,
};

pub const zx_type_16 = struct {
    info: []const u8,
    key: []const u8,
    length: u32,
    salt: []const u8,
};

pub const zx_type_17 = struct {
    iterations: u32,
    length: u32,
    password: []const u8,
    salt: []const u8,
};

pub const zx_type_18 = struct {
    aad: []const u8,
    data: []const u8,
    key: []const u8,
    nonce: []const u8,
};

pub const zx_type_19 = struct {
    ciphertext: []const u8,
    tag: []const u8,
};

pub const zx_type_20 = struct {
    aad: []const u8,
    ciphertext: []const u8,
    key: []const u8,
    nonce: []const u8,
    tag: []const u8,
};

pub const zx_type_21 = struct {
    bytes: []const u8,
    text: []const u8,
};

pub const zx_type_22 = struct {
    base64: []const u8,
    base64_bytes: []const u8,
    hex: []const u8,
    hex_bytes: []const u8,
    sha256: []const u8,
    sha512: []const u8,
    text: []const u8,
    utf8: []const u8,
};

pub const native = struct {
    pub const @"std:crypto" = struct {
        pub const ScryptOptions = *const zx_type_12;
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
            pub const Input = *const zx_type_13;
            pub const Output = bool;
            pub const InputValue = zx_type_13;
            pub const OutputValue = bool;
        };
        pub const verifyHmacSha256 = struct {
            pub const Input = *const zx_type_14;
            pub const Output = bool;
            pub const InputValue = zx_type_14;
            pub const OutputValue = bool;
        };
        pub const verifyHmacSha512 = struct {
            pub const Input = *const zx_type_14;
            pub const Output = bool;
            pub const InputValue = zx_type_14;
            pub const OutputValue = bool;
        };
        pub const hmacSha256 = struct {
            pub const Input = *const zx_type_15;
            pub const Output = []const u8;
            pub const InputValue = zx_type_15;
            pub const OutputValue = []const u8;
        };
        pub const hmacSha512 = struct {
            pub const Input = *const zx_type_15;
            pub const Output = []const u8;
            pub const InputValue = zx_type_15;
            pub const OutputValue = []const u8;
        };
        pub const hkdfSha256 = struct {
            pub const Input = *const zx_type_16;
            pub const Output = []const u8;
            pub const InputValue = zx_type_16;
            pub const OutputValue = []const u8;
        };
        pub const hkdfSha512 = struct {
            pub const Input = *const zx_type_16;
            pub const Output = []const u8;
            pub const InputValue = zx_type_16;
            pub const OutputValue = []const u8;
        };
        pub const pbkdf2Sha256 = struct {
            pub const Input = *const zx_type_17;
            pub const Output = []const u8;
            pub const InputValue = zx_type_17;
            pub const OutputValue = []const u8;
        };
        pub const pbkdf2Sha512 = struct {
            pub const Input = *const zx_type_17;
            pub const Output = []const u8;
            pub const InputValue = zx_type_17;
            pub const OutputValue = []const u8;
        };
        pub const encryptAes128Gcm = struct {
            pub const Input = *const zx_type_18;
            pub const Output = *const zx_type_19;
            pub const InputValue = zx_type_18;
            pub const OutputValue = zx_type_19;
        };
        pub const decryptAes128Gcm = struct {
            pub const Input = *const zx_type_20;
            pub const Output = []const u8;
            pub const InputValue = zx_type_20;
            pub const OutputValue = []const u8;
        };
        pub const encryptAes256Gcm = struct {
            pub const Input = *const zx_type_18;
            pub const Output = *const zx_type_19;
            pub const InputValue = zx_type_18;
            pub const OutputValue = zx_type_19;
        };
        pub const decryptAes256Gcm = struct {
            pub const Input = *const zx_type_20;
            pub const Output = []const u8;
            pub const InputValue = zx_type_20;
            pub const OutputValue = []const u8;
        };
        pub const encryptChaCha20Poly1305 = struct {
            pub const Input = *const zx_type_18;
            pub const Output = *const zx_type_19;
            pub const InputValue = zx_type_18;
            pub const OutputValue = zx_type_19;
        };
        pub const decryptChaCha20Poly1305 = struct {
            pub const Input = *const zx_type_20;
            pub const Output = []const u8;
            pub const InputValue = zx_type_20;
            pub const OutputValue = []const u8;
        };
        pub const scrypt = struct {
            pub const Input = *const zx_type_12;
            pub const Output = []const u8;
            pub const InputValue = zx_type_12;
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
};

pub const layouts = struct {
    pub const @"std:crypto" = struct {
        pub const ScryptOptions = zx_type_12;
    };
    pub const @"std:encoding" = struct {
    };
};

