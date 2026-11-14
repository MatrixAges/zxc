const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const model = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const Origins = @import("../nominal_origins.zig");
const Record = @import("../module_record.zig");
const FunctionImport = @import("../function_import.zig");
const generated = @import("parser_options").generated_parser;
const Seed = @import("restoring/seed.zig");
const Validate = @import("../../ir/validate.zig");

pub const Current = struct {
    allocator: std.mem.Allocator,
    backing: std.mem.Allocator,
    types: *ir.TypeStorage,
    origins: *Origins,
    functions: *ir.FunctionStorage,
    verified: *Validate.Verified,
    native_modules: ir.NativeModuleTable,
    aliases: []const ir.Export,
    imports: []const FunctionImport,
    members: []const FunctionImport = &.{},
    constant_imports: []const ir.Constant = &.{},
    dependencies: []const Record.Import,
};

const Error = @import("../link/types.zig").Error || model.Error;

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
        if (!@import("restoring/preflight/host.zig").check(module, &current, decoded)) return error.InvalidModule;
    } else if (!Seed.preflight(module, &current)) return error.InvalidModule;

    var arena = std.heap.ArenaAllocator.init(current.backing);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const allocator = current.allocator;
    const before_types = current.types.view();
    const first_origin = current.origins.items.view().count();

    errdefer {
        inline for (@typeInfo(ir.TypeStorage).@"struct".field_names) |name| {
            @field(current.types, name).items.len = @field(before_types, name).len;
        }

        current.origins.items.retainPrefix(first_origin);
    }

    const function_mapping = try temporary.alloc(?ir.FunctionId, module.functions.count() + @intFromBool(module.function != null));
    const native_mapping = try temporary.alloc(?ir.NativeModuleId, module.native_modules.count());

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    const mapping, const own = if (comptime generated) prepared: {
        const types = @import("restoring/types/host.zig");
        const ids = try temporary.alloc(u32, module.types.count());

        @memset(ids, 0);

        var workspace = zx.Arena.init(temporary);

        defer workspace.deinit();

        const plan = try types.prepare(workspace.allocator(), module, &current, ids, decoded);

        const entry = try @import("restoring/rebind/host.zig").check(temporary, module, &current, .{
            .types = @ptrCast(ids),
            .functions = function_mapping,
            .natives = native_mapping,
        });

        try types.commit(&current, plan);

        break :prepared .{ @as([]const ir.TypeId, @ptrCast(ids)), entry };
    } else seed: {
        const ids = try Seed.mergeTypes(temporary, module, &current);
        var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = ids }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };
        const entry = try Seed.rebind(module, &current, &nodes, function_mapping, native_mapping);

        break :seed .{ ids, entry };
    };

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };
    const structure: Nodes.Structure = if (decoded) .validated else .unchecked;
    const result = @import("../link/result/host.zig");

    const tables: result.Tables = .{
        .types = current.types.view(),
        .functions = current.functions.view(),
        .native_modules = current.native_modules,
    };

    var restored = if (comptime generated)
        try @import("restoring/publication/host.zig").materialize(&nodes, module, tables, own, structure)

    else seed: {
        const function = if (module.function) |value| try nodes.functionEntry(value, own, structure) else null;

        break :seed Restored{
            .program = try result.assemble(allocator, module, if (function) |*value| &value.body else null, tables, mapping),
            .recursive = if (function) |value| value.recursive else null,
        };
    };

    const program = &restored.program;
    const recursive = restored.recursive;

    if (recursive != null) {
        try current.functions.append(allocator, @import("../function_body.zig").value(program.*));

        program.functions = current.functions.view();
    }

    errdefer if (recursive != null) {
        _ = current.functions.pop(allocator);
    };

    if (try Validate.validateProjectPrefix(temporary, program.*, current.verified.*) != null) return error.InvalidIr;

    if (comptime generated) current.verified.* = .{
        .functions = program.functions.count(),
        .types = Validate.TypePrefix.fromTable(program.types),
        .native = true,
    };

    return restored;
}
