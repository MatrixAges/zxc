const std = @import("std");
const zx = @import("zx");
const enabled = @import("parser_options").generated_parser;
pub const State = if (enabled) @FieldType(std.meta.Child(@import("generated_project_load_admission").Input), "state") else enum { Fresh, Visiting, Done };
pub const Phase = enum { body, signature };
const Admission = if (enabled) Result(@import("generated_project_load_admission")) else enum { Push, Skip, Cycle, Depth };
const SourceAction = if (enabled) Result(@import("generated_project_load_source")) else enum { Descend, BindBody, BindSignature, DeferSignature, SkipSignature, RejectRx, Missing };

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

pub fn source(rx: bool, phase: Phase, function_import: bool, exported: bool, state: ?State) SourceAction {
    if (comptime enabled) {
        const generated = @import("generated_project_load_source");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(generated.Input) = .{
            .rx = rx,
            .signature = phase == .signature,
            .function_import = function_import,
            .exported = exported,
            .state = state,
        };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (rx) {
        if (phase != .signature) return .RejectRx;

        return if (function_import and !exported) .SkipSignature else .DeferSignature;
    }

    if (state == null) return .Missing;
    if (state != .Done) return .Descend;

    return if (phase == .signature) .BindSignature else .BindBody;
}
