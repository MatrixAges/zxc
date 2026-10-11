const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

/// List growth emitted into generated code: an append allocates a buffer with a header recording its capacity and the
/// length of the furthest value built on it. Appending to a value at that frontier writes in place and moves the
/// frontier; any other value copies, so older values never see the write. Only the values the uniqueness plan proves
/// headered are checked, and a pop of a unique headered value hands the frontier back. A loop whose state must own a
/// list renews it once on entry, copying the records on the way so the loop never writes into its initial value.
pub fn declarations(self: *Lower, exported: bool) Lower.Error![4]node.Declaration {
    var emitter = Emitter{ .lowering = self };

    return .{
        .{ .constant = .{ .name = "ZxHeader", .value = try emitter.header(), .exported = exported } },
        .{ .function = try emitter.reserve(exported) },
        .{ .function = try emitter.retract(exported) },
        .{ .function = try emitter.renew(exported) },
    };
}

/// Gives the list at `path` of a loop state variable its own growth buffer: `try zxRenew(allocator, &state, &.{...})`
/// with one field name and record origin name per record on the way.
pub fn renew(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, state: node.ExpressionId, path: []const u32) Lower.Error!void {
    const steps = try self.allocator.alloc(node.ExpressionId, path.len);
    const text = try self.builder.expression(.{ .const_slice = try self.builder.expression(.{ .primitive = .u8 }) });
    var current = type_id;

    for (path, steps) |step, *item| {
        while (self.program.typeOf(current) == .optional) current = self.program.typeOf(current).optional;

        const member: struct { name: []const u8, type_id: ir.TypeId } = switch (self.program.typeOf(current)) {
            .object => |fields| .{ .name = fields.at(step).name, .type_id = fields.at(step).type_id },
            .tuple => |items| .{ .name = try std.fmt.allocPrint(self.allocator, "{d}", .{step}), .type_id = items.at(step) },
            else => unreachable,
        };

        item.* = try self.builder.expression(.{ .tuple = try self.allocator.dupe(node.ExpressionId, &.{ try self.builder.string(member.name), try self.builder.string(try @import("state_value/origin.zig").name(self, current)) }) });
        current = member.type_id;
    }

    const pair = try self.builder.expression(.{ .fixed_array_type = .{ .length = try self.builder.integer(2), .element = text } });
    const names = try self.builder.expression(.{ .address_of = try self.builder.expression(.{ .array = .{ .element_type = pair, .values = steps } }) });

    try body.append(self.allocator, .{ .expression = try self.call(try reference(self, "zxRenew"), &.{ try self.builder.identifier("allocator"), try self.builder.expression(.{ .address_of = state }), names }, true) });
}

/// A growable buffer of `count` elements holding `source` as its prefix; `frontier` reuses a headered source in place.
pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const arguments = [_]node.ExpressionId{ element, try self.builder.identifier("allocator"), source, count, try self.builder.expression(.{ .boolean = frontier }) };

    return aggregate.bind(self, body, try self.call(try reference(self, "zxReserve"), &arguments, true));
}

/// One growth copy of a plain list the plan found flowing into appends, so they extend it in place from then on.
pub fn normalize(self: *Lower, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const child = self.program.typeOf(self.program.expression(id).type_id).list;
    const element = try @import("iteration_value/types.zig").element(self, child);
    const source = try aggregate.bind(self, &body, value);
    const buffer = try reserve(self, &body, element, source, try self.field(source, "len"), false);

    return aggregate.finish(self, &body, buffer);
}

pub fn retract(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, length: node.ExpressionId) Lower.Error!void {
    try body.append(self.allocator, .{ .expression = try self.call(try reference(self, "zxRetract"), &.{ element, source, length }, false) });
}

fn reference(self: *Lower, name: []const u8) Lower.Error!node.ExpressionId {
    if (self.shared_types) return self.field(try self.builder.identifier("zx_abi"), name);

    return self.builder.identifier(name);
}

