const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const flow = @import("../buffer_call/analysis/flow.zig");
const audit = @import("../buffer_call/analysis/audit.zig");
const Capability = @import("../buffer_call/transfer/analysis.zig").Capability;
const generated = @import("generated_function_facts");
const Input = std.meta.Child(generated.Input);
const Program = std.meta.Child(@FieldType(Input, "program"));
const Functions = std.meta.Child(@FieldType(Program, "functions"));
const Unit = std.meta.Child(@typeInfo(@FieldType(Input, "units")).pointer.child);

pub const Facts = struct {
    value: @import("../value_call/analysis.zig").Summary,
    buffers: []const []const flow.Lane,
    allocated: []const bool,
    transfers: []const []const Capability,
    io: []bool,
    process: []bool,
};

/// Borrows the program columns for the generated facts and copies the results into the caller allocator.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Facts {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

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

    const units = try @import("units.zig").build(Unit, scratch.allocator(), &program);
    const pointers = try scratch.allocator().alloc(*const Unit, units.len);

    for (units, pointers) |*unit, *pointer| pointer.* = unit;

    const input = Input{ .program = &view, .units = columns.slice(@FieldType(Input, "units"), @as([]const *const Unit, pointers)) };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

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
        .buffers = try lanes(allocator, output.lanes, output.rejections),
        .allocated = try allocator.dupe(bool, output.allocated),
        .transfers = try capabilities(allocator, output.transfers),
        .io = try allocator.dupe(bool, output.io),
        .process = try allocator.dupe(bool, output.process),
    };
}

fn lanes(allocator: std.mem.Allocator, summaries: anytype, codes: anytype) std.mem.Allocator.Error![]const []const flow.Lane {
    const result = try allocator.alloc([]const flow.Lane, summaries.len);

    for (summaries, codes, result) |source, rejections, *target| {
        const selected = try allocator.alloc(flow.Lane, source.len);

        for (source, rejections, selected) |lane, code, *item| {
            const iterations = try allocator.alloc(flow.Iteration, lane.iterations.len);
            const calls = try allocator.alloc(flow.Call, lane.calls.len);

            for (lane.iterations, iterations) |iteration, *copied| copied.* = .{ .expression = @fromBackingInt(iteration.expression), .path = try allocator.dupe(u32, iteration.path) };
            for (lane.calls, calls) |call, *copied| copied.* = .{ .expression = @fromBackingInt(call.expression), .lane = @intCast(call.lane) };

            item.* = .{
                .input = try allocator.dupe(u32, lane.input),
                .output = try allocator.dupe(u32, lane.output),
                .appends = try ids(allocator, lane.appends),
                .pops = try ids(allocator, lane.pops),
                .updates = try ids(allocator, lane.updates),
                .iterations = iterations,
                .calls = calls,
                .rejection = if (code == 0) null else @as(audit.Rejection, @enumFromInt(code - 1)),
            };
        }

        target.* = selected;
    }

    return result;
}

fn ids(allocator: std.mem.Allocator, values: []const u32) std.mem.Allocator.Error![]const ir.ExprId {
    const result = try allocator.alloc(ir.ExprId, values.len);

    for (values, result) |value, *id| id.* = @fromBackingInt(value);

    return result;
}

fn capabilities(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error![]const []const Capability {
    const result = try allocator.alloc([]const Capability, source.len);

    for (source, result) |items, *target| {
        const selected = try allocator.alloc(Capability, items.len);

        for (items, selected) |item, *capability| capability.* = .{ .index_only = item.index_only, .writable = item.writable, .forwardable = item.forwardable };

        target.* = selected;
    }

    return result;
}
