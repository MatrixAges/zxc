const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated_mode = @import("parser_options").generated_parser;
const Signature = @import("source_signature.zig");
const FunctionImport = @import("function_import.zig");

pub fn merge(comptime T: type, allocator: std.mem.Allocator, own: []const T, forwarded: []const T) std.mem.Allocator.Error![]const T {
    if (own.len == 0) return forwarded;
    if (forwarded.len == 0) return own;

    const result = try allocator.alloc(T, own.len + forwarded.len);

    @memcpy(result[0..own.len], own);
    @memcpy(result[own.len..], forwarded);

    return result;
}

pub fn prepend(comptime T: type, allocator: std.mem.Allocator, own: ?T, forwarded: []const T) std.mem.Allocator.Error![]const T {
    const value = own orelse return forwarded;
    const result = try allocator.alloc(T, forwarded.len + 1);

    result[0] = value;

    @memcpy(result[1..], forwarded);

    return result;
}

const Action = if (generated_mode)
    @FieldType(@typeInfo(@TypeOf(@import("generated_project_public_exports").executeValue(undefined, undefined))).error_union.payload, "action")

else
    enum { None, Forward, Callable, Deferred, Intrinsic, Invalid };

const Plan = struct {
    invalid_name: ?usize = null,
    default_member: ?usize = null,
    action: Action = .None,
};

pub fn bodyEntry(allocator: std.mem.Allocator, backing: std.mem.Allocator, own: ?ir.FunctionId, types: []const ir.Export, constants: []const ir.Constant, functions: []const FunctionImport, reporter: *zx.Reporter) zx.Error!?ir.FunctionId {
    const selected = try plan(allocator, backing, types, constants, functions, own != null, reporter);

    return switch (selected.action) {
        .None => own,
        .Forward => functions[selected.default_member.?].id,
        else => unreachable,
    };
}

pub fn signatureEntry(allocator: std.mem.Allocator, backing: std.mem.Allocator, signature: *Signature.Result, reporter: *zx.Reporter) zx.Error!void {
    const members = signature.members;
    const selected = try plan(allocator, backing, signature.exports, signature.constant_exports, members, true, reporter);

    switch (selected.action) {
        .None, .Intrinsic => {},
        .Invalid => return reporter.fail(.module, .{ .start = 0, .end = 0 }, "a default re-export requires a callable source"),
        .Deferred => signature.deferred_source = members[selected.default_member.?].source,
        .Callable => {
            const member = members[selected.default_member.?];

            signature.ports = member.ports.?;
            signature.has_store = member.has_store;
            signature.type_only = false;
        },
        .Forward => unreachable,
    }
}

fn plan(allocator: std.mem.Allocator, backing: std.mem.Allocator, types: []const ir.Export, constants: []const ir.Constant, functions: anytype, has_function: bool, reporter: *zx.Reporter) zx.Error!Plan {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    const first_function = types.len + constants.len;
    const count = first_function + functions.len;
    const names = try temporary.alloc([]const u8, count);
    var index: usize = 0;
    var signature: ?*const Signature.Member = null;

    inline for (.{ types, constants, functions }) |items| {
        for (items) |*item| {
            names[index] = item.name;
            index += 1;

            if (comptime @TypeOf(item.*) == Signature.Member) {
                if (item.name.len == 0) signature = item;
            }
        }
    }

    const selected = try select(temporary, names, first_function, false, has_function, signature);

    if (selected.invalid_name) |duplicate| {
        const name = names[duplicate];

        return reporter.fail(.name, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "duplicate public export: {s}", .{if (name.len == 0) "default" else name}));
    }

    return selected;
}

pub fn invalidRootName(allocator: std.mem.Allocator, roots: anytype) std.mem.Allocator.Error!?usize {
    if (roots.len == 0) return null;

    const names = try allocator.alloc([]const u8, roots.len);

    for (roots, names) |root, *name| name.* = root.name;

    return (try select(allocator, names, names.len, true, false, null)).invalid_name;
}

fn select(allocator: std.mem.Allocator, names: []const []const u8, first_function: usize, roots: bool, has_function: bool, signature: ?*const Signature.Member) std.mem.Allocator.Error!Plan {
    if (comptime generated_mode) {
        const generated = @import("generated_project_public_exports");
        const Input = std.meta.Child(generated.Input);
        const Facts = std.meta.Child(@typeInfo(@FieldType(Input, "signature")).optional.child);

        const facts: ?Facts = if (signature) |member| .{
            .callable = member.ports != null,
            .deferred = member.source != null,
            .intrinsic = member.intrinsic != null,
        } else null;

        const buckets = try @import("source_index/fixed.zig").bucketsFor(allocator, names.len);

        defer allocator.free(buckets);

        const input: Input = .{
            .keys = names,
            .buckets = @ptrCast(&buckets),
            .capacity = buckets.len,
            .first_function = first_function,
            .roots = roots,
            .has_function = has_function,
            .signature = if (facts) |*value| value else null,
        };

        const output = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.IndexOutOfBounds => unreachable,
        };

        return .{
            .invalid_name = if (output.names.invalid_name) |index| @intCast(index) else null,
            .default_member = if (output.names.default_member) |index| @intCast(index) else null,
            .action = output.action,
        };
    }

    var seen: std.StringHashMapUnmanaged(void) = .empty;
    var result: Plan = .{};

    for (names, 0..) |name, index| {
        if ((roots and name.len == 0) or (try seen.getOrPut(allocator, name)).found_existing) {
            return .{ .invalid_name = index };
        }

        if (index >= first_function and name.len == 0) result.default_member = index - first_function;
    }

    if (signature) |member| {
        result.action = if (member.ports != null) .Callable else if (member.source != null)
            .Deferred

        else if (member.intrinsic != null)
            .Intrinsic
        else
            .Invalid;
    } else if (result.default_member != null and !has_function) {
        result.action = .Forward;
    }

    return result;
}
