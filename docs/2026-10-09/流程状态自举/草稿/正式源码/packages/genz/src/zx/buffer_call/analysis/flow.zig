const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
pub const Call = struct { expression: ir.ExprId, lane: usize };
pub const Iteration = struct { expression: ir.ExprId, path: []const u32 };

pub const Lane = struct {
    input: []const u32,
    output: []const u32,
    appends: []const ir.ExprId,
    pops: []const ir.ExprId,
    updates: []const ir.ExprId = &.{},
    iterations: []const Iteration = &.{},
    calls: []const Call,
    rejection: ?@import("audit.zig").Rejection = null,
};

pub fn functions(allocator: std.mem.Allocator, program: ir.Program, value_functions: []const bool, pure_functions: []const bool) std.mem.Allocator.Error![]const []const Lane {
    const summaries = try allocator.alloc([]const Lane, program.functions.count());
    const readers = try allocator.alloc(bool, program.functions.count());

    defer allocator.free(readers);

    for (0..program.functions.count(), pure_functions, readers) |function_row, pure, *reader| {
        const function = program.functions.at(function_row);

        reader.* = pure and detached(program, function.output_type);
    }

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        summaries[index] = &.{};

        if (!value_functions[index] and !(pure_functions[index] and function.external == null and program.typeOf(function.output_type) == .list)) continue;

        summaries[index] = try analyzeLanes(allocator, program, function, summaries[0..index], readers[0..index]);
    }

    return summaries;
}

pub fn entry(allocator: std.mem.Allocator, program: ir.Program, summaries: []const []const Lane, pure_functions: []const bool) std.mem.Allocator.Error![]const Lane {
    const readers = try allocator.alloc(bool, program.functions.count());

    defer allocator.free(readers);

    for (0..program.functions.count(), pure_functions, readers) |index, pure, *reader| {
        reader.* = pure and detached(program, program.functions.at(index).output_type);
    }

    const function: ir.Function = .{
        .file_name = program.file_name,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
        .stores = program.stores,
        .store_mode = program.store_mode,
        .contracts = program.contracts,
        .output_ownership = program.output_ownership,
    };

    return analyzeLanes(allocator, program, function, summaries, readers);
}

fn analyzeLanes(allocator: std.mem.Allocator, program: ir.Program, function: ir.Function, summaries: []const []const Lane, readers: []const bool) std.mem.Allocator.Error![]const Lane {
    var paths: std.ArrayList([]const u32) = .empty;

    try leaves(allocator, program, function.output_type, &.{}, false, &paths);

    var trace = try Trace.init(allocator, program, function, summaries);

    trace.readers = readers;

    var lanes: std.ArrayList(Lane) = .empty;

    for (paths.items) |path| {
        if (try trace.lane(path)) |lane| try lanes.append(allocator, lane);
    }

    var unique: std.ArrayList(Lane) = .empty;

    for (lanes.items, 0..) |lane, position| {
        const duplicated = for (lanes.items, 0..) |other, other_position| {
            if (position != other_position and std.mem.eql(u32, lane.input, other.input)) break true;
        } else false;

        if (!duplicated) try unique.append(allocator, lane);
    }

    for (unique.items) |*lane| lane.rejection = try @import("audit.zig").check(&trace, lane.*);

    return unique.toOwnedSlice(allocator);
}

pub fn detached(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => true,
        .enumeration, .error_set => true,
        .optional => |child| detached(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!detached(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!detached(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => false,
    };
}

pub fn leaves(allocator: std.mem.Allocator, program: ir.Program, type_id: ir.TypeId, path: []const u32, include_optional: bool, output: *std.ArrayList([]const u32)) std.mem.Allocator.Error!void {
    switch (program.typeOf(type_id)) {
        .list => try output.append(allocator, path),
        .optional => if (include_optional) try output.append(allocator, path),
        .object => |fields| for (0..fields.len, 0..) |view_index, index| {
            const field = fields.at(view_index);

            try leaves(allocator, program, field.type_id, try append(allocator, path, @intCast(index)), include_optional, output);
        },
        .tuple => |items| for (0..items.len, 0..) |item_index, index| {
            const item = items.at(item_index);

            try leaves(allocator, program, item, try append(allocator, path, @intCast(index)), include_optional, output);
        },
        else => {},
    }
}

fn append(allocator: std.mem.Allocator, path: []const u32, index: u32) std.mem.Allocator.Error![]const u32 {
    const result = try allocator.alloc(u32, path.len + 1);

    @memcpy(result[0..path.len], path);

    result[path.len] = index;

    return result;
}
