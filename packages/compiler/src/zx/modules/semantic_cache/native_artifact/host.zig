const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("../../interface.zig").Native;
const Artifact = @import("../../artifact/model.zig");
const Origins = @import("../../nominal_origins.zig");
const generated = @import("generated_native_artifact");
const Input = std.meta.Child(generated.Input);

pub fn create(allocator: std.mem.Allocator, entry: Native, fingerprint: [32]u8, error_allocator: std.mem.Allocator, reporter: *zx.Reporter, span: zx.Span) zx.Error!Artifact.Result {
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const declaration: std.meta.Child(@FieldType(Input, "declaration")) = .{
        .identity = entry.identity,
        .specifier = entry.specifier,
        .path = entry.path,
        .import_name = entry.module,
        .namespace = entry.namespace,
    };

    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "base")), .{});
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), .{});
    const input: Input = .{ .declaration = &declaration, .namespace_bytes = entry.namespace, .source = entry.source, .base = &base, .origins = &origins };

    const result = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return fail(error_allocator, reporter, entry, span, .contract, 0, try std.fmt.allocPrint(scratch.allocator(), "internal compiler error: generated native analysis failed with {s}", .{@errorName(err)})),
    };

    const value = result.artifact orelse return fail(error_allocator, reporter, entry, span,
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        @intCast(result.diagnostic.start), result.diagnostic.message);

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const module = try @import("own.zig").artifact(arena.allocator(), value, entry.key(), fingerprint);

    return .{ .arena = arena, .value = module };
}

fn fail(allocator: std.mem.Allocator, reporter: *zx.Reporter, entry: Native, span: zx.Span, code: @FieldType(zx.Diagnostic, "code"), offset: usize, cause: []const u8) zx.Error {
    const location = zx.source.locate(entry.source, offset);
    const message = std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ entry.path, location.line, location.column, cause }) catch return error.OutOfMemory;

    return reporter.fail(code, span, message);
}
