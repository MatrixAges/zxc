const std = @import("std");
const ir = @import("zx").ir;
const read = @import("control_read.zig");

pub fn equal(source: []const ir.Statement, view: read.Block) bool {
    if (source.len != view.len) return false;

    for (source, 0..) |before, index| {
        const after = view.at(index);

        if (!std.mem.eql(u8, @tagName(before), @tagName(after))) return false;

        switch (before) {
            .parallel => |items| {
                if (items.len != after.parallel.len) return false;

                for (items, 0..) |item, position| {
                    if (!std.meta.eql(item, after.parallel.at(position))) return false;
                }
            },
            .destructure => |item| {
                if (item.value != after.destructure.value or item.symbols.len != after.destructure.symbols.len) return false;

                for (item.symbols, 0..) |symbol, position| {
                    if (symbol != after.destructure.symbols.at(position)) return false;
                }
            },
            .branch => |item| {
                if (item.condition != after.branch.condition or !equal(item.yes, after.branch.yes) or !equal(item.no, after.branch.no)) return false;
            },
            .switch_stmt => |item| {
                if (item.subject != after.switch_stmt.subject or item.exhaustive != after.switch_stmt.exhaustive or item.cases.len != after.switch_stmt.cases.len) return false;

                for (item.cases, 0..) |arm, position| {
                    const restored = after.switch_stmt.cases.at(position);

                    if (arm.value != restored.value or !equal(arm.body, restored.body)) return false;
                }
            },
            inline else => |item, tag| {
                if (!std.meta.eql(item, @field(after, @tagName(tag)))) return false;
            },
        }
    }

    return true;
}
