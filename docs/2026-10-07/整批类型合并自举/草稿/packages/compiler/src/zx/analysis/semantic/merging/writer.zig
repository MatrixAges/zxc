const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const References = @import("reference_view");
pub const copy = @import("copy.zig").value;

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: ir.TypeTable,
origins: Origins.Table,
origin_indices: []const ?usize,
mapping: []ir.TypeId,
items: *ir.TypeStorage,
nominal: *Origins.Storage,
scalar: [2]u32 = undefined,
references: References,
