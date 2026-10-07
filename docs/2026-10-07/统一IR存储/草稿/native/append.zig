const std = @import("std");
const model = @import("model.zig");
const Storage = @import("storage.zig");

pub fn block(self: *Storage, allocator: std.mem.Allocator, values: []const model.Statement) Storage.Error!u32 {
    const borrowed_symbols = self.destructure_symbols.items;

    try @import("reserve.zig").block(self, allocator, values);

    const id: u32 = @intCast(self.block_first.items.len);
    const first: u32 = @intCast(self.statement_kinds.items.len);

    for (values) |value| {
        const row: struct { model.Kind, usize } = switch (value) {
            .evaluate => |item| blk: {
                const payload = self.evaluations.items.len;

                self.evaluations.appendAssumeCapacity(item);

                break :blk .{ .Evaluate, payload };
            },
            .constant => |item| blk: {
                const payload = self.constant_values.items.len;

                self.constant_symbols.appendAssumeCapacity(item.symbol);
                self.constant_values.appendAssumeCapacity(item.value);

                break :blk .{ .Constant, payload };
            },
            .parallel => |items| blk: {
                const payload = self.parallel_first.items.len;

                self.parallel_first.appendAssumeCapacity(@intCast(self.parallel_values.items.len));
                self.parallel_count.appendAssumeCapacity(@intCast(items.len));

                for (items) |item| {
                    self.parallel_symbols.appendAssumeCapacity(item.symbol);
                    self.parallel_values.appendAssumeCapacity(item.value);
                }

                break :blk .{ .Parallel, payload };
            },
            .destructure => |item| blk: {
                const payload = self.destructure_values.items.len;

                self.destructure_values.appendAssumeCapacity(item.value);
                self.destructure_first.appendAssumeCapacity(@intCast(self.destructure_symbols.items.len));
                self.destructure_count.appendAssumeCapacity(@intCast(item.symbols.len));

                const symbols = retainedSymbols(borrowed_symbols, self.destructure_symbols.items, item.symbols);

                self.destructure_symbols.appendSliceAssumeCapacity(symbols);

                break :blk .{ .Destructure, payload };
            },
            .branch => |item| blk: {
                const payload = self.branch_conditions.items.len;

                self.branch_conditions.appendAssumeCapacity(item.condition);
                self.branch_yes.appendAssumeCapacity(item.yes);
                self.branch_no.appendAssumeCapacity(item.no);

                break :blk .{ .Branch, payload };
            },
            .selection => |item| blk: {
                const payload = self.selection_subjects.items.len;

                self.selection_subjects.appendAssumeCapacity(item.subject);
                self.selection_first.appendAssumeCapacity(@intCast(self.case_bodies.items.len));
                self.selection_count.appendAssumeCapacity(@intCast(item.cases.len));
                self.selection_exhaustive.appendAssumeCapacity(item.exhaustive);

                for (item.cases) |case| {
                    self.case_values.appendAssumeCapacity(case.value);
                    self.case_bodies.appendAssumeCapacity(case.body);
                }

                break :blk .{ .Switch, payload };
            },
            .store_set => |item| blk: {
                const payload = self.setter_values.items.len;

                self.setter_slots.appendAssumeCapacity(item.slot);
                self.setter_values.appendAssumeCapacity(item.value);

                break :blk .{ .StoreSet, payload };
            },
            .result => |item| blk: {
                const payload = self.results.items.len;

                self.results.appendAssumeCapacity(item);

                break :blk .{ .Result, payload };
            },
        };

        self.statement_kinds.appendAssumeCapacity(row[0]);
        self.statement_payloads.appendAssumeCapacity(@intCast(row[1]));
    }

    self.block_first.appendAssumeCapacity(first);
    self.block_count.appendAssumeCapacity(@intCast(values.len));

    return id;
}

fn retainedSymbols(previous: []const ?u32, current: []const ?u32, values: []const ?u32) []const ?u32 {
    if (values.len == 0) return values;

    const start = @intFromPtr(previous.ptr);
    const pointer = @intFromPtr(values.ptr);

    if (pointer < start or (pointer - start) % @sizeOf(?u32) != 0) return values;

    const first = (pointer - start) / @sizeOf(?u32);

    if (first > previous.len or values.len > previous.len - first) return values;

    return current[first..][0..values.len];
}
