const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const Order = @import("../order.zig");
const Slots = @import("../slots.zig");
const Summaries = @import("../summaries.zig");
const generated = @import("generated_uniqueness_sites");
const usage = @import("generated_uniqueness_usage");
const usage_read = @import("generated_uniqueness_usage_read");
const Input = std.meta.Child(generated.Input);
pub const Facts = std.meta.Child(generated.Output);
pub const Plan = std.meta.Child(@FieldType(Facts, "plan"));
const State = std.meta.Child(@FieldType(Facts, "states"));
const Query = std.meta.Child(usage.Input);

pub fn build(allocator: std.mem.Allocator, workspace: std.mem.Allocator, order: *const Order, slots: Slots, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, summaries: *const Summaries) std.mem.Allocator.Error!Facts {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const Layout = std.meta.Child(@FieldType(Input, "layout"));
    const layout = Layout{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };

    const input = Input{
        .expressions = columns.pointer(@FieldType(Input, "expressions"), &expressions),
        .symbols = symbols.types,
        .counts = slots.counts,
        .def_loop = order.def_loop,
        .held = summaries.held,
        .written = summaries.written,
        .effects = summaries.effects,
        .layout = &layout,
        .nodes = columns.pointer(@FieldType(Input, "nodes"), &order.nodes),
        .regions = columns.pointer(@FieldType(Input, "regions"), &order.regions),
        .edges = columns.pointer(@FieldType(Input, "edges"), &order.edges),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const Table = std.meta.Child(@FieldType(Plan, "sites"));
    const sites = try allocator.create(Table);

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        const Item = std.meta.Child(@FieldType(Table, name));

        comptime switch (@typeInfo(Item)) {
            .int, .bool, .@"enum" => {},
            else => @compileError("Sites columns must contain scalar metadata"),
        };

        @field(sites.*, name) = try allocator.dupe(Item, @field(output.plan.sites.*, name));
    }

    const plan = try allocator.create(Plan);
    plan.* = .{ .edge_count = output.plan.edge_count, .first = try allocator.dupe(u32, output.plan.first), .slot_first = try allocator.dupe(u32, output.plan.slot_first), .sites = sites };

    return .{ .plan = plan, .states = try allocator.dupe(State, output.states) };
}

pub fn query(plan: *const Plan, order: *const Order, expressions: *const ir.ExpressionTable, symbols: usize, summaries: *const Summaries, root: u32, slot: u32, observe: bool) bool {
    const input = Query{
        .plan = columns.pointer(@FieldType(Query, "plan"), plan),
        .nodes = columns.pointer(@FieldType(Query, "nodes"), &order.nodes),
        .regions = columns.pointer(@FieldType(Query, "regions"), &order.regions),
        .expressions = columns.pointer(@FieldType(Query, "expressions"), expressions),
        .def_loop = order.def_loop,
        .symbols = symbols,
        .held = summaries.held,
        .written = summaries.written,
        .root = root,
        .slot = slot,
        .observe = observe,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return usage.executeIn(memory.allocator(), &input) catch unreachable;
}

pub fn read(state: State, comptime observe: bool) bool {
    const answers = comptime blk: {
        const names = @typeInfo(State).@"enum".field_names;
        var values: [names.len]bool = undefined;
        var memory = std.heap.FixedBufferAllocator.init(&.{});

        for (names, 0..) |name, index| {
            const value = @field(State, name);

            std.debug.assert(@backingInt(value) == index);

            values[index] = usage_read.executeIn(memory.allocator(), &.{ .state = value, .observe = observe }) catch unreachable;
        }

        break :blk values;
    };

    return answers[@backingInt(state)];
}
