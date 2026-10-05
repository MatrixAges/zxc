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
    nominal_types: []const Origins.Item,
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
    const order = try graph.order(scratch, modules, entry);
    const sorted = try scratch.alloc(model.Module, order.len);
    const mappings = try scratch.alloc([]const ir.TypeId, order.len);
    const function_ids = try scratch.alloc(?ir.FunctionId, order.len);
    var types = try Types.init(owned);

    @memset(function_ids, null);

    for (order, sorted, mappings) |index, *module, *mapping| {
        module.* = modules[index];
        mapping.* = try types.append(scratch, module.*);
    }

    var builder = Builder{ .allocator = owned, .temporary = scratch, .modules = sorted, .type_mappings = mappings, .module_functions = function_ids };
    var root: ?ir.Function = null;

    for (sorted, 0..) |module, index| {
        const function = try builder.module(index);

        if (index + 1 == sorted.len) {
            root = function;
        } else {
            if (module.stores.len != 0) return error.InvalidModule;

            if (function) |value| {
                function_ids[index] = @enumFromInt(builder.functions.items.len);

                try builder.functions.append(owned, value);
            }
        }
    }

    const module = sorted[sorted.len - 1];
    const mapping = TypeMap{ .mapped = mappings[mappings.len - 1] };
    const exports = try owned.dupe(ir.Export, module.exports);
    const stores = try owned.dupe(ir.StoreSlot, module.stores);

    for (exports) |*item| {
        item.name = try owned.dupe(u8, item.name);
        item.type_id = try mapping.include(item.type_id);
    }

    for (stores) |*item| {
        item.path = try owned.dupe(u8, item.path);
        item.handle = try owned.dupe(u8, item.handle);
        item.type_id = try mapping.include(item.type_id);
    }

    const program = ir.Program{
        .file_name = try owned.dupe(u8, module.path),
        .types = types.items.items,
        .input_type = if (root) |value| value.input_type else @enumFromInt(0),
        .output_type = if (root) |value| value.output_type else @enumFromInt(0),
        .consumes_input = if (root) |value| value.consumes_input else false,
        .output_ownership = if (root) |value| value.output_ownership else .borrowed,
        .symbols = if (root) |value| value.symbols else &.{},
        .expressions = if (root) |value| value.expressions else &.{},
        .body = if (root) |value| value.body else &.{},
        .contracts = if (root) |value| value.contracts else &.{},
        .exports = exports,
        .functions = builder.functions.items,
        .native_modules = builder.native_modules.items,
        .stores = stores,
        .store_mode = if (root) |value| value.store_mode else .transaction,
        .type_only = root == null,
    };

    if (try @import("../ir/validate.zig").validate(scratch, program) != null) return error.InvalidIr;

    return .{ .arena = arena, .program = program, .nominal_types = types.origins.items.items };
}
