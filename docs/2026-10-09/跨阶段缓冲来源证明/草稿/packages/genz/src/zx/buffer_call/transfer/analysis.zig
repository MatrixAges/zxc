const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("../analysis/flow.zig");

pub const Capability = struct {
    index_only: bool = false,
    writable: bool = false,
    forwardable: bool = false,
};

pub fn functions(allocator: std.mem.Allocator, program: ir.Program, lanes: []const []const flow.Lane, pure: []const bool) std.mem.Allocator.Error![]const []const Capability {
    const result = try allocator.alloc([]const Capability, program.functions.count());

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);
        const selected = try allocator.alloc(Capability, lanes[index].len);

        const producer = pure[index] and function.external == null and function.contracts.count() == 0 and
            function.stores.count() == 0 and @import("fresh.zig").product(program, function.output_type);

        for (lanes[index], selected) |lane, *capability| {
            capability.* = .{};

            if (lane.rejection != null or lane.appends.len != 0 or lane.pops.len != 0) continue;

            var writable = lane.updates.len != 0;

            const index_only = for (lane.calls) |saved| {
                const call = function.expressions.at(@backingInt(saved.expression)).value.call;
                const callee = @backingInt(call.function);

                if (callee >= index or call.stores.len != 0) break false;

                const nested = result[callee][saved.lane];

                if (!nested.index_only) break false;

                writable = writable or nested.writable;
            } else true;

            capability.* = .{
                .index_only = index_only,
                .writable = index_only and writable,
                .forwardable = index_only and producer,
            };
        }

        result[index] = selected;
    }

    return result;
}
