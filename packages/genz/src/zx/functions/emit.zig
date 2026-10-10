const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Requests = @import("requests.zig");

pub fn append(self: *Lower, output: *std.ArrayList(node.Declaration), request: Requests.Item) Lower.Error!void {
    const index = @backingInt(request.id);
    const function = self.program.functions.at(index);

    if (function.external != null) {
        std.debug.assert(request.variant == .regular);

        try output.append(self.allocator, try @import("../external.zig").lower(self, function, index));

        return;
    }

    var helper = self.*;

    helper.program.symbols = function.symbols;
    helper.program.expressions = function.expressions;
    helper.program.body = function.body;
    helper.program.input_type = function.input_type;
    helper.program.output_type = function.output_type;
    helper.program.stores = function.stores;
    helper.program.store_mode = function.store_mode;
    helper.program.contracts = function.contracts;
    helper.pending_name = try std.fmt.allocPrint(self.allocator, "zx_pending_{d}", .{index});
    helper.names = try self.allocator.alloc([]const u8, function.symbols.count());
    helper.used = try self.allocator.alloc(bool, function.symbols.count());
    helper.cache_reads = try self.allocator.alloc(usize, function.expressions.count());
    helper.cache = .empty;
    helper.append_overrides = .empty;
    helper.list_update_buffers = .empty;
    helper.collection_buffers = .empty;
    helper.buffer_calls = .empty;
    helper.stack_symbols = .empty;
    helper.state_symbols = .empty;
    helper.state_active = false;
    helper.buffered_type = null;
    helper.buffer_pointer = false;
    helper.value_output = false;
    helper.iteration_value = null;
    helper.capture = null;
    helper.serial = 0;

    if (request.first) try @import("../store.zig").declaration(&helper, output);

    const name = try request.variant.name(self.allocator, request.id);

    const declaration = switch (request.variant) {
        .regular => try helper.function(name, false),
        .value => try helper.functionValue(name),
        .buffered => try @import("../buffer_call/root.zig").declaration(&helper, name, self.buffer_functions[index], .value),
        .buffered_pointer => try @import("../buffer_call/root.zig").declaration(&helper, name, self.buffer_functions[index], .pointer),
    };

    try output.append(self.allocator, declaration);

    self.buffer_types = helper.buffer_types;
    self.iteration_analyses = helper.iteration_analyses;
    self.uses_parallel = self.uses_parallel or helper.uses_parallel;
}
