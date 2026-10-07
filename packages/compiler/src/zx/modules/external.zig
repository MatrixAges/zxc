const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const External = @import("interface.zig").External;
const Types = @import("../analysis/types.zig");
const Result = struct { types: ir.TypeTable, function: ir.Function };

pub fn load(allocator: std.mem.Allocator, entry: External, module: ir.NativeModuleId, span: zx.Span, existing: ir.TypeTable, shared: Types.Shared, reporter: *zx.Reporter) zx.Error!Result {
    const signature = try @import("signature.zig").resolve(allocator, entry, span, existing, shared, reporter);
    const input_type = signature.input_type;
    const output_type = signature.output_type;
    const implementation = entry.implementation;

    if (implementation.expand_tuple and signature.types.at(@backingInt(input_type)) != .tuple) return reporter.fail(.module, span, "positional external signatures require tuple Input");

    const errors = if (implementation.errors) |names| blk: {
        if (!implementation.fallible) return reporter.fail(.module, span, "native error sets require a fallible implementation");

        const owned = try allocator.alloc([]const u8, names.len);

        for (names, 0..) |name, index| {
            if (!@import("lint").checkName(name, .type_decl)) return reporter.fail(.naming, span, "error names must use PascalCase");

            for (names[0..index]) |previous| {
                if (std.mem.eql(u8, previous, name)) return reporter.fail(.name, span, "duplicate native error name");
            }

            owned[index] = try allocator.dupe(u8, name);
        }

        break :blk owned;
    } else null;

    var members: std.ArrayList([]const u8) = .empty;
    var parts = std.mem.splitScalar(u8, implementation.member, '.');

    while (parts.next()) |part| {
        if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return reporter.fail(.module, span, "native member paths require nonempty UTF-8 names");
        try members.append(allocator, try allocator.dupe(u8, part));
    }

    return .{ .types = signature.types, .function = .{
        .file_name = try allocator.dupe(u8, entry.specifier),
        .input_type = input_type,
        .output_type = output_type,
        .symbols = .{},
        .expressions = .{},
        .body = &.{},
        .external = .{
            .module = module,
            .member = members.items,
            .export_name = if (entry.export_name) |name| try allocator.dupe(u8, name) else null,
            .allocator_argument = implementation.allocator_argument,
            .io_argument = implementation.io_argument,
            .process_argument = implementation.process_argument,
            .expand_tuple = implementation.expand_tuple,
            .fallible = implementation.fallible,
            .errors = errors,
            .concurrent = implementation.concurrent,
        },
    } };
}
