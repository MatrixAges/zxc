const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const collections = @import("../collections.zig");

pub fn lower(self: *Context, id: ir.ExprId) Lower.Error!?node.ExpressionId {
    const lowering = self.lowering;
    const plan = select(self, id);

    switch (plan.route) {
        .Argument => return self.argument.?.value,
        .Cached => {
            try self.reads.increment(lowering.allocator, id);

            return @fromBackingInt(plan.value.?);
        },
        .Fallback => return null,
        .Unpack => return try unpack(self, id),
        else => {},
    }

    const value = lowering.program.expression(id);

    return try switch (plan.route) {
        .Reference => reference(lowering, value.value.reference),
        .Field => field(lowering, value.value.field),
        .Unwrap => lowering.builder.expression(.{ .optional_unwrap = try lowering.expr(value.value.optional_value) }),
        .TupleField => tuple(lowering, value.value.tuple_field),
        .Scope => @import("scope.zig").lower(self, value.value.scope),
        .Index => index(lowering, value.value.index.target, value.value.index.index),
        .Length => length(lowering, value.type_id, value.value.length),
        .Update => @import("mutation.zig").update(self, id),
        .Mutation => @import("mutation.zig").operation(self, id),
        .List => @import("list.zig").lower(self, value.type_id, value.value.list),
        .Call => @import("invocation.zig").lower(self, id, value.value.call.argument),
        .None => lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.builder.expression(.null_value)),
        .Some => lowering.cast(try @import("types.zig").get(self, value.type_id), try lowering.expr(value.value.some)),
        .Binary => lowering.regular(id),
        .Aggregate => @import("aggregate.zig").lower(self, id),
        .Collection => collections.lowerValue(lowering, id, try @import("types.zig").get(self, value.type_id)),
        .Conditional => conditional(lowering, value.value.conditional),
        .Match => @import("../match.zig").lower(lowering, value.value.match_expr),
        else => unreachable,
    };
}

const entry = @import("generated_iteration_evaluation");
const Plan = @typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload;

fn select(self: *const Context, id: ir.ExprId) Plan {
    const Input = std.meta.Child(entry.Input);
    const lowering = self.lowering;
    const program: *const ir.Program = &lowering.program;
    const expressions = zx.columns.borrow(std.meta.Child(@FieldType(Input, "expressions")), &program.expressions);
    const Cache = std.meta.Child(@FieldType(Input, "cache"));
    const cache = self.cache.view(Cache);
    const regular = lowering.cache.view(std.meta.Child(@FieldType(Input, "regular")));
    const symbols = self.symbols.view(std.meta.Child(@FieldType(Input, "symbols")));

    const input: Input = .{
        .expressions = &expressions,
        .type_kinds = program.types.kinds,
        .layouts = zx.columns.slice(@FieldType(Input, "layouts"), lowering.layout_types),
        .inline_lists = self.inline_lists,
        .cache = &cache,
        .regular = &regular,
        .symbols = &symbols,
        .argument = if (self.argument) |argument| @backingInt(argument.id) else null,
        .id = @backingInt(id),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch unreachable;
}

fn reference(lowering: *Lower, symbol: ir.SymbolId) Lower.Error!node.ExpressionId {
    const row = @backingInt(symbol);

    lowering.used[row] = true;

    return lowering.builder.identifier(lowering.names[row]);
}

fn field(lowering: *Lower, item: ir.Projection) Lower.Error!node.ExpressionId {
    const target = try lowering.expr(item.target);
    const target_type = lowering.program.expression(item.target).type_id;
    const name = lowering.program.typeOf(target_type).object.at(item.index).name;

    return lowering.field(target, name);
}

fn tuple(lowering: *Lower, item: ir.Projection) Lower.Error!node.ExpressionId {
    if (try collections.projection(lowering, item.target, item.index)) |selected| return selected;

    const target = try lowering.expr(item.target);
    const name = try std.fmt.allocPrint(lowering.allocator, "{d}", .{item.index});

    return lowering.field(target, name);
}

fn index(lowering: *Lower, target: ir.ExprId, key: ir.ExprId) Lower.Error!node.ExpressionId {
    const items = try lowering.field(try lowering.expr(target), "items");

    return @import("../intrinsics.zig").index(lowering, items, try lowering.expr(key));
}

fn length(lowering: *Lower, type_id: ir.TypeId, child: ir.ExprId) Lower.Error!node.ExpressionId {
    const type_expr = try lowering.typeExpr(type_id);
    const items = try lowering.field(try lowering.expr(child), "items");

    return lowering.cast(type_expr, try lowering.field(items, "len"));
}

fn conditional(lowering: *Lower, selected: @FieldType(@FieldType(ir.ExpressionRow, "value"), "conditional")) Lower.Error!node.ExpressionId {
    return lowering.builder.expression(.{ .conditional = .{
        .condition = try lowering.expr(selected.condition),
        .yes = try lowering.expr(selected.yes),
        .no = try lowering.expr(selected.no),
    } });
}

pub fn unpack(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;
    const value = try aggregate.bind(lowering, &body, try lowering.regular(id));

    return aggregate.finish(lowering, &body, try @import("conversion.zig").convert(self, lowering.program.expression(id).type_id, value, false));
}
