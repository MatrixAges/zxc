const ir = @import("zx").ir;

pub const Step = union(enum) {
    call: usize,
    result: ir.Program,
    task: []const Step,
    selection: struct { subject: ir.Program, cases: []const Case },
};

pub const Case = struct { value: ?ir.Program, body: []const Step };
