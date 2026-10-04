const os = @import("os.zig");

export fn architecture() [*]const u8 {
    return os.arch().ptr;
}

export fn operatingSystem() [*]const u8 {
    return os.platform().ptr;
}

export fn byteOrder() [*]const u8 {
    return os.endianness().ptr;
}
