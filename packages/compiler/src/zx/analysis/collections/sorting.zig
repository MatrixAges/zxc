const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");
const Builder = @import("builder.zig");
const Options = @import("lower.zig").Options;

pub fn lower(analyzer: *Analyzer, options: Options) zx.Error!ir.ExprId {
    const builder = Builder{ .analyzer = analyzer, .span = options.span };
    const list_type = analyzer.node(options.target).type_id;
    const element_type = analyzer.types.get(list_type).list;
    const values = try analyzer.allocator.alloc(ir.ExprId, options.callback.captures.len);

    for (values, options.callback.captures) |*value, capture| value.* = capture.value;

    const environment = try builder.tuple(values);
    const parameter = try builder.symbol("$sort_context", analyzer.node(environment).type_id);
    const context = try builder.reference(parameter);
    const bindings = try analyzer.allocator.alloc(ir.ScopeBinding, values.len);

    for (bindings, options.callback.captures, 0..) |*binding, capture, index| {
        const value = try builder.expression(analyzer.symbols.at(@backingInt(capture.target)).type_id, .{ .tuple_field = .{ .target = context, .index = @intCast(index) } });

        binding.* = .{ .symbol = capture.target, .value = value, .borrow = true };
    }

    const body = try builder.expression(analyzer.node(options.callback.body).type_id, .{ .scope = .{ .bindings = bindings, .result = options.callback.body } });
    const parameters = try analyzer.allocator.alloc(ir.SymbolId, 3);

    for (parameters[0..2], 0..) |*symbol, index| symbol.* = if (index < options.callback.parameters.len) options.callback.parameters[index] else try builder.symbol(if (index == 0) "$sort_left" else "$sort_right", element_type);

    parameters[2] = parameter;

    const sorted = try builder.expression(list_type, .{ .transform = .{ .kind = .sort, .target = options.target, .parameters = parameters, .body = body, .initial = environment } });
    const result_symbol = try builder.symbol("$sort_result", list_type);
    const value = try builder.reference(result_symbol);
    const unit = try builder.expression(Types.scalarId(.void), .unit);
    const result = if (options.projection) |slot| (if (slot == 0) value else unit) else try builder.tuple(&.{ value, unit });

    return builder.expression(analyzer.node(result).type_id, .{ .scope = .{ .bindings = try analyzer.allocator.dupe(ir.ScopeBinding, &.{.{ .symbol = result_symbol, .value = sorted }}), .result = result } });
}
