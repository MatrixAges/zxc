const std = @import("std");
const zx = @import("zx");
const Conditions = @import("../../verification/conditions.zig");
const values = @import("../../verification/terms.zig");
const Terms = @import("terms.zig");
pub const ir = @import("ir.zig");
pub const validate = @import("validate.zig").validate;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { module: ir.Module, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn generate(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (try @import("frontend").validateIr(allocator, program)) |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } };

    var reporter: zx.Reporter = .{};
    var conditions = Conditions{ .allocator = arena.allocator(), .program = program, .reporter = &reporter };

    const model = conditions.model() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic orelse diagnostic("unsupported hardware symbolic model") } };
    };

    const module = build(arena.allocator(), program, model) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = diagnostic("invalid or oversized typed hardware expression") } };
    };

    return .{ .arena = arena, .value = .{ .module = module } };
}

fn build(allocator: std.mem.Allocator, program: zx.ir.Program, model: Conditions.Model) !ir.Module {
    var terms = Terms{ .allocator = allocator };
    const inputs = try allocator.alloc(ir.Port, model.inputs.len);

    for (model.inputs, inputs, 0..) |input, *port, index| {
        const sort = try sortOf(program.typeOf(input.type_id));
        const id = try terms.add(.{ .sort = sort, .value = .{ .input = index } });

        try terms.variables.put(allocator, input.symbol, id);

        port.* = .{ .name = input.symbol, .path = input.path, .sort = sort, .signed = signed(program.typeOf(input.type_id)), .node = id };
    }

    for (model.definitions) |definition| {
        terms.origin = .{ .file_name = definition.origin.file_name, .span = definition.origin.span };

        const id = try terms.parse(definition.expression);
        const sort = ir.Sort{ .width = if (definition.width == 0) 1 else definition.width, .boolean = definition.width == 0 };

        if (!sort.equal(terms.nodes.items[@intFromEnum(id)].sort)) return error.InvalidHardwareTerm;
        try terms.variables.put(allocator, definition.name, id);
    }

    terms.origin = null;

    var outputs: std.ArrayList(ir.Port) = .empty;

    try flatten(&terms, program, program.output_type, model.output.value, "out", &outputs);

    const safe = try terms.parse(model.output.safe);

    if (!terms.nodes.items[@intFromEnum(safe)].sort.boolean) return error.InvalidHardwareTerm;

    return .{ .nodes = terms.nodes.items, .inputs = inputs, .outputs = outputs.items, .safe = safe };
}

fn flatten(terms: *Terms, program: zx.ir.Program, type_id: zx.ir.TypeId, value: values.Value, path: []const u8, ports: *std.ArrayList(ir.Port)) Terms.Error!void {
    const target = program.typeOf(type_id);

    if (target == .object or target == .tuple) {
        const count = if (target == .object) target.object.len else target.tuple.len;

        if (value != .fields or value.fields.len != count) return error.InvalidHardwareTerm;

        for (value.fields, 0..) |field, index| {
            const child_path = if (target == .object) try std.fmt.allocPrint(terms.allocator, "{s}.{s}", .{ path, target.object.at(index).name }) else try std.fmt.allocPrint(terms.allocator, "{s}[{d}]", .{ path, index });

            try flatten(terms, program, if (target == .object) target.object.at(index).type_id else target.tuple.at(index), field, child_path, ports);
        }

        return;
    }

    if (target == .scalar and target.scalar == .void) return;
    if (value != .scalar) return error.InvalidHardwareTerm;

    const sort = try sortOf(target);
    const id = try terms.parse(value.scalar);

    if (!sort.equal(terms.nodes.items[@intFromEnum(id)].sort)) return error.InvalidHardwareTerm;

    try ports.append(terms.allocator, .{ .name = try std.fmt.allocPrint(terms.allocator, "output_{d}", .{ports.items.len}), .path = path, .sort = sort, .signed = signed(target), .node = id });
}

fn sortOf(target: zx.ir.Type) !ir.Sort {
    if (values.integer(target)) |integer| return .{ .width = integer.width };
    if (target == .scalar and target.scalar == .bool) return .{ .width = 1, .boolean = true };

    return error.InvalidHardwareTerm;
}

fn signed(target: zx.ir.Type) bool {
    return if (values.integer(target)) |integer| integer.signed else false;
}

fn diagnostic(message: []const u8) zx.Diagnostic {
    return .{ .code = .unsupported, .span = .{ .start = 0, .end = 0 }, .message = message };
}
