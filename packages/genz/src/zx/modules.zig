const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const render = @import("../render.zig").render;
pub const Names = struct { types: []const []const u8, functions: []const []const u8 };
pub const abi_view = @import("abi_view.zig");
pub const Error = std.mem.Allocator.Error || error{ InvalidNames, InvalidFunction };

pub fn entry(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), program, names);

    return render(allocator, try lower.declarations());
}

pub fn types(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), program, names);

    lower.shared_types = false;

    return render(allocator, try @import("type_bundle.zig").declarations(&lower));
}

pub fn function(allocator: std.mem.Allocator, program: ir.Program, id: ir.FunctionId, names: Names) Error![]u8 {
    if (@intFromEnum(id) >= program.functions.len) return error.InvalidFunction;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const selected = program.functions[@intFromEnum(id)];
    var lower = try initialize(temporary, program, names);

    lower.program.symbols = selected.symbols;
    lower.program.expressions = selected.expressions;
    lower.program.body = selected.body;
    lower.program.consumes_input = selected.consumes_input;
    lower.program.input_type = selected.input_type;
    lower.program.output_type = selected.output_type;
    lower.program.stores = selected.stores;
    lower.program.store_mode = selected.store_mode;
    lower.program.contracts = selected.contracts;
    lower.names = try temporary.alloc([]const u8, selected.symbols.len);
    lower.used = try temporary.alloc(bool, selected.symbols.len);
    lower.cache_reads = try temporary.alloc(usize, selected.expressions.len);

    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;

    lower.comparisons = &comparisons;

    try output.append(temporary, .{ .constant = .{ .name = "std", .value = try lower.builtin(.import, &.{try lower.builder.string("std")}) } });
    try @import("types.zig").lower(&lower, &output, false);
    try @import("store.zig").declaration(&lower, &output);

    var declaration = if (selected.external) |external| native: {
        const module = program.native_modules[@intFromEnum(external.module)];
        const native_names = try temporary.alloc([]const u8, program.native_modules.len);

        @memset(native_names, "");
        native_names[@intFromEnum(external.module)] = "zx_native";

        lower.native_names = native_names;

        try output.append(temporary, .{ .constant = .{ .name = "zx_native", .value = try lower.builtin(.import, &.{try lower.builder.string(module.import_name)}) } });

        break :native try @import("external.zig").lower(&lower, selected, @intFromEnum(id));
    } else try lower.function("call", false);

    declaration.function.name = "call";
    declaration.function.exported = true;

    try output.append(temporary, declaration);

    if (lower.value_functions[@intFromEnum(id)]) {
        var value_declaration = try lower.functionValue("callValue");

        value_declaration.function.exported = true;

        try output.append(temporary, value_declaration);
    }

    if (lower.uses_parallel) try output.append(temporary, .{ .source = @import("parallel/allocator.zig").source });
    for (comparisons.items) |type_id| try output.append(temporary, try @import("comparison.zig").ordering(&lower, type_id));

    return render(allocator, try output.toOwnedSlice(temporary));
}

fn initialize(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error!Lower {
    if (names.types.len != program.types.len or names.functions.len != program.functions.len) return error.InvalidNames;

    var lower = try @import("render.zig").initialize(allocator, program);

    lower.type_names = names.types;
    lower.function_modules = names.functions;
    lower.shared_types = true;

    return lower;
}
