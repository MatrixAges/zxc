const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const Order = @import("../order.zig");
const generated = @import("generated_uniqueness_order");
const Input = std.meta.Child(generated.Input);
const Output = std.meta.Child(generated.Output);
const Graph = std.meta.Child(@FieldType(Output, "graph"));
const generated_apart = @import("generated_uniqueness_apart");
const ApartInput = std.meta.Child(generated_apart.Input);
const generated_concurrent = @import("generated_uniqueness_concurrent");
pub const Nodes = std.meta.Child(@FieldType(Output, "nodes"));
pub const Regions = std.meta.Child(@FieldType(Graph, "regions"));
pub const Edges = std.meta.Child(@FieldType(Graph, "edges"));

pub fn build(allocator: std.mem.Allocator, workspace: std.mem.Allocator, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.Block) std.mem.Allocator.Error!Order {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const input = Input{
        .expressions = columns.pointer(@FieldType(Input, "expressions"), &expressions),
        .control = columns.pointer(@FieldType(Input, "control"), body.control),
        .symbols = symbols.count(),
        .first = @intCast(body.first),
        .count = @intCast(body.len),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const definitions = try allocator.alloc(Order.Def, output.graph.definitions.kind.len);

    for (output.graph.definitions.kind, definitions, 0..) |kind, *target, index| {
        const value: ir.ExprId = @fromBackingInt(output.graph.definitions.value[index]);

        target.* = switch (kind) {
            .Unknown => .unknown,
            .Input => .input,
            .Value => .{ .value = value },
            .Part => .{ .part = .{ .value = value, .index = output.graph.definitions.index[index] } },
            .Carried => .{ .carried = value },
            .Condition => .{ .condition = value },
            .Element => .element,
        };
    }

    comptime {
        std.debug.assert(@typeInfo(ir.ExprId).@"enum".tag_type == u32);

        const roles: @FieldType(Edges, "role") = &.{};

        _ = columns.slice([]const Order.Role, roles);
    }

    return .{
        .nodes = try ownColumns(allocator, output.nodes),
        .regions = try ownColumns(allocator, output.graph.regions),
        .edges = try ownColumns(allocator, output.graph.edges),
        .definitions = definitions,
        .def_loop = try allocator.dupe(u32, output.graph.definitions.repeated),
        .results = @ptrCast(try allocator.dupe(u32, output.graph.results)),
        .repeated = @ptrCast(try allocator.dupe(u32, output.graph.repeated.owner)),
        .repeated_parent = try allocator.dupe(u32, output.graph.repeated.parent),
        .concurrent = try allocator.dupe(bool, output.graph.repeated.concurrent),
        .seed = {},
    };
}

fn ownColumns(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!std.meta.Child(@TypeOf(source)) {
    const Table = std.meta.Child(@TypeOf(source));
    var result: Table = undefined;

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        const Item = std.meta.Child(@FieldType(Table, name));

        comptime switch (@typeInfo(Item)) {
            .int, .bool, .@"enum" => {},
            else => @compileError("Order columns must contain scalar metadata"),
        };

        @field(result, name) = try allocator.dupe(Item, @field(source.*, name));
    }

    return result;
}

pub fn apart(regions: *const Regions, left: u32, left_time: u32, right: u32, right_time: u32) bool {
    const input = ApartInput{ .regions = regions, .left = left, .left_time = left_time, .right = right, .right_time = right_time };
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return generated_apart.executeIn(memory.allocator(), &input) catch unreachable;
}

pub fn crossesConcurrent(parents: []const u32, concurrent: []const bool, inner: u32, outer: u32) bool {
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return generated_concurrent.executeIn(memory.allocator(), &.{ .parents = parents, .concurrent = concurrent, .inner = inner, .outer = outer }) catch unreachable;
}
