const std = @import("std");
const ir = @import("zx").ir;
const model = @import("artifact/model.zig");
const Origins = @import("nominal_origins.zig");
const Types = @import("link/types.zig");
const Builder = @import("link/build.zig");
const graph = @import("link/graph.zig");
const result = @import("link/result/host.zig");
pub const Error = Types.Error || Builder.Error || graph.Error;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    program: ir.Program,
    nominal_types: Origins.Table,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn link(allocator: std.mem.Allocator, modules: []const model.Module, entry: []const u8) Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    var module_scratch = std.heap.ArenaAllocator.init(allocator);

    defer module_scratch.deinit();

    const owned = arena.allocator();
    const scratch = temporary.allocator();
    const plan = try graph.prepare(scratch, modules, entry);
    const order = plan.order;
    const mappings = try scratch.alloc([]const ir.TypeId, modules.len);
    const function_ids = try scratch.alloc(?ir.FunctionId, modules.len);
    var types = try Types.init(owned);

    @memset(function_ids, null);

    for (order) |index| {
        const source = &modules[index];
        mappings[index] = try types.appendFrom(scratch, source.types, source.nominal_types, 0);
    }

    var builder = Builder{ .allocator = owned, .temporary = module_scratch.allocator(), .modules = modules, .plan = plan, .type_mappings = mappings, .module_functions = function_ids };
    const entry_position = order.len - 1;

    for (order[0..entry_position]) |index| {
        const module = &modules[index];
        const function = try builder.module(index);

        _ = module_scratch.reset(.retain_capacity);

        switch (@import("link/placement.zig").select(module.stores.count(), function != null)) {
            .Invalid => return error.InvalidModule,
            .Skip => {},
            .Append => {
                function_ids[index] = @fromBackingInt(@as(u32, @intCast(builder.functions.count())));

                try builder.functions.append(owned, function.?);
            },
        }
    }

    const entry_index = order[entry_position];
    const function = try builder.module(entry_index);
    const body = if (function) |*value| value else null;
    const candidate: ir.FunctionId = @fromBackingInt(@as(u32, @intCast(builder.functions.count())));
    _ = module_scratch.reset(.free_all);

    const header = try result.publish(scratch, body, candidate);

    if (header.recursive != null) try builder.functions.append(owned, function.?);

    const program = try result.materialize(owned, scratch, &modules[entry_index], body, header, .{
        .types = types.items.view(),
        .functions = builder.functions.view(),
        .native_modules = builder.native_modules.view(),
    }, mappings[entry_index]);

    return .{ .arena = arena, .program = program, .nominal_types = types.origins.items.view() };
}
