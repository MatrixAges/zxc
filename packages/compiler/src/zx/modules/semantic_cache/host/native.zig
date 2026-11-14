const std = @import("std");
const columns = @import("zx").columns;
const Native = @import("../../interface.zig").Native;
const Loaded = @import("../../native.zig");
const Artifact = @import("../../artifact/model.zig");
const restoring = @import("../native_restore.zig");
const generated = @import("generated_native_restore");
const Input = @import("native_input.zig");

pub fn restore(allocator: std.mem.Allocator, artifact: *const Artifact.Module, entry: Native, current: restoring.Current, admitted: bool) restoring.Error!Loaded.Result {
    var arena = std.heap.ArenaAllocator.init(current.backing);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    var input: Input = undefined;
    const temporary = scratch.allocator();

    try input.init(temporary, artifact, entry, current, admitted);

    if (!admitted) try @import("native_admission.zig").check(temporary, &input.request, artifact.function_imports);

    const request: *const @TypeOf(input.input) = &input.input;

    const result = columns.invoke(generated.executeValue, temporary, request) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    switch (result.status) {
        .Ready => {},
        .InvalidModule => return error.InvalidModule,
        .InvalidIr => return error.InvalidIr,
        .MissingNominalOrigin => return error.MissingNominalOrigin,
        .ConflictingNominalType => return error.ConflictingNominalType,
    }

    return @import("native_publish.zig").apply(allocator, result.value.?, &input, artifact.functions, current);
}
