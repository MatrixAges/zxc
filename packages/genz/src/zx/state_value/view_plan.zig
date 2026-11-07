const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const querying = @import("generated_state_view_query");
const Query = std.meta.Child(querying.Input);
const Source = std.meta.Child(@FieldType(Query, "source"));
const Conversion = std.meta.Child(@FieldType(Source, "source"));
const planning = @import("generated_state_view_plan");
const Plan = std.meta.Child(@import("generated_state_conversion_plan").Output);

pub fn required(self: *Lower, id: ir.TypeId, input: bool) Lower.Error!bool {
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Conversion, "types")), self.program.types);

    const conversion: Conversion = .{
        .types = &types,
        .queries = zx.columns.slice(@FieldType(Conversion, "queries"), self.state_plan.queries),
        .selected = self.state_plan.selected,
        .element_storage = self.state_plan.element_storage,
        .root = @backingInt(id),
        .mode = if (input) .ViewValue else .ViewLayout,
    };

    const source = borrowed(self, &conversion);
    const query: Query = .{ .source = &source, .type_id = @backingInt(id), .mode = conversion.mode };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    while (true) {
        const decision = zx.columns.invoke(querying.executeValue, fixed.allocator(), &query) catch |err| return failure(err);

        if (decision.resource == .None) return decision.operation != .Value;
        try resolve(self, @backingInt(id), decision.resource);
    }
}

pub fn build(self: *Lower, allocator: std.mem.Allocator, conversion: *const Conversion) Lower.Error!*const Plan {
    const creating = @import("generated_state_view_initialize");
    const CreateParameter = @typeInfo(@TypeOf(creating.executeState)).@"fn".param_types[1].?;
    const CreateInput = Child(CreateParameter);
    const initial: CreateInput = .{ .root = conversion.root, .mode = conversion.mode };
    var state = creating.executeState(allocator, if (@typeInfo(CreateParameter) == .pointer) &initial else initial) catch |err| return failure(err);
    const Parameter = @typeInfo(@TypeOf(planning.executeState)).@"fn".param_types[1].?;
    const Input = Child(Parameter);
    const source = borrowed(self, conversion);

    while (true) {
        const input: Input = .{ .source = &source, .state = state };

        state = planning.executeState(allocator, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);

        if (state.complete) break;
        try resolve(self, state.pending.type_id, state.resource);
    }

    const result = try allocator.create(Plan);

    inline for (@typeInfo(Plan).@"struct".field_names) |name| @field(result, name) = @field(state.plan, name).items;

    return result;
}

fn borrowed(self: *const Lower, conversion: *const Conversion) Source {
    const view = @import("../../node/view.zig");

    return .{
        .source = conversion,
        .states = view.slice(@FieldType(Source, "states"), @as([]const node.ExpressionId, self.state_types)),
        .views = view.slice(@FieldType(Source, "views"), @as([]const node.ExpressionId, self.view_types)),
    };
}

fn resolve(self: *Lower, id: u32, resource: anytype) Lower.Error!void {
    switch (resource) {
        .State => _ = try @import("../types.zig").get(self, self.state_types, @fromBackingInt(id)),
        .View => _ = try @import("../types.zig").get(self, self.view_types, @fromBackingInt(id)),
        .None => @panic("missing view type request"),
    }
}

fn Child(comptime Value: type) type {
    return if (@typeInfo(Value) == .pointer) std.meta.Child(Value) else Value;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid view conversion plan"),
    };
}
