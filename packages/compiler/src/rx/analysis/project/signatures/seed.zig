pub const Stage = enum { Start, Bindings, Tasks, Input, Output, Done };

pub fn advance(stage: Stage) Stage {
    return switch (stage) {
        .Start => .Bindings,
        .Bindings => .Tasks,
        .Tasks => .Input,
        .Input => .Output,
        .Output, .Done => .Done,
    };
}
