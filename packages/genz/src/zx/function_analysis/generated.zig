const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const generated = @import("generated_function_facts");
const Input = std.meta.Child(generated.Input);
const Program = std.meta.Child(@FieldType(Input, "program"));
const Functions = std.meta.Child(@FieldType(Program, "functions"));
const Errors = std.meta.Child(@FieldType(Input, "errors"));

pub const Facts = struct {
    value: @import("../value_call/analysis.zig").Summary,
    io: []bool,
    process: []bool,
    tasks: []bool,
    fresh_outputs: []bool,
    identity_free: []bool,
    errors: []const ?[]const []const u8,
};

/// Borrows the program columns for the generated facts and copies the results into the caller allocator.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Facts {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    var bodies = try zx.error_effects.functionBodies(temporary, program.types, program.functions);

    defer bodies.deinit();

    const names = try temporary.alloc([]const []const u8, bodies.own.len);
    const unknown = try temporary.alloc(bool, bodies.own.len);
    const callees = try temporary.alloc([]const u32, bodies.own.len);

    comptime std.debug.assert(@typeInfo(ir.FunctionId).@"enum".tag_type == u32);

    for (bodies.own, names, unknown, callees) |body, *target_names, *target_unknown, *target_callees| {
        target_names.* = body.names;
        target_unknown.* = body.unknown;
        target_callees.* = @as([*]const u32, @ptrCast(body.callees.ptr))[0..body.callees.len];
    }

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Program, "types")), program.types);
    var functions: Functions = undefined;

    inline for (@typeInfo(Functions).@"struct".field_names) |name| {
        @field(functions, name) = columns.slice(@FieldType(Functions, name), @field(program.functions, name));
    }

    const view = Program{
        .types = &types,
        .functions = &functions,
        .stores = columns.pointer(@FieldType(Program, "stores"), &program.stores),
        .expressions = columns.pointer(@FieldType(Program, "expressions"), &program.expressions),
        .contracts = columns.pointer(@FieldType(Program, "contracts"), &program.contracts),
        .control = columns.pointer(@FieldType(Program, "control"), program.body.control),
        .root = if (program.body.root) |root| @backingInt(root) else null,
        .output_type = @backingInt(program.output_type),
    };

    const error_sources = Errors{ .names = names, .unknown = unknown, .callees = callees };
    const input = Input{ .program = &view, .errors = &error_sources };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const grouped = try temporary.alloc([]const []const u8, output.errors.names.len);

    for (grouped, output.errors.names) |*target, source| target.* = try allocator.dupe([]const u8, source);

    const errors = try allocator.alloc(?[]const []const u8, bodies.own.len);

    for (errors, output.errors.components) |*target, component| target.* = if (output.errors.unknown[component]) null else grouped[component];

    return .{
        .value = .{
            .pure = try allocator.dupe(bool, output.pure),
            .local = try allocator.dupe(bool, output.local),
            .values = try allocator.dupe(bool, output.values),
            .state = .{
                .selected = try allocator.dupe(bool, output.selected),
                .keys = try allocator.dupe([32]u8, std.mem.bytesAsSlice([32]u8, output.keys)),
            },
        },
        .io = try allocator.dupe(bool, output.io),
        .process = try allocator.dupe(bool, output.process),
        .tasks = try allocator.dupe(bool, output.tasks),
        .fresh_outputs = try allocator.dupe(bool, output.fresh_outputs),
        .identity_free = try allocator.dupe(bool, output.identity_free),
        .errors = errors,
    };
}
