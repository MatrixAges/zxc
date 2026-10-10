const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const render = @import("../render.zig").render;
const Lower = @import("lower.zig");
pub const modules = @import("modules.zig");
pub const state = @import("state.zig");
pub const io = @import("io.zig");
pub const value_call = @import("value_call/root.zig");
pub const buffer_call = @import("buffer_call/root.zig");
pub const state_value = @import("state_value/root.zig");
pub const capabilities = @import("capabilities.zig");
pub const tasks = @import("tasks/root.zig");
pub const prepare = @import("inline_call/root.zig").prepare;

pub fn emit(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, program);

    return render(allocator, try lower.declarations());
}

pub fn bundle(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Bundle {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), program);
    const types = try render(allocator, try @import("type_bundle.zig").declarations(&lower));

    errdefer allocator.free(types);

    lower.shared_types = true;

    return .{ .source = try render(allocator, try lower.declarations()), .types = types };
}

pub const Bundle = struct {
    source: []u8,
    types: []u8,
    pub fn deinit(self: Bundle, allocator: std.mem.Allocator) void {
        allocator.free(self.source);
        allocator.free(self.types);
    }
};

pub fn initialize(temporary: std.mem.Allocator, source: zx.ir.Program) std.mem.Allocator.Error!Lower {
    return initializePrepared(temporary, try prepare(temporary, source));
}

pub fn initializePrepared(temporary: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Lower {
    return initializeAnalyzed(temporary, program, try @import("function_analysis.zig").analyze(temporary, program));
}

pub fn initializeAnalyzed(temporary: std.mem.Allocator, program: zx.ir.Program, facts: @import("function_analysis.zig")) std.mem.Allocator.Error!Lower {
    return .{
        .allocator = temporary,
        .program = program,
        .builder = .{ .allocator = temporary },
        .types = try temporary.alloc(*const node.Expression, program.types.count()),
        .layouts = try temporary.alloc(*const node.Expression, program.types.count()),
        .state_plan = facts.value.state,
        .names = try temporary.alloc([]const u8, program.symbols.count()),
        .cache_reads = try temporary.alloc(usize, program.expressions.count()),
        .used = try temporary.alloc(bool, program.symbols.count()),
        .io_functions = facts.io,
        .process_functions = facts.process,
        .value_functions = facts.value.values,
        .pure_functions = facts.value.pure,
        .allocated_functions = facts.allocated,
        .local_functions = facts.value.local,
        .buffer_functions = facts.buffers,
        .transfer_functions = facts.transfers,
    };
}
