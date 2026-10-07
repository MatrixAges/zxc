const ir = @import("../ir.zig");
const model = @import("model.zig");

pub fn expression(table: *const model.Table, index: usize) @import("row.zig").Expression {
    const payload = table.payloads[index];

    const value: @FieldType(@import("row.zig").Expression, "value") = switch (table.kinds[index]) {
        .None => .none,
        .Unit => .unit,
        .Integer => .{ .integer = table.integers[payload] },
        .NegativeInteger => .{ .negative_integer = table.negative_integers[payload] },
        .Float => .{ .float = table.floats[payload] },
        .String => .{ .string = table.strings[payload] },
        .Boolean => .{ .boolean = table.booleans[payload] },
        .Some => .{ .some = @fromBackingInt(table.some[payload]) },
        .Capture => .{ .capture = @fromBackingInt(table.captures[payload]) },
        .AwaitTask => .{ .await_task = @fromBackingInt(table.awaits[payload]) },
        .CancelTask => .{ .cancel_task = @fromBackingInt(table.cancellations[payload]) },
        .OptionalValue => .{ .optional_value = @fromBackingInt(table.optional_values[payload]) },
        .EnumValue => .{ .enum_value = table.enumerations[payload] },
        .ErrorValue => .{ .error_value = table.errors[payload] },
        .Reference => .{ .reference = @fromBackingInt(table.references[payload]) },
        .StoreGet => .{ .store_get = table.stores[payload] },
        .Length => .{ .length = @fromBackingInt(table.lengths[payload]) },
        .List => .{ .list = ids(ir.ExprId, table.sequence_items, table.sequence_first[payload], table.sequence_count[payload]) },
        .Tuple => .{ .tuple = ids(ir.ExprId, table.sequence_items, table.sequence_first[payload], table.sequence_count[payload]) },
        .Template => .{ .template = ids(ir.ExprId, table.sequence_items, table.sequence_first[payload], table.sequence_count[payload]) },
        .Field => .{ .field = .{ .target = @fromBackingInt(table.projection_targets[payload]), .index = table.projection_indices[payload] } },
        .TupleField => .{ .tuple_field = .{ .target = @fromBackingInt(table.projection_targets[payload]), .index = table.projection_indices[payload] } },
        .Index => .{ .index = .{ .target = @fromBackingInt(table.index_targets[payload]), .index = @fromBackingInt(table.index_values[payload]) } },
        .Task => .{ .task = .{ .body = @fromBackingInt(table.task_bodies[payload]), .captures = ids(ir.SymbolId, table.task_captures, table.task_capture_first[payload], table.task_capture_count[payload]) } },
        .Parallel => blk: {
            const first = table.parallel_first[payload];
            const count = table.parallel_count[payload];

            break :blk .{ .parallel = .{ .tasks = table.parallel_tasks[first..][0..count], .fields = table.parallel_fields[first..][0..count], .len = count } };
        },
        .ListOperation => .{ .list_operation = .{ .kind = reverse(ir.ListOperation, table.collection_kinds[payload]), .target = @fromBackingInt(table.collection_targets[payload]), .arguments = ids(ir.ExprId, table.collection_arguments, table.collection_first[payload], table.collection_count[payload]) } },
        .Transform => .{ .transform = .{ .kind = reverse(@FieldType(ir.Transform, "kind"), table.transform_kinds[payload]), .target = @fromBackingInt(table.transform_targets[payload]), .parameters = ids(ir.SymbolId, table.transform_parameters, table.transform_first[payload], table.transform_count[payload]), .body = @fromBackingInt(table.transform_bodies[payload]), .initial = if (table.transform_initials[payload]) |id| @fromBackingInt(id) else null } },
        .Scope => blk: {
            const first = table.scope_first[payload];
            const count = table.scope_count[payload];
            const bindings = @import("views.zig").Bindings{ .symbols = table.scope_symbols[first..][0..count], .values = table.scope_values[first..][0..count], .borrows = table.scope_borrows[first..][0..count], .len = count };

            break :blk .{ .scope = .{ .bindings = bindings, .result = @fromBackingInt(table.scope_results[payload]) } };
        },
        .Iteration => .{ .iteration = .{ .initial = @fromBackingInt(table.iteration_initials[payload]), .condition_parameter = @fromBackingInt(table.iteration_condition_parameters[payload]), .parameter = @fromBackingInt(table.iteration_parameters[payload]), .condition = @fromBackingInt(table.iteration_conditions[payload]), .body = @fromBackingInt(table.iteration_bodies[payload]), .postcondition = table.iteration_postconditions[payload] } },
        .ListUpdate => .{ .list_update = .{ .target = @fromBackingInt(table.update_targets[payload]), .index = @fromBackingInt(table.update_indices[payload]), .value = @fromBackingInt(table.update_values[payload]) } },
        .Call => .{ .call = .{ .function = @fromBackingInt(table.call_functions[payload]), .argument = @fromBackingInt(table.call_arguments[payload]), .stores = table.call_stores[table.call_store_first[payload]..][0..table.call_store_count[payload]] } },
        .Unary => .{ .unary = .{ .operator = reverse(@FieldType(@FieldType(@FieldType(ir.Expression, "value"), "unary"), "operator"), table.unary_operators[payload]), .operand = @fromBackingInt(table.unary_operands[payload]) } },
        .Binary => .{ .binary = .{ .operator = reverse(ir.Operator, table.binary_operators[payload]), .left = @fromBackingInt(table.binary_left[payload]), .right = @fromBackingInt(table.binary_right[payload]) } },
        .Conditional => .{ .conditional = .{ .condition = @fromBackingInt(table.conditional_conditions[payload]), .yes = @fromBackingInt(table.conditional_yes[payload]), .no = @fromBackingInt(table.conditional_no[payload]) } },
        .Match => blk: {
            const first = table.match_first[payload];
            const count = table.match_count[payload];
            const arms = @import("views.zig").MatchArms{ .conditions = table.match_conditions[first..][0..count], .results = table.match_results[first..][0..count], .len = count };

            break :blk .{ .match_expr = .{ .subject = if (table.match_subjects[payload]) |id| @fromBackingInt(id) else null, .arms = arms, .fallback = @fromBackingInt(table.match_fallbacks[payload]) } };
        },
        .Object => blk: {
            const first = table.object_first[payload];
            const count = table.object_count[payload];
            const fields = @import("views.zig").ObjectFields{ .indices = table.object_field_indices[first..][0..count], .values = table.object_field_values[first..][0..count], .len = count };

            break :blk .{ .object = .{ .fields = fields, .evaluation = ids(ir.ExprId, table.object_evaluation_values, table.object_evaluation_first[payload], table.object_evaluation_count[payload]) } };
        },
    };

    return .{ .type_id = @fromBackingInt(table.types[index]), .span = .{ .start = @intCast(table.span_start[index]), .end = @intCast(table.span_end[index]) }, .value = value };
}

fn ids(comptime Id: type, values: []const u32, first: u32, count: u32) []const Id {
    if (@sizeOf(Id) != @sizeOf(u32) or @alignOf(Id) != @alignOf(u32)) @compileError("Incompatible ID representation");

    return @as([*]const Id, @ptrCast(values.ptr))[first..][0..count];
}

fn reverse(comptime Target: type, value: anytype) Target {
    inline for (@typeInfo(Target).@"enum".field_names) |name| {
        if (@import("enumeration.zig").convert(@TypeOf(value), @field(Target, name)) == value) return @field(Target, name);
    }

    unreachable;
}
