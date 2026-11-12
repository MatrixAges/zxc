const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const Types = @import("../link/types.zig");
const native = @import("../link/native.zig");
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
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
    aliases: []const ir.Export,
    imports: []const FunctionImport,
    constant_imports: []const ir.Constant = &.{},
    dependencies: []const Record.Import,
};

const Error = Types.Error || model.Error;

pub fn restore(module: *const model.Module, current: Current) std.mem.Allocator.Error!?ir.Program {
    return restoreChecked(module, current) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return null;
    };
}

fn restoreChecked(module: *const model.Module, current: Current) Error!ir.Program {
    if (!module.native_modules.validStructure() or !module.functions.validStructure() or !current.native_modules.validStructure()) return error.InvalidModule;

    const same_dependencies = if (comptime generated)
        Host.dependencies(module.dependencies, current.dependencies)
    else
        Seed.sameDependencies(module.dependencies, current.dependencies);

    if (!same_dependencies) return error.InvalidModule;
    if (module.type_imports.len != current.aliases.len or module.function_imports.len != current.imports.len) return error.InvalidModule;
    if (module.constant_imports.len != current.constant_imports.len) return error.InvalidModule;

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

    const mapping = try types.appendTemporary(temporary, temporary, module);

    if (!try constants.validate(temporary, module.types, module.constant_exports)) return error.InvalidModule;
    if (!try constants.validate(temporary, module.types, module.constant_imports)) return error.InvalidModule;
    if (try @import("../../analysis/constants/bindings.zig").compare(temporary, .{ .previous = module.constant_imports, .current = current.constant_imports, .mapping = mapping }) != .Equal) return error.InvalidModule;

    const function_mapping = try temporary.alloc(?ir.FunctionId, module.functions.count() + @intFromBool(module.function != null));
    const native_mapping = try temporary.alloc(?ir.NativeModuleId, module.native_modules.count());

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };

    for (module.type_imports, current.aliases) |*previous, *alias| {
        const same = if (comptime generated)
            Host.alias(previous, alias, mapping)
        else
            std.mem.eql(u8, previous.name, alias.name) and try nodes.types.include(previous.type_id) == alias.type_id;

        if (!same) return error.InvalidModule;
    }

    for (0..module.native_modules.count(), native_mapping) |previous_row, *id| {
        const previous = module.native_modules.at(previous_row);

        id.* = if (comptime generated)
            try native.restore(temporary, current.native_modules, previous, mapping)
        else
            try Seed.restoreNative(current.native_modules, previous, nodes.types);
    }

    const imported = function_mapping[0..module.functions.count()];

    for (module.function_imports, current.imports) |*previous, *binding| {
        if (comptime generated) {
            if (!Host.bind(previous, binding, imported, mapping, current.functions.count())) return error.InvalidModule;
        } else try Seed.bind(previous, binding, imported, nodes.types, current.functions.count());
    }

    const linked = ir.SignatureTable.fromFunctions(current.functions);

    for (imported, 0..) |id, row| {
        const previous = module.functions.at(row);
        const function = linked.at(@backingInt(id orelse return error.InvalidModule));

        const same = if (comptime generated)
            Host.sameSignature(previous, function, mapping)
        else
            try Seed.sameSignature(previous, function, nodes.types);

        if (!same) return error.InvalidModule;

        if (previous.external) |external| {
            if (external.member.len == 0) return error.InvalidModule;

            const implementation = function.external orelse return error.InvalidModule;

            if (comptime generated) {
                var mapped = external;

                mapped.module = try nodes.native_modules.get(external.module);

                if (!try @import("../link/native/signature.zig").compatible(temporary, mapped, implementation)) return error.InvalidModule;
            } else {
                const mapped = try nodes.external(external);

                if (!std.mem.eql(u8, mapped.exportName(), implementation.exportName()) or !native.sameExternalSeed(mapped, implementation)) return error.InvalidModule;
            }
        } else if (function.external != null) return error.InvalidModule;
    }

    if (module.function != null) function_mapping[module.functions.count()] = @fromBackingInt(@intCast(current.functions.count()));

    const function = if (module.function) |value| try nodes.function(value) else null;
    const body = if (function) |*value| value else null;
    const result = @import("../link/result/host.zig");
    const header = try result.publish(temporary, body, null);

    var program = try result.assemble(allocator, temporary, module, body, header, .{
        .types = types.items.view(),
        .functions = current.functions,
        .native_modules = current.native_modules,
    }, mapping);

    try @import("../function_body.zig").complete(allocator, &program, current.functions);
    if (try @import("../../ir/validate.zig").validate(temporary, program) != null) return error.InvalidIr;

    return program;
}
