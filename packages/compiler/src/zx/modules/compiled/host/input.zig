const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../compiled.zig");
const load = @import("../load.zig");
const Origins = @import("../../nominal_origins.zig");
const borrow = @import("../../../ir/canonical/borrow.zig");
const generated = @import("generated_compiled_library");
const Input = std.meta.Child(generated.Input);
const Graph = std.meta.Child(@FieldType(Input, "graph"));
const Destination = std.meta.Child(@FieldType(Input, "destination"));
const Self = @This();

program: @import("../../../ir/canonical/validation/input.zig").Storage(std.meta.Child(@FieldType(Graph, "program"))),
origins: std.meta.Child(@FieldType(Graph, "origins")),
exports: std.meta.Child(@FieldType(Graph, "exports")),
initializers: std.meta.Child(@FieldType(Graph, "initializers")),
types: std.meta.Child(@FieldType(Destination, "types")),
base_origins: std.meta.Child(@FieldType(Destination, "origins")),
natives: std.meta.Child(@FieldType(Destination, "natives")),
graph: Graph,
destination: Destination,
input: Input,
pub fn init(self: *Self, allocator: std.mem.Allocator, graph: *const model.Graph, instance: []const u8, artifact: []const u8, destination: ?load.Destination, seed: bool) std.mem.Allocator.Error!void {
    try self.program.init(allocator, &graph.program, 0);

    self.origins = Origins.Table.borrow(@TypeOf(self.origins), graph.nominal_types);
    self.exports = try @import("input/exports.zig").columns(@TypeOf(self.exports), allocator, graph.exports);
    self.initializers = try @import("input/initializers.zig").columns(@TypeOf(self.initializers), allocator, graph.store_initializers);
    self.types = ir.TypeTable.borrow(@TypeOf(self.types), if (destination) |target| target.types.view() else .{});
    self.base_origins = Origins.Table.borrow(@TypeOf(self.base_origins), if (destination) |target| target.origins.items.view() else .{});
    self.natives = borrow.columns(@TypeOf(self.natives), if (destination) |target| target.native_modules.view() else @as(ir.NativeModuleTable, .{}));
    self.graph = .{ .program = &self.program.input, .origins = &self.origins, .origin_names = graph.nominal_types.names, .exports = &self.exports, .initializers = &self.initializers };
    self.destination = .{ .types = &self.types, .origins = &self.base_origins, .origin_names = if (destination) |target| target.origins.items.view().names else &.{}, .natives = &self.natives, .function_count = if (destination) |target| target.functions.count() else 0 };
    self.input = .{ .graph = &self.graph, .instance = instance, .artifact = artifact, .load = destination != null, .seed = seed, .destination = &self.destination };
}
