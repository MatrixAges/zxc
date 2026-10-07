const std = @import("std");
const model = @import("model.zig");
const ir = @import("../ir.zig");
const Storage = @import("storage.zig");

pub fn block(self: *Storage, allocator: std.mem.Allocator, values: []const ir.Statement) std.mem.Allocator.Error!ir.BlockId {
    try @import("reserve.zig").block(self, allocator, values);

    const id: u32 = @intCast(self.block_first.items.len);
    const first: u32 = @intCast(self.statement_kinds.items.len);

    for (values) |value| {
        const row: struct { model.Kind, usize } = switch (value) {
            .evaluate => |item| blk: {
                const payload = self.evaluations.items.len;

                self.evaluations.appendAssumeCapacity(@backingInt(item));

                break :blk .{ .Evaluate, payload };
            },
            .constant => |item| blk: {
                const payload = self.constant_values.items.len;

                self.constant_symbols.appendAssumeCapacity(@backingInt(item.symbol));
                self.constant_values.appendAssumeCapacity(@backingInt(item.value));

                break :blk .{ .Constant, payload };
            },
            .parallel => |items| blk: {
                const payload = self.parallel_first.items.len;

                self.parallel_first.appendAssumeCapacity(@intCast(self.parallel_values.items.len));
                self.parallel_count.appendAssumeCapacity(@intCast(items.len));

                for (items) |item| {
                    self.parallel_symbols.appendAssumeCapacity(if (item.symbol) |symbol| @backingInt(symbol) else null);
                    self.parallel_values.appendAssumeCapacity(@backingInt(item.value));
                }

                break :blk .{ .Parallel, payload };
            },
            .destructure => |item| blk: {
                const payload = self.destructure_values.items.len;

                self.destructure_values.appendAssumeCapacity(@backingInt(item.value));
                self.destructure_first.appendAssumeCapacity(@intCast(self.destructure_symbols.items.len));
                self.destructure_count.appendAssumeCapacity(@intCast(item.symbols.len));
                for (item.symbols) |symbol| self.destructure_symbols.appendAssumeCapacity(if (symbol) |symbol_id| @backingInt(symbol_id) else null);

                break :blk .{ .Destructure, payload };
            },
            .branch => |item| blk: {
                const payload = self.branch_conditions.items.len;

                self.branch_conditions.appendAssumeCapacity(@backingInt(item.condition));
                self.branch_yes.appendAssumeCapacity(@backingInt(item.yes));
                self.branch_no.appendAssumeCapacity(@backingInt(item.no));

                break :blk .{ .Branch, payload };
            },
            .switch_stmt => |item| blk: {
                const payload = self.selection_subjects.items.len;

                self.selection_subjects.appendAssumeCapacity(@backingInt(item.subject));
                self.selection_first.appendAssumeCapacity(@intCast(self.case_bodies.items.len));
                self.selection_count.appendAssumeCapacity(@intCast(item.cases.len));
                self.selection_exhaustive.appendAssumeCapacity(item.exhaustive);

                for (item.cases) |case| {
                    self.case_values.appendAssumeCapacity(if (case.value) |expression| @backingInt(expression) else null);
                    self.case_bodies.appendAssumeCapacity(@backingInt(case.body));
                }

                break :blk .{ .Switch, payload };
            },
            .store_set => |item| blk: {
                const payload = self.setter_values.items.len;

                self.setter_slots.appendAssumeCapacity(item.slot);
                self.setter_values.appendAssumeCapacity(@backingInt(item.value));

                break :blk .{ .StoreSet, payload };
            },
            .result => |item| blk: {
                const payload = self.results.items.len;

                self.results.appendAssumeCapacity(if (item) |expression| @backingInt(expression) else null);

                break :blk .{ .Result, payload };
            },
        };

        self.statement_kinds.appendAssumeCapacity(row[0]);
        self.statement_payloads.appendAssumeCapacity(@intCast(row[1]));
    }

    self.block_first.appendAssumeCapacity(first);
    self.block_count.appendAssumeCapacity(@intCast(values.len));

    return @fromBackingInt(id);
}
