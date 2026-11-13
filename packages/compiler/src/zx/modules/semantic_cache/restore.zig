const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const Types = @import("../link/types.zig");
const Origins = @import("../nominal_origins.zig");
const Record = @import("../module_record.zig");
const FunctionImport = @import("../function_import.zig");
const generated = @import("parser_options").generated_parser;
const Host = @import("restoring/host.zig");
const Seed = @import("restoring/seed.zig");

pub const Current = struct {
    allocator: std.mem.Allocator,
    backing: std.mem.Allocator,
    types: *ir.TypeStorage,
    origins: *Origins,
    functions: *ir.FunctionStorage,
    verified_functions: usize,
    verified_types: ?@import("../../ir/validate.zig").TypePrefix,
    native_modules: ir.NativeModuleTable,
    aliases: []const ir.Export,
    imports: []const FunctionImport,
    constant_imports: []const ir.Constant = &.{},
    dependencies: []const Record.Import,
};

const Error = Types.Error || model.Error;

pub const Restored = struct {
    program: ir.Program,
    recursive: ?ir.FunctionId,
};

pub fn restore(entry: *const @import("entries.zig").Entry, current: Current) std.mem.Allocator.Error!?Restored {
    return restoreChecked(&entry.result.value, current, generated and entry.decoded) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return null;
    };
}

fn restoreChecked(module: *const model.Module, current: Current, decoded: bool) Error!Restored {
    if (comptime generated) {
        if (!Host.preflight(module, &current, decoded) or !Host.dependencies(module.dependencies, current.dependencies)) return error.InvalidModule;
    } else if (!Seed.preflight(module, &current)) return error.InvalidModule;

    var arena = std.heap.ArenaAllocator.init(current.backing);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const constants = @import("../../analysis/constants/check.zig");

    if (!try constants.validate(temporary, current.types.view(), current.constant_imports)) return error.InvalidModule;

    const allocator = current.allocator;
    const first_type = current.types.count();
    const first_origin = current.origins.items.view().count();
    var types = Types{ .allocator = allocator, .items = current.types.*, .origins = current.origins.* };

    current.types.* = .{};
    current.origins.items = .{};

    defer {
        current.types.* = types.items;
        current.origins.* = types.origins;
    }

    errdefer {
        types.items.retainPrefix(first_type);
        types.origins.items.retainPrefix(first_origin);
    }

    if (types.items.count() == 0) {
        for (std.enums.values(ir.Scalar)) |scalar| try types.items.append(allocator, .{ .scalar = scalar });
    }

    const mapping = try types.appendTemporaryValidated(temporary, temporary, module, decoded);

    if (comptime generated) {
        if (!try Host.constants(temporary, module, current.constant_imports, mapping, decoded)) return error.InvalidModule;
    } else if (!try Seed.constants(temporary, module, current.constant_imports, mapping)) return error.InvalidModule;

    const function_mapping = try temporary.alloc(?ir.FunctionId, module.functions.count() + @intFromBool(module.function != null));
    const native_mapping = try temporary.alloc(?ir.NativeModuleId, module.native_modules.count());

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };

    if (comptime generated) {
        if (!Host.aliases(module.type_imports, current.aliases, mapping)) return error.InvalidModule;
    } else {
        for (module.type_imports, current.aliases) |*previous, *alias| {
            if (!std.mem.eql(u8, previous.name, alias.name) or try nodes.types.include(previous.type_id) != alias.type_id) return error.InvalidModule;
        }
    }

    if (comptime generated) {
        if (!try Host.bindModules(temporary, module.native_modules, current.native_modules, mapping, native_mapping)) return error.InvalidModule;
    } else try Seed.modules(module.native_modules, current.native_modules, nodes.types, native_mapping);

    const imported = function_mapping[0..module.functions.count()];

    if (comptime generated) {
        if (!Host.bindings(module.function_imports, current.imports, imported, mapping, current.functions.count())) return error.InvalidModule;
    } else {
        for (module.function_imports, current.imports) |*previous, *binding| try Seed.bind(previous, binding, imported, nodes.types, current.functions.count());
    }

    const linked = ir.SignatureTable.fromFunctions(current.functions.view());

    if (comptime generated) {
        if (!try Host.signatures(temporary, module.functions, linked, mapping, imported, native_mapping)) return error.InvalidModule;
    } else try Seed.signatures(&nodes, module.functions, linked, imported);

    const own = if (comptime generated)
        try Host.own(function_mapping, module.functions.count(), current.functions.count(), module.function != null)

    else
        try Seed.own(function_mapping, module.functions.count(), current.functions.count(), module.function != null);

    const function = if (module.function) |value| try nodes.functionEntry(value, own) else null;
    const body = if (function) |*value| &value.body else null;
    const recursive = if (function) |*value| value.recursive else null;
    const result = @import("../link/result/host.zig");

    var program = try result.assemble(allocator, temporary, module, body, .{
        .types = types.items.view(),
        .functions = current.functions.view(),
        .native_modules = current.native_modules,
    }, mapping);

    if (recursive != null) {
        try current.functions.append(allocator, @import("../function_body.zig").value(program));

        program.functions = current.functions.view();
    }

    errdefer if (recursive != null) {
        _ = current.functions.pop(allocator);
    };

    if (try @import("../../ir/validate.zig").validateProjectPrefix(temporary, program, current.verified_functions, current.verified_types) != null) return error.InvalidIr;

    return .{ .program = program, .recursive = recursive };
}
