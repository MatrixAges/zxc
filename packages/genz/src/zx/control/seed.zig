const ir = @import("zx").ir;

pub fn writes(values: ir.Block) bool {
    for (0..values.len) |value_index| {
        const value = values.at(value_index);

        switch (value) {
            .store_set => return true,
            .branch => |branch| if (writes(branch.yes) or writes(branch.no)) {
                return true;
            },
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (writes(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
