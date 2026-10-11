const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Origins = @import("../nominal_origins.zig");
const External = @import("../interface.zig").External;
const Result = @import("../external.zig").Result;
const generated = @import("generated_external");
const Input = std.meta.Child(generated.Input);

pub fn load(allocator: std.mem.Allocator, entry: External, module: zx.ir.NativeModuleId, span: zx.Span, existing: *zx.ir.TypeStorage, shared: Types.Shared, reporter: *zx.Reporter) zx.Error!Result {
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const base = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "type_base")), existing.view());
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "nominal_base")), shared.origins.items.view());

    const origin: std.meta.Child(@FieldType(Input, "nominal_origin")) = .{
        .kind = switch (shared.origin) {
            .source => 0,
            .native => 1,
            .external => 2,
        },
        .owner = switch (shared.origin) {
            .source, .native => |name| name,
            .external => |value| value.module,
        },
        .member = if (shared.origin == .external) shared.origin.external.member else "",
    };

    const location: std.meta.Child(@FieldType(Input, "span")) = .{ .start = span.start, .end = span.end };
    const implementation = entry.implementation;

    const input = Input{
        .bytes = entry.signature,
        .type_base = &base,
        .nominal_base = &origins,
        .nominal_origin = &origin,
        .span = &location,
        .expand_tuple = implementation.expand_tuple,
        .fallible = implementation.fallible,
        .errors = implementation.errors,
        .member = implementation.member,
    };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return reporter.fail(.contract, span, try std.fmt.allocPrint(allocator, "internal compiler error: generated external loading failed with {s}", .{@errorName(err)})),
    };

    if (output.publish) try @import("../../analysis/semantic/merging/commit.zig").append(allocator, existing, &shared.origins.items, output.type_delta.*, output.nominal_delta.*);

    if (output.diagnostic.message.len != 0) return reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try allocator.dupe(u8, output.diagnostic.message),
    );

    const errors = if (implementation.errors) |names| copied: {
        const owned = try allocator.alloc([]const u8, names.len);

        for (names, owned) |name, *value| value.* = try allocator.dupe(u8, name);

        break :copied owned;
    } else null;

    const members = try allocator.alloc([]const u8, output.members.len);

    for (output.members, members) |part, *member| member.* = try allocator.dupe(u8, implementation.member[@intCast(part.start)..@intCast(part.end)]);

    return .{ .types = existing.view(), .function = .{
        .file_name = try allocator.dupe(u8, entry.specifier),
        .input_type = @fromBackingInt(output.input_type),
        .output_type = @fromBackingInt(output.output_type),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .external = .{
            .module = module,
            .member = members,
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
