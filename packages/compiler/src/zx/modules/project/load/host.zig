const std = @import("std");
const zx = @import("zx");
const Index = @import("../../source_index.zig").Map;
const enabled = @import("parser_options").generated_parser;
pub const State = if (enabled) @FieldType(std.meta.Child(@import("generated_project_load_admission").Input), "state") else enum { Fresh, Visiting, Done };
pub const Phase = enum { body, signature };
const Admission = if (enabled) Result(@import("generated_project_load_admission")) else enum { Push, Skip, Cycle, Depth };
const SourceAction = if (enabled) @FieldType(Result(@import("generated_project_load_source")), "action") else enum { Descend, Bind, DeferSignature, SkipSignature, RejectRx, Missing, Cycle, Depth };

fn Result(comptime module: type) type {
    return @typeInfo(@TypeOf(module.executeValue(undefined, undefined))).error_union.payload;
}

pub fn states(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error![]State {
    const result = try allocator.alloc(State, count);

    @memset(result, .Fresh);

    return result;
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
    path: []const u8,
    phase: Phase,
    function_import: bool,
    exported: bool,
    depth: usize,
};

const Plan = struct {
    action: SourceAction,
    index: ?usize = null,
};

pub fn source(index: *const Index, state_column: []const State, request: Source) Plan {
    if (comptime enabled) {
        const generated = @import("generated_project_load_source");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const Input = std.meta.Child(generated.Input);

        const input: Input = .{
            .path = request.path,
            .signature = request.phase == .signature,
            .function_import = request.function_import,
            .exported = request.exported,
            .depth = request.depth,
            .keys = index.keys,
            .buckets = @ptrCast(&index.buckets),
            .capacity = index.buckets.len,
            .states = zx.columns.slice(@FieldType(Input, "states"), state_column),
        };

        const plan = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;

        return .{ .action = plan.action, .index = if (plan.index) |row| @intCast(row) else null };
    }

    if (std.mem.endsWith(u8, request.path, ".rx")) {
        if (request.phase != .signature) return .{ .action = .RejectRx };

        return .{ .action = if (request.function_import and !request.exported) .SkipSignature else .DeferSignature };
    }

    const row = index.get(request.path) orelse return .{ .action = .Missing };

    return switch (admit(state_column[row], request.depth)) {
        .Push => .{ .action = .Descend, .index = row },
        .Skip => .{ .action = .Bind, .index = row },
        .Cycle => .{ .action = .Cycle },
        .Depth => .{ .action = .Depth },
    };
}
