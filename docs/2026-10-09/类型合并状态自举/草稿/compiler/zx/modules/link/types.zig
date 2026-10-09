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

pub fn compact(self: *Self, temporary: std.mem.Allocator, first: usize, origin_count: usize) Error![]const ir.TypeId {
    const source = self.items.view();
    const origins = self.origins.items.view();

    self.items.retainPrefix(first);
    self.origins.items.retainPrefix(origin_count);

    errdefer {
        self.items.retainPrefix(first);
        self.origins.items.retainPrefix(origin_count);
    }

    const mapping = try self.appendFrom(temporary, source, origins, first);

    inline for (@typeInfo(ir.TypeStorage).@"struct".field_names) |name| {
        std.debug.assert(@field(self.items, name).items.ptr == @field(source, name).ptr);
    }

    inline for (@typeInfo(Origins.Storage).@"struct".field_names) |name| {
        std.debug.assert(@field(self.origins.items, name).items.ptr == @field(origins, name).ptr);
    }

    return mapping;
}

pub fn appendFrom(self: *Self, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: Origins.Table, first: usize) Error![]const ir.TypeId {
    if (!@import("../../ir/type_rules.zig").validate(values)) return error.InvalidModule;

    var prepared = try @import("../../analysis/semantic/preflight.zig").prepare(self.allocator, temporary, values, nominal_types, self.items.view(), first);

    defer prepared.deinitScratch();
    errdefer self.allocator.free(prepared.mapping);

    if (!@import("parser_options").generated_parser) return @import("seed_types.zig").appendPrepared(self, temporary, values, nominal_types, first, prepared.origins, prepared.mapping);

    try @import("../../analysis/semantic/merge.zig").append(.{
        .allocator = self.allocator,
        .temporary = temporary,
        .source = values,
        .origins = nominal_types,
        .origin_indices = prepared.origins,
        .mapping = prepared.mapping,
        .items = &self.items,
        .nominal = &self.origins.items,
        .first = first,
    });

    return prepared.mapping;
}
