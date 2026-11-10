const std = @import("std");
const zx = @import("zx");
const initialize = @import("generated_store_registry_initialize");
const registration = @import("generated_store_registry_register");
const coverage = @import("generated_store_registry_coverage");
const State = @typeInfo(@typeInfo(@TypeOf(initialize.executeState)).@"fn".return_type.?).error_union.payload;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ DuplicateInitializer, MissingInitializer, InvalidInitializer };

state: State,
allocator: std.mem.Allocator,
pub fn create(allocator: std.mem.Allocator) Error!Self {
    return .{ .state = initialize.executeState(allocator, .{}) catch |err| return failure(err), .allocator = allocator };
}

pub fn register(self: *Self, identity: []const u8, type_id: zx.ir.TypeId) Error!void {
    self.state = registration.executeState(self.allocator, .{
        .registry = self.state,
        .identity = .{ .items = identity, .storage = .plain },
        .type_id = @backingInt(type_id),
        .zx_origin = null,
    }) catch |err| return failure(err);

    if (self.state.status == .DuplicateInitializer) return error.DuplicateInitializer;
}

pub fn validate(self: *const Self, stores: *const zx.ir.StoreTable) Error!void {
    const Input = std.meta.Child(coverage.Input);
    const Registry = std.meta.Child(@FieldType(Input, "registry"));
    const Index = std.meta.Child(@FieldType(Registry, "index"));

    const index: Index = .{
        .keys = self.state.index.keys.items,
        .values = self.state.index.values.items,
        .buckets = self.state.index.buckets.items,
    };

    const registry: Registry = .{ .index = &index, .status = self.state.status };
    const input: Input = .{ .registry = &registry, .paths = stores.paths, .types = stores.types };
    const status = coverage.executeValue(self.allocator, &input) catch |err| return failure(err);

    return switch (status) {
        .Ready => {},
        .MissingInitializer => error.MissingInitializer,
        .InvalidInitializer => error.InvalidInitializer,
        else => unreachable,
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
