const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../nominal_origins.zig");
const Module = @import("../artifact/model.zig").Module;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin, ConflictingNominalType };

allocator: std.mem.Allocator,
items: ir.TypeStorage = .{},
origins: Origins,
pub fn init(allocator: std.mem.Allocator) Error!Self {
    var self = Self{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    for (std.enums.values(ir.Scalar)) |scalar| try self.items.append(allocator, .{ .scalar = scalar });

    return self;
}

pub fn append(self: *Self, temporary: std.mem.Allocator, module: Module) Error![]const ir.TypeId {
    return self.appendFrom(temporary, module.types, module.nominal_types, 0);
}

pub fn appendFrom(self: *Self, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: Origins.Table, first: usize) Error![]const ir.TypeId {
    if (!@import("../../ir/type_rules.zig").validate(values)) return error.InvalidModule;

    const prepared = try @import("../../analysis/semantic/preflight.zig").prepare(self.allocator, temporary, values, nominal_types, self.items.view(), first);

    if (!@import("parser_options").generated_parser) return @import("seed_types.zig").appendPrepared(self, temporary, values, nominal_types, first, prepared.origins, prepared.mapping);

    var writer = @import("merge_writer_view"){
        .allocator = self.allocator,
        .temporary = temporary,
        .source = values,
        .origins = nominal_types,
        .origin_indices = prepared.origins,
        .mapping = prepared.mapping,
        .items = &self.items,
        .nominal = &self.origins.items,
        .references = .{ .mapping = .{ .dense = prepared.mapping }, .target = &.{} },
    };

    try @import("../../analysis/semantic/merge.zig").append(&writer, first);

    return prepared.mapping;
}
