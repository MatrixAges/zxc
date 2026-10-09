const std = @import("std");
const h = @import("native_keys/check.zig");
const f = h.f;
const Change = enum { clear, wrong, empty, specifier, alias, missing_specifier };

fn oneProvider(identified: bool, change: Change, valid: bool) !void {
    for (f.orders) |order| {
        var analysis = try f.analyze(order, identified);

        defer analysis.deinit();

        for (f.specifiers, 0..) |specifier, provider| {
            var item = try f.dependency(analysis, specifier);
            const key = if (identified) f.identities[provider] else specifier;

            try std.testing.expectEqualStrings(key, item.identity.?);

            switch (change) {
                .clear => item.identity = null,
                .wrong => item.identity = "missing@1",
                .empty => item.identity = "",
                .specifier => item.identity = specifier,
                .alias => item.specifier = "zig:unresolved",
                .missing_specifier => {
                    item.identity = null;
                    item.specifier = "zig:unresolved";
                },
            }

            const selected = try h.records.types(&analysis, &.{item});

            if (valid) try h.accepted(&analysis, selected, &.{key}) else try h.rejected(&analysis, selected);
        }
    }
}

test "real providers retain their native keys and function mappings in every import order" {
    for ([_]bool{ false, true }) |identified| {
        for (f.orders) |order| {
            var analysis = try f.analyze(order, identified);

            defer analysis.deinit();

            const selected = try f.index(analysis, "/project/main.zx");

            try h.accepted(&analysis, selected, if (identified) &f.identities else &f.specifiers);
        }
    }
}

test "null dependency identity falls back to the provider specifier" {
    try oneProvider(false, .clear, true);
}

test "null dependency identity does not match an identified provider by its specifier" {
    try oneProvider(true, .clear, false);
}

test "wrong identity cannot fall back to a matching unidentified provider specifier" {
    try oneProvider(false, .wrong, false);
}

test "wrong identity cannot fall back to a matching identified provider specifier" {
    try oneProvider(true, .wrong, false);
}

test "empty dependency identity is present and cannot fall back to a matching specifier" {
    try oneProvider(false, .empty, false);
    try oneProvider(true, .empty, false);
}

test "a provider specifier cannot replace its distinct declared identity" {
    try oneProvider(true, .specifier, false);
}

test "matching identity permits a distinct dependency specifier" {
    try oneProvider(false, .alias, true);
    try oneProvider(true, .alias, true);
}

test "missing fallback specifier is rejected without a dependency identity" {
    try oneProvider(false, .missing_specifier, false);
}
