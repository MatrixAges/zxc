const rx = @import("rx");

pub const Step = struct {
    value: union(enum) {
        call: usize,
        parallel: []const Branch,
        result: rx.ast.Attribute,
        task: struct { node: rx.ast.Node, body: []const Step },
        selection: struct { subject: rx.ast.Attribute, cases: []const Case },
    },
};

pub const Case = struct { value: ?rx.ast.Attribute, body: []const Step };

pub fn terminates(sequence: []const Step) bool {
    for (sequence) |step| switch (step.value) {
        .result => return true,
        .task => |task| if (terminates(task.body)) return true,
        .selection => |selection| {
            var has_default = false;
            var all_return = true;

            for (selection.cases) |case| {
                has_default = has_default or case.value == null;
                all_return = all_return and terminates(case.body);
            }

            if (has_default and all_return) return true;
        },
        .call, .parallel => {},
    };

    return false;
}

pub const Task = struct { id: usize, node: rx.ast.Node, body: []const Step };
pub const Branch = union(enum) { call: usize, task: Task };

pub fn returns(sequence: []const Step) bool {
    for (sequence) |step| switch (step.value) {
        .result => return true,
        .task => |task| if (returns(task.body)) return true,
        .selection => |selection| {
            for (selection.cases) |case| if (returns(case.body)) return true;
        },
        .call, .parallel => {},
    };

    return false;
}
