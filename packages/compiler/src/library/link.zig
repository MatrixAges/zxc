const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
const artifact = frontend.project.artifact;
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
    var functions: ir.FunctionStorage = .{};
    var native_modules: ir.NativeModuleStorage = .{};
    var initializers = Initializers{ .allocator = owned, .scratch = scratch, .types = &types, .functions = &functions };
    const exports = try owned.alloc(model.Export, inputs.len);
    var names: std.StringHashMapUnmanaged(void) = .empty;
    var stores: std.StringHashMapUnmanaged(ir.TypeId) = .empty;

    for (inputs, exports) |input, *exported| {
        if (input.name.len == 0 or std.mem.indexOfScalar(u8, input.name, 0) != null or !std.unicode.utf8ValidateSlice(input.name)) return error.InvalidModule;
        if ((try names.getOrPut(scratch, input.name)).found_existing) return error.DuplicateExport;
        if (input.analysis.value != .ir) return error.InvalidAnalysis;

        const program = input.analysis.value.ir;

        var nodes = try artifact.program_link.append(.{
            .program = program,
            .nominal_types = input.analysis.nominal_types,
        }, .{
            .allocator = owned,
            .temporary = scratch,
            .types = &types,
            .functions = &functions,
            .native_modules = &native_modules,
        });

        for (input.analysis.store_initializers) |initial| try initializers.append(.{
            .identity = initial.identity,
            .schema_version = initial.schema_version,
            .function = try nodes.functionId(initial.function),
        });

        for (input.initializers) |initial| try initializers.source(initial, input.analysis.nominal_types);

        var function_id: ?ir.FunctionId = null;

        if (!program.type_only) {
            function_id = @fromBackingInt(@intCast(functions.count()));

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

    for (0..functions.count()) |function_row| {
        const function = functions.at(function_row);

        for (0..function.stores.count()) |store_index| {
            const slot = function.stores.at(store_index);
            const entry = try stores.getOrPut(scratch, slot.path);

            if (entry.found_existing and entry.value_ptr.* != slot.type_id) return error.ConflictingStore;

            entry.value_ptr.* = slot.type_id;
        }
    }

    const program = ir.Program{
        .file_name = "library",
        .types = types.items.view(),
        .input_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .output_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .functions = functions.view(),
        .native_modules = native_modules.view(),
        .type_only = true,
    };

    if (try frontend.validateIr(scratch, program) != null) return error.InvalidIr;

    const result = model.Result{ .arena = arena, .program = program, .exports = exports, .nominal_types = types.origins.items.view(), .store_initializers = initializers.items.items };

    try @import("validate.zig").validate(scratch, &result);

    return result;
}
