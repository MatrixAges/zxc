const std = @import("std");
const zx = @import("zx");
const Function = @import("../function.zig");
const Level = @import("../level.zig").Level;
const closing = @import("generated_uniqueness_function_close");
const Input = @typeInfo(@TypeOf(closing.executeValue)).@"fn".param_types[1].?;
const Context = @FieldType(Input, "context");
const Result = @typeInfo(@TypeOf(closing.executeValue)).@"fn".return_type.?;
pub const State = @typeInfo(Result).error_union.payload;
const Knowledge = std.meta.Child(@FieldType(State, "known"));
const Growth = std.meta.Child(std.meta.Child(@FieldType(Context, "normalized")));

pub fn close(function: *Function) std.mem.Allocator.Error!void {
    var borrowed: Borrowed = undefined;

    try borrowed.init(function);

    const state = closing.executeValue(function.allocator, .{ .context = borrowed.context, .repeated = @ptrCast(function.order.repeated) }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("function closure failed: {s}", .{@errorName(err)}),
    };

    function.evaluation = state;

    try publish(function);
}

pub fn level(value: Knowledge) Level {
    return @bitCast(@as(u3, @intCast(@backingInt(value))));
}

pub fn publish(function: *Function) std.mem.Allocator.Error!void {
    if (function.reads) |reads| for (function.evaluation.?.reads) |entry| {
        try reads.append(function.allocator, .{ .table = @fromBackingInt(@backingInt(entry.table)), .function = entry.function_index, .slot = entry.slot, .value = level(entry.value) });
    };
}

pub const Borrowed = struct {
    const Descriptor = std.meta.Child(std.meta.Child(@FieldType(Context, "zx_origin")));
    const Metadata = std.meta.Child(@FieldType(Descriptor, "metadata"));
    const Layout = std.meta.Child(@FieldType(Metadata, "layout"));
    const Usage = std.meta.Child(@FieldType(Metadata, "usage"));

    context: Context,
    descriptor: Descriptor,
    metadata: Metadata,
    layout: Layout,
    usage: Usage,
    pub fn init(self: *Borrowed, function: *Function) std.mem.Allocator.Error!void {
        const slots = function.slots;
        const sites = function.sites;
        const order = function.order;

        self.layout = .{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };

        self.usage = .{
            .plan = zx.columns.pointer(@FieldType(Usage, "plan"), sites.facts.plan),
            .nodes = zx.columns.pointer(@FieldType(Usage, "nodes"), &order.nodes),
            .regions = zx.columns.pointer(@FieldType(Usage, "regions"), &order.regions),
            .expressions = zx.columns.pointer(@FieldType(Usage, "expressions"), &@as(*const Function, function).expressions),
            .def_loop = order.def_loop,
            .symbols = sites.symbols.count(),
            .held = sites.summaries.held,
            .written = sites.summaries.written,
            .root = 0,
            .slot = 0,
            .observe = false,
        };

        self.metadata = .{
            .expressions = zx.columns.pointer(@FieldType(Metadata, "expressions"), &@as(*const Function, function).expressions),
            .definitions = zx.columns.pointer(@FieldType(Metadata, "definitions"), &order.definitions),
            .layout = &self.layout,
            .counts = slots.counts,
            .parents = order.repeated_parent,
            .concurrent = order.concurrent,
            .usage = &self.usage,
            .states = @ptrCast(sites.facts.states),
            .input = @ptrCast(function.input),
            .output = @ptrCast(function.summaries.output),
            .function_index = @intCast(function.function orelse std.math.maxInt(u32)),
            .record = function.reads != null,
        };

        self.descriptor = .{
            .metadata = &self.metadata,
            .normalized = try growth(function.allocator, function.normalized.*),
            .renewed = try growth(function.allocator, function.renewed.*),
        };

        const descriptor: *const Descriptor = &self.descriptor;

        self.context = zx.columns.borrow(Context, descriptor);
    }
};

fn growth(allocator: std.mem.Allocator, map: anytype) std.mem.Allocator.Error![]const *const Growth {
    const rows = try allocator.alloc(Growth, map.count());
    const pointers = try allocator.alloc(*const Growth, rows.len);
    var entries = map.iterator();
    var index: usize = 0;

    while (entries.next()) |entry| : (index += 1) {
        const key = switch (@typeInfo(@TypeOf(entry.key_ptr.*))) {
            .@"enum" => @backingInt(entry.key_ptr.*),
            else => entry.key_ptr.*,
        };

        rows[index] = .{ .key = key, .value = @fromBackingInt(@as(u3, @bitCast(entry.value_ptr.*))) };
        pointers[index] = &rows[index];
    }

    return pointers;
}
