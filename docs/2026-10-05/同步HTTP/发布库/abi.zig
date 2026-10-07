pub const zx_type_d57df09f954bc7087f7d142b62342d59541d8e12eb7d4467200ef0b5250e08f1 = enum { Get, Head, Post, Put, Patch, Delete, Options, };

pub const zx_type_8734ca80ac4a59956e57463ad5423609994e74337dfdaf4396deb432e8dcefd7 = struct {
    name: []const u8,
    value: []const u8,
};

pub const zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856 = struct {
    body: ?[]const u8,
    headers: []const *const zx_type_8734ca80ac4a59956e57463ad5423609994e74337dfdaf4396deb432e8dcefd7,
    max_body_bytes: u64,
    max_header_bytes: u64,
    method: zx_type_d57df09f954bc7087f7d142b62342d59541d8e12eb7d4467200ef0b5250e08f1,
    url: []const u8,
};

pub const zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84 = struct {
    body: []const u8,
    headers: []const *const zx_type_8734ca80ac4a59956e57463ad5423609994e74337dfdaf4396deb432e8dcefd7,
    status: u16,
};

pub const native = struct {
    pub const @"std:http" = struct {
        pub const Method = zx_type_d57df09f954bc7087f7d142b62342d59541d8e12eb7d4467200ef0b5250e08f1;
        pub const Header = *const zx_type_8734ca80ac4a59956e57463ad5423609994e74337dfdaf4396deb432e8dcefd7;
        pub const Options = *const zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856;
        pub const Response = *const zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84;
        pub const request = struct {
            pub const Input = *const zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856;
            pub const Output = *const zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84;
            pub const InputValue = zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856;
            pub const OutputValue = zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84;
        };
    };
};

pub const layouts = struct {
    pub const @"std:http" = struct {
        pub const Method = zx_type_d57df09f954bc7087f7d142b62342d59541d8e12eb7d4467200ef0b5250e08f1;
        pub const Header = zx_type_8734ca80ac4a59956e57463ad5423609994e74337dfdaf4396deb432e8dcefd7;
        pub const Options = zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856;
        pub const Response = zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84;
    };
};

