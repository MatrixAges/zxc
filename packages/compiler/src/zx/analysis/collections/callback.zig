const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Captures = @import("captures.zig");

pub const Result = struct { parameters: []const ir.SymbolId, captures: []const Captures.Binding, body: ir.ExprId };

pub fn analyze(analyzer: *Analyzer, source: anytype, parameter_types: []const ir.TypeId, expected: ?ir.TypeId) zx.Error!Result {
    if (syntax.value(source) != .lambda) return analyzer.reporter.fail(.type_mismatch, source.span, "collection callback must be an inline lambda");

    const lambda = syntax.value(source).lambda;

    if (lambda.parameters.len > parameter_types.len) return analyzer.reporter.fail(.type_mismatch, source.span, "too many collection callback parameters");

    const start = analyzer.active.items.len;
    const floor = analyzer.scope_floor;
    const parent = analyzer.collection_captures;
    var captures = Captures{ .start = start, .floor = floor, .parent = parent };

    analyzer.scope_floor = start;
    analyzer.collection_captures = &captures;
    analyzer.lambda_depth += 1;

    defer {
        analyzer.active.shrinkRetainingCapacity(start);

        analyzer.scope_floor = floor;
        analyzer.collection_captures = parent;
        analyzer.lambda_depth -= 1;
    }

    const parameters = try analyzer.allocator.alloc(ir.SymbolId, lambda.parameters.len);

    for (parameters, 0..) |*parameter, index| {
        parameter.* = try analyzer.bind(syntax.item(lambda.parameters, index), parameter_types[index], start);

        analyzer.symbols.ownership.items[@backingInt(parameter.*)] = if (try analyzer.types.containsList(parameter_types[index])) .Borrowed else .Copy;
    }

    const body = try analyzer.expression(lambda.body, expected);

    return .{ .parameters = parameters, .captures = try captures.bindings.toOwnedSlice(analyzer.allocator), .body = body };
}
