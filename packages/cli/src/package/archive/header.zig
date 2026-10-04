const std = @import("std");

pub fn validate(source: []const u8, maximum_entries: usize) !void {
    var offset: usize = 0;
    var entries: usize = 0;
    var long_name = false;

    while (offset < source.len) {
        if (source.len - offset < 512) return error.TruncatedPackageTar;

        const header = source[offset..][0..512];

        if (std.mem.allEqual(u8, header, 0)) {
            if (long_name or source.len - offset < 1024 or source.len % 512 != 0) return error.InvalidPackageTarEnd;
            if (!std.mem.allEqual(u8, source[offset..], 0)) return error.TrailingPackageTarData;

            return;
        }

        if (entries == maximum_entries) return error.TooManyPackageEntries;

        entries += 1;
        offset += 512;

        const size = try sizeField(header[124..136]);

        if (size > source.len - offset) return error.TruncatedPackageTar;

        const length: usize = @intCast(size);
        const padding = (512 - length % 512) % 512;

        if (padding > source.len - offset - length) return error.TruncatedPackageTar;

        switch (header[156]) {
            0, '0', '5' => {
                if (header[156] == '5' and length != 0) return error.InvalidPackageDirectory;

                long_name = false;
            },
            'L' => {
                if (long_name or length == 0 or length > std.fs.max_path_bytes) return error.InvalidPackageLongName;

                const name = source[offset..][0..length];

                if (name[length - 1] != 0 or std.mem.indexOfScalar(u8, name[0 .. length - 1], 0) != null) return error.InvalidPackageLongName;

                long_name = true;
            },
            else => return error.UnsupportedPackageTarEntry,
        }

        offset += length + padding;
    }

    return error.InvalidPackageTarEnd;
}

fn sizeField(field: []const u8) !u64 {
    if (field[0] == 0x80) {
        if (!std.mem.allEqual(u8, field[1..4], 0)) return error.InvalidPackageTarSize;

        return std.mem.readInt(u64, field[4..12], .big);
    }

    const value = std.mem.trim(u8, field, " \x00");

    return if (value.len == 0) 0 else std.fmt.parseInt(u64, value, 8) catch error.InvalidPackageTarSize;
}
