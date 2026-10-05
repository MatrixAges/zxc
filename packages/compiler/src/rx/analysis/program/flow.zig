const ir = @import("zx").ir;

pub const Step = union(enum) {
    call: usize,
    parallel: []const usize,
    result: ir.Program,
    task: struct { body: []const Step, output: ?struct { value: ir.Program, name: ?[]const u8 } = null },
    selection: struct { subject: ir.Program, cases: []const Case },
};

pub const Case = struct { value: ?ir.Program, body: []const Step };
