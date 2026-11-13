const std = @import("std");
const ir = @import("zx").ir;
const Native = @import("../interface.zig").Native;
const Loaded = @import("../native.zig");
const Artifact = @import("../artifact/model.zig");
const Types = @import("../link/types.zig");
const Origins = @import("../nominal_origins.zig");
pub const Current = struct { module: ir.NativeModuleId, types: *ir.TypeStorage, origins: *Origins };
pub const Error = Types.Error || Artifact.Error;

pub fn restore(allocator: std.mem.Allocator, artifact: Artifact.Module, entry: Native, current: Current) Error!Loaded.Result {
    if (!@import("parser_options").generated_parser) return @import("seed_native_restore.zig").restore(allocator, artifact, entry, current);

    return @import("host/native.zig").restore(allocator, artifact, entry, current);
}
