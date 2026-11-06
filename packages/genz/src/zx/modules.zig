const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const render = @import("../render.zig").render;
pub const Analysis = @import("function_analysis.zig");
pub const Names = struct { types: []const []const u8, functions: []const []const u8 };
/// `function` is one function's file; a value function's file holds only its value variant. `regular` is the same file
/// with the pointer-ABI `call` as well, for value functions some caller reaches through it.
pub const Unit = union(enum) { entry, function: ir.FunctionId, types, regular: ir.FunctionId };
pub const abi_view = @import("abi_view.zig");
pub const typeNames = @import("types/export_names.zig").build;
pub const Error = std.mem.Allocator.Error || error{ InvalidNames, InvalidFunction };
pub const PublicMember = struct { name: []const u8, function: ir.FunctionId };

/// Function types for separately compiled files. Bodies are deliberately absent: importing a type
/// must not pull the owning function and its dependency graph into another compilation unit.
pub fn signatures(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, facts: Analysis, units: []const Unit) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, backing, program, names, facts);
    var output: std.ArrayList(node.Declaration) = .empty;
    var emitted: std.StringHashMapUnmanaged(void) = .empty;

    try output.append(temporary, .{ .constant = .{ .name = "std", .value = try lower.builtin(.import, &.{try lower.builder.string("std")}) } });
    try @import("types.zig").lower(&lower, &output, false);

    for (units) |unit| {
        const id = switch (unit) {
            .function, .regular => |id| id,
            else => continue,
        };

        const path = names.functions[@backingInt(id)];
        const name = std.fs.path.stem(path);

        if ((try emitted.getOrPut(temporary, name)).found_existing) continue;

        var selected = lower;
        const function_value = try selectFunction(&selected, id);
        const value = function_value.external == null and selected.value_functions[@backingInt(id)];
        var variants: std.ArrayList(node.Declaration) = .empty;

        if (!value or unit == .regular) {
            const prototype = if (function_value.external != null)
                try @import("external.zig").prototype(&selected, function_value, @backingInt(id))
            else
                try selected.prototype("signature", false);
            try variants.append(temporary, try signatureType(&selected, "call", prototype));
        }

        if (value) try variants.append(temporary, try signatureType(&selected, "callValue", try selected.valuePrototype("signature")));
        try output.append(temporary, .{ .constant = .{ .name = name, .exported = true, .value = try lower.builder.expression(.{ .namespace_type = variants.items }) } });
    }

    return render(allocator, lower.builder.nodes, output.items);
}

fn signatureType(lower: *Lower, name: []const u8, prototype: node.Function) Error!node.Declaration {
    var function_type = prototype;
    function_type.name = "signature";
    function_type.exported = false;
    function_type.inlined = false;
    function_type.body = try lower.builder.statements(&.{.unreachable_stmt});

    const parameters = try lower.allocator.dupe(node.Field, prototype.parameters);

    for (parameters) |*parameter| parameter.name = "_";

    function_type.parameters = parameters;

    const declarations = try lower.allocator.dupe(node.Declaration, &.{.{ .function = function_type }});
    const container = try lower.builder.expression(.{ .namespace_type = declarations });

    return .{ .constant = .{ .name = name, .exported = true, .value = try lower.builtin(.TypeOf, &.{try lower.builder.field(container, "signature")}) } };
}

fn selectFunction(lower: *Lower, id: ir.FunctionId) Error!ir.Function {
    if (@backingInt(id) >= lower.program.functions.count()) return error.InvalidFunction;

    const selected = lower.program.functions.at(@backingInt(id));

    lower.program.symbols = selected.symbols;
    lower.program.expressions = selected.expressions;
    lower.program.body = selected.body;
    lower.program.input_type = selected.input_type;
    lower.program.output_type = selected.output_type;
    lower.program.stores = selected.stores;
    lower.program.store_mode = selected.store_mode;
    lower.program.contracts = selected.contracts;
    lower.self_function = id;

    try lower.refreshEntry();

    return selected;
}

