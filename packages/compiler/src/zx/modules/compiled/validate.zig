const std = @import("std");
const model = @import("../compiled.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidLibrary};

pub fn validate(allocator: std.mem.Allocator, library: model.Graph) Error!void {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, library);

    return @import("host/root.zig").validate(allocator, library);
}
