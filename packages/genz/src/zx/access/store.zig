const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, slot: u32, type_id: ir.TypeId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("store_seed.zig").lower(self, slot, type_id);

    self.uses_context = true;

    const generated = @import("generated_store_access");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const row = @backingInt(type_id);

    const input: Input = .{
        .slot = slot,
        .type_kind = self.program.types.kinds[row],
        .query = zx.columns.view(@FieldType(Input, "query"), self.state_plan.queries[row]),
        .active = self.state_active,
        .store_count = self.program.stores.count(),
        .store_mode = switch (self.program.store_mode) {
            .transaction => .transaction,
            .orchestration => .orchestration,
        },
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    var nodes = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    const name = try self.allocator.dupe(u8, output.name);
    const names = [_][]const u8{ name, name };

    nodes.field_name = names[0..nodes.field_name.len];

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &nodes) catch |err| return failure(err);

    const root: node.ExpressionId = @fromBackingInt(output.root);

    switch (output.result) {
        .Direct => return root,
        .BorrowedList => return @import("../state_value/list.zig").borrowed(self, type_id, root),
        .Value => {},
        .ViewValue => unreachable,
    }

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try @import("../aggregate.zig").bind(self, &body, root);
    const converted = try @import("../state_value/conversion.zig").convert(self, &body, type_id, source, .value);

    return @import("../aggregate.zig").finish(self, &body, converted);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
