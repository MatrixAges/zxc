const ir = @import("../ir.zig");
const model = @import("model.zig");
const views = @import("views.zig");

pub const Block = struct {
    control: *const model.Table,
    first: usize,
    len: usize,
    pub fn prefix(self: Block, count: usize) Block {
        @import("std").debug.assert(count <= self.len);

        var result = self;
        result.len = count;

        return result;
    }
    pub fn at(self: Block, index: usize) Statement {
        const first = self.first;
        const kind = self.control.statement_kinds[first..][0..self.len][index];
        const payload = self.control.statement_payloads[first..][0..self.len][index];

        return statement(self.control, kind, payload);
    }
};

pub const Statement = union(enum) {
    evaluate: ir.ExprId,
    constant: @FieldType(ir.Statement, "constant"),
    parallel: views.Invocations,
    destructure: struct { symbols: views.Symbols, value: ir.ExprId },
    branch: struct { condition: ir.ExprId, yes: Block, no: Block },
    switch_stmt: struct { subject: ir.ExprId, cases: views.Cases, exhaustive: bool },
    store_set: @FieldType(ir.Statement, "store_set"),
    result: ?ir.ExprId,
};

pub fn block(control: *const model.Table, root: ir.BlockId) Block {
    const index = @backingInt(root);

    return .{ .control = control, .first = control.block_first[index], .len = control.block_count[index] };
}

fn statement(control: *const model.Table, kind: model.Kind, payload: u32) Statement {
    return switch (kind) {
        .Evaluate => .{ .evaluate = @fromBackingInt(control.evaluations[payload]) },
        .Constant => .{ .constant = .{ .symbol = @fromBackingInt(control.constant_symbols[payload]), .value = @fromBackingInt(control.constant_values[payload]) } },
        .Parallel => blk: {
            const first = control.parallel_first[payload];
            const count = control.parallel_count[payload];

            break :blk .{ .parallel = .{ .symbols = control.parallel_symbols[first..][0..count], .values = control.parallel_values[first..][0..count], .len = count } };
        },
        .Destructure => blk: {
            const first = control.destructure_first[payload];
            const count = control.destructure_count[payload];

            break :blk .{ .destructure = .{ .symbols = .{ .values = control.destructure_symbols[first..][0..count], .len = count }, .value = @fromBackingInt(control.destructure_values[payload]) } };
        },
        .Branch => .{ .branch = .{ .condition = @fromBackingInt(control.branch_conditions[payload]), .yes = block(control, @fromBackingInt(control.branch_yes[payload])), .no = block(control, @fromBackingInt(control.branch_no[payload])) } },
        .Switch => blk: {
            const first = control.selection_first[payload];
            const count = control.selection_count[payload];

            break :blk .{ .switch_stmt = .{ .subject = @fromBackingInt(control.selection_subjects[payload]), .cases = .{ .control = control, .values = control.case_values[first..][0..count], .bodies = control.case_bodies[first..][0..count], .len = count }, .exhaustive = control.selection_exhaustive[payload] } };
        },
        .StoreSet => .{ .store_set = .{ .slot = control.setter_slots[payload], .value = @fromBackingInt(control.setter_values[payload]) } },
        .Result => .{ .result = if (control.results[payload]) |id| @fromBackingInt(id) else null },
    };
}
