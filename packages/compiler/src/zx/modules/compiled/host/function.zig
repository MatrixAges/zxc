const std = @import("std");
const ir = @import("zx").ir;
const own = @import("../../artifact/nodes/columns.zig").own;
const strings = @import("native.zig").strings;

pub fn copy(allocator: std.mem.Allocator, source: ir.Function) std.mem.Allocator.Error!ir.Function {
    var result = source;
    const control = try allocator.create(ir.ControlTable);
    control.* = try own(allocator, source.body.control.*, .{});
    result.file_name = try allocator.dupe(u8, source.file_name);
    result.symbols = try own(allocator, source.symbols, .{});
    result.expressions = try own(allocator, source.expressions, .{});
    result.stores = try own(allocator, source.stores, .{});
    result.contracts = try @import("../../../analysis/analyzer/host/contracts.zig").copy(allocator, source.contracts);
    result.body = .{ .control = control, .root = source.body.root };
    result.external = if (source.external) |external| try copyExternal(allocator, external) else null;

    return result;
}

fn copyExternal(allocator: std.mem.Allocator, source: ir.External) std.mem.Allocator.Error!ir.External {
    var result = source;
    result.member = try strings(allocator, source.member);
    result.errors = if (source.errors) |errors| try strings(allocator, errors) else null;
    result.export_name = if (source.export_name) |name| try allocator.dupe(u8, name) else null;

    if (source.input) |input| {
        const names = try allocator.alloc(?[]const u8, input.names.len);

        for (input.names, names) |name, *owned| owned.* = if (name) |text| try allocator.dupe(u8, text) else null;

        result.input = .{ .names = names };
    }

    return result;
}
