const f = @import("fixture.zig");

fn single(external: f.ir.External, expected: bool) !void {
    var case = try f.Case.init();

    defer case.deinit();

    var function = case.nativeFunction();
    function.external = external;

    try case.functions(&.{function});
    try case.expectExport(0, expected);
}

test "native exports accept module zero and the absent export name fallback" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"} }, true);
}

test "native exports use the last member segment for fallback names" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{ "nested", "identity" } }, true);
}

test "native exports accept explicit names independent of member segments" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .export_name = "renamed" }, true);
}

test "native exports reject empty explicit names instead of falling back" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .export_name = "" }, false);
}

test "native exports reject a name that collides with a type binding" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .export_name = "Node" }, false);
}

test "native exports reject invalid UTF8 and NUL names" {
    for ([_][]const u8{ "\x80", "a\x00b", "\xed\xa0\x80" }) |name| {
        try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .export_name = name }, false);
    }
}

test "native exports reject an ordinary function at a valid row" {
    var case = try f.Case.init();

    defer case.deinit();

    var function = case.nativeFunction();
    function.external = null;

    try case.functions(&.{function});
    try case.expectExport(0, false);
}

test "native exports reject error declarations on an infallible function" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .errors = &.{"Missing"} }, false);
}

test "native exports accept a fallible function with an absent error set" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .fallible = true }, true);
}

test "native exports accept a fallible function with an explicit empty error set" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .fallible = true, .errors = &.{} }, true);
}

test "native exports accept distinct PascalCase error members" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .fallible = true, .errors = &.{ "Missing", "InvalidInput" } }, true);
}

test "native exports reject duplicate error members" {
    try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .fallible = true, .errors = &.{ "Missing", "Missing" } }, false);
}

test "native exports reject invalid error member names" {
    for ([_][]const u8{ "missing", "_Missing", "", "Bad\x00Name" }) |name| {
        try single(.{ .module = @fromBackingInt(0), .member = &.{"identity"}, .fallible = true, .errors = &.{name} }, false);
    }
}

const Difference = enum { none, input, output, fallible, concurrent, absent_errors, error_member, reordered_errors, name, owner, ordinary };

fn pair(difference: Difference, expected: bool) !void {
    var case = try f.Case.init();

    defer case.deinit();

    var first = case.nativeFunction();

    first.external.?.fallible = true;
    first.external.?.errors = &.{ "Missing", "InvalidInput" };

    var second = first;

    switch (difference) {
        .none => {},
        .input => second.input_type = @fromBackingInt(@backingInt(f.ir.Scalar.u64)),
        .output => second.output_type = @fromBackingInt(@backingInt(f.ir.Scalar.u64)),
        .fallible => {
            second.external.?.fallible = false;
            second.external.?.errors = null;
        },
        .concurrent => second.external.?.concurrent = true,
        .absent_errors => {
            first.external.?.errors = null;
            second.external.?.errors = &.{};
        },
        .error_member => second.external.?.errors = &.{ "Missing", "Other" },
        .reordered_errors => second.external.?.errors = &.{ "InvalidInput", "Missing" },
        .name => second.external.?.export_name = "other",
        .owner => {
            const original = case.program.native_modules.at(0);
            var other = original;
            other.identity = "other-owner";
            other.types = .{};

            try case.modules(&.{ original, other });

            second.external.?.module = @fromBackingInt(1);
        },
        .ordinary => first.external = null,
    }

    try case.functions(&.{ first, second });
    try case.expectExport(1, expected);
}

test "native exports accept identical repeated declarations" {
    try pair(.none, true);
}

test "native exports reject mismatched input types for one logical export" {
    try pair(.input, false);
}

test "native exports reject mismatched output types for one logical export" {
    try pair(.output, false);
}

test "native exports reject mismatched fallibility for one logical export" {
    try pair(.fallible, false);
}

test "native exports reject mismatched concurrency for one logical export" {
    try pair(.concurrent, false);
}

test "native exports distinguish absent and explicit empty error sets" {
    try pair(.absent_errors, false);
}

test "native exports reject different error members for one logical export" {
    try pair(.error_member, false);
}

test "native exports accept error sets in a different declaration order" {
    try pair(.reordered_errors, true);
}

test "native exports separate different names under one owner" {
    try pair(.name, true);
}

test "native exports separate the same name under different owners" {
    try pair(.owner, true);
}

test "native exports ignore earlier ordinary functions" {
    try pair(.ordinary, true);
}
