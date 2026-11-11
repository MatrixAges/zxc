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

        if (input.analysis.entry_function) |id| {
            function_id = try nodes.functionId(id);
        } else if (!program.type_only) {
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

        const public_types = try @import("interface.zig").complete(owned, allocator, program, nodes.types);
        const constants = try @import("constants.zig").complete(allocator, &nodes, program.constant_exports);
        const members = try @import("members.zig").complete(owned, allocator, input.analysis, program.file_name, &nodes);
        exported.* = .{ .name = try owned.dupe(u8, input.name), .path = try owned.dupe(u8, program.file_name), .function = function_id, .types = public_types, .constants = constants, .members = members };
    }

    const linked_functions = functions.view();

    try @import("stores.zig").validate(allocator, linked_functions.stores);

    const program = ir.Program{
        .file_name = "library",
        .types = types.items.view(),
        .input_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .output_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .functions = linked_functions,
        .native_modules = native_modules.view(),
        .type_only = true,
    };

    if (try frontend.validateIr(scratch, program) != null) return error.InvalidIr;

    const result = model.Result{ .arena = arena, .program = program, .exports = exports, .nominal_types = types.origins.items.view(), .store_initializers = initializers.items.items };

    try @import("validate.zig").validate(scratch, &result);

    return result;
}
