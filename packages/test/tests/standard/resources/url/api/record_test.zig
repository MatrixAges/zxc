const std = @import("std");
const allocation_testing = @import("allocation_testing");
const api = @import("implementation").url_api;
const Url = @typeInfo(@typeInfo(@TypeOf(api.stringify)).@"fn".param_types[1].?).pointer.child;

fn freeRecord(allocator: std.mem.Allocator, value: *const Url) void {
    inline for (@typeInfo(Url).@"struct".field_names) |field| {
        const item = @field(value, field);

        if (@FieldType(Url, field) == []const u8) {
            allocator.free(item);
        } else if (@FieldType(Url, field) == ?[]const u8) {
            if (item) |text| allocator.free(text);
        } else if (@FieldType(Url, field) == []const []const u8) {
            for (item) |text| allocator.free(text);

            allocator.free(item);
        }
    }

    allocator.destroy(value);
}

fn checkParse(allocator: std.mem.Allocator, is_opaque: bool) !void {
    const input = if (is_opaque) "data:你好?#" else "https://user:pass@example.org:8443/a//b?x#f";
    const value = try api.parse(allocator, input);

    defer freeRecord(allocator, value);

    const text = try api.stringify(allocator, value);

    defer allocator.free(text);

    try std.testing.expectEqualStrings(if (is_opaque) "data:%E4%BD%A0%E5%A5%BD?#" else input, text);
}

fn checkResolve(allocator: std.mem.Allocator) !void {
    const value = try api.resolve(allocator, &.{ .input = "../a?x#f", .base = "https://example.org/one/two" });

    defer freeRecord(allocator, value);

    const text = try api.stringify(allocator, value);

    defer allocator.free(text);

    try std.testing.expectEqualStrings("https://example.org/a?x#f", text);
}

fn checkTry(allocator: std.mem.Allocator, valid: bool) !void {
    const input = if (valid) "https://example.org/a?b#c" else "http://[bad";
    const value = try api.tryParse(allocator, &.{ .input = input, .base = null });

    defer if (value) |record| freeRecord(allocator, record);

    try std.testing.expectEqual(valid, value != null);
    try std.testing.expectEqual(valid, try api.canParse(allocator, &.{ .input = input, .base = null }));
}

fn checkDomain(allocator: std.mem.Allocator, valid: bool) !void {
    const input = if (valid) "bücher.example" else "invalid host";
    const ascii = try api.domainToASCII(allocator, input);

    defer allocator.free(ascii);

    const unicode = try api.domainToUnicode(allocator, input);

    defer allocator.free(unicode);

    try std.testing.expectEqualStrings(if (valid) "xn--bcher-kva.example" else "", ascii);
    try std.testing.expectEqualStrings(if (valid) input else "", unicode);
}

test "public parse owns hierarchical and opaque records across allocation failures" {
    for ([_]bool{ false, true }) |is_opaque| {
        try checkParse(std.testing.allocator, is_opaque);
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkParse, .{is_opaque});
    }
}

test "public resolve owns copied base fields across allocation failures" {
    try checkResolve(std.testing.allocator);
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkResolve, .{});
}

test "public optional parsing propagates allocation failure on success and rejection" {
    for ([_]bool{ false, true }) |valid| {
        try checkTry(std.testing.allocator, valid);
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkTry, .{valid});
    }
}

test "public domain conversions own success and empty rejection strings" {
    for ([_]bool{ false, true }) |valid| {
        try checkDomain(std.testing.allocator, valid);
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkDomain, .{valid});
    }
}

test "public record does not retain input buffer references" {
    const input = try std.testing.allocator.dupe(u8, "https://user:pass@example.org:8443/a/b?x#f");

    defer std.testing.allocator.free(input);

    const value = try api.parse(std.testing.allocator, input);

    defer freeRecord(std.testing.allocator, value);

    @memset(input, 'x');

    const text = try api.stringify(std.testing.allocator, value);

    defer std.testing.allocator.free(text);

    try std.testing.expectEqualStrings("https://user:pass@example.org:8443/a/b?x#f", text);
}
