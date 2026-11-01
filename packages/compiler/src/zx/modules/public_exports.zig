const std = @import("std");
const zx = @import("zx");

pub fn merge(comptime T: type, allocator: std.mem.Allocator, own: []const T, forwarded: []const T) std.mem.Allocator.Error![]const T {
    if (own.len == 0) return forwarded;
    if (forwarded.len == 0) return own;

    const result = try allocator.alloc(T, own.len + forwarded.len);

    @memcpy(result[0..own.len], own);
    @memcpy(result[own.len..], forwarded);

    return result;
}

pub fn validate(allocator: std.mem.Allocator, types: []const zx.ir.Export, constants: []const zx.ir.Constant, functions: anytype, reporter: *zx.Reporter) zx.Error!void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const names = try temporary.alloc([]const u8, types.len + constants.len + functions.len);
    var index: usize = 0;

    inline for (.{ types, constants, functions }) |items| {
        for (items) |item| {
            names[index] = item.name;
            index += 1;
        }
    }

    if (@import("parser_options").generated_parser) {
        const valid = @import("generated_public_names").executeValue(temporary, names) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, "public export name validation failed"),
        };

        if (valid) return;
    }

    var seen: std.StringHashMapUnmanaged(void) = .empty;

    for (names) |name| {
        if ((try seen.getOrPut(temporary, name)).found_existing) return reporter.fail(.name, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "duplicate public export: {s}", .{if (name.len == 0) "default" else name}));
    }
}
