const std = @import("std");
const zx = @import("zx");
const terms = @import("terms.zig");
const Self = @This();
pub const Origin = struct { file_name: []const u8, span: zx.Span };
pub const Definition = struct { name: []const u8, expression: []const u8, width: u16, origin: Origin };

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
definitions: std.ArrayList(Definition) = .empty,
indices: std.StringHashMapUnmanaged(usize) = .empty,
calls: std.StringHashMapUnmanaged(terms.Evaluation) = .empty,
steps: usize = 0,
pub fn step(self: *Self, span: zx.Span) zx.Error!void {
    if (self.steps >= 1000000) return self.reporter.fail(.unsupported, span, "symbolic execution exceeds 1000000 evaluation steps");

    self.steps += 1;
}

pub fn bind(self: *Self, expression: []const u8, width: u16, origin: Origin) zx.Error![]const u8 {
    if (expression.len == 0 or expression[0] != '(') return expression;

    if (self.indices.get(expression)) |index| {
        const definition = self.definitions.items[index];

        if (definition.width != width) return error.InvalidSource;

        return definition.name;
    }

    if (self.definitions.items.len >= 100000) return self.reporter.fail(.unsupported, origin.span, "symbolic graph exceeds 100000 definitions");

    const owned_origin = Origin{ .file_name = try self.allocator.dupe(u8, origin.file_name), .span = origin.span };
    const name = try std.fmt.allocPrint(self.allocator, "term_{d}", .{self.definitions.items.len});

    try self.indices.put(self.allocator, expression, self.definitions.items.len);
    try self.definitions.append(self.allocator, .{ .name = name, .expression = expression, .width = width, .origin = owned_origin });

    return name;
}

pub fn value(self: *Self, program: zx.ir.Program, type_id: zx.ir.TypeId, input: terms.Value, span: zx.Span) zx.Error!terms.Value {
    const target = program.typeOf(type_id);

    if (target == .object or target == .tuple) {
        const fields = try self.allocator.alloc(terms.Value, input.fields.len);

        for (input.fields, fields, 0..) |child, *field, index| {
            field.* = try self.value(program, if (target == .object) target.object[index].type_id else target.tuple[index], child, span);
        }

        return .{ .fields = fields };
    }

    if (target == .scalar and target.scalar == .void) return input;

    const width = if (terms.integer(target)) |integer| integer.width else if (target == .scalar and target.scalar == .bool) 0 else return self.reporter.fail(.unsupported, span, "symbolic graph requires boolean or fixed-width integer values");

    return .{ .scalar = try self.bind(input.scalar, width, .{ .file_name = program.file_name, .span = span }) };
}

pub fn declarations(self: *Self) zx.Error![]const u8 {
    var output: std.Io.Writer.Allocating = .init(self.allocator);

    for (self.definitions.items) |definition| {
        const sort = if (definition.width == 0) "Bool" else try std.fmt.allocPrint(self.allocator, "(_ BitVec {d})", .{definition.width});

        output.writer.print("(define-fun {s} () {s} {s})\n", .{ definition.name, sort, definition.expression }) catch return error.OutOfMemory;
    }

    return output.toOwnedSlice();
}
