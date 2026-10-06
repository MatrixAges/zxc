const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Diagnostic = @import("../expression.zig").Diagnostic;

pub const Value = union(enum) { resolved: struct { types: zx.ir.TypeTable, id: zx.ir.TypeId }, diagnostic: Diagnostic };

pub fn resolve(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute, context: frontend.Context) std.mem.Allocator.Error!Value {
    const prefix = "export type StoreValue = ";
    const source = try std.fmt.allocPrint(allocator, "{s}{s}\n", .{ prefix, attribute.value });
    var parsed = try frontend.parseModule(allocator, source, owner);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| return .{ .diagnostic = try mapped(allocator, attribute, issue, prefix.len) };

    const valid = switch (parsed) {
        .native => |result| validType(zx.syntax.header.Native{ .program = result.value.parsed.ast }),
        .indexed => |result| if (frontend.project.ParseCache.indexed_enabled) validType(result.header()) else unreachable,
    };

    if (!valid) {
        return .{ .diagnostic = try mapped(allocator, attribute, .{ .code = .syntax, .span = .{ .start = prefix.len, .end = prefix.len }, .message = "Field.type must contain exactly one ZX type expression" }, prefix.len) };
    }

    const analyzed = try frontend.analyzeModule(allocator, &parsed, context);

    if (analyzed.value == .diagnostic) return .{ .diagnostic = try mapped(allocator, attribute, analyzed.value.diagnostic, prefix.len) };

    const program = analyzed.value.ir;
    const id = program.exports[0].type_id;

    if (@backingInt(id) == @backingInt(zx.ir.Scalar.void)) return .{ .diagnostic = try mapped(allocator, attribute, .{ .code = .type_mismatch, .span = .{ .start = prefix.len, .end = prefix.len }, .message = "Store fields cannot have void type" }, prefix.len) };

    return .{ .resolved = .{ .types = program.types, .id = id } };
}

fn validType(header: anytype) bool {
    return header.importCount() == 0 and !header.hasBody() and header.declarationCount() == 1 and std.mem.eql(u8, header.declarationAt(0).name.text, "StoreValue");
}

fn mapped(allocator: std.mem.Allocator, attribute: rx.ast.Attribute, issue: zx.Diagnostic, prefix: usize) std.mem.Allocator.Error!Diagnostic {
    const offset = @min(issue.span.start -| prefix, attribute.value.len);
    const location = rx.attributeLocation(attribute, offset) orelse attribute.value_location;

    return .{ .location = location, .issue = .{ .code = issue.code, .span = .{ .start = location.offset, .end = location.offset }, .message = try allocator.dupe(u8, issue.message) } };
}
