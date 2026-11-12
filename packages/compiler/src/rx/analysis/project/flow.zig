const std = @import("std");
const rx = @import("rx");

pub const Step = struct {
    value: union(enum) {
        call: usize,
        parallel: []const Branch,
        result: rx.ast.Attribute,
        task: struct { node: rx.ast.Node, body: []const Step },
        selection: struct { subject: rx.ast.Attribute, cases: []const Case },
    },
};

pub const Case = struct { value: ?rx.ast.Attribute, body: []const Step };

pub const Exits = struct {
    returns: bool = false,
    terminates: bool = false,
    pub const returned: Exits = .{ .returns = true, .terminates = true };
};

pub const Sequence = struct {
    steps: std.ArrayList(Step) = .empty,
    exits: Exits = .{},
    pub fn append(self: *Sequence, allocator: std.mem.Allocator, value: @FieldType(Step, "value"), exits: Exits) std.mem.Allocator.Error!void {
        try self.steps.append(allocator, .{ .value = value });

        self.exits.returns = self.exits.returns or exits.returns;
        self.exits.terminates = exits.terminates;
    }
};

pub const BranchExits = struct {
    has_default: bool = false,
    any_return: bool = false,
    all_terminate: bool = true,
    pub fn add(self: *BranchExits, default: bool, exits: Exits) void {
        self.has_default = self.has_default or default;
        self.any_return = self.any_return or exits.returns;
        self.all_terminate = self.all_terminate and exits.terminates;
    }

    pub fn finish(self: BranchExits) Exits {
        return .{ .returns = self.any_return, .terminates = self.has_default and self.all_terminate };
    }
};

pub const Task = struct { id: usize, node: rx.ast.Node, body: []const Step };
pub const Branch = union(enum) { call: usize, task: Task };
