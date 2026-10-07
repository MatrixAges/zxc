const std = @import("std");
const ir = @import("zx").ir;
const Children = @import("../../inline_call/children.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;
const Work = struct { id: ir.ExprId, region: usize, exclusive: bool };

allocator: std.mem.Allocator,
program: ir.Program,
uses: []u8,
references: []u8,
bindings: []?ir.ExprId,
declarations: []bool,
regions: []?usize,
exclusive: []bool,
pub fn create(allocator: std.mem.Allocator, program: ir.Program) Error!Self {
    var self = Self{
        .allocator = allocator,
        .program = program,
        .uses = try allocator.alloc(u8, program.expressions.count()),
        .references = try allocator.alloc(u8, program.symbols.count()),
        .bindings = try allocator.alloc(?ir.ExprId, program.symbols.count()),
        .declarations = try allocator.alloc(bool, program.symbols.count()),
        .regions = try allocator.alloc(?usize, program.expressions.count()),
        .exclusive = try allocator.alloc(bool, program.expressions.count()),
    };

    @memset(self.uses, 0);
    @memset(self.references, 0);
    @memset(self.bindings, null);
    @memset(self.declarations, false);
    @memset(self.regions, null);
    @memset(self.exclusive, false);

    for (0..program.expressions.count()) |index| {
        const value = program.expressions.at(index).value;

        switch (value) {
            .object => |object| for (0..object.fields.len) |field| self.use(object.fields.at(field).value),
            else => {
                const children = Children.init(value);

                for (0..children.len) |child| self.use(children.at(child));
            },
        }

        switch (value) {
            .reference => |symbol| self.references[@backingInt(symbol)] +|= 1,
            .task => |task| for (task.captures) |symbol| {
                self.references[@backingInt(symbol)] +|= 1;
            },
            .scope => |scope| for (0..scope.bindings.len) |binding_index| {
                const binding = scope.bindings.at(binding_index);

                if (binding.symbol) |symbol| self.bind(symbol, binding.value);
            },
            else => {},
        }
    }

    const control = program.body.control;
    var pending: std.ArrayList(Work) = .empty;

    for (control.constant_symbols, control.constant_values) |symbol, value| self.bind(@fromBackingInt(symbol), @fromBackingInt(value));

    inline for (.{ "evaluations", "constant_values", "parallel_values", "destructure_values", "branch_conditions", "selection_subjects", "setter_values" }) |name| {
        for (@field(control, name)) |value| try self.root(&pending, @fromBackingInt(value));
    }

    inline for (.{ "case_values", "results" }) |name| {
        for (@field(control, name)) |value| if (value) |id| try self.root(&pending, @fromBackingInt(id));
    }

    while (pending.pop()) |work| try self.visit(&pending, work);

    return self;
}

fn use(self: *Self, id: ir.ExprId) void {
    self.uses[@backingInt(id)] +|= 1;
}

fn bind(self: *Self, symbol: ir.SymbolId, value: ir.ExprId) void {
    const index = @backingInt(symbol);

    self.bindings[index] = if (self.declarations[index]) null else value;
    self.declarations[index] = true;
}

fn root(self: *Self, pending: *std.ArrayList(Work), id: ir.ExprId) Error!void {
    self.use(id);

    try pending.append(self.allocator, .{ .id = id, .region = 0, .exclusive = true });
}

fn visit(self: *Self, pending: *std.ArrayList(Work), work: Work) Error!void {
    const index = @backingInt(work.id);
    const region = if (self.regions[index]) |previous| if (previous == work.region) previous else std.math.maxInt(usize) else work.region;
    const exclusive = work.exclusive and self.uses[index] == 1 and region != std.math.maxInt(usize) and (self.regions[index] == null or self.exclusive[index]);

    if (self.regions[index] == region and self.exclusive[index] == exclusive) return;

    self.regions[index] = region;
    self.exclusive[index] = exclusive;

    const value = self.program.expression(work.id).value;
    const children = Children.init(value);

    for (0..children.len) |child_index| {
        const child = children.at(child_index);

        const repeated = switch (value) {
            .transform => child_index == 1,
            .iteration => child_index != 0,
            .task => true,
            else => false,
        };

        try pending.append(self.allocator, .{ .id = child, .region = if (repeated) @as(usize, @backingInt(child)) + 1 else region, .exclusive = exclusive });
    }
}
