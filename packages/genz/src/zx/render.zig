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
pub const capabilities = @import("capabilities.zig");
pub const tasks = @import("tasks/root.zig");

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

pub fn initialize(temporary: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Lower {
    const function_facts = try @import("value_call/analysis.zig").analyze(temporary, program);
    const value_functions = function_facts.values;

    return .{
        .allocator = temporary,
        .program = program,
        .builder = .{ .allocator = temporary },
        .types = try temporary.alloc(*const node.Expression, program.types.len),
        .layouts = try temporary.alloc(*const node.Expression, program.types.len),
        .names = try temporary.alloc([]const u8, program.symbols.len),
        .cache_reads = try temporary.alloc(usize, program.expressions.len),
        .used = try temporary.alloc(bool, program.symbols.len),
        .io_functions = try io.functions(temporary, program),
        .process_functions = try capabilities.functions(temporary, program, .process),
        .value_functions = value_functions,
        .pure_functions = function_facts.pure,
        .buffer_functions = try buffer_call.analysis.functions(temporary, program, value_functions),
    };
}
