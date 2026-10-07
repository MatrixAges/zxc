const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_native_validation");
const layout = @import("../../analysis/semantic/resolving/host/layout.zig");

pub fn check(arena: *std.heap.ArenaAllocator, view: anytype, reporter: *zx.Reporter) zx.Error!void {
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .source = view.source,
        .declarations = layout.borrow(@FieldType(Input, "declarations"), view.storage.declarations),
        .functions = layout.borrow(@FieldType(Input, "functions"), view.storage.functions),
        .parameters = layout.borrow(@FieldType(Input, "parameters"), view.storage.parameters),
        .errors = layout.borrow(@FieldType(Input, "errors"), view.storage.errors),
    };

    const diagnostic = generated.execute(arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (diagnostic.message.len != 0) return reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), diagnostic.code) orelse unreachable,
        zx.syntax.header.span(.{ .start = diagnostic.start, .end = diagnostic.end }),
        diagnostic.message,
    );
}
