const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const target = @import("target.zig");

pub fn load(allocator: std.mem.Allocator, options: target.Options) std.mem.Allocator.Error!target.Value {
    const attribute = target.attribute(options.call, "module");
    const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, options.owner });
    var reporter: zx.Reporter = .{};

    const resolved = frontend.project.resolveTarget(allocator, owner, attribute.value, options.project, &reporter, .{ .start = 0, .end = 0 }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return fail(allocator, options, "module", reporter.diagnostic.?.message);
    };

    if (resolved != .compiled) return fail(allocator, options, "module", "Call.module requires a public compiled package module");

    const selected = resolved.compiled;
    var library: ?frontend.project.compiled.Library = null;

    for (options.project.compiled_libraries) |candidate| {
        if (!std.mem.eql(u8, candidate.instance, selected.instance)) continue;

        const artifact = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, candidate.artifact });

        if (library != null or !std.mem.eql(u8, artifact, selected.artifact)) return fail(allocator, options, "module", "compiled package instance has conflicting artifacts");

        library = candidate;
    }

    var functions: std.ArrayList(zx.ir.Function) = .empty;
    var native_modules: std.ArrayList(zx.ir.NativeModule) = .empty;

    const loaded = frontend.project.compiled.load(allocator, .{
        .library = library orelse return fail(allocator, options, "module", "compiled library is missing from the input set"),
        .types = options.project.context.types,
        .nominal_types = options.project.context.nominal_types,
        .functions = &functions,
        .native_modules = &native_modules,
    }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return fail(allocator, options, "module", "compiled library cannot be linked to the shared type table");
    };

    for (loaded.exports) |exported| {
        if (!std.mem.eql(u8, exported.name, selected.name)) continue;

        const id = exported.function orelse return fail(allocator, options, "module", "Call.module requires an executable public module");
        const function = functions.items[@intFromEnum(id)];

        if (options.setter != null) return fail(allocator, options, "capability", "Call.module cannot grant a setter; Store authorization belongs inside the published RX module");
        if (function.stores.len != 0 and function.store_mode != .orchestration) return fail(allocator, options, "capability", "compiled Store transactions require an explicit authorized RX module");

        const stores = try allocator.alloc(u32, function.stores.len);

        for (stores, 0..) |*slot, index| slot.* = @intCast(index);

        const span = zx.Span{ .start = attribute.value_location.offset, .end = attribute.value_location.offset };
        const is_void = function.input_type == @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)));
        const symbols = try allocator.dupe(zx.ir.Symbol, &.{.{ .name = "$in", .type_id = function.input_type, .span = span }});

        const expressions = try allocator.dupe(zx.ir.Expression, &.{
            .{ .type_id = function.input_type, .span = span, .value = if (is_void) .unit else .{ .reference = @enumFromInt(0) } },
            .{ .type_id = function.output_type, .span = span, .value = .{ .call = .{ .function = id, .argument = @enumFromInt(0), .stores = stores } } },
        });

        const program = zx.ir.Program{
            .file_name = try std.fmt.allocPrint(allocator, "rx.module:{s}", .{exported.path}),
            .types = loaded.types,
            .stores = function.stores,
            .store_mode = function.store_mode,
            .input_type = function.input_type,
            .output_type = function.output_type,
            .output_ownership = function.output_ownership,
            .symbols = symbols,
            .expressions = expressions,
            .body = try allocator.dupe(zx.ir.Statement, &.{.{ .result = @enumFromInt(1) }}),
            .functions = functions.items,
            .native_modules = native_modules.items,
        };

        if (try frontend.validateIr(allocator, program)) |issue| return fail(allocator, options, @tagName(issue.code), issue.message);

        return .{ .function = .{ .program = program, .nominal_types = loaded.nominal_types, .store_initializers = loaded.store_initializers } };
    }

    return fail(allocator, options, "module", "compiled package does not export the requested public module");
}

fn fail(allocator: std.mem.Allocator, options: target.Options, code: []const u8, message: []const u8) std.mem.Allocator.Error!target.Value {
    return target.failure(allocator, .{ .path = options.owner, .location = target.attribute(options.call, "module").value_location, .code = code, .message = message });
}
