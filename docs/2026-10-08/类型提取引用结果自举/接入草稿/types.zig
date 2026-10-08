const std = @import("std");
const ir = @import("zx").ir;
const NominalOrigins = @import("../nominal_origins.zig");
const Error = @import("model.zig").Error;
const Self = @This();

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
source: ir.TypeTable,
origins: NominalOrigins.Table,
mapping: []?ir.TypeId,
items: ir.TypeStorage = .{},
nominal_origins: NominalOrigins,
pub fn init(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: ir.TypeTable, origins: NominalOrigins.Table) Error!Self {
    if (!@import("../../ir/type_rules.zig").validate(source)) return error.InvalidIr;
    if (!origins.hasValidShape()) return error.InvalidModule;

    const mapping = try temporary.alloc(?ir.TypeId, source.count());
    var self = Self{ .allocator = allocator, .temporary = temporary, .source = source, .origins = origins, .mapping = mapping, .nominal_origins = .{ .allocator = allocator } };
    const count = std.enums.values(ir.Scalar).len;

    @memset(mapping, null);

    try self.items.appendDelta(allocator, source.prefix(count));
    for (0..count) |index| mapping[index] = @fromBackingInt(@intCast(index));

    return self;
}

pub fn include(self: *Self, id: ir.TypeId) Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return @import("seed_types.zig").include(self, id);

    var workspace = @import("extract_workspace_view"){
        .allocator = self.allocator,
        .temporary = self.temporary,
        .source = self.source,
        .origins = self.origins,
        .mapping = self.mapping,
        .items = &self.items,
        .nominal = &self.nominal_origins.items,
    };

    return @import("../../analysis/semantic/extract.zig").include(&workspace, id);
}
