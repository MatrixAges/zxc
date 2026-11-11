const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const generated = @import("genz_options").generated_analysis;
const writing = @import("generated_cache_put");

pub fn Map(comptime Key: type) type {
    comptime {
        const info = @typeInfo(Key);

        if (info != .@"enum" or info.@"enum".tag_type != u32) @compileError("Expression map keys must use enum(u32)");
    }

    return struct {
        const State = if (generated) @typeInfo(@typeInfo(@TypeOf(writing.executeState)).@"fn".return_type.?).error_union.payload else std.AutoHashMapUnmanaged(Key, node.ExpressionId);
        const Self = @This();

        state: State = if (generated) .{
            .count = 0,
            .metadata = .{ .items = &.{}, .storage = .plain },
            .keys = .{ .items = &.{}, .storage = .plain },
            .values = .{ .items = &.{}, .storage = .plain },
        } else .empty,
        pub const empty: Self = .{};
        pub const SnapshotBuffer = [256]u8;

        pub fn put(self: *Self, allocator: std.mem.Allocator, key: Key, value: node.ExpressionId) std.mem.Allocator.Error!void {
            if (!generated) return self.state.put(allocator, key, value);

            self.state = writing.executeState(allocator, .{ .state = self.state, .key = @backingInt(key), .value = @backingInt(value) }) catch |err| {
                if (err == error.OutOfMemory) {
                    var fixed = std.heap.FixedBufferAllocator.init(&.{});
                    const result = @import("generated_cache_overwrite").executeState(fixed.allocator(), .{ .state = self.state, .key = @backingInt(key), .value = @backingInt(value) }) catch unreachable;

                    if (result) |state| {
                        self.state = state;

                        return;
                    }
                }

                if (err == error.OutOfMemory or err == error.IntegerOverflow) return error.OutOfMemory;

                unreachable;
            };
        }

        pub fn get(self: *const Self, key: Key) ?node.ExpressionId {
            if (!generated) return self.state.get(key);

            const slot = self.lookup(key) orelse return null;

            return @fromBackingInt(self.state.values.items[slot]);
        }

        pub fn contains(self: *const Self, key: Key) bool {
            if (!generated) return self.state.contains(key);

            return self.lookup(key) != null;
        }

        pub fn remove(self: *Self, key: Key) bool {
            if (!generated) return self.state.remove(key);

            var fixed = std.heap.FixedBufferAllocator.init(&.{});
            const result = @import("generated_cache_remove").executeState(fixed.allocator(), .{ .state = self.state, .key = @backingInt(key) }) catch unreachable;

            self.state = result.state;

            return result.removed;
        }
        pub fn snapshot(self: *const Self, allocator: std.mem.Allocator, keys: []const Key) std.mem.Allocator.Error![]const ?u32 {
            if (keys.len == 0) return &.{};

            if (!generated) {
                const values = try allocator.alloc(?u32, keys.len);

                for (keys, values) |key, *value| value.* = if (self.get(key)) |prior| @backingInt(prior) else null;

                return values;
            }

            const entry = @import("generated_cache_snapshot");
            const Input = std.meta.Child(entry.Input);
            const state = self.view(std.meta.Child(@FieldType(Input, "state")));
            const input: Input = .{ .state = &state, .keys = rawKeys(keys) };

            return zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| switch (err) {
                error.OutOfMemory => return error.OutOfMemory,
                else => unreachable,
            };
        }
        pub fn restore(self: *Self, allocator: std.mem.Allocator, keys: []const Key, values: []const ?u32) void {
            if (keys.len == 0) return;

            if (!generated) {
                for (keys, values) |key, value| {
                    if (value) |prior| self.put(allocator, key, @fromBackingInt(prior)) catch unreachable else _ = self.remove(key);
                }

                return;
            }

            const entry = @import("generated_cache_restore");

            self.state = entry.executeState(allocator, .{
                .state = self.state,
                .keys = .{ .items = rawKeys(keys), .storage = .plain },
                .previous = .{ .items = values, .storage = .plain },
            }) catch unreachable;
        }

        fn rawKeys(keys: []const Key) []const u32 {
            return @as([*]const u32, @ptrCast(keys.ptr))[0..keys.len];
        }
        pub fn view(self: *const Self, comptime Target: type) Target {
            return .{
                .count = self.state.count,
                .metadata = self.state.metadata.items,
                .keys = self.state.keys.items,
                .values = self.state.values.items,
            };
        }
        fn lookup(self: *const Self, key: Key) ?usize {
            const querying = @import("generated_cache_lookup");
            const Input = std.meta.Child(querying.Input);

            const input: Input = .{
                .count = self.state.count,
                .metadata = self.state.metadata.items,
                .keys = self.state.keys.items,
                .key = @backingInt(key),
            };

            var fixed = std.heap.FixedBufferAllocator.init(&.{});
            const result = zx.columns.invoke(querying.executeValue, fixed.allocator(), &input) catch unreachable;

            return if (result) |slot| @intCast(slot) else null;
        }
        pub const Iterator = if (!generated) State.Iterator else struct {
            owner: *const Self,
            slot: u64 = 0,
            pub fn next(self: *@This()) ?struct { key_ptr: *const Key, value_ptr: *const node.ExpressionId } {
                const querying = @import("generated_cache_next");
                const Input = std.meta.Child(querying.Input);
                const input: Input = .{ .metadata = self.owner.state.metadata.items, .count = self.owner.state.count, .start = self.slot };
                var fixed = std.heap.FixedBufferAllocator.init(&.{});
                const result = zx.columns.invoke(querying.executeValue, fixed.allocator(), &input) catch unreachable;
                self.slot = result.next;
                const slot = result.position orelse return null;

                return .{ .key_ptr = @ptrCast(&self.owner.state.keys.items[slot]), .value_ptr = @ptrCast(&self.owner.state.values.items[slot]) };
            }
        };
        pub fn iterator(self: *const Self) Iterator {
            return if (!generated) self.state.iterator() else .{ .owner = self };
        }
    };
}
