const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("interface.zig").Native;
const resolution = @import("../analysis/types/resolve.zig");
const views = @import("native/view.zig");
const syntax = zx.syntax.borrow;
const Types = @import("../analysis/types.zig");
pub const Member = struct { name: []const u8, function: ir.Function };
pub const Result = struct { types: ir.TypeTable, exports: []const ir.Export, members: []const Member };

pub fn load(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId, existing: ir.TypeTable, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, span: zx.Span) zx.Error!Result {
    var local: zx.Reporter = .{};

    return analyze(allocator, entry, module, existing, origins, &local) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = local.diagnostic.?;
        const location = zx.source.locate(entry.source, issue.span.start);
        const message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ entry.path, location.line, location.column, issue.message });

        return reporter.fail(issue.code, span, message);
    };
}

fn analyze(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId, existing: ir.TypeTable, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter) zx.Error!Result {
    if (@import("parser_options").generated_parser) {
        const generated = @import("generated_native");
        var scratch = std.heap.ArenaAllocator.init(allocator);

        defer scratch.deinit();

        const output = generated.execute(&scratch, entry.source) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow => return error.OutOfMemory,
            else => return reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(allocator, "internal compiler error: generated native parser failed with {s}", .{@errorName(err)})),
        };

        if (output.diagnostic.message.len != 0) return reporter.fail(
            std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
            zx.syntax.header.span(.{ .start = output.diagnostic.start, .end = output.diagnostic.end }),
            try allocator.dupe(u8, output.diagnostic.message),
        );

        const view = views.Indexed(@TypeOf(output)){
            .source = entry.source,
            .storage = output,
            .types = .{ .source = entry.source, .storage = output },
        };

        try @import("native/validate.zig").check(scratch.allocator(), view, reporter);

        return analyzeView(allocator, entry, module, existing, origins, reporter, view);
    }

    const parsed = try @import("declarations.zig").parse(allocator, entry.source, reporter);

    return analyzeView(allocator, entry, module, existing, origins, reporter, views.Native{ .value = parsed });
}

fn analyzeView(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId, existing: ir.TypeTable, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, view: anytype) zx.Error!Result {
    const type_view = view.typeView();
    var types = Types{ .native_interface = true, .allocator = allocator, .reporter = reporter, .declarations = &.{}, .shared = if (origins) |items| Types.Shared{ .origins = items, .origin = .{ .native = entry.key() } } else null };

    try types.items.appendDelta(allocator, existing);
    try resolution.initialize(&types, type_view);

    for (entry.namespace) |part| {
        if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return reporter.fail(.module, .{ .start = 0, .end = 0 }, "native namespaces require nonempty UTF-8 member names");
    }

    const declarations = type_view.declarations();
    const exports = try allocator.alloc(ir.Export, declarations.count());
    const members = try allocator.alloc(Member, view.functionCount());
    var iterator = declarations.iterator();

    for (exports) |*item| {
        const declaration = iterator.next().?;

        item.* = .{ .name = try allocator.dupe(u8, declaration.name.text), .type_id = try resolution.named(&types, type_view, declaration.name) };
    }

    for (members, 0..) |*member, index| {
        const declaration = view.functionAt(index);
        const parameters = try allocator.alloc(ir.TypeId, declaration.parameters.len);

        for (parameters, 0..) |*type_id, parameter_index| {
            type_id.* = try resolution.node(&types, type_view, syntax.item(declaration.parameters, parameter_index));

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

            for (owned, 0..) |*item, error_index| item.* = try allocator.dupe(u8, syntax.item(names, error_index));

            break :blk owned;
        } else null;

        const output = try resolution.node(&types, type_view, declaration.output);

        if (declaration.concurrent and (try ir.containsNativeReference(allocator, types.items.view(), input) or try ir.containsNativeReference(allocator, types.items.view(), output))) return reporter.fail(.capability, declaration.name.span, "host reference accessors cannot declare concurrency");
        if (try ir.containsNativeReference(allocator, types.items.view(), output) and !(try ir.containsNativeReference(allocator, types.items.view(), input))) return reporter.fail(.ownership, declaration.name.span, "native reference results require a host reference input");

        member.* = .{ .name = path[entry.namespace.len], .function = .{
            .file_name = try allocator.dupe(u8, entry.path),
            .input_type = input,
            .output_type = output,
            .symbols = &.{},
            .expressions = &.{},
            .body = &.{},
            .external = .{ .input = try @import("native_types.zig").parameters(allocator, type_view, declaration.parameters, reporter), .module = module, .member = path, .export_name = path[entry.namespace.len], .allocator_argument = declaration.allocator_argument, .io_argument = declaration.io_argument, .process_argument = declaration.process_argument, .expand_tuple = parameters.len > 1, .fallible = declaration.fallible, .errors = errors, .concurrent = declaration.concurrent },
        } };
    }

    return .{ .types = types.items.view(), .exports = exports, .members = members };
}