const Emitter = struct {
    lowering: *Lower,

    fn header(self: Emitter) Lower.Error!node.ExpressionId {
        const size = try self.primitive(.usize);

        return self.lowering.builder.expression(.{ .struct_type = try self.lowering.allocator.dupe(node.Field, &.{
            .{ .name = "capacity", .value = size },
            .{ .name = "committed", .value = size },
        }) });
    }

    fn reserve(self: Emitter, exported: bool) Lower.Error!node.Function {
        const lowering = self.lowering;
        const items = try self.id("items");
        const count = try self.id("count");
        const element = try self.id("T");
        const header_type = try self.headerType();
        const header_size = try lowering.builtin(.sizeOf, &.{header_type});
        const current = try self.id("current");
        const committed = try lowering.field(current, "committed");
        const at_frontier = try self.binary(.logical_and, try self.binary(.equal, committed, try lowering.field(items, "len")), try self.binary(.less_equal, count, try lowering.field(current, "capacity")));
        const reused = try lowering.builder.expression(.{ .slice = .{ .target = try lowering.builtin(.constCast, &.{try lowering.field(items, "ptr")}), .start = null, .end = count } });

        const in_place = try lowering.builder.statements(&.{
            .{ .constant = .{ .name = "current", .type_expr = try lowering.builder.expression(.{ .pointer = header_type }), .value = try self.headerOf(try lowering.builtin(.ptrCast, &.{try lowering.builtin(.constCast, &.{try lowering.field(items, "ptr")})}), header_size) } },
            try lowering.builder.branch(at_frontier, &.{
                .{ .assignment = .{ .target = committed, .value = count } },
                .{ .result = reused },
            }, &.{}),
        });

        const alignment = try lowering.call(try lowering.field(try lowering.call(try self.standard(&.{ "mem", "Alignment", "of" }), &.{element}, false), "max"), &.{try lowering.call(try self.standard(&.{ "mem", "Alignment", "of" }), &.{header_type}, false)}, false);
        const offset = try lowering.call(try lowering.field(try lowering.call(try self.standard(&.{ "mem", "Alignment", "of" }), &.{element}, false), "forward"), &.{header_size}, false);
        const capacity = try lowering.builder.expression(.{ .conditional = .{
            .condition = try self.binary(.equal, count, try lowering.builder.integer(0)),
            .yes = try lowering.builder.integer(0),
            .no = try lowering.call(try self.standard(&.{ "math", "ceilPowerOfTwoAssert" }), &.{ try self.primitive(.usize), try lowering.builtin(.max, &.{ count, try lowering.builder.integer(8) }) }, false),
        } });
        const length = try self.binary(.add, try self.id("offset"), try self.binary(.multiply, try self.id("capacity"), try lowering.builtin(.sizeOf, &.{element})));
        const bytes = try lowering.call(try lowering.field(try self.id("allocator"), "alignedAlloc"), &.{ try self.primitive(.u8), try lowering.builder.expression(.{ .comptime_value = alignment }), length }, true);
        const start = try self.binary(.add, try lowering.field(try self.id("bytes"), "ptr"), try self.id("offset"));
        const data = try self.id("data");

        const statements = [_]node.Statement{
            .{ .constant = .{ .name = "offset", .value = try lowering.builder.expression(.{ .comptime_value = offset }) } },
            try lowering.builder.branch(try self.binary(.logical_and, try self.id("frontier"), try self.binary(.not_equal, try lowering.field(items, "len"), try lowering.builder.integer(0))), &.{.{ .scope = in_place }}, &.{}),
            .{ .constant = .{ .name = "capacity", .type_expr = try self.primitive(.usize), .value = capacity } },
            .{ .constant = .{ .name = "bytes", .value = bytes } },
            .{ .constant = .{ .name = "data", .type_expr = try lowering.builder.expression(.{ .many_pointer = element }), .value = try lowering.builtin(.ptrCast, &.{try lowering.builtin(.alignCast, &.{start})}) } },
            .{ .constant = .{ .name = "fresh", .type_expr = try lowering.builder.expression(.{ .pointer = header_type }), .value = try self.headerOf(start, header_size) } },
            .{ .assignment = .{ .target = try lowering.builder.expression(.{ .dereference = try self.id("fresh") }), .value = try lowering.builder.object(&.{ .{ .name = "capacity", .value = try self.id("capacity") }, .{ .name = "committed", .value = count } }) } },
            .{ .expression = try lowering.builtin(.memcpy, &.{ try lowering.builder.expression(.{ .slice = .{ .target = data, .end = try lowering.field(items, "len") } }), items }) },
            .{ .result = try lowering.builder.expression(.{ .slice = .{ .target = data, .end = count } }) },
        };

        return .{
            .name = "zxReserve",
            .parameters = try lowering.allocator.dupe(node.Field, &.{
                .{ .name = "T", .value = try self.primitive(.type), .comptime_parameter = true },
                .{ .name = "allocator", .value = try self.standard(&.{ "mem", "Allocator" }) },
                .{ .name = "items", .value = try lowering.builder.expression(.{ .const_slice = element }) },
                .{ .name = "count", .value = try self.primitive(.usize) },
                .{ .name = "frontier", .value = try self.primitive(.bool), .comptime_parameter = true },
            }),
            .return_type = try lowering.builder.expression(.{ .error_union = .{ .payload = try lowering.builder.expression(.{ .mutable_slice = element }), .errors = &.{"OutOfMemory"} } }),
            .body = try lowering.builder.statements(&statements),
            .exported = exported,
        };
    }

    fn retract(self: Emitter, exported: bool) Lower.Error!node.Function {
        const lowering = self.lowering;
        const items = try self.id("items");
        const header_type = try self.headerType();
        const header_size = try lowering.builtin(.sizeOf, &.{header_type});
        const current = try self.headerOf(try lowering.builtin(.ptrCast, &.{try lowering.builtin(.constCast, &.{try lowering.field(items, "ptr")})}), header_size);

        const statements = [_]node.Statement{
            .{ .constant = .{ .name = "current", .type_expr = try lowering.builder.expression(.{ .pointer = header_type }), .value = current } },
            .{ .assignment = .{ .target = try lowering.field(try self.id("current"), "committed"), .value = try self.id("length") } },
        };

        return .{
            .name = "zxRetract",
            .parameters = try lowering.allocator.dupe(node.Field, &.{
                .{ .name = "T", .value = try self.primitive(.type), .comptime_parameter = true },
                .{ .name = "items", .value = try lowering.builder.expression(.{ .const_slice = try self.id("T") }) },
                .{ .name = "length", .value = try self.primitive(.usize) },
            }),
            .return_type = try self.primitive(.void),
            .body = try lowering.builder.statements(&statements),
            .exported = exported,
        };
    }

    /// Walks `path` from `target`: optionals by their payload, a record pointer by a fresh copy of the record, a record by
    /// clearing its origin and stepping into the field, and the list at the end by a growth copy.
    fn renew(self: Emitter, exported: bool) Lower.Error!node.Function {
        const lowering = self.lowering;
        const target = try self.id("target");
        const value = try lowering.builder.expression(.{ .dereference = target });
        const info = try self.id("info");
        const path = try self.id("path");
        const allocator = try self.id("allocator");
        const step = try lowering.builder.expression(.{ .index = .{ .target = path, .index = try lowering.builder.integer(0) } });
        const field_name = try lowering.builder.expression(.{ .index = .{ .target = step, .index = try lowering.builder.integer(0) } });
        const origin_name = try lowering.builder.expression(.{ .index = .{ .target = step, .index = try lowering.builder.integer(1) } });
        const child = try lowering.field(try lowering.field(info, "pointer"), "child");
        const recurse = struct {
            fn call(emitter: Emitter, argument: node.ExpressionId, rest: node.ExpressionId) Lower.Error!node.Statement {
                return .{ .expression = try emitter.lowering.call(try emitter.id("zxRenew"), &.{ try emitter.id("allocator"), argument, rest }, true) };
            }
        }.call;

        const optional = [_]node.Statement{
            .{ .branch = .{ .condition = value, .yes = try lowering.builder.statements(&.{try recurse(self, try self.id("inner"), path)}), .no = .{}, .capture = "inner", .capture_reference = true } },
        };
        const list = [_]node.Statement{
            .{ .assignment = .{ .target = value, .value = try lowering.call(try self.id("zxReserve"), &.{ child, allocator, value, try lowering.field(value, "len"), try lowering.builder.expression(.{ .boolean = false }) }, true) } },
        };
        const record = [_]node.Statement{
            .{ .constant = .{ .name = "fresh", .value = try lowering.call(try lowering.field(allocator, "create"), &.{child}, true) } },
            .{ .assignment = .{ .target = try lowering.builder.expression(.{ .dereference = try self.id("fresh") }), .value = try lowering.builder.expression(.{ .dereference = value }) } },
            try recurse(self, try self.id("fresh"), path),
            .{ .assignment = .{ .target = value, .value = try self.id("fresh") } },
        };
        const pointer = [_]node.Statement{
            try lowering.builder.branch(try self.binary(.equal, try lowering.field(try lowering.field(info, "pointer"), "size"), try lowering.builder.expression(.{ .enum_literal = "slice" })), &list, &record),
        };
        const fields = [_]node.Statement{
            try lowering.builder.branch(try lowering.builtin(.hasField, &.{ try self.id("V"), origin_name }), &.{.{ .assignment = .{ .target = try lowering.builtin(.field, &.{ value, origin_name }), .value = try lowering.builder.expression(.null_value) } }}, &.{}),
            try recurse(self, try lowering.builder.expression(.{ .address_of = try lowering.builtin(.field, &.{ value, field_name }) }), try lowering.builder.expression(.{ .slice = .{ .target = path, .start = try lowering.builder.integer(1) } })),
        };
        const nonoptional = [_]node.Statement{
            try lowering.builder.branch(try self.binary(.equal, info, try lowering.builder.expression(.{ .enum_literal = "pointer" })), &pointer, &fields),
        };
        const statements = [_]node.Statement{
            .{ .constant = .{ .name = "V", .value = try lowering.builtin(.TypeOf, &.{value}) } },
            .{ .constant = .{ .name = "info", .value = try lowering.builtin(.typeInfo, &.{try self.id("V")}) } },
            try lowering.builder.branch(try self.binary(.equal, info, try lowering.builder.expression(.{ .enum_literal = "optional" })), &optional, &nonoptional),
        };

        return .{
            .name = "zxRenew",
            .parameters = try lowering.allocator.dupe(node.Field, &.{
                .{ .name = "allocator", .value = try self.standard(&.{ "mem", "Allocator" }) },
                .{ .name = "target", .value = try self.primitive(.@"anytype") },
                .{ .name = "path", .value = try lowering.builder.expression(.{ .const_slice = try lowering.builder.expression(.{ .fixed_array_type = .{ .length = try lowering.builder.integer(2), .element = try lowering.builder.expression(.{ .const_slice = try self.primitive(.u8) }) } }) }), .comptime_parameter = true },
            }),
            .return_type = try lowering.builder.expression(.{ .error_union = .{ .payload = try self.primitive(.void), .errors = &.{"OutOfMemory"} } }),
            .body = try lowering.builder.statements(&statements),
            .exported = exported,
        };
    }

    /// The header sits right before the elements: `@ptrCast(@alignCast(@as([*]u8, start) - @sizeOf(ZxHeader)))`.
    fn headerOf(self: Emitter, start: node.ExpressionId, header_size: node.ExpressionId) Lower.Error!node.ExpressionId {
        const lowering = self.lowering;
        const bytes = try lowering.cast(try lowering.builder.expression(.{ .many_pointer = try self.primitive(.u8) }), start);

        return lowering.builtin(.ptrCast, &.{try lowering.builtin(.alignCast, &.{try self.binary(.subtract, bytes, header_size)})});
    }

    fn headerType(self: Emitter) Lower.Error!node.ExpressionId {
        return reference(self.lowering, "ZxHeader");
    }

    fn standard(self: Emitter, path: []const []const u8) Lower.Error!node.ExpressionId {
        var expression = try self.lowering.builtin(.import, &.{try self.lowering.builder.string("std")});

        for (path) |part| expression = try self.lowering.field(expression, part);

        return expression;
    }

    fn id(self: Emitter, name: []const u8) Lower.Error!node.ExpressionId {
        return self.lowering.builder.identifier(name);
    }

    fn primitive(self: Emitter, value: @FieldType(node.Expression, "primitive")) Lower.Error!node.ExpressionId {
        return self.lowering.builder.expression(.{ .primitive = value });
    }

    fn binary(self: Emitter, operator: node.BinaryOperator, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
        return self.lowering.builder.binary(operator, left, right);
    }
};
