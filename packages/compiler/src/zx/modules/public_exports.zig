const std = @import("std");
const zx = @import("zx");
const generated_mode = @import("parser_options").generated_parser;
const Signature = @import("source_signature.zig");

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
    enum { None, Callable, Deferred, Intrinsic, Invalid };

pub const Plan = struct {
    invalid_name: ?usize = null,
    default_member: ?usize = null,
    action: Action = .None,
};

pub fn plan(allocator: std.mem.Allocator, backing: std.mem.Allocator, types: []const zx.ir.Export, constants: []const zx.ir.Constant, functions: anytype, reporter: *zx.Reporter) zx.Error!Plan {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    const names = try temporary.alloc([]const u8, types.len + constants.len + functions.len);
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

    const first_function = types.len + constants.len;
    const selected = try select(temporary, names, first_function, false, signature);

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

    return (try select(allocator, names, names.len, true, null)).invalid_name;
}

fn select(allocator: std.mem.Allocator, names: []const []const u8, first_function: usize, roots: bool, signature: ?*const Signature.Member) std.mem.Allocator.Error!Plan {
    if (comptime generated_mode) {
        const generated = @import("generated_project_public_exports");
        const Input = std.meta.Child(generated.Input);
        const Facts = std.meta.Child(@typeInfo(@FieldType(Input, "signature")).optional.child);

        const facts: ?Facts = if (signature) |member| .{
            .callable = member.ports != null,
            .deferred = member.source != null,
            .intrinsic = member.intrinsic != null,
        } else null;

        const input: Input = .{
            .names = names,
            .first_function = first_function,
            .roots = roots,
            .signature = if (facts) |*value| value else null,
        };

        const output = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
            else => unreachable,
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
    }

    return result;
}
