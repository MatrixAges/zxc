const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
const artifact = frontend.project.artifact;
const Nodes = frontend.ArtifactNodes;
const Types = artifact.type_link.Table;
const Initializers = @import("initializers.zig");
pub const Error = Types.Error || artifact.Error || Initializers.Error || @import("validate.zig").Error || error{ ConflictingInterface, InvalidAnalysis, InvalidIr, DuplicateExport, ConflictingStore };

pub fn link(allocator: std.mem.Allocator, inputs: []const model.Input) Error!model.Result {
    if (inputs.len == 0) return error.InvalidModule;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    const scratch = temporary.allocator();
    var types = try Types.init(owned);
    var functions: std.ArrayList(ir.Function) = .empty;
    var native_modules: std.ArrayList(ir.NativeModule) = .empty;
    var initializers = Initializers{ .allocator = owned, .scratch = scratch, .types = &types, .functions = &functions };
    const exports = try owned.alloc(model.Export, inputs.len);
    var names: std.StringHashMapUnmanaged(void) = .empty;
    var stores: std.StringHashMapUnmanaged(ir.TypeId) = .empty;

    for (inputs, exports) |input, *exported| {
        if (input.name.len == 0 or std.mem.indexOfScalar(u8, input.name, 0) != null or !std.unicode.utf8ValidateSlice(input.name)) return error.InvalidModule;
        if ((try names.getOrPut(scratch, input.name)).found_existing) return error.DuplicateExport;
        if (input.analysis.value != .ir) return error.InvalidAnalysis;

        const program = input.analysis.value.ir;

        if (try frontend.validateIr(scratch, program) != null) return error.InvalidIr;

        const type_mapping = try types.appendFrom(scratch, program.types, input.analysis.nominal_types, 0);
        const function_mapping = try scratch.alloc(?ir.FunctionId, program.functions.len);
        const native_mapping = try scratch.alloc(?ir.NativeModuleId, program.native_modules.len);

        for (function_mapping, 0..) |*id, index| id.* = @fromBackingInt(@intCast(functions.items.len + index));

        @memset(native_mapping, null);

        var nodes = Nodes{ .allocator = owned, .types = .{ .mapped = type_mapping }, .functions = function_mapping, .native_modules = native_mapping };

        for (program.native_modules, native_mapping) |native, *id| id.* = try artifact.native_link.append(owned, &native_modules, native, &nodes);
        for (program.functions) |function| try functions.append(owned, try nodes.function(function));

        for (input.analysis.store_initializers) |initial| try initializers.append(.{
            .identity = initial.identity,
            .schema_version = initial.schema_version,
            .function = try nodes.functionId(initial.function),
        });

        for (input.initializers) |initial| try initializers.source(initial, input.analysis.nominal_types);

        var function_id: ?ir.FunctionId = null;

        if (!program.type_only) {
            function_id = @fromBackingInt(@intCast(functions.items.len));

            try functions.append(owned, try nodes.function(.{
                .file_name = program.file_name,
                .input_type = program.input_type,
                .output_type = program.output_type,
                .output_ownership = program.output_ownership,
                .symbols = program.symbols,
                .expressions = program.expressions,
                .body = program.body,
                .contracts = program.contracts,
                .stores = program.stores,
                .store_mode = program.store_mode,
            }));
        }

        var public_types: std.ArrayList(ir.Export) = .empty;

        for (program.exports) |item| try public_types.append(owned, .{ .name = try owned.dupe(u8, item.name), .type_id = try nodes.types.include(item.type_id) });

        if (!program.type_only) {
            for ([_]ir.Export{ .{ .name = "Input", .type_id = program.input_type }, .{ .name = "Output", .type_id = program.output_type } }) |signature| {
                const type_id = try nodes.types.include(signature.type_id);
                var found = false;

                for (public_types.items) |item| if (std.mem.eql(u8, item.name, signature.name)) {
                    if (item.type_id != type_id) return error.ConflictingInterface;

                    found = true;
                };

                if (!found) try public_types.append(owned, .{ .name = try owned.dupe(u8, signature.name), .type_id = type_id });
            }
        }

        exported.* = .{ .name = try owned.dupe(u8, input.name), .path = try owned.dupe(u8, program.file_name), .function = function_id, .types = public_types.items };
    }

    for (functions.items) |function| for (0..function.stores.count()) |store_index| {
        const slot = function.stores.at(store_index);
        const entry = try stores.getOrPut(scratch, slot.path);

        if (entry.found_existing and entry.value_ptr.* != slot.type_id) return error.ConflictingStore;

        entry.value_ptr.* = slot.type_id;
    };

    const program = ir.Program{
        .file_name = "library",
        .types = types.items.view(),
        .input_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .output_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .functions = functions.items,
        .native_modules = native_modules.items,
        .type_only = true,
    };

    if (try frontend.validateIr(scratch, program) != null) return error.InvalidIr;

    const result = model.Result{ .arena = arena, .program = program, .exports = exports, .nominal_types = types.origins.items.view(), .store_initializers = initializers.items.items };

    try @import("validate.zig").validate(scratch, &result);

    return result;
}
