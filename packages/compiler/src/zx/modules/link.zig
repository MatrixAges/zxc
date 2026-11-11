const std = @import("std");
const ir = @import("zx").ir;
const model = @import("artifact/model.zig");
const Origins = @import("nominal_origins.zig");
const Types = @import("link/types.zig");
const Builder = @import("link/build.zig");
const graph = @import("link/graph.zig");
const TypeMap = @import("artifact/nodes.zig").TypeMap;
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
    var root: ?ir.Function = null;
    var recursive_root: ?ir.FunctionId = null;

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
            .Entry => root = function,
            .Append => {
                function_ids[index] = id;

                try builder.functions.append(owned, function.?);
            },
            .RecursiveEntry => {
                root = function;
                recursive_root = id;

                try builder.functions.append(owned, function.?);
            },
        }
    }

    const entry_index = order[order.len - 1];
    const module = &modules[entry_index];
    const mapping = TypeMap{ .mapped = mappings[entry_index] };
    const exports = try owned.dupe(ir.Export, module.exports);
    var nodes = @import("artifact/nodes.zig"){ .allocator = owned, .types = mapping, .functions = .{ .indexed = &.{} }, .native_modules = .{ .indexed = &.{} } };
    const stores = try nodes.stores(module.stores);

    for (exports) |*item| {
        item.name = try owned.dupe(u8, item.name);
        item.type_id = try mapping.include(item.type_id);
    }

    var program = ir.Program{
        .file_name = try owned.dupe(u8, module.path),
        .types = types.items.view(),
        .input_type = if (root) |value| value.input_type else @fromBackingInt(@intCast(0)),
        .output_type = if (root) |value| value.output_type else @fromBackingInt(@intCast(0)),
        .output_ownership = if (root) |value| value.output_ownership else .borrowed,
        .symbols = if (root) |value| value.symbols else .{},
        .expressions = if (root) |value| value.expressions else .{},
        .body = if (root) |value| value.body else .{},
        .contracts = if (root) |value| value.contracts else .{},
        .exports = exports,
        .constant_exports = try nodes.constants(module.constant_exports),
        .functions = builder.functions.view(),
        .native_modules = builder.native_modules.view(),
        .stores = stores,
        .store_mode = if (root) |value| value.store_mode else .transaction,
        .type_only = root == null,
    };

    if (recursive_root) |id| try @import("function_body.zig").entry(owned, &program, id);
    if (try @import("../ir/validate.zig").validate(scratch, program) != null) return error.InvalidIr;

    return .{ .arena = arena, .program = program, .nominal_types = types.origins.items.view() };
}
