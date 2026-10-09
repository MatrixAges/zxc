const std = @import("std");
const ir = @import("zx").ir;
const program_link = @import("program.zig");
const Origins = @import("../nominal_origins.zig");
const Nodes = @import("../artifact/nodes.zig");
const Initializer = @import("../compiled.zig").StoreInitializer;

pub const Input = struct {
    program: ir.Program,
    base_functions: ?ir.FunctionTable = null,
    nominal_types: Origins.Table,
    store_initializers: []const Initializer = &.{},
};

pub const Loaded = struct {
    function: ?ir.FunctionId,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    exports: []const ir.Export,
    store_initializers: []const Initializer,
};

pub fn append(input: Input, destination: program_link.Destination) program_link.Error!Loaded {
    var nodes = try program_link.append(.{ .program = input.program, .nominal_types = input.nominal_types }, destination);

    return finish(input, destination, &nodes);
}

pub fn appendBody(input: Input, destination: program_link.Destination) program_link.Error!Loaded {
    const program = input.program;
    const base = input.base_functions orelse program.functions;

    if (!sameView(base, destination.functions.view()) or !sameView(program.native_modules, destination.native_modules.view())) return error.InvalidModule;
    if (!@import("function_table.zig").hasPrefix(program.functions, base)) return error.InvalidModule;
    if (try @import("../../ir/validate.zig").validate(destination.temporary, program) != null) return error.InvalidIr;

    const mapping = try destination.types.appendFrom(destination.temporary, program.types, input.nominal_types, destination.types.items.count());
    const functions = try destination.temporary.alloc(?ir.FunctionId, program.functions.count());
    const native_modules = try destination.temporary.alloc(?ir.NativeModuleId, program.native_modules.count());

    defer destination.temporary.free(functions);
    defer destination.temporary.free(native_modules);

    for (functions, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));
    for (native_modules, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));

    var nodes = Nodes{
        .allocator = destination.allocator,
        .types = .{ .mapped = mapping },
        .functions = .{ .indexed = functions },
        .native_modules = .{ .indexed = native_modules },
    };

    for (base.count()..program.functions.count()) |index| {
        try destination.functions.append(destination.allocator, try nodes.function(program.functions.at(index)));
    }

    return finish(input, destination, &nodes);
}

fn finish(input: Input, destination: program_link.Destination, nodes: *Nodes) program_link.Error!Loaded {
    const allocator = destination.allocator;
    const program = input.program;
    var function: ?ir.FunctionId = null;

    if (!program.type_only) {
        const mapped = try nodes.function(.{
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
        });

        function = @fromBackingInt(@intCast(destination.functions.count()));

        try destination.functions.append(allocator, mapped);
    }

    const exports = try allocator.alloc(ir.Export, program.exports.len);

    for (program.exports, exports) |source, *exported| {
        exported.* = .{ .name = try allocator.dupe(u8, source.name), .type_id = try nodes.types.include(source.type_id) };
    }

    const initializers = try allocator.alloc(Initializer, input.store_initializers.len);

    for (input.store_initializers, initializers) |source, *initializer| {
        initializer.* = .{
            .identity = try allocator.dupe(u8, source.identity),
            .schema_version = source.schema_version,
            .function = try nodes.functionId(source.function),
        };
    }

    return .{
        .function = function,
        .input_type = try nodes.types.include(program.input_type),
        .output_type = try nodes.types.include(program.output_type),
        .exports = exports,
        .store_initializers = initializers,
    };
}

fn sameView(left: anytype, right: @TypeOf(left)) bool {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const a = @field(left, name);
        const b = @field(right, name);

        if (a.len != b.len or (a.len != 0 and a.ptr != b.ptr)) return false;
    }

    return true;
}
