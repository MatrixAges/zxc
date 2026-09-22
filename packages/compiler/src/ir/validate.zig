const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!?zx.Diagnostic {
    if (program.version != zx.ir_version or !@import("type_rules.zig").validate(program.types)) return invalid();
    if (!try function(allocator, program)) return invalid();

    for (program.functions, 0..) |item, function_index| {
        for (item.expressions) |expression| {
            if (expression.value == .call and @intFromEnum(expression.value.call.function) >= function_index) return invalid();
        }

        if (item.external) |external| {
            if (external.module.len == 0 or external.member.len == 0 or item.symbols.len != 0 or item.expressions.len != 0 or item.body.len != 0 or @intFromEnum(item.input_type) >= program.types.len or @intFromEnum(item.output_type) >= program.types.len) return invalid();
            if (external.expand_tuple and program.typeOf(item.input_type) != .tuple) return invalid();

            continue;
        }

        var child = program;
        child.file_name = item.file_name;
        child.input_type = item.input_type;
        child.output_type = item.output_type;
        child.symbols = item.symbols;
        child.expressions = item.expressions;
        child.body = item.body;
        child.type_only = false;
        child.stores = &.{};

        if (!try function(allocator, child)) return invalid();
    }

    for (program.exports, 0..) |item, index| {
        if (@intFromEnum(item.type_id) >= program.types.len or item.name.len == 0) return invalid();

        for (program.exports[0..index]) |previous| {
            if (std.mem.eql(u8, item.name, previous.name)) return invalid();
        }
    }

    for (program.stores) |item| {
        if (@intFromEnum(item.type_id) >= program.types.len or program.typeOf(item.type_id) != .object or !std.mem.startsWith(u8, item.path, "store.")) return invalid();
    }

    return null;
}

fn function(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (@intFromEnum(program.input_type) >= program.types.len or @intFromEnum(program.output_type) >= program.types.len) return false;
    if (program.type_only) return @intFromEnum(program.input_type) == 0 and @intFromEnum(program.output_type) == 0 and program.symbols.len == 0 and program.expressions.len == 0 and program.body.len == 0;
    if (program.symbols.len == 0 or program.symbols[0].type_id != program.input_type) return false;

    for (program.symbols) |symbol| {
        if (@intFromEnum(symbol.type_id) >= program.types.len or symbol.name.len == 0) return false;
    }

    for (program.expressions, 0..) |expression, index| {
        if (!@import("expression_rules.zig").validate(program, expression, index)) return false;
    }

    if (!try @import("scopes.zig").validate(allocator, program)) return false;

    var reporter: zx.Reporter = .{};

    @import("../ownership/check.zig").check(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return false;
    };

    return true;
}

fn invalid() zx.Diagnostic {
    return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid ZX IR version, structure, types or bindings" };
}
