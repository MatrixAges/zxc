const std = @import("std");
const zx = @import("zx");
const Origins = @import("../../../modules/nominal_origins.zig");

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
types: *zx.ir.TypeStorage,
origins: *Origins,
origin: Origins.Origin,
aliases: []const zx.ir.Export = &.{},
functions: zx.ir.FunctionTable = .{},
function_imports: []const @import("../../../modules/function_import.zig") = &.{},
store_bindings: []const @import("../../analyze.zig").StoreBinding = &.{},
store_type_count: usize = 0,
