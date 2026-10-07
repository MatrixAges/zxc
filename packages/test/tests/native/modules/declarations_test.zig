const f = @import("fixture.zig");

fn specifiers(values: []const []const u8, expected: bool) !void {
    var case = try f.Case.init();

    defer case.deinit();

    for (values) |value| {
        var module = case.program.native_modules.at(0);

        module.specifier = value;
        module.identity = "stable-owner";

        try case.modules(&.{module});
        try case.expectModules(expected);
    }
}

test "native module declarations accept all supported native specifier families" {
    try specifiers(&.{ "zig:host", "c:host", "std:host", "lib:host" }, true);
}

test "native module declarations reject file and package specifiers" {
    try specifiers(&.{ "./host", "../host", "@/host", "host", "pkg/host" }, false);
}

test "native module declarations reject malformed native specifiers" {
    try specifiers(&.{ "", "zig:", "unknown:host", "zig:host:part", "zig:two words", "zig:a\x00b", "zig:a\\b" }, false);
}

test "native module declarations retain absent identity as the specifier key" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);
    module.identity = null;

    try case.modules(&.{module});
    try case.expectModules(true);
}

test "native module declarations reject empty identity instead of falling back" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);
    module.identity = "";

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native module declarations reject invalid UTF8 empty and NUL text in every metadata field" {
    const invalid = [_][]const u8{ "", "\x00", "a\x00b", "\x80", "\xc0\xaf", "\xc2", "\xe0\x80\x80", "\xed\xa0\x80", "\xf0\x80\x80\x80", "\xf4\x90\x80\x80", "\xf5\x80\x80\x80", "\xf0\x90\x80" };
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);

    for (invalid) |value| {
        for (0..4) |field| {
            var module = original;

            switch (field) {
                0 => module.import_name = value,
                1 => module.identity = value,
                2 => module.type_namespace = &.{value},
                3 => module.types.names = &.{value},
                else => unreachable,
            }

            try case.modules(&.{module});
            try case.expectModules(false);
        }
    }
}

test "native module declarations accept UTF8 scalar boundaries without decoding copies" {
    const valid = [_][]const u8{ "ascii", "\xc2\x80", "\xdf\xbf", "\xe0\xa0\x80", "\xed\x9f\xbf", "\xef\xbf\xbf", "\xf0\x90\x80\x80", "\xf4\x8f\xbf\xbf" };
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);

    for (valid) |value| {
        var module = original;
        module.import_name = value;
        module.identity = value;
        module.type_namespace = &.{ value, "Nested" };

        try case.modules(&.{module});
        try case.expectModules(true);
    }
}

test "native module declarations reject the same import alias under one owner" {
    var case = try f.Case.init();

    defer case.deinit();

    const module = case.program.native_modules.at(0);

    try case.modules(&.{ module, module });
    try case.expectModules(false);
}

test "native module declarations permit the same alias under different owners" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    var other = original;
    other.identity = "other-owner";
    other.types = .{};

    try case.modules(&.{ original, other });
    try case.expectModules(true);
}
