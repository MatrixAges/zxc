const std = @import("std");
const Builder = @import("../builder.zig");

pub fn reexports(allocator: std.mem.Allocator, module: []const u8, member: []const u8, names: []const []const u8) std.mem.Allocator.Error![]u8 {
    return reexportsBacked(allocator, allocator, module, member, names);
}

fn reexportsBacked(allocator: std.mem.Allocator, workspace: std.mem.Allocator, module: []const u8, member: []const u8, names: []const []const u8) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    const declarations = try arena.allocator().alloc(@import("../node.zig").Declaration, names.len + 1);

    declarations[0] = .{ .constant = .{
        .name = "entry",
        .value = try builder.field(try builder.builtin(.import, &.{try builder.string(module)}), member),
    } };

    for (names, declarations[1..]) |name, *declaration| declaration.* = .{ .constant = .{
        .name = name,
        .value = try builder.field(try builder.identifier("entry"), name),
        .exported = true,
    } };

    return @import("../render.zig").render(allocator, builder.nodes, declarations);
}

pub fn result(allocator: std.mem.Allocator, emit: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());

    return @import("../render.zig").render(allocator, builder.nodes, &.{.{ .constant = .{ .name = "emit", .value = try builder.expression(.{ .boolean = emit }), .exported = true } }});
}

pub fn cAdapter(allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());

    return @import("../render.zig").render(allocator, builder.nodes, &.{.{ .constant = .{ .name = "c", .value = try builder.builtin(.import, &.{try builder.string("zxc_c")}), .exported = true } }});
}

pub fn bootstrapReexports(allocator: std.mem.Allocator, workspace: std.mem.Allocator, input: @import("root.zig").BootstrapEntries) std.mem.Allocator.Error![]u8 {
    var storage: [10][]const u8 = undefined;
    var names: std.ArrayList([]const u8) = .initBuffer(&storage);

    names.appendSliceAssumeCapacity(&.{ "Input", "Output", "execute", "requires_io", "requires_process", "input_shape", "output_shape" });

    if (input.value_entry) names.appendAssumeCapacity("executeValue");
    if (input.state_entry) names.appendAssumeCapacity("executeState");
    if (input.allocator_entry) names.appendAssumeCapacity("executeIn");

    return reexportsBacked(allocator, workspace, "generated", input.member, names.items);
}
