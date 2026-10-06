const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn payload(self: *const Analyzer, expected: ?ir.TypeId) ?ir.TypeId {
    var result = expected orelse return null;

    while (self.types.get(result) == .optional) result = self.types.get(result).optional;

    return result;
}

pub fn list(self: *Analyzer, items: anytype, span: zx.Span, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const hint = payload(self, expected);
    const target = if (hint) |id| self.types.get(id) else null;
    const values = try self.allocator.alloc(ir.ExprId, items.len);

    if (target != null and target.? == .tuple) {
        const children = target.?.tuple;

        if (children.len != items.len) return self.reporter.fail(.type_mismatch, span, "tuple arity does not match the declared type");
        for (0..children.len) |index| values[index] = try self.expression(syntax.item(items, index), self.types.get(hint.?).tuple.at(index));

        return self.append(.{ .span = span, .type_id = hint.?, .value = .{ .tuple = values } });
    }

    if (target != null and target.? != .list) return self.reporter.fail(.type_mismatch, span, "a list literal requires a list or tuple type");
    if (target == null and items.len == 0) return self.reporter.fail(.type_mismatch, span, "an empty list requires a declared element type");

    var element_type: ?ir.TypeId = if (target) |value_type| value_type.list else null;

    for (0..items.len) |index| {
        const item = syntax.item(items, index);

        values[index] = try self.expression(item, element_type);

        if (element_type == null) element_type = self.node(values[index]).type_id;
    }

    const type_id = try self.types.wrap(.list, element_type.?);

    return self.append(.{ .span = span, .type_id = type_id, .value = .{ .list = values } });
}

pub fn object(self: *Analyzer, fields: anytype, span: zx.Span, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const hint = payload(self, expected);

    if (hint) |id| {
        const target = self.types.get(id);

        if (target != .object) return self.reporter.fail(.type_mismatch, span, "an object literal requires an object type");
    }

    const Entry = struct { name: []const u8, value: ir.ExprId };
    var entries: std.ArrayList(Entry) = .empty;
    var evaluation: std.ArrayList(ir.ExprId) = .empty;

    for (0..fields.len) |field_index| {
        const field = syntax.item(fields, field_index);

        if (field.spread) {
            const base = try self.expression(field.value, null);
            const base_type = self.types.get(self.node(base).type_id);

            if (base_type != .object) return self.reporter.fail(.type_mismatch, field.value.span, "only objects can be spread");
            try evaluation.append(self.allocator, base);

            for (0..base_type.object.len) |index| {
                const base_field = base_type.object.at(index);
                const value = try self.append(.{ .span = field.value.span, .type_id = base_field.type_id, .value = .{ .field = .{ .target = base, .index = @intCast(index) } } });
                var replaced = false;

                for (entries.items) |*entry| {
                    if (std.mem.eql(u8, entry.name, base_field.name)) {
                        entry.value = value;
                        replaced = true;

                        break;
                    }
                }

                if (!replaced) try entries.append(self.allocator, .{ .name = base_field.name, .value = value });
            }

            continue;
        }

        var field_type: ?ir.TypeId = null;

        if (hint) |expected_id| {
            const required_count = self.types.get(expected_id).object.len;

            for (0..required_count) |index| {
                const item = self.types.get(expected_id).object.at(index);

                if (std.mem.eql(u8, item.name, field.name.text)) field_type = item.type_id;
            }

            if (field_type == null) return self.reporter.fail(.name, field.name.span, "unexpected object field");
        }

        const value = try self.expression(field.value, field_type);

        try evaluation.append(self.allocator, value);

        var replaced = false;

        for (entries.items) |*entry| {
            if (std.mem.eql(u8, entry.name, field.name.text)) {
                entry.value = value;
                replaced = true;

                break;
            }
        }

        if (!replaced) try entries.append(self.allocator, .{ .name = field.name.text, .value = value });
    }

    if (hint) |expected_id| {
        const required_count = self.types.get(expected_id).object.len;

        for (0..required_count) |index| {
            const field = self.types.get(expected_id).object.at(index);
            var present = false;

            for (entries.items) |*entry| {
                if (std.mem.eql(u8, entry.name, field.name)) {
                    entry.value = try self.coerce(entry.value, field.type_id, span);
                    present = true;

                    break;
                }
            }

            if (!present) {
                if (self.types.get(field.type_id) != .optional) return self.reporter.fail(.type_mismatch, span, "missing required object field");

                const value = try self.append(.{ .span = span, .type_id = field.type_id, .value = .none });

                try entries.append(self.allocator, .{ .name = field.name, .value = value });
                try evaluation.append(self.allocator, value);
            }
        }

        if (entries.items.len != required_count) return self.reporter.fail(.type_mismatch, span, "spread introduces fields outside the required object type");
    }

    const type_fields = try @import("types.zig").Fields.init(self.allocator, entries.items.len);

    for (entries.items, 0..) |entry, index| type_fields.set(index, try self.allocator.dupe(u8, entry.name), self.node(entry.value).type_id);

    const type_id = try self.types.object(type_fields);
    const output_fields = try self.allocator.alloc(ir.ObjectField, entries.items.len);

    for (entries.items, 0..) |entry, index| {
        for (0..self.types.get(type_id).object.len, 0..) |view_index, field_index| {
            const field = self.types.get(type_id).object.at(view_index);

            if (std.mem.eql(u8, entry.name, field.name)) output_fields[index] = .{ .index = @intCast(field_index), .value = entry.value };
        }
    }

    return self.append(.{ .span = span, .type_id = type_id, .value = .{ .object = .{ .fields = output_fields, .evaluation = try evaluation.toOwnedSlice(self.allocator) } } });
}
