const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const References = @import("reference_view");
pub const copy = @import("copy.zig").value;
pub const Step = struct { id: u32, ready: bool };

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: ir.TypeTable,
origins: Origins.Table,
mapping: []?ir.TypeId,
items: *ir.TypeStorage,
nominal: *Origins.Storage,
pending: std.ArrayList(Step) = .empty,
scalar: [2]u32 = undefined,
references: References,
