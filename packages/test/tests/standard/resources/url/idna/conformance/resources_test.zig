const std = @import("std");
const impl = @import("implementation");
const Mode = enum { ascii, unicode };

fn check(allocator: std.mem.Allocator, mode: Mode, input: []const u8, expected: []const u8) !void {
    const result = try switch (mode) {
        .ascii => impl.toAscii(allocator, input),
        .unicode => impl.toUnicode(allocator, input),
    };

    defer allocator.free(result);

    try std.testing.expectEqualStrings(expected, result);
}

fn checkRejected(allocator: std.mem.Allocator, mode: Mode, input: []const u8) !void {
    const result = (switch (mode) {
        .ascii => impl.toAscii(allocator, input),
        .unicode => impl.toUnicode(allocator, input),
    }) catch |err| {
        if (err == error.InvalidDomain or err == error.InvalidPunycode) return;

        return err;
    };

    defer allocator.free(result);

    return error.TestExpectedError;
}

test "IDNA mapped Unicode to ASCII releases every partial allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ Mode.ascii, @as([]const u8, "BÜCHER.Example"), @as([]const u8, "xn--bcher-kva.example") });
}

test "IDNA ACE to Unicode releases every partial allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ Mode.unicode, @as([]const u8, "xn--bcher-kva.example"), @as([]const u8, "bücher.example") });
}

test "IDNA deviation characters remain nontransitional" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ Mode.ascii, @as([]const u8, "FAẞ.de"), @as([]const u8, "xn--fa-hia.de") });
}

test "IDNA NFC composition and ACE generation release partial allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ Mode.ascii, @as([]const u8, "e\u{301}.example"), @as([]const u8, "xn--9ca.example") });
}

test "IDNA virama permits contextual joiner" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ Mode.unicode, @as([]const u8, "\u{915}\u{94d}\u{200d}\u{915}"), @as([]const u8, "\u{915}\u{94d}\u{200d}\u{915}") });
}

test "IDNA profile permits empty labels hyphens and nonSTD3 ASCII" {
    for ([_][]const u8{ "", ".", "a..b", "-a-", "ab--cd", "a_b" }) |input| {
        inline for (std.meta.tags(Mode)) |mode| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{ mode, input, input });
        }
    }
}

test "IDNA invalid UTF8 rejects without replacement in both directions" {
    for ([_][]const u8{ "\xff", "a\xed\xa0\x80", "\xc0\xaf", "\xe2\x82", "\xf4\x90\x80\x80" }) |input| {
        inline for (std.meta.tags(Mode)) |mode| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, checkRejected, .{ mode, input });
        }
    }
}

test "IDNA invalid contextual joiners release mapped prefix" {
    for ([_][]const u8{ "a\u{200c}", "a\u{200d}" }) |input| {
        inline for (std.meta.tags(Mode)) |mode| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, checkRejected, .{ mode, input });
        }
    }
}

test "IDNA Bidi and mixed numeric errors release all labels" {
    for ([_][]const u8{ "אa", "ا1١", "1.א" }) |input| {
        inline for (std.meta.tags(Mode)) |mode| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, checkRejected, .{ mode, input });
        }
    }
}

test "IDNA combining marks and invalid ACE release all temporaries" {
    for ([_][]const u8{ "\u{301}a", "xn--", "xn--a!" }) |input| {
        inline for (std.meta.tags(Mode)) |mode| {
            try std.testing.checkAllAllocationFailures(std.testing.allocator, checkRejected, .{ mode, input });
        }
    }
}
