const std = @import("std");
const fixture = @import("fixture.zig");

test "Punycode boundary encode empty" {
    try fixture.checkEncode(std.testing.allocator, &.{}, "");
}

test "Punycode boundary decode empty" {
    try fixture.checkDecode(std.testing.allocator, "", &.{});
}

test "Punycode boundary encode basic ASCII case" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x41, 0x42, 0x43, 0x78, 0x79, 0x7a }, "ABCxyz-");
}

test "Punycode boundary decode basic ASCII case" {
    try fixture.checkDecode(std.testing.allocator, "ABCxyz-", &.{ 0x41, 0x42, 0x43, 0x78, 0x79, 0x7a });
}

test "Punycode boundary encode basic punctuation" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x61, 0x2d, 0x62, 0x5f, 0x63, 0x2e, 0x20, 0x2f }, "a-b_c. /-");
}

test "Punycode boundary decode basic punctuation" {
    try fixture.checkDecode(std.testing.allocator, "a-b_c. /-", &.{ 0x61, 0x2d, 0x62, 0x5f, 0x63, 0x2e, 0x20, 0x2f });
}

test "Punycode boundary encode C0 DEL" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x0, 0x1f, 0x7f }, "\x00\x1f\x7f-");
}

test "Punycode boundary decode C0 DEL" {
    try fixture.checkDecode(std.testing.allocator, "\x00\x1f\x7f-", &.{ 0x0, 0x1f, 0x7f });
}

test "Punycode boundary encode minimum nonbasic" {
    try fixture.checkEncode(std.testing.allocator, &.{0x80}, "a");
}

test "Punycode boundary decode minimum nonbasic" {
    try fixture.checkDecode(std.testing.allocator, "a", &.{0x80});
}

test "Punycode boundary encode next nonbasic" {
    try fixture.checkEncode(std.testing.allocator, &.{0x81}, "ba");
}

test "Punycode boundary decode next nonbasic" {
    try fixture.checkDecode(std.testing.allocator, "ba", &.{0x81});
}

test "Punycode boundary encode before surrogate range" {
    try fixture.checkEncode(std.testing.allocator, &.{0xd7ff}, "hb9b");
}

test "Punycode boundary decode before surrogate range" {
    try fixture.checkDecode(std.testing.allocator, "hb9b", &.{0xd7ff});
}

test "Punycode boundary encode after surrogate range" {
    try fixture.checkEncode(std.testing.allocator, &.{0xe000}, "0y0c");
}

test "Punycode boundary decode after surrogate range" {
    try fixture.checkDecode(std.testing.allocator, "0y0c", &.{0xe000});
}

test "Punycode boundary encode noncharacter" {
    try fixture.checkEncode(std.testing.allocator, &.{0xffff}, "1n7c");
}

test "Punycode boundary decode noncharacter" {
    try fixture.checkDecode(std.testing.allocator, "1n7c", &.{0xffff});
}

test "Punycode boundary encode supplementary start" {
    try fixture.checkEncode(std.testing.allocator, &.{0x10000}, "2n7c");
}

test "Punycode boundary decode supplementary start" {
    try fixture.checkDecode(std.testing.allocator, "2n7c", &.{0x10000});
}

test "Punycode boundary encode Unicode maximum" {
    try fixture.checkEncode(std.testing.allocator, &.{0x10ffff}, "dn32g");
}

test "Punycode boundary decode Unicode maximum" {
    try fixture.checkDecode(std.testing.allocator, "dn32g", &.{0x10ffff});
}

test "Punycode boundary encode wide mixed repeated" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x10ffff, 0x80, 0x10ffff, 0x80, 0x61 }, "a-aa440765bba");
}

test "Punycode boundary decode wide mixed repeated" {
    try fixture.checkDecode(std.testing.allocator, "a-aa440765bba", &.{ 0x10ffff, 0x80, 0x10ffff, 0x80, 0x61 });
}

test "Punycode boundary encode composed" {
    try fixture.checkEncode(std.testing.allocator, &.{0xe9}, "9ca");
}

test "Punycode boundary decode composed" {
    try fixture.checkDecode(std.testing.allocator, "9ca", &.{0xe9});
}

test "Punycode boundary encode decomposed" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x65, 0x301 }, "e-xbb");
}

test "Punycode boundary decode decomposed" {
    try fixture.checkDecode(std.testing.allocator, "e-xbb", &.{ 0x65, 0x301 });
}

test "Punycode boundary encode bucher" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x62, 0xfc, 0x63, 0x68, 0x65, 0x72 }, "bcher-kva");
}

test "Punycode boundary decode bucher" {
    try fixture.checkDecode(std.testing.allocator, "bcher-kva", &.{ 0x62, 0xfc, 0x63, 0x68, 0x65, 0x72 });
}

test "Punycode boundary encode manana" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x6d, 0x61, 0xf1, 0x61, 0x6e, 0x61 }, "maana-pta");
}

test "Punycode boundary decode manana" {
    try fixture.checkDecode(std.testing.allocator, "maana-pta", &.{ 0x6d, 0x61, 0xf1, 0x61, 0x6e, 0x61 });
}

test "Punycode boundary encode duplicate emoji" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600 }, "e28haaaaaaaaaaa");
}

test "Punycode boundary decode duplicate emoji" {
    try fixture.checkDecode(std.testing.allocator, "e28haaaaaaaaaaa", &.{ 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600, 0x1f600 });
}

test "Punycode boundary encode last delimiter" {
    try fixture.checkEncode(std.testing.allocator, &.{ 0x61, 0x2d, 0x2d, 0xe9, 0x2d, 0x2d }, "a-----dsa");
}

test "Punycode boundary decode last delimiter" {
    try fixture.checkDecode(std.testing.allocator, "a-----dsa", &.{ 0x61, 0x2d, 0x2d, 0xe9, 0x2d, 0x2d });
}
