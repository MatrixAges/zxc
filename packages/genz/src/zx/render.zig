const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const render = @import("../render.zig").render;
const Lower = @import("lower.zig");
pub const modules = @import("modules.zig");
pub const state = @import("state.zig");
pub const io = @import("io.zig");
pub const value_call = @import("value_call/root.zig");
pub const state_value = @import("state_value/root.zig");
pub const capabilities = @import("capabilities.zig");
pub const tasks = @import("tasks/root.zig");
pub const prepare = @import("inline_call/root.zig").prepare;
pub const function_analysis = @import("function_analysis.zig");

pub fn emit(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, allocator, program);

    return render(allocator, lower.builder.nodes, try lower.declarations());
}

pub fn bundle(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Bundle {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), allocator, program);
    const types = try render(allocator, lower.builder.nodes, try @import("type_bundle.zig").declarations(&lower));

    errdefer allocator.free(types);

    lower.shared_types = true;

    return .{ .source = try render(allocator, lower.builder.nodes, try lower.declarations()), .types = types };
}

pub const Bundle = struct {
    source: []u8,
    types: []u8,
    pub fn deinit(self: Bundle, allocator: std.mem.Allocator) void {
        allocator.free(self.source);
        allocator.free(self.types);
    }
};

/// Workspace backs short-lived analysis storage that is released before the lowering arena.
pub fn initialize(temporary: std.mem.Allocator, workspace: std.mem.Allocator, source: zx.ir.Program) std.mem.Allocator.Error!Lower {
    return initializePrepared(temporary, workspace, try prepare(temporary, source));
}

pub fn initializePrepared(temporary: std.mem.Allocator, workspace: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Lower {
    const Analysis = @import("function_analysis.zig");
    const basis = try temporary.create(Analysis.Uniqueness.Basis);

    basis.* = try .create(temporary, program);

    return initializeAnalyzed(temporary, workspace, program, try Analysis.analyze(temporary, workspace, program, &.{}, basis, null));
}

pub fn initializeAnalyzed(temporary: std.mem.Allocator, workspace: std.mem.Allocator, program: zx.ir.Program, facts: @import("function_analysis.zig")) std.mem.Allocator.Error!Lower {
    return .{
        .allocator = temporary,
        .workspace = workspace,
        .program = program,
        .builder = try @import("../builder.zig").init(temporary),
        .types = try temporary.alloc(node.ExpressionId, program.types.count()),
        .layouts = try temporary.alloc(node.ExpressionId, program.types.count()),
        .state_plan = facts.value.state,
        .names = try temporary.alloc([]const u8, program.symbols.count()),
        .cache_reads = try temporary.alloc(usize, program.expressions.count()),
        .used = try temporary.alloc(bool, program.symbols.count()),
        .io_functions = facts.io,
        .process_functions = facts.process,
        .task_functions = facts.tasks,
        .function_errors = if (facts.errors.len == program.functions.count()) facts.errors else null,
        .value_functions = facts.value.values,
        .pure_functions = facts.value.pure,
        .local_functions = facts.value.local,
        .plans = facts.uniqueness.functions,
        .plan = facts.uniqueness.entry,
    };
}
