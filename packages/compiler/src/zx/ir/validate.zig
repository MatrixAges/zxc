const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!?zx.Diagnostic {
    if (program.version != zx.ir_version or !@import("type_rules.zig").validate(program.types)) return invalid();
    if (!@import("native_modules.zig").validate(program)) return invalid();
    if (!try function(allocator, program)) return invalid();

    for (program.functions, 0..) |item, function_index| {
        for (item.expressions) |expression| {
            if (expression.value == .call and @backingInt(expression.value.call.function) >= function_index) return invalid();
        }

        if (item.external) |external| {
            if (item.consumes_input or item.stores.len != 0 or item.store_mode != .transaction or item.contracts.len != 0 or item.output_ownership != .borrowed) return invalid();
            if (@backingInt(external.module) >= program.native_modules.len or external.member.len == 0 or item.symbols.len != 0 or item.expressions.len != 0 or item.body.len != 0 or @backingInt(item.input_type) >= program.types.len or @backingInt(item.output_type) >= program.types.len) return invalid();

            for (external.member) |part| {
                if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return invalid();
            }

            if (!@import("native_modules.zig").validateExport(program, function_index)) return invalid();
            if (program.typeOf(item.input_type) == .task or program.typeOf(item.output_type) == .task) return invalid();
            if (external.expand_tuple and program.typeOf(item.input_type) != .tuple) return invalid();

            if (external.input) |shape| {
                if (!@import("native_modules.zig").validateType(program, external.module, item.input_type, shape, 0)) return invalid();
            }

            continue;
        }

        var child = program;
        child.file_name = item.file_name;
        child.input_type = item.input_type;
        child.output_type = item.output_type;
        child.consumes_input = item.consumes_input;
        child.output_ownership = item.output_ownership;
        child.symbols = item.symbols;
        child.expressions = item.expressions;
        child.body = item.body;
        child.type_only = false;
        child.stores = item.stores;
        child.store_mode = item.store_mode;
        child.contracts = item.contracts;

        if (!try function(allocator, child)) return invalid();
    }

    for (program.exports, 0..) |item, index| {
        if (@backingInt(item.type_id) >= program.types.len or item.name.len == 0) return invalid();
        if (program.typeOf(item.type_id) == .task) return invalid();

        for (program.exports[0..index]) |previous| {
            if (std.mem.eql(u8, item.name, previous.name)) return invalid();
        }
    }

    if (!try @import("error_contracts.zig").validate(allocator, program)) return invalid();

    return null;
}

fn function(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (!@import("stores.zig").validate(program)) return false;
    if (@backingInt(program.input_type) >= program.types.len or @backingInt(program.output_type) >= program.types.len) return false;
    if (program.type_only) return !program.consumes_input and @backingInt(program.input_type) == 0 and @backingInt(program.output_type) == 0 and program.symbols.len == 0 and program.expressions.len == 0 and program.body.len == 0 and program.contracts.len == 0;
    if (!@import("contracts.zig").validate(program)) return false;
    if (program.symbols.len == 0 or program.symbols[0].type_id != program.input_type) return false;

    for (program.symbols) |symbol| {
        if (@backingInt(symbol.type_id) >= program.types.len or symbol.name.len == 0) return false;
    }

    for (program.expressions, 0..) |expression, index| {
        if (!@import("expression_rules.zig").validate(program, expression, index)) return false;
    }

    if (!try @import("scopes.zig").validate(allocator, program)) return false;
    if (!try @import("tasks.zig").validate(allocator, program)) return false;

    var reporter: zx.Reporter = .{};

    const ownership = @import("../ownership/check.zig").analyze(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return false;
    };

    if (program.output_ownership != .borrowed and program.output_ownership != ownership) return false;

    return true;
}

fn invalid() zx.Diagnostic {
    return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid ZX IR version, structure, types or bindings" };
}
