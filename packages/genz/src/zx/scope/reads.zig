const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("genz_options").generated_analysis;
const Seed = @import("reads/seed.zig");
const collecting = @import("generated_scope_reads");
const querying = @import("generated_scope_reads_get");
const State = if (generated) @typeInfo(@typeInfo(@TypeOf(collecting.executeValue)).@"fn".return_type.?).error_union.payload else void;

pub const Last = if (!generated) Seed.Last else struct {
    arena: std.heap.ArenaAllocator,
    state: State,
    pub fn get(self: *const @This(), symbol: ir.SymbolId) ?usize {
        const Parameter = @typeInfo(@TypeOf(querying.executeValue)).@"fn".param_types[1].?;
        const indirect = @typeInfo(Parameter) == .pointer;
        const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
        const LastParameter = @FieldType(Input, "last");
        const last_indirect = @typeInfo(LastParameter) == .pointer;
        const Value = if (last_indirect) std.meta.Child(LastParameter) else LastParameter;
        var fixed = std.heap.FixedBufferAllocator.init(&.{});
        const last = @import("zx").columns.view(Value, self.state);
        const input: Input = .{ .last = if (last_indirect) &last else last, .symbol = @backingInt(symbol) };
        const result = querying.executeValue(fixed.allocator(), if (indirect) &input else input) catch unreachable;

        return if (result) |position| @intCast(position) else null;
    }
    pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
        _ = allocator;

        self.arena.deinit();
    }
};

pub fn collect(workspace: std.mem.Allocator, program: *const ir.Program, scope: ir.ScopeRow) std.mem.Allocator.Error!Last {
    if (!generated) return Seed.collect(workspace, program, scope);

    const Parameter = @typeInfo(@TypeOf(collecting.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const input: Input = .{
        .expressions = @import("zx").columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .bindings = scope.bindings.values,
        .result = @backingInt(scope.result),
    };

    const state = collecting.executeValue(arena.allocator(), if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .arena = arena, .state = state };
}
