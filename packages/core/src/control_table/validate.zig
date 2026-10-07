const std = @import("std");
const Table = @import("model.zig").Table;

pub fn structure(table: Table) bool {
    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        if (@field(table, name).len > std.math.maxInt(u32)) return false;
    }

    if (table.statement_kinds.len != table.statement_payloads.len) return false;
    if (table.constant_values.len != table.constant_symbols.len) return false;
    if (table.parallel_first.len != table.parallel_count.len) return false;
    if (table.parallel_values.len != table.parallel_symbols.len) return false;
    if (table.destructure_values.len != table.destructure_first.len or table.destructure_values.len != table.destructure_count.len) return false;
    if (table.branch_conditions.len != table.branch_yes.len or table.branch_conditions.len != table.branch_no.len) return false;
    if (table.selection_subjects.len != table.selection_first.len or table.selection_subjects.len != table.selection_count.len or table.selection_subjects.len != table.selection_exhaustive.len) return false;
    if (table.case_values.len != table.case_bodies.len) return false;
    if (table.setter_slots.len != table.setter_values.len) return false;
    if (table.block_first.len != table.block_count.len) return false;
    if (!segments(table.parallel_first, table.parallel_count, table.parallel_values.len)) return false;
    if (!segments(table.destructure_first, table.destructure_count, table.destructure_symbols.len)) return false;
    if (!segments(table.selection_first, table.selection_count, table.case_bodies.len)) return false;
    if (!segments(table.block_first, table.block_count, table.statement_kinds.len)) return false;

    const lengths = [_]usize{ table.evaluations.len, table.constant_values.len, table.parallel_first.len, table.destructure_values.len, table.branch_conditions.len, table.selection_subjects.len, table.setter_values.len, table.results.len };
    var counts: [lengths.len]usize = @splat(0);

    for (table.statement_kinds, table.statement_payloads) |kind, payload| {
        const index = @backingInt(kind);

        if (payload != counts[index] or payload >= lengths[index]) return false;

        counts[index] += 1;
    }

    if (!std.mem.eql(usize, &counts, &lengths)) return false;

    for (table.block_first, table.block_count, 0..) |first, count, block| {
        for (table.statement_kinds[first..][0..count], table.statement_payloads[first..][0..count]) |kind, payload| switch (kind) {
            .Branch => {
                if (table.branch_yes[payload] >= block or table.branch_no[payload] >= block) return false;
            },
            .Switch => {
                const start = table.selection_first[payload];
                const size = table.selection_count[payload];

                for (table.case_bodies[start..][0..size]) |child| if (child >= block) return false;
            },
            else => {},
        };
    }

    return true;
}

fn segments(first: []const u32, count: []const u32, length: usize) bool {
    var next: usize = 0;

    for (first, count) |start, size| {
        if (start != next or size > length - next) return false;

        next += size;
    }

    return next == length;
}
