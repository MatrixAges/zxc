const std = @import("std");
const zx = @import("zx");
const enabled = @import("parser_options").generated_parser;
pub const State = if (enabled) @FieldType(std.meta.Child(@import("generated_project_load_admission").Input), "state") else enum { Fresh, Visiting, Done };
pub const Phase = enum { body, signature };
const Admission = if (enabled) Result(@import("generated_project_load_admission")) else enum { Push, Skip, Cycle, Depth };
const SourceAction = if (enabled) Result(@import("generated_project_load_source")) else enum { Descend, BindBody, BindSignature, DeferSignature, SkipSignature, RejectRx, Missing, Cycle, Depth };

fn Result(comptime module: type) type {
    return @typeInfo(@TypeOf(module.executeValue(undefined, undefined))).error_union.payload;
}

pub fn admit(state: State, depth: usize) Admission {
    if (comptime enabled) {
        const generated = @import("generated_project_load_admission");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(generated.Input) = .{ .state = state, .depth = depth };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    return switch (state) {
        .Done => .Skip,
        .Visiting => .Cycle,
        .Fresh => if (depth < 256) .Push else .Depth,
    };
}

pub const Source = struct {
    rx: bool,
    phase: Phase,
    function_import: bool,
    exported: bool,
    state: ?State,
    depth: usize,
};

pub fn source(request: Source) SourceAction {
    if (comptime enabled) {
        const generated = @import("generated_project_load_source");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(generated.Input) = .{
            .rx = request.rx,
            .signature = request.phase == .signature,
            .function_import = request.function_import,
            .exported = request.exported,
            .state = request.state,
            .depth = request.depth,
        };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (request.rx) {
        if (request.phase != .signature) return .RejectRx;

        return if (request.function_import and !request.exported) .SkipSignature else .DeferSignature;
    }

    return switch (admit(request.state orelse return .Missing, request.depth)) {
        .Push => .Descend,
        .Skip => if (request.phase == .signature) .BindSignature else .BindBody,
        .Cycle => .Cycle,
        .Depth => .Depth,
    };
}
