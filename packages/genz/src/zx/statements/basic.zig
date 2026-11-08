const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;

pub fn discard(self: *Lower, output: *std.ArrayList(node.Statement), value: node.ExpressionId) Lower.Error!void {
    if (!generated) return output.append(self.allocator, .{ .discard = value });

    return append(@import("generated_statement_discard"), self, output, .{ .value = @backingInt(value) });
}

pub fn branch(self: *Lower, output: *std.ArrayList(node.Statement), condition: node.ExpressionId, yes: node.Block, no: node.Block) Lower.Error!void {
    if (!generated) return output.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = yes, .no = no } });

    return append(@import("generated_statement_branch"), self, output, .{
        .condition = @backingInt(condition),
        .yes_start = yes.start,
        .yes_count = yes.len,
        .no_start = no.start,
        .no_count = no.len,
    });
}

pub fn assignment(self: *Lower, output: *std.ArrayList(node.Statement), target: node.ExpressionId, value: node.ExpressionId) Lower.Error!void {
    if (!generated) return output.append(self.allocator, .{ .assignment = .{ .target = target, .value = value } });

    return append(@import("generated_statement_assignment"), self, output, .{ .target = @backingInt(target), .value = @backingInt(value) });
}

pub fn storeTarget(self: *Lower, slot: u32) Lower.Error!node.ExpressionId {
    if (!generated) {
        const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{slot});

        return self.field(try self.builder.identifier("pending"), name);
    }

    const entry = @import("generated_statement_store_target");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Nodes = std.meta.Child(@FieldType(Output, "nodes"));
    const input: Input = .{ .slot = slot, .base = @intCast(self.builder.nodes.expressions.tags.items.len) };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    var nodes = zx.columns.view(Nodes, result.nodes);
    const name = try self.allocator.dupe(u8, nodes.field_name[0]);
    const names = [_][]const u8{name};

    nodes.field_name = &names;

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &nodes) catch |err| return failure(err);

    return @fromBackingInt(result.root);
}

fn append(comptime entry: type, self: *Lower, output: *std.ArrayList(node.Statement), input: std.meta.Child(entry.Input)) Lower.Error!void {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, output, result) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
