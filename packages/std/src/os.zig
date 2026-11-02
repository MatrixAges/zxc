const builtin = @import("builtin");

pub fn arch() []const u8 {
    return switch (builtin.cpu.arch) {
        .x86 => "ia32",
        .x86_64 => "x64",
        .aarch64, .aarch64_be => "arm64",
        .arm, .armeb, .thumb, .thumbeb => "arm",
        .loongarch64 => "loong64",
        .powerpc64, .powerpc64le => "ppc64",
        else => @tagName(builtin.cpu.arch),
    };
}

pub fn platform() []const u8 {
    if (builtin.abi.isAndroid()) return "android";

    return switch (builtin.os.tag) {
        .macos => "darwin",
        .windows => "win32",
        .illumos => "sunos",
        else => @tagName(builtin.os.tag),
    };
}

pub fn endianness() []const u8 {
    return switch (builtin.cpu.arch.endian()) {
        .big => "BE",
        .little => "LE",
    };
}
