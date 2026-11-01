const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../collections/builder.zig");
const Types = @import("../types.zig");
const value = @import("value.zig");
const Operation = @import("../utilities.zig").Operation;

pub fn lower(builder: Builder, operation: Operation, values: []const ir.ExprId) zx.Error!ir.ExprId {
    const analyzer = builder.analyzer;
    const source = values[0];
    const list_type = analyzer.node(source).type_id;
    const element_type = analyzer.types.get(list_type).list;
    const length = try builder.expression(Types.scalarId(.u64), .{ .length = source });
    const count = values[1];
    const bounded = try value.choice(builder, try value.binary(builder, .less, count, length), count, length);
    const remaining = try value.binary(builder, .subtract, length, bounded);
    const zero = try builder.integer(0);

    const start = switch (operation) {
        .take, .dropRight => zero,
        .takeRight => remaining,
        else => bounded,
    };

    const end = switch (operation) {
        .take => bounded,
        .dropRight => remaining,
        else => length,
    };

    const initial = try builder.object(&.{
        .{ .name = "source", .value = source },
        .{ .name = "index", .value = start },
        .{ .name = "end", .value = end },
        .{ .name = "result", .value = try builder.expression(list_type, .{ .list = &.{} }) },
    });

    const state_type = analyzer.node(initial).type_id;
    const condition_parameter = try builder.symbol("$collection_condition", state_type);
    const parameter = try builder.symbol("$collection_state", state_type);

    analyzer.symbols.ownership.items[@backingInt(condition_parameter)] = .Borrowed;
    analyzer.symbols.ownership.items[@backingInt(parameter)] = .Borrowed;

    const condition_state = try builder.reference(condition_parameter);
    const condition = try value.binary(builder, .less, try builder.field(condition_state, "index"), try builder.field(condition_state, "end"));
    const current = try builder.reference(parameter);
    const original = try builder.field(current, "source");
    const index = try builder.field(current, "index");
    const element = try builder.expression(element_type, .{ .index = .{ .target = original, .index = index } });

    const body = try builder.object(&.{
        .{ .name = "source", .value = original },
        .{ .name = "index", .value = try value.binary(builder, .add, index, try builder.integer(1)) },
        .{ .name = "end", .value = try builder.field(current, "end") },
        .{ .name = "result", .value = try builder.push(try builder.field(current, "result"), element) },
    });

    const iteration = try builder.expression(state_type, .{ .iteration = .{
        .initial = initial,
        .condition_parameter = condition_parameter,
        .parameter = parameter,
        .condition = condition,
        .body = body,
        .postcondition = false,
    } });

    const result = try builder.symbol("$collection_result", state_type);

    return builder.expression(list_type, .{ .scope = .{
        .bindings = try analyzer.allocator.dupe(ir.ScopeBinding, &.{.{ .symbol = result, .value = iteration }}),
        .result = try builder.field(try builder.reference(result), "result"),
    } });
}
