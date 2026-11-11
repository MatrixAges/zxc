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

    var builder = Builder{ .allocator = owned, .temporary = scratch, .modules = modules, .plan = plan, .type_mappings = mappings, .module_functions = function_ids };
    var selected: result.Entry = .{};

    for (order, 0..) |index, position| {
        const module = &modules[index];
        const function = try builder.module(index);
        const id: ir.FunctionId = @fromBackingInt(@as(u32, @intCast(builder.functions.count())));

        const action = try @import("link/placement.zig").select(
            scratch,
            position + 1 == order.len,
            module.stores.count(),
            if (function) |*body| body else null,
            id,
        );

        switch (action) {
            .Invalid => return error.InvalidModule,
            .Skip => {},
            .Entry => selected.body = function,
            .Append => {
                function_ids[index] = id;

                try builder.functions.append(owned, function.?);
            },
            .RecursiveEntry => {
                selected.body = function;
                selected.recursive = id;

                try builder.functions.append(owned, function.?);
            },
        }
    }

    const entry_index = order[order.len - 1];

    const program = try result.materialize(owned, scratch, &modules[entry_index], &selected, .{
        .types = types.items.view(),
        .functions = builder.functions.view(),
        .native_modules = builder.native_modules.view(),
    }, mappings[entry_index]);

    return .{ .arena = arena, .program = program, .nominal_types = types.origins.items.view() };
}
