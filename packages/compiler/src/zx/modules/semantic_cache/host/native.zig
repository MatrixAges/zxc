const std = @import("std");
const Native = @import("../../interface.zig").Native;
const Loaded = @import("../../native.zig");
const Artifact = @import("../../artifact/model.zig");
const restoring = @import("../native_restore.zig");
const generated = @import("generated_native_restore");
const Input = @import("native_input.zig");

pub fn restore(allocator: std.mem.Allocator, artifact: Artifact.Module, entry: Native, current: restoring.Current) restoring.Error!Loaded.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var input: Input = undefined;

    try input.init(arena.allocator(), artifact, entry, current);

    const result = generated.execute(&arena, &input.input) catch |err| switch (err) {
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

    return @import("native_publish.zig").apply(allocator, result.value.?, &artifact, &entry, current);
}
