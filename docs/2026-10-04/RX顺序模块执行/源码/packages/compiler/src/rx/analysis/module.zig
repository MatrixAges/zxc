const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("call/target.zig");
const Graph = @import("inference/types.zig");
const Expression = @import("inference/expression.zig");
const paths = @import("frontend").binding_path;

pub const Options = struct {
    owner: []const u8,
    module: rx.ast.Node,
    sources: []const frontend.project.Source,
    project: frontend.project.Options = .{ .entry = "" },
};

pub const Call = struct { callee: zx.ir.Program, argument: zx.ir.Program, out: ?[]const u8 };

pub const Contract = struct {
    program: zx.ir.Program,
    types: []const zx.ir.Type,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    calls: []const Call,
    result: ?zx.ir.Program,
    native_modules: []const zx.ir.NativeModule,
};

pub const Value = union(enum) { contract: Contract, diagnostic: target.Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const Loaded = struct { node: rx.ast.Node, function: target.Function };
pub const Binding = struct { name: []const u8, type_id: zx.ir.TypeId };

pub fn infer(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try inferIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn inferIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var checked = try rx.validate(allocator, options.owner, options.module);

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failure(allocator, .{ .path = options.owner, .location = issue.location, .code = @tagName(issue.code), .message = issue.message });
    }

    if (!std.mem.eql(u8, options.module.name, "Module")) return failure(allocator, .{ .path = options.owner, .location = options.module.location, .code = "module", .message = "module inference requires an ordinary RX Module" });

    var calls: std.ArrayList(Loaded) = .empty;
    var returned: ?rx.ast.Attribute = null;
    var project = options.project;

    for (options.module.children) |node| {
        if (returned != null) return failure(allocator, .{ .path = options.owner, .location = node.location, .code = "return_path", .message = "steps after Return are unreachable" });

        if (std.mem.eql(u8, node.name, "Return")) {
            returned = target.attribute(node, "value");

            continue;
        }

        if (!std.mem.eql(u8, node.name, "Call")) return failure(allocator, .{ .path = options.owner, .location = node.location, .code = "unsupported", .message = "this inference entry currently supports sequential Call.fn and Return steps" });

        const loaded = try target.load(allocator, .{ .owner = options.owner, .call = node, .sources = options.sources, .project = project });

        if (loaded.value == .diagnostic) return .{ .diagnostic = loaded.value.diagnostic };

        const function = loaded.value.function;
        project.context.types = function.program.types;
        project.context.nominal_types = function.nominal_types;

        try calls.append(allocator, .{ .node = node, .function = function });
    }

    var reporter: zx.Reporter = .{};
    var graph = Graph.init(allocator, &reporter, project.context.types) catch |err| return report(allocator, options, reporter, err);
    const input = graph.add(.unknown, .{ .start = options.module.location.offset, .end = options.module.location.offset }) catch |err| return report(allocator, options, reporter, err);
    const placeholder = rx.ast.Attribute{ .name = "", .value = "", .location = options.module.location, .value_location = options.module.location };
    var expression = Expression{ .graph = &graph, .input = input, .attribute = placeholder };
    var output_bindings: std.ArrayList(Binding) = .empty;

    for (calls.items) |call| {
        const attribute = target.attribute(call.node, "in");
        const parsed = try frontend.parseExpression(allocator, attribute.value, options.owner);

        if (parsed.value == .diagnostic) return parseFailure(allocator, options.owner, attribute, parsed.value.diagnostic);

        expression.attribute = attribute;
        const expected = graph.known(call.function.program.input_type, expression.sourceSpan(parsed.value.parsed.expression.span)) catch |err| return report(allocator, options, reporter, err);
        _ = expression.infer(parsed.value.parsed.expression, expected) catch |err| return report(allocator, options, reporter, err);

        for (call.node.attributes) |out| {
            if (!std.mem.eql(u8, out.name, "out")) continue;
            if (!paths.valid(out.value) or paths.overlaps(out.value, "$in")) return failure(allocator, .{ .path = options.owner, .location = out.value_location, .code = "name", .message = "Call.out requires a result binding path distinct from the module input" });
            if (call.function.program.output_type == @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)))) return failure(allocator, .{ .path = options.owner, .location = out.value_location, .code = "type_mismatch", .message = "void call results cannot be bound" });

            for (output_bindings.items) |binding| {
                if (paths.overlaps(binding.name, out.value)) return failure(allocator, .{ .path = options.owner, .location = out.value_location, .code = "name", .message = "flow result binding paths must not overlap" });
            }

            const name = try allocator.dupe(u8, out.value);
            const value = graph.known(call.function.program.output_type, .{ .start = out.value_location.offset, .end = out.value_location.offset }) catch |err| return report(allocator, options, reporter, err);

            try expression.bindings.append(allocator, .{ .name = name, .value = value });
            try output_bindings.append(allocator, .{ .name = name, .type_id = call.function.program.output_type });
        }
    }

    var output: ?Graph.Id = null;

    if (returned) |attribute| {
        const parsed = try frontend.parseExpression(allocator, attribute.value, options.owner);

        if (parsed.value == .diagnostic) return parseFailure(allocator, options.owner, attribute, parsed.value.diagnostic);

        expression.attribute = attribute;
        output = expression.infer(parsed.value.parsed.expression, null) catch |err| return report(allocator, options, reporter, err);
    }

    graph.finish() catch |err| return report(allocator, options, reporter, err);

    const input_type = if (expression.input_used) graph.resolve(input) catch |err| return report(allocator, options, reporter, err) else @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)));
    const output_type = if (output) |id| graph.resolve(id) catch |err| return report(allocator, options, reporter, err) else @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)));

    return @import("module_compile.zig").compile(allocator, .{ .owner = options.owner, .module = options.module, .calls = calls.items, .returned = returned, .bindings = output_bindings.items, .types = graph.types.items.items, .nominal_types = project.context.nominal_types, .input_type = input_type, .output_type = output_type });
}

fn parseFailure(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute, issue: zx.Diagnostic) std.mem.Allocator.Error!Value {
    return failure(allocator, .{ .path = owner, .location = rx.attributeLocation(attribute, issue.span.start) orelse attribute.value_location, .code = @tagName(issue.code), .message = issue.message });
}

fn report(allocator: std.mem.Allocator, options: Options, reporter: zx.Reporter, err: zx.Error) std.mem.Allocator.Error!Value {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    const issue = reporter.diagnostic.?;
    const location = locate(options.module, issue.span.start) orelse options.module.location;

    return failure(allocator, .{ .path = options.owner, .location = location, .code = @tagName(issue.code), .message = issue.message });
}

pub fn locate(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    for (node.attributes) |attribute| {
        const source = attribute.raw_value orelse continue;
        const start = attribute.value_location.offset;

        if (offset < start or offset > start + source.len) continue;

        const position = zx.source.locate(source, offset - start);

        return .{ .offset = offset, .line = attribute.value_location.line + position.line - 1, .column = if (position.line == 1) attribute.value_location.column + position.column - 1 else position.column };
    }

    for (node.children) |child| {
        if (locate(child, offset)) |location| return location;
    }

    return null;
}

fn failure(allocator: std.mem.Allocator, issue: target.Diagnostic) std.mem.Allocator.Error!Value {
    const value = try target.failure(allocator, issue);

    return .{ .diagnostic = value.diagnostic };
}