pub fn publicEntry(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, facts: Analysis, members: []const PublicMember) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, backing, program, names, facts);
    var declarations: std.ArrayList(node.Declaration) = .empty;

    try declarations.appendSlice(temporary, try lower.declarations());

    for (members) |member| {
        const module = try lower.builder.builtin(.import, &.{try lower.builder.string(names.functions[@backingInt(member.function)])});

        try declarations.append(temporary, .{ .constant = .{
            .exported = true,
            .name = member.name,
            .value = try lower.builder.field(module, "call"),
        } });
    }

    return render(allocator, lower.builder.nodes, declarations.items);
}

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
    if (unit == .function and @backingInt(unit.function) >= program.functions.count()) return error.InvalidFunction;
    if (names.types.len != program.types.count() or names.functions.len != program.functions.count()) return error.InvalidNames;

    var analysis = try Analysis.create(allocator, program);

    defer analysis.deinit();

    return analyzed(allocator, allocator, program, names, unit, analysis.value);
}

pub fn analyzed(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit, facts: Analysis) Error![]u8 {
    return switch (unit) {
        .entry => entryPrepared(allocator, backing, program, names, facts),
        .types => typesPrepared(allocator, backing, program, names, facts),
        .function => |id| functionPrepared(allocator, backing, program, id, names, facts, false),
        .regular => |id| functionPrepared(allocator, backing, program, id, names, facts, true),
    };
}

fn entryPrepared(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, facts: Analysis) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), backing, program, names, facts);

    return render(allocator, lower.builder.nodes, try lower.declarations());
}

fn typesPrepared(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, facts: Analysis) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    var lower = try initialize(arena.allocator(), backing, program, names, facts);

    lower.shared_types = false;

    return @import("../render.zig").renderStored(allocator, lower.builder.nodes, try @import("type_bundle.zig").declarations(&lower));
}

fn functionPrepared(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, id: ir.FunctionId, names: Names, facts: Analysis, regular: bool) Error![]u8 {
    if (@backingInt(id) >= program.functions.count()) return error.InvalidFunction;

    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    var lower = try initialize(temporary, backing, program, names, facts);
    const selected = try selectFunction(&lower, id);

    lower.plan = lower.plans[@backingInt(id)];
    lower.names = try temporary.alloc([]const u8, selected.symbols.count());
    lower.may_grow = if (@backingInt(id) < lower.growth_functions.len) lower.growth_functions[@backingInt(id)] else true;
    lower.used = try temporary.alloc(bool, selected.symbols.count());
    lower.cache_reads = try temporary.alloc(usize, selected.expressions.count());

    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;
    var task_declarations: std.ArrayList(node.Declaration) = .empty;
    lower.comparisons = &comparisons;
    lower.task_declarations = &task_declarations;

    try output.append(temporary, .{ .constant = .{ .name = "std", .value = try lower.builtin(.import, &.{try lower.builder.string("std")}) } });
    try @import("types.zig").lower(&lower, &output, false);
    try @import("store.zig").declaration(&lower, &output);

    const value = selected.external == null and lower.value_functions[@backingInt(id)];

    if (!value or regular) {
        var declaration = if (selected.external) |external| native: {
            const module = program.native_modules.at(@backingInt(external.module));
            const native_names = try temporary.alloc([]const u8, program.native_modules.count());

            @memset(native_names, "");
            native_names[@backingInt(external.module)] = "zx_native";

            lower.native_names = native_names;

            try output.append(temporary, .{ .constant = .{ .name = "zx_native", .value = try lower.builtin(.import, &.{try lower.builder.string(module.import_name)}) } });

            break :native try @import("external.zig").lower(&lower, selected, @backingInt(id));
        } else try lower.function("call", false);

        declaration.function.name = "call";
        declaration.function.exported = true;

        try output.append(temporary, declaration);
    }

    if (value) {
        var value_declaration = try lower.functionValue("callValue");
        value_declaration.function.exported = true;

        try output.append(temporary, value_declaration);
    }

    if (lower.uses_parallel) try output.append(temporary, try @import("parallel/allocator.zig").declaration(&lower));
    try output.appendSlice(temporary, task_declarations.items);
    for (comparisons.items) |type_id| try output.append(temporary, try @import("comparison.zig").ordering(&lower, type_id));

    return render(allocator, lower.builder.nodes, try output.toOwnedSlice(temporary));
}

fn initialize(allocator: std.mem.Allocator, backing: std.mem.Allocator, program: ir.Program, names: Names, facts: Analysis) Error!Lower {
    if (names.types.len != program.types.count() or names.functions.len != program.functions.count()) return error.InvalidNames;

    var lower = try @import("render.zig").initializeAnalyzed(allocator, backing, program, facts);

    lower.type_names = names.types;
    lower.function_modules = names.functions;
    lower.shared_types = true;

    return lower;
}
