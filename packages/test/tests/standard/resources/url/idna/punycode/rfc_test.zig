const std = @import("std");
const fixture = @import("fixture.zig");
const cases = @import("rfc_cases.zig").cases;

test "RFC3492 A encode" {
    try fixture.checkEncode(std.testing.allocator, cases[0].points, cases[0].encoded);
}

test "RFC3492 A decode" {
    try fixture.checkDecode(std.testing.allocator, cases[0].original, cases[0].points);
}

test "RFC3492 B encode" {
    try fixture.checkEncode(std.testing.allocator, cases[1].points, cases[1].encoded);
}

test "RFC3492 B decode" {
    try fixture.checkDecode(std.testing.allocator, cases[1].original, cases[1].points);
}

test "RFC3492 C encode" {
    try fixture.checkEncode(std.testing.allocator, cases[2].points, cases[2].encoded);
}

test "RFC3492 C decode" {
    try fixture.checkDecode(std.testing.allocator, cases[2].original, cases[2].points);
}

test "RFC3492 D encode" {
    try fixture.checkEncode(std.testing.allocator, cases[3].points, cases[3].encoded);
}

test "RFC3492 D decode" {
    try fixture.checkDecode(std.testing.allocator, cases[3].original, cases[3].points);
}

test "RFC3492 E encode" {
    try fixture.checkEncode(std.testing.allocator, cases[4].points, cases[4].encoded);
}

test "RFC3492 E decode" {
    try fixture.checkDecode(std.testing.allocator, cases[4].original, cases[4].points);
}

test "RFC3492 F encode" {
    try fixture.checkEncode(std.testing.allocator, cases[5].points, cases[5].encoded);
}

test "RFC3492 F decode" {
    try fixture.checkDecode(std.testing.allocator, cases[5].original, cases[5].points);
}

test "RFC3492 G encode" {
    try fixture.checkEncode(std.testing.allocator, cases[6].points, cases[6].encoded);
}

test "RFC3492 G decode" {
    try fixture.checkDecode(std.testing.allocator, cases[6].original, cases[6].points);
}

test "RFC3492 H encode" {
    try fixture.checkEncode(std.testing.allocator, cases[7].points, cases[7].encoded);
}

test "RFC3492 H decode" {
    try fixture.checkDecode(std.testing.allocator, cases[7].original, cases[7].points);
}

test "RFC3492 I encode" {
    try fixture.checkEncode(std.testing.allocator, cases[8].points, cases[8].encoded);
}

test "RFC3492 I decode" {
    try fixture.checkDecode(std.testing.allocator, cases[8].original, cases[8].points);
}

test "RFC3492 J encode" {
    try fixture.checkEncode(std.testing.allocator, cases[9].points, cases[9].encoded);
}

test "RFC3492 J decode" {
    try fixture.checkDecode(std.testing.allocator, cases[9].original, cases[9].points);
}

test "RFC3492 K encode" {
    try fixture.checkEncode(std.testing.allocator, cases[10].points, cases[10].encoded);
}

test "RFC3492 K decode" {
    try fixture.checkDecode(std.testing.allocator, cases[10].original, cases[10].points);
}

test "RFC3492 L encode" {
    try fixture.checkEncode(std.testing.allocator, cases[11].points, cases[11].encoded);
}

test "RFC3492 L decode" {
    try fixture.checkDecode(std.testing.allocator, cases[11].original, cases[11].points);
}

test "RFC3492 M encode" {
    try fixture.checkEncode(std.testing.allocator, cases[12].points, cases[12].encoded);
}

test "RFC3492 M decode" {
    try fixture.checkDecode(std.testing.allocator, cases[12].original, cases[12].points);
}

test "RFC3492 N encode" {
    try fixture.checkEncode(std.testing.allocator, cases[13].points, cases[13].encoded);
}

test "RFC3492 N decode" {
    try fixture.checkDecode(std.testing.allocator, cases[13].original, cases[13].points);
}

test "RFC3492 O encode" {
    try fixture.checkEncode(std.testing.allocator, cases[14].points, cases[14].encoded);
}

test "RFC3492 O decode" {
    try fixture.checkDecode(std.testing.allocator, cases[14].original, cases[14].points);
}

test "RFC3492 P encode" {
    try fixture.checkEncode(std.testing.allocator, cases[15].points, cases[15].encoded);
}

test "RFC3492 P decode" {
    try fixture.checkDecode(std.testing.allocator, cases[15].original, cases[15].points);
}

test "RFC3492 Q encode" {
    try fixture.checkEncode(std.testing.allocator, cases[16].points, cases[16].encoded);
}

test "RFC3492 Q decode" {
    try fixture.checkDecode(std.testing.allocator, cases[16].original, cases[16].points);
}

test "RFC3492 R encode" {
    try fixture.checkEncode(std.testing.allocator, cases[17].points, cases[17].encoded);
}

test "RFC3492 R decode" {
    try fixture.checkDecode(std.testing.allocator, cases[17].original, cases[17].points);
}

test "RFC3492 S encode" {
    try fixture.checkEncode(std.testing.allocator, cases[18].points, cases[18].encoded);
}

test "RFC3492 S decode" {
    try fixture.checkDecode(std.testing.allocator, cases[18].original, cases[18].points);
}
