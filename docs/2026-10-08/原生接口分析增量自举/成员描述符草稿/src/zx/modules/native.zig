const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("interface.zig").Native;
const resolution = @import("../analysis/types/resolve.zig");
const views = @import("native/view.zig");
const Members = @import("native/members.zig");
const Types = @import("../analysis/types.zig");
pub const Member = Members.Member;
pub const Result = struct { types: ir.TypeTable, exports: []const ir.Export, members: []const Member };

pub fn load(arena: *std.heap.ArenaAllocator, entry: Native, module: ir.NativeModuleId, existing: *ir.TypeStorage, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, span: zx.Span) zx.Error!Result {
    const allocator = arena.allocator();
    var local: zx.Reporter = .{};

    return analyze(arena, entry, module, existing, origins, &local) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const issue = local.diagnostic.?;
        const location = zx.source.locate(entry.source, issue.span.start);
        const message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ entry.path, location.line, location.column, issue.message });

        return reporter.fail(issue.code, span, message);
    };
}

fn analyze(arena: *std.heap.ArenaAllocator, entry: Native, module: ir.NativeModuleId, existing: *ir.TypeStorage, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter) zx.Error!Result {
    const allocator = arena.allocator();

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

        try @import("native/validate.zig").check(&scratch, view, reporter);

        return analyzeView(arena, entry, module, existing, origins, reporter, view);
    }

    const parsed = try @import("declarations.zig").parse(allocator, entry.source, reporter);

    return analyzeView(arena, entry, module, existing, origins, reporter, views.Native{ .value = parsed });
}

fn analyzeView(arena: *std.heap.ArenaAllocator, entry: Native, module: ir.NativeModuleId, existing: *ir.TypeStorage, origins: ?*@import("nominal_origins.zig"), reporter: *zx.Reporter, view: anytype) zx.Error!Result {
    const allocator = arena.allocator();
    const type_view = view.typeView();
    var types = Types{ .native_interface = true, .allocator = allocator, .reporter = reporter, .declarations = &.{}, .shared = if (origins) |items| Types.Shared{ .origins = items, .origin = .{ .native = entry.key() } } else null };

    types.items = existing.*;
    existing.* = .{};
    defer existing.* = types.items;

    try resolution.initialize(&types, type_view);

    if (!@import("parser_options").generated_parser) {
        for (entry.namespace) |part| {
            if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return reporter.fail(.module, .{ .start = 0, .end = 0 }, "native namespaces require nonempty UTF-8 member names");
        }
    }

    const analyzed = if (@import("parser_options").generated_parser)
        try @import("native/interface.zig").analyze(&types, view, entry, module)

    else blk: {
        const declarations = type_view.declarations();
        const exports = try allocator.alloc(ir.Export, declarations.count());
        var iterator = declarations.iterator();

        for (exports) |*item| {
            const declaration = iterator.next().?;

            item.* = .{ .name = try allocator.dupe(u8, declaration.name.text), .type_id = types.resolved.get(declaration.name.text).? };
        }

        const signatures = try @import("native/seed_signatures.zig").analyze(arena, &types, view);
        const members = try allocator.alloc(Member, signatures.len);

        if (members.len != 0) {
            const owner = try Members.init(allocator, entry, module);

            for (members, signatures, 0..) |*member, signature, index| {
                const declaration = view.functionAt(index);

                member.* = try owner.create(.{
                    .name = declaration.name.text,
                    .signature = .{ .input = @backingInt(signature.input), .output = @backingInt(signature.output) },
                    .allocator_argument = declaration.allocator_argument,
                    .io_argument = declaration.io_argument,
                    .process_argument = declaration.process_argument,
                    .expand_tuple = declaration.parameters.len > 1,
                    .fallible = declaration.fallible,
                    .errors = declaration.errors,
                    .concurrent = declaration.concurrent,
                }, signature.native);
            }
        }

        break :blk @import("native/interface.zig").Result{ .exports = exports, .members = members };
    };

    return .{ .types = types.items.view(), .exports = analyzed.exports, .members = analyzed.members };
}
