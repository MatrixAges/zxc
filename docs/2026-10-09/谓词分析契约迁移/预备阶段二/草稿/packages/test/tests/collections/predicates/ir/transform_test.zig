const std = @import("std");
const zx = @import("zx");
const f = @import("fixture.zig");
const Mutation = enum { unexpected_initial, missing_initial, wrong_body, wrong_target, forward_body };

fn reject(mutation: Mutation) !void {
    for ([_]@FieldType(f.ir.Transform, "kind"){ .every, .some }) |kind| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var value = try f.program(arena.allocator(), kind, mutation == .missing_initial);

        try f.valid(value);

        const bodies = try arena.allocator().dupe(u32, value.expressions.transform_bodies);
        const initials = try arena.allocator().dupe(?u32, value.expressions.transform_initials);
        const targets = try arena.allocator().dupe(u32, value.expressions.transform_targets);

        value.expressions.transform_bodies = bodies;
        value.expressions.transform_initials = initials;
        value.expressions.transform_targets = targets;

        switch (mutation) {
            .unexpected_initial => initials[0] = 2,
            .missing_initial => initials[0] = null,
            .wrong_body => bodies[0] = 0,
            .wrong_target => targets[0] = 1,
            .forward_body => bodies[0] = 3,
        }

        try f.invalid(value);
    }
}

test "legacy predicates retain copy bool results without container effects" {
    for ([_]@FieldType(f.ir.Transform, "kind"){ .every, .some }) |kind| {
        for ([_]bool{ false, true }) |context| {
            var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

            defer arena.deinit();

            const value = try f.program(arena.allocator(), kind, context);

            try f.valid(value);

            const effects = (try zx.error_effects.program(std.testing.allocator, value)).?;

            defer std.testing.allocator.free(effects);

            try std.testing.expectEqual(@as(usize, 0), effects.len);
        }
    }
}

test "legacy predicates reject an initial without a context parameter" {
    try reject(.unexpected_initial);
}

test "legacy predicates reject a context parameter without an initial" {
    try reject(.missing_initial);
}

test "legacy predicates reject non bool callback bodies" {
    try reject(.wrong_body);
}

test "legacy predicates reject non list targets" {
    try reject(.wrong_target);
}

test "legacy predicates reject self referencing callback bodies" {
    try reject(.forward_body);
}
