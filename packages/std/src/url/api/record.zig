const std = @import("std");
const Url = @import("../model.zig").Url;
const api = @import("zxc_abi").native.@"std:url";
const layouts = @import("zxc_abi").layouts.@"std:url";

pub fn read(input: api.Url) Url {
    var result: Url = undefined;

    inline for (@typeInfo(Url).@"struct".field_names) |field| @field(result, field) = @field(input, field);

    return result;
}

pub fn copy(allocator: std.mem.Allocator, input: Url) !api.Url {
    const output = try allocator.create(layouts.Url);
    var completed: usize = 0;

    errdefer {
        inline for (@typeInfo(Url).@"struct".field_names, 0..) |field, index| {
            if (index < completed) {
                const value = @field(output, field);

                if (@FieldType(Url, field) == []const u8) {
                    allocator.free(value);
                } else if (@FieldType(Url, field) == ?[]const u8) {
                    if (value) |text| allocator.free(text);
                } else if (@FieldType(Url, field) == []const []const u8) {
                    for (value) |text| allocator.free(text);

                    allocator.free(value);
                }
            }
        }

        allocator.destroy(output);
    }

    inline for (@typeInfo(Url).@"struct".field_names) |field| {
        const value = @field(input, field);

        @field(output, field) = if (@FieldType(Url, field) == []const u8)
            try allocator.dupe(u8, value)

        else if (@FieldType(Url, field) == ?[]const u8)
            if (value) |text| try allocator.dupe(u8, text) else null
        else if (@FieldType(Url, field) == []const []const u8)
            try copyPath(allocator, value)
        else
            value;

        completed += 1;
    }

    return output;
}

fn copyPath(allocator: std.mem.Allocator, input: []const []const u8) ![]const []const u8 {
    const output = try allocator.alloc([]const u8, input.len);
    var completed: usize = 0;

    errdefer {
        for (output[0..completed]) |text| allocator.free(text);

        allocator.free(output);
    }

    for (input, output) |text, *item| {
        item.* = try allocator.dupe(u8, text);
        completed += 1;
    }

    return output;
}
