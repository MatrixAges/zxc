const std = @import("std");
const zx = @import("zx");

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

const Plan = struct {
    duplicate: ?u64 = null,
    default_member: ?u64 = null,
};

pub fn plan(allocator: std.mem.Allocator, backing: std.mem.Allocator, types: []const zx.ir.Export, constants: []const zx.ir.Constant, functions: anytype, reporter: *zx.Reporter) zx.Error!?usize {
    var arena = std.heap.ArenaAllocator.init(backing);

    defer arena.deinit();

    const temporary = arena.allocator();
    const names = try temporary.alloc([]const u8, types.len + constants.len + functions.len);
    var index: usize = 0;

    inline for (.{ types, constants, functions }) |items| {
        for (items) |item| {
            names[index] = item.name;
            index += 1;
        }
    }

    const first_function = types.len + constants.len;
    const selected = try select(temporary, names, first_function);

    if (selected.duplicate) |duplicate| {
        const name = names[@intCast(duplicate)];

        return reporter.fail(.name, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "duplicate public export: {s}", .{if (name.len == 0) "default" else name}));
    }

    return if (selected.default_member) |member| @as(usize, @intCast(member)) else null;
}

fn select(allocator: std.mem.Allocator, names: []const []const u8, first_function: usize) std.mem.Allocator.Error!Plan {
    if (comptime @import("parser_options").generated_parser) {
        const generated = @import("generated_project_public_exports");
        const input: std.meta.Child(generated.Input) = .{ .names = names, .first_function = first_function };

        const output = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
            else => unreachable,
        };

        return .{ .duplicate = output.duplicate, .default_member = output.default_member };
    }

    var seen: std.StringHashMapUnmanaged(void) = .empty;

    for (names, 0..) |name, index| {
        if ((try seen.getOrPut(allocator, name)).found_existing) return .{ .duplicate = index };
    }

    for (names[first_function..], 0..) |name, index| if (name.len == 0) return .{ .default_member = index };

    return .{};
}
