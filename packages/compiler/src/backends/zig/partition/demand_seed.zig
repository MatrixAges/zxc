const std = @import("std");
const model = @import("demand.zig");
const Variants = std.ArrayList([]const u8);
const Demands = std.AutoArrayHashMapUnmanaged(u32, Variants);
const Copies = std.AutoArrayHashMapUnmanaged(u32, void);
const Reference = struct { callees: []const u32, variants: []const []const u8 };

pub fn create(allocator: std.mem.Allocator, input: model.Input) std.mem.Allocator.Error!model.Plan {
    const references = try allocator.alloc(Reference, input.callees.len);

    for (references, input.callees, input.variants) |*reference, callees, variants| reference.* = .{ .callees = callees, .variants = variants };

    var state = Scopes{
        .allocator = allocator,
        .partitions = input.owners,
        .references = references,
        .inline_names = input.inline_names,
        .stubs = try allocator.alloc(Demands, @as(usize, input.count) + 1),
        .copies = try allocator.alloc(Copies, @as(usize, input.count) + 1),
        .seed = input.seed,
    };

    @memset(state.stubs, .empty);
    @memset(state.copies, .empty);

    if (input.seed) for (input.owners, references) |scope, calls| try state.demand(scope, calls);
    for (input.top_callees, input.top_variants) |callees, variants| try state.demand(input.count, .{ .callees = callees, .variants = variants });

    const scopes = try allocator.alloc(model.Scope, state.stubs.len);

    for (scopes, state.stubs, state.copies) |*scope, stub, copy| scope.* = .{ .copies = copy.keys(), .stubs = try publish(allocator, stub, copy) };

    return .{ .scopes = scopes, .exports = try publish(allocator, state.exports, .empty) };
}

fn publish(allocator: std.mem.Allocator, values: Demands, copies: Copies) std.mem.Allocator.Error!model.Values {
    var callees: std.ArrayList(u32) = .empty;
    var variants: std.ArrayList([]const []const u8) = .empty;

    for (values.keys(), values.values()) |callee, value| {
        if (copies.contains(callee)) continue;
        try callees.append(allocator, callee);
        try variants.append(allocator, value.items);
    }

    return .{ .callees = callees.items, .variants = variants.items };
}

/// Functions are referred to by their index in the planned function list.
const Scopes = struct {
    allocator: std.mem.Allocator,
    partitions: []const u32,
    references: []const Reference,
    inline_names: []const []const []const u8,
    stubs: []Demands,
    copies: []Copies,
    exports: Demands = .empty,
    seed: bool,
    /// Records every call from `scope` into a function owned by another scope.
    fn demand(self: *Scopes, scope: u32, calls: Reference) !void {
        for (calls.callees, calls.variants) |callee, variant| {
            if (self.partitions[callee] == scope) continue;

            const seed_import = self.seed and self.references[callee].callees.len <= 1;

            if (seed_import or inlined(self.inline_names[callee], variant)) {
                if ((try self.copies[scope].getOrPut(self.allocator, callee)).found_existing) continue;
                try self.demand(scope, self.references[callee]);

                continue;
            }

            try add(self.allocator, &self.stubs[scope], callee, variant);
            try add(self.allocator, &self.exports, callee, variant);
        }
    }
};

fn inlined(names: []const []const u8, variant: []const u8) bool {
    for (names) |name| if (std.mem.eql(u8, name, variant)) return true;

    return false;
}

fn add(allocator: std.mem.Allocator, demands: *Demands, callee: u32, variant: []const u8) !void {
    const entry = try demands.getOrPut(allocator, callee);

    if (!entry.found_existing) entry.value_ptr.* = .empty;
    for (entry.value_ptr.items) |known| if (std.mem.eql(u8, known, variant)) return;
    try entry.value_ptr.append(allocator, variant);
}

