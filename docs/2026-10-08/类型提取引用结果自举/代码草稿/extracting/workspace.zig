const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
pub const copy = @import("copy.zig").value;

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: ir.TypeTable,
origins: Origins.Table,
mapping: []?ir.TypeId,
items: *ir.TypeStorage,
nominal: *Origins.Storage,
