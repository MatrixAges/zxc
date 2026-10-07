pub const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79 = opaque {};
pub const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697 = opaque {};
pub const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f = opaque {};
pub const zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010 = struct { *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79, u64, };
pub const zx_type_e56b5671f1a714d0463912960f5561e52ce6f21e27fafade24d0dd85adb03ba1 = struct { *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697, u64, u64, };
pub const zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e = enum { Invalid, Module, Import, Call, Task, Parallel, Switch, Case, Default, Emit, Return, Gateway, Group, Route, Store, StoreRef, Object, Field, };
pub const zx_type_c1abe98383782fd72d7583df765b9e8b9f3e302ac1e4ff9b6624b24e975841ff = enum { String, OptionalString, Unsigned, Protocol, Method, };

pub const zx_type_877f927949fa0e81ce427c2f47f9423014a1344003c8e9175d2f03aeb4383732 = struct {
    fallback: u64,
    kind: zx_type_c1abe98383782fd72d7583df765b9e8b9f3e302ac1e4ff9b6624b24e975841ff,
    name: []const u8,
    required: bool,
};

pub const zx_type_fefefee69c6456cbdbbd2bfb46c23d9689ace6503fc5f0a169e2215a4cc6e147 = struct { *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79, };
pub const zx_type_39692b9357a0cc5b2e0e22413b64ce3f3e6ea3c6a6788a57b7c34df62f99027d = struct { *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79, zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_cc8afdbd9436c3bed966cb878225efe1f82f2cb909997af6228473dd7a5b6910" = struct {
        pub const Node = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
        pub const Attribute = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
        pub const Text = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
        pub const nodeName = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = []const u8;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = []const u8;
        };
        pub const nodeOffset = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const nodeLine = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const nodeColumn = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const attributeCount = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const attributeAt = struct {
            pub const Input = *const zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const Output = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const InputValue = zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const OutputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
        };
        pub const childCount = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const childAt = struct {
            pub const Input = *const zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const Output = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const InputValue = zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const OutputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
        };
        pub const textCount = struct {
            pub const Input = *const zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const Output = u64;
            pub const InputValue = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
            pub const OutputValue = u64;
        };
        pub const textAt = struct {
            pub const Input = *const zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const Output = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const InputValue = zx_type_51f7d5a95ae51b446eabc0a5ea34a743cca32900a6d5b67c1cc21a8eaaf68010;
            pub const OutputValue = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
        };
        pub const attributeName = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = []const u8;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = []const u8;
        };
        pub const attributeValue = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = []const u8;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = []const u8;
        };
        pub const attributeBytes = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = []const u8;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = []const u8;
        };
        pub const attributeExpression = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = bool;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = bool;
        };
        pub const attributeSlice = struct {
            pub const Input = *const zx_type_e56b5671f1a714d0463912960f5561e52ce6f21e27fafade24d0dd85adb03ba1;
            pub const Output = []const u8;
            pub const InputValue = zx_type_e56b5671f1a714d0463912960f5561e52ce6f21e27fafade24d0dd85adb03ba1;
            pub const OutputValue = []const u8;
        };
        pub const attributeOffset = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const attributeLine = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const attributeColumn = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const valueOffset = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const valueLine = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const valueColumn = struct {
            pub const Input = *const zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const Output = u64;
            pub const InputValue = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
            pub const OutputValue = u64;
        };
        pub const textBytes = struct {
            pub const Input = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const Output = []const u8;
            pub const InputValue = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const OutputValue = []const u8;
        };
        pub const textOffset = struct {
            pub const Input = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const Output = u64;
            pub const InputValue = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const OutputValue = u64;
        };
        pub const textLine = struct {
            pub const Input = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const Output = u64;
            pub const InputValue = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const OutputValue = u64;
        };
        pub const textColumn = struct {
            pub const Input = *const zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const Output = u64;
            pub const InputValue = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
            pub const OutputValue = u64;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_cc8afdbd9436c3bed966cb878225efe1f82f2cb909997af6228473dd7a5b6910" = struct {
        pub const Node = zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
        pub const Attribute = zx_type_3e29e88d0b453ed2cb49eb7a7573a475582f0c0de7e39559d6b85827eb30d697;
        pub const Text = zx_type_64c95aabc8ea1872667267e48818b2445e1de1d26d9a3bb7c32a2c2298ef401f;
    };
};

pub const native = struct {
    pub const @"zig:rx_ast" = (native_by_identity).@"zig:zxc_native_cc8afdbd9436c3bed966cb878225efe1f82f2cb909997af6228473dd7a5b6910";
};

pub const layouts = struct {
    pub const @"zig:rx_ast" = (layouts_by_identity).@"zig:zxc_native_cc8afdbd9436c3bed966cb878225efe1f82f2cb909997af6228473dd7a5b6910";
};

