const ir = @import("zx").ir;
const Storage = @import("../storage.zig");

pub fn task(self: *Storage, value: ir.Task) usize {
    const payload = self.task_bodies.items.len;

    self.task_bodies.appendAssumeCapacity(@backingInt(value.body));
    self.task_capture_first.appendAssumeCapacity(@intCast(self.task_captures.items.len));
    self.task_capture_count.appendAssumeCapacity(@intCast(value.captures.len));
    for (value.captures) |capture| self.task_captures.appendAssumeCapacity(@backingInt(capture));

    return payload;
}

pub fn parallel(self: *Storage, values: []const ir.ParallelBranch) usize {
    const payload = self.parallel_first.items.len;

    self.parallel_first.appendAssumeCapacity(@intCast(self.parallel_tasks.items.len));
    self.parallel_count.appendAssumeCapacity(@intCast(values.len));

    for (values) |value| {
        self.parallel_tasks.appendAssumeCapacity(@backingInt(value.task));
        self.parallel_fields.appendAssumeCapacity(value.field);
    }

    return payload;
}

pub fn iteration(self: *Storage, value: ir.Iteration) usize {
    const payload = self.iteration_initials.items.len;

    self.iteration_initials.appendAssumeCapacity(@backingInt(value.initial));
    self.iteration_condition_parameters.appendAssumeCapacity(@backingInt(value.condition_parameter));
    self.iteration_parameters.appendAssumeCapacity(@backingInt(value.parameter));
    self.iteration_conditions.appendAssumeCapacity(@backingInt(value.condition));
    self.iteration_bodies.appendAssumeCapacity(@backingInt(value.body));
    self.iteration_postconditions.appendAssumeCapacity(value.postcondition);

    return payload;
}
