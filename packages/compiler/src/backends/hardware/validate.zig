const std = @import("std");
const ir = @import("ir.zig");

pub fn validate(module: ir.Module) bool {
    for (module.nodes, 0..) |node, index| {
        if (node.sort.width == 0 or node.sort.width > 256 or (node.sort.boolean and node.sort.width != 1)) return false;

        switch (node.value) {
            .input => |input| {
                if (input >= module.inputs.len) return false;
                if (@intFromEnum(module.inputs[input].node) != index or !module.inputs[input].sort.equal(node.sort)) return false;
            },
            .constant => |value| if (node.sort.width < 64 and value >> @intCast(node.sort.width) != 0) return false,
            .invert, .negate => |operand| {
                const sort = child(module, index, operand) orelse return false;

                if (!node.sort.equal(sort) or sort.boolean != (node.value == .invert)) return false;
            },
            .extend => |extension| {
                const sort = child(module, index, extension.operand) orelse return false;

                if (sort.boolean or node.sort.boolean or extension.extra > 256 or node.sort.width != sort.width + extension.extra) return false;
            },
            .select => |selection| {
                const condition = child(module, index, selection.condition) orelse return false;
                const yes = child(module, index, selection.yes) orelse return false;
                const no = child(module, index, selection.no) orelse return false;

                if (!condition.boolean or !yes.equal(no) or !node.sort.equal(yes)) return false;
            },
            .binary => |binary| {
                const left = child(module, index, binary.left) orelse return false;
                const right = child(module, index, binary.right) orelse return false;
                const logical = binary.operator == .logical_and or binary.operator == .logical_or;
                const equality = binary.operator == .equal;
                const comparison = @intFromEnum(binary.operator) >= @intFromEnum(ir.Operator.unsigned_less);
                const result: ir.Sort = if (logical or equality or comparison) .{ .width = 1, .boolean = true } else left;

                if (!left.equal(right) or !node.sort.equal(result)) return false;
                if (!equality and left.boolean != logical) return false;
            },
        }
    }

    for (module.inputs, 0..) |port, index| {
        if (!validPort(module, port, "input", index)) return false;

        const value = module.nodes[@intFromEnum(port.node)].value;

        if (value != .input or value.input != index) return false;
    }

    for (module.outputs, 0..) |port, index| {
        if (!validPort(module, port, "output", index)) return false;
    }

    return @intFromEnum(module.safe) < module.nodes.len and module.nodes[@intFromEnum(module.safe)].sort.boolean;
}

fn child(module: ir.Module, parent: usize, id: ir.Id) ?ir.Sort {
    const index = @intFromEnum(id);

    return if (index < parent) module.nodes[index].sort else null;
}

fn validPort(module: ir.Module, port: ir.Port, prefix: []const u8, index: usize) bool {
    var buffer: [64]u8 = undefined;
    const name = std.fmt.bufPrint(&buffer, "{s}_{d}", .{ prefix, index }) catch return false;
    const node = @intFromEnum(port.node);

    return std.mem.eql(u8, name, port.name) and node < module.nodes.len and port.sort.equal(module.nodes[node].sort) and !(port.signed and port.sort.boolean);
}
