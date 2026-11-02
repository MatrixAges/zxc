const std = @import("std");
const ir = @import("zx").ir;
const Analysis = @import("../state_value/analysis.zig");

pub fn build(owned: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, base_names: []const []const u8, state_plan: Analysis) std.mem.Allocator.Error![]const []const u8 {
    if (!@import("genz_options").generated_analysis) return seed(owned, program, base_names, state_plan);

    const generated = @import("generated_abi_type_names");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = buffered.allocator();
    const keys = try temporary.alloc([]const u8, state_plan.keys.len);

    for (state_plan.keys, keys) |*key, *target| target.* = key;

    const input: Input = .{
        .kinds = program.types.kinds,
        .names = base_names,
        .selected = state_plan.selected,
        .keys = keys,
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const names = try owned.alloc([]const u8, output.names.len);

    errdefer owned.free(names);

    var copied: usize = 0;

    errdefer for (names[0..copied], output.origins[0..copied]) |name, origin| if (origin == null) owned.free(name);

    for (output.names, output.origins, names) |name, origin, *target| {
        target.* = if (origin) |id| base_names[id] else try owned.dupe(u8, name);
        copied += 1;
    }

    return names;
}

fn seed(owned: std.mem.Allocator, program: ir.Program, base_names: []const []const u8, state_plan: Analysis) std.mem.Allocator.Error![]const []const u8 {
    var type_names: std.ArrayList([]const u8) = .empty;
    var type_set: @import("zx").bytes.Map(void) = .empty;

    for (0..program.types.count(), base_names, 0..) |view_index, name, index| {
        const value = program.types.at(view_index);

        if (value != .list and value != .object and value != .tuple and value != .enumeration and value != .native_reference) continue;
        if (value != .list and !(try type_set.getOrPut(owned, name)).found_existing) try type_names.append(owned, name);

        if (state_plan.selected[index]) {
            const internal_name = try state_plan.name(owned, @fromBackingInt(@intCast(index)), name);

            if (!(try type_set.getOrPut(owned, internal_name)).found_existing) try type_names.append(owned, internal_name);

            if (value == .object or value == .tuple) {
                const view_name = try std.fmt.allocPrint(owned, "view_{s}", .{internal_name});

                if (!(try type_set.getOrPut(owned, view_name)).found_existing) try type_names.append(owned, view_name);
            }
        }
    }

    return type_names.toOwnedSlice(owned);
}
