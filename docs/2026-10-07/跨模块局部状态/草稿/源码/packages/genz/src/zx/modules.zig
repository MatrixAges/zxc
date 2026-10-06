const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const render = @import("../render.zig").render;
pub const Names = struct { types: []const []const u8, functions: []const []const u8 };
pub const Unit = union(enum) { entry, function: ir.FunctionId, types };
pub const abi_view = @import("abi_view.zig");
pub const Error = std.mem.Allocator.Error || error{ InvalidNames, InvalidFunction };

pub fn entry(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    return generate(allocator, program, names, .entry);
}

pub fn types(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    return generate(allocator, program, names, .types);
}

pub fn function(allocator: std.mem.Allocator, program: ir.Program, id: ir.FunctionId, names: Names) Error![]u8 {
    return generate(allocator, program, names, .{ .function = id });
}

fn generate(allocator: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return prepared(allocator, try @import("render.zig").prepare(arena.allocator(), program), names, unit);
}

pub fn prepared(allocator: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit) Error![]u8 {
    return switch (unit) {
        .entry => entryPrepared(allocator, program, names),
        .types => typesPrepared(allocator, program, names),
        .function => |id| functionPrepared(allocator, program, id, names),
    };
}

fn entryPrepared(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), program, names);

    return render(allocator, try lower.declarations());
}

fn typesPrepared(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), program, names);

    lower.shared_types = false;

    return render(allocator, try @import("type_bundle.zig").declarations(&lower));
}

fn functionPrepared(allocator: std.mem.Allocator, program: ir.Program, id: ir.FunctionId, names: Names) Error![]u8 {
    if (@backingInt(id) >= program.functions.len) return error.InvalidFunction;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, program, names);
    const selected = lower.program.functions[@backingInt(id)];

    lower.program.symbols = selected.symbols;
    lower.program.expressions = selected.expressions;
    lower.program.body = selected.body;
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
    var task_declarations: std.ArrayList(node.Declaration) = .empty;
    lower.comparisons = &comparisons;
    lower.task_declarations = &task_declarations;

    try output.append(temporary, .{ .constant = .{ .name = "std", .value = try lower.builtin(.import, &.{try lower.builder.string("std")}) } });
    try @import("types.zig").lower(&lower, &output, false);
    try @import("store.zig").declaration(&lower, &output);

    var declaration = if (selected.external) |external| native: {
        const module = program.native_modules[@backingInt(external.module)];
        const native_names = try temporary.alloc([]const u8, program.native_modules.len);

        @memset(native_names, "");
        native_names[@backingInt(external.module)] = "zx_native";

        lower.native_names = native_names;

        try output.append(temporary, .{ .constant = .{ .name = "zx_native", .value = try lower.builtin(.import, &.{try lower.builder.string(module.import_name)}) } });

        break :native try @import("external.zig").lower(&lower, selected, @backingInt(id));
    } else try lower.function("call", false);

    declaration.function.name = "call";
    declaration.function.exported = true;

    try output.append(temporary, declaration);

    if (lower.value_functions[@backingInt(id)]) {
        var value_declaration = try lower.functionValue("callValue");

        value_declaration.function.exported = true;

        try output.append(temporary, value_declaration);
    }

    if (@import("buffer_call/root.zig").available(lower.buffer_functions[@backingInt(id)])) {
        var buffered_declaration = try @import("buffer_call/root.zig").declaration(&lower, "callBuffered", lower.buffer_functions[@backingInt(id)]);

        buffered_declaration.function.exported = true;

        try output.append(temporary, buffered_declaration);
    }

    if (lower.uses_parallel) try output.append(temporary, try @import("parallel/allocator.zig").declaration(&lower));
    try output.appendSlice(temporary, task_declarations.items);
    for (comparisons.items) |type_id| try output.append(temporary, try @import("comparison.zig").ordering(&lower, type_id));

    return render(allocator, try output.toOwnedSlice(temporary));
}

fn initialize(allocator: std.mem.Allocator, program: ir.Program, names: Names) Error!Lower {
    if (names.types.len != program.types.count() or names.functions.len != program.functions.len) return error.InvalidNames;

    var lower = try @import("render.zig").initializePrepared(allocator, program);

    lower.type_names = names.types;
    lower.function_modules = names.functions;
    lower.shared_types = true;

    return lower;
}
