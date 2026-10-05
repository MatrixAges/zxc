const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Parsed = @import("../frontend/parse_expression.zig").Parsed;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");
const Options = @import("expression.zig").Options;
const Result = @import("analyze.zig").Result;

pub fn compile(allocator: std.mem.Allocator, parsed: Parsed, options: Options) std.mem.Allocator.Error!Result {
    return compileStage(allocator, parsed, options, false);
}

pub fn compileForLinking(allocator: std.mem.Allocator, parsed: Parsed, options: Options) std.mem.Allocator.Error!Result {
    return compileStage(allocator, parsed, options, true);
}

fn compileStage(allocator: std.mem.Allocator, parsed: Parsed, options: Options, comptime linking: bool) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: zx.Reporter = .{};

    const program = build(arena.allocator(), parsed, options, &reporter, linking) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program } };
}

fn build(allocator: std.mem.Allocator, parsed: Parsed, options: Options, reporter: *zx.Reporter, comptime linking: bool) zx.Error!ir.Program {
    const span = parsed.expression.span;

    if (options.types.len != 0 and !@import("../ir/type_rules.zig").validate(options.types)) return reporter.fail(.contract, span, "invalid shared type table");

    var analyzer = Analyzer{
        .allocator = allocator,
        .reporter = reporter,
        .types = .{ .allocator = allocator, .reporter = reporter, .declarations = &.{} },
    };

    try analyzer.types.items.appendSlice(allocator, try @import("type_table.zig").copy(allocator, options.types));
    try analyzer.types.initialize();

    const children = try allocator.alloc(ir.TypeId, options.bindings.len);

    for (options.bindings, children) |binding, *child| {
        if (@intFromEnum(binding.type_id) >= analyzer.types.items.items.len) return reporter.fail(.contract, span, "expression binding type is missing from the shared type table");

        child.* = binding.type_id;
    }

    if (options.expected) |expected| {
        if (@intFromEnum(expected) >= analyzer.types.items.items.len) return reporter.fail(.contract, span, "expected type is missing from the shared type table");
    }

    const input_type = if (children.len == 0) Types.scalarId(.void) else try analyzer.types.tuple(children);
    const input_symbol = try analyzer.bind(.{ .text = "@environment", .span = span }, input_type, 0);
    const input = try analyzer.append(.{ .span = span, .type_id = input_type, .value = .{ .reference = input_symbol } });
    var body: std.ArrayList(ir.Statement) = .empty;

    for (options.unit_bindings) |name| try @import("expression_binding.zig").bindUnit(&analyzer, .{ .text = name, .span = span });

    for (options.bindings, 0..) |binding, index| {
        try @import("expression_binding.zig").bind(&analyzer, .{ .text = binding.name, .span = span }, binding.type_id);

        const symbol = analyzer.expression_bindings.items[index];
        const value = try analyzer.append(.{ .span = span, .type_id = binding.type_id, .value = .{ .tuple_field = .{ .target = input, .index = @intCast(index) } } });

        try body.append(allocator, .{ .constant = .{ .symbol = symbol, .value = value } });
    }

    const result = try analyzer.expression(parsed.expression, options.expected);
    const output_type = analyzer.node(result).type_id;

    try body.append(allocator, .{ .result = result });

    var program = ir.Program{
        .file_name = try allocator.dupe(u8, parsed.file_name),
        .types = try analyzer.types.items.toOwnedSlice(allocator),
        .symbols = try analyzer.symbols.toOwnedSlice(allocator),
        .expressions = try analyzer.nodes.toOwnedSlice(allocator),
        .input_type = input_type,
        .output_type = output_type,
        .body = try body.toOwnedSlice(allocator),
    };

    if (!linking) program.output_ownership = try @import("../ownership/check.zig").analyze(allocator, program, reporter);

    return program;
}
