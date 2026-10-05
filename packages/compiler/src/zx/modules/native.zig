const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("interface.zig").Native;
const Types = @import("../analysis/types.zig");
pub const Member = struct { name: []const u8, function: ir.Function };
pub const Result = struct { types: []const ir.Type, exports: []const ir.Export, members: []const Member };

pub fn load(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId, existing: []const ir.Type, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, span: zx.Span) zx.Error!Result {
    var local: zx.Reporter = .{};

    return analyze(allocator, entry, module, existing, origins, &local) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = local.diagnostic.?;
        const location = zx.source.locate(entry.source, issue.span.start);
        const message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ entry.path, location.line, location.column, issue.message });

        return reporter.fail(issue.code, span, message);
    };
}

fn analyze(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId, existing: []const ir.Type, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter) zx.Error!Result {
    const parsed = try @import("declarations.zig").parse(allocator, entry.source, reporter);
    var types = Types{ .allocator = allocator, .reporter = reporter, .declarations = parsed.types, .shared = if (origins) |items| Types.Shared{ .origins = items, .origin = .{ .native = entry.key() } } else null };

    try types.items.appendSlice(allocator, existing);
    try types.initialize();

    for (entry.namespace) |part| {
        if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return reporter.fail(.module, .{ .start = 0, .end = 0 }, "native namespaces require nonempty UTF-8 member names");
    }

    const exports = try allocator.alloc(ir.Export, parsed.types.len);
    const members = try allocator.alloc(Member, parsed.functions.len);

    for (parsed.types, exports) |declaration, *item| item.* = .{ .name = try allocator.dupe(u8, declaration.name.text), .type_id = try types.named(declaration.name) };

    for (parsed.functions, members) |declaration, *member| {
        const parameters = try allocator.alloc(ir.TypeId, declaration.parameters.len);

        for (declaration.parameters, parameters) |parameter, *type_id| {
            type_id.* = try types.resolve(parameter);

            if (type_id.* == Types.scalarId(.void)) return reporter.fail(.type_mismatch, declaration.name.span, "native void inputs use an empty parameter list");
        }

        const input = switch (parameters.len) {
            0 => Types.scalarId(.void),
            1 => parameters[0],
            else => try types.tuple(parameters),
        };

        const path = try allocator.alloc([]const u8, entry.namespace.len + 1);

        for (entry.namespace, path[0..entry.namespace.len]) |part, *item| {
            item.* = try allocator.dupe(u8, part);
        }

        path[entry.namespace.len] = try allocator.dupe(u8, declaration.name.text);

        const errors = if (declaration.errors) |names| blk: {
            const owned = try allocator.alloc([]const u8, names.len);

            for (names, owned) |name, *item| item.* = try allocator.dupe(u8, name);

            break :blk owned;
        } else null;

        member.* = .{ .name = path[entry.namespace.len], .function = .{
            .file_name = try allocator.dupe(u8, entry.path),
            .input_type = input,
            .output_type = try types.resolve(declaration.output),
            .symbols = &.{},
            .expressions = &.{},
            .body = &.{},
            .external = .{ .input = try @import("native_types.zig").parameters(allocator, parsed.types, declaration.parameters, reporter), .module = module, .member = path, .export_name = path[entry.namespace.len], .allocator_argument = declaration.allocator_argument, .io_argument = declaration.io_argument, .process_argument = declaration.process_argument, .expand_tuple = parameters.len > 1, .fallible = declaration.fallible, .errors = errors, .concurrent = declaration.concurrent },
        } };
    }

    return .{ .types = types.items.items, .exports = exports, .members = members };
}
