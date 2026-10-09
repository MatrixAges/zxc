const std = @import("std");
const check = @import("check.zig");
const feedback = @import("feedback.zig");
const h = @import("ownership_case");
const initial = "    const fresh: u64[] = []\n\n    const initial = {fresh: fresh, view: in}\n\n";
const reduce = "    const result = in.reduce((state, item) => {fresh: state.fresh.push(item)[0], view: state.view}, initial)\n\n";

test "feedback reaches borrowed provenance through multiple field transfers" {
    for ([_]usize{ 2, 5, 17 }) |fields| {
        const source = try feedback.source(std.testing.allocator, fields, "v0");

        defer std.testing.allocator.free(source);

        var result = try check.analyze(std.testing.allocator, source, .borrowed);

        defer result.deinit();
    }
}

test "feedback preserves untouched owned field beside propagated borrowed fields" {
    for ([_]usize{ 2, 5, 17 }) |fields| {
        const source = try feedback.source(std.testing.allocator, fields, "untouched");

        defer std.testing.allocator.free(source);

        var result = try check.analyze(std.testing.allocator, source, .owned);

        defer result.deinit();
    }
}

test "reduce mixed accumulator preserves owned field including empty source" {
    try h.run(.{ .body = initial ++ reduce ++ "    return result.fresh" });
}

test "reduce mixed accumulator preserves borrowed sibling" {
    try h.run(.{ .body = initial ++ reduce ++ "    return result.view", .ownership = "borrowed" });
}

test "reduce callback copies cannot erase the borrowed zero callback initial path" {
    try h.run(.{ .ownership = "borrowed", .body =
        \\    const initial = {fresh: in, view: in}
        \\
        \\    const result = in.reduce((state, item) => {fresh: state.fresh.map(value => value), view: state.view}, initial)
        \\
        \\    return result.fresh
    });
}

test "precondition loop retains borrowed zero step projection" {
    try h.run(.{ .ownership = "borrowed", .body =
        \\    const result = loop({fresh: in, view: in, index: 0}, {
        \\        while: state => state.index < state.view.length,
        \\        next: state => {
        \\            state.fresh = state.fresh.map(value => value)
        \\            state.index += 1
        \\        }
        \\    })
        \\
        \\    return result.fresh
    });
}

test "postcondition loop replaces borrowed projection before every exit" {
    try h.run(.{ .body =
        \\    const result = loop({fresh: in, view: in, index: 0}, {
        \\        while: state => state.index < state.view.length,
        \\        do: state => {
        \\            state.fresh = state.fresh.map(value => value)
        \\            state.index += 1
        \\        }
        \\    })
        \\
        \\    return result.fresh
    });
}
