const std = @import("std");
const f = @import("fixture.zig");

test "compiled import rejects missing library input" {
    try f.reject(&.{f.package("sample", "call")}, &.{}, "compiled library is missing from the input set");
}

test "compiled import rejects artifact mismatch for selected instance" {
    var value = try f.library();
    defer value.deinit();
    var library = f.dependency(&value);
    library.artifact = "other.zxlib";

    try f.reject(&.{f.package("sample", "call")}, &.{library}, "compiled package instance has conflicting artifacts");
}

test "compiled import rejects duplicate instance registration" {
    var value = try f.library();
    defer value.deinit();
    const library = f.dependency(&value);

    try f.reject(&.{f.package("sample", "call")}, &.{ library, library }, "compiled package instance has conflicting artifacts");
}

test "compiled import requires selected public name instead of source path" {
    var value = try f.library();
    defer value.deinit();

    try f.reject(&.{f.package("sample", "/library/run.zx")}, &.{f.dependency(&value)}, "compiled library does not export this public module");
}

test "compiled type only module cannot be default callable import" {
    var value = try f.library();
    defer value.deinit();

    try f.reject(&.{f.package("sample", "types")}, &.{f.dependency(&value)}, "default imports must refer to an executable module");
}

test "compiled import rejects invalid public table" {
    var value = try f.library();
    defer value.deinit();
    var library = f.dependency(&value);
    library.exports = &.{};

    try f.reject(&.{f.package("sample", "call")}, &.{library}, "compiled library has invalid IR or conflicting identities");
}

test "compiled target cannot also select source entry" {
    var target = f.package("sample", "call");
    target.entry = "fallback.zx";

    try f.reject(&.{target}, &.{}, "compiled package target must identify one instance, artifact and public module");
}

test "compiled import rejects duplicate package specifiers" {
    const target = f.package("sample", "call");

    try f.reject(&.{ target, target }, &.{}, "duplicate ZX package specifier");
}

test "compiled named imports require actual public exported types" {
    var value = try f.library();
    defer value.deinit();
    var result = try f.analyze("import type { Missing } from \"sample\"\nexport type Value = Missing\n", &.{f.package("sample", "types")}, &.{f.dependency(&value)});
    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.module, result.value.diagnostic.code);
    try std.testing.expectEqualStrings("the imported name is not exported by the module", result.value.diagnostic.message);
}
