const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Parsed = @import("../frontend/parse_expression.zig").Parsed;
const Analyzer = @import("analyzer.zig");
pub const compile = @import("expression_program.zig").compile;
pub const compileForLinking = @import("expression_program.zig").compileForLinking;
pub const Binding = struct { name: []const u8, type_id: ir.TypeId };
pub const Options = struct { types: []const ir.Type = &.{}, bindings: []const Binding = &.{}, unit_bindings: []const []const u8 = &.{}, expected: ?ir.TypeId = null };
pub const Expression = struct { types: []const ir.Type, symbols: []const ir.Symbol, expressions: []const ir.Expression, value: ir.ExprId };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { expression: Expression, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn analyze(allocator: std.mem.Allocator, parsed: Parsed, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: zx.Reporter = .{};

    const expression = analyzeIn(arena.allocator(), parsed, options, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .expression = expression } };
}

fn analyzeIn(allocator: std.mem.Allocator, parsed: Parsed, options: Options, reporter: *zx.Reporter) zx.Error!Expression {
    if (options.types.len != 0 and !@import("../ir/type_rules.zig").validate(options.types)) return reporter.fail(.contract, parsed.expression.span, "invalid shared type table");

    var analyzer = Analyzer{
        .allocator = allocator,
        .reporter = reporter,
        .types = .{ .allocator = allocator, .reporter = reporter, .declarations = &.{} },
    };

    try analyzer.types.items.appendSlice(allocator, try @import("type_table.zig").copy(allocator, options.types));
    try analyzer.types.initialize();
    for (options.unit_bindings) |name| try @import("expression_binding.zig").bindUnit(&analyzer, .{ .text = name, .span = parsed.expression.span });

    for (options.bindings) |binding| {
        if (@intFromEnum(binding.type_id) >= analyzer.types.items.items.len) return reporter.fail(.contract, parsed.expression.span, "expression binding type is missing from the shared type table");
        try @import("expression_binding.zig").bind(&analyzer, .{ .text = binding.name, .span = parsed.expression.span }, binding.type_id);
    }

    if (options.expected) |expected| {
        if (@intFromEnum(expected) >= analyzer.types.items.items.len) return reporter.fail(.contract, parsed.expression.span, "expected type is missing from the shared type table");
    }

    const value = try analyzer.expression(parsed.expression, options.expected);

    return .{
        .types = try analyzer.types.items.toOwnedSlice(allocator),
        .symbols = try analyzer.symbols.toOwnedSlice(allocator),
        .expressions = try analyzer.nodes.toOwnedSlice(allocator),
        .value = value,
    };
}
