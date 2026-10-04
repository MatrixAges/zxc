const std = @import("std");
const ir = @import("zx").ir;
const Record = @import("../module_record.zig");
const Error = @import("model.zig").Error;
const Self = @This();

needed: []bool,
program: ir.Program,
pub fn collect(allocator: std.mem.Allocator, program: ir.Program, record: Record) Error![]const bool {
    const needed = try allocator.alloc(bool, program.types.len);
    var self = Self{ .needed = needed, .program = program };

    @memset(needed, false);

    if (record.type_range.start > record.type_range.end or record.type_range.end > needed.len) return error.InvalidModule;

    @memset(needed[record.type_range.start..record.type_range.end], true);

    for (record.exports) |item| try self.mark(item.type_id);
    for (record.type_imports) |item| try self.mark(item.type_id);

    for (record.function_imports) |binding| {
        if (@intFromEnum(binding.id) >= program.functions.len) return error.InvalidModule;

        const function = program.functions[@intFromEnum(binding.id)];

        try self.mark(binding.input_type);
        try self.mark(binding.output_type);
        try self.mark(function.input_type);
        try self.mark(function.output_type);

        if (binding.positional_types) |types| for (types) |id| {
            try self.mark(id);
        };

        if (function.external) |external| try self.nativeModule(external.module);
    }

    for (record.imports) |dependency| {
        if (dependency.target != .native) continue;

        for (program.native_modules, 0..) |module, index| {
            if (std.mem.eql(u8, dependency.specifier, module.specifier)) try self.nativeModule(@enumFromInt(index));
        }
    }

    switch (record.body) {
        .types => {},
        .entry => {
            try self.mark(program.input_type);
            try self.mark(program.output_type);
            try self.nodes(program.symbols, program.expressions, program.contracts);
            for (program.stores) |slot| try self.mark(slot.type_id);
        },
        .function => |id| {
            if (@intFromEnum(id) >= program.functions.len) return error.InvalidModule;

            const function = program.functions[@intFromEnum(id)];

            try self.mark(function.input_type);
            try self.mark(function.output_type);
            try self.nodes(function.symbols, function.expressions, function.contracts);
            for (function.stores) |slot| try self.mark(slot.type_id);
        },
    }

    var remaining = needed.len;

    while (remaining != 0) {
        remaining -= 1;

        if (!needed[remaining]) continue;

        switch (program.types[remaining]) {
            .optional, .list => |child| try self.mark(child),
            .tuple => |children| for (children) |child| try self.mark(child),
            .object => |fields| for (fields) |field| try self.mark(field.type_id),
            .scalar, .enumeration => {},
        }
    }

    return needed;
}

fn mark(self: *Self, id: ir.TypeId) Error!void {
    if (@intFromEnum(id) >= self.needed.len) return error.InvalidModule;

    self.needed[@intFromEnum(id)] = true;
}

fn nativeModule(self: *Self, id: ir.NativeModuleId) Error!void {
    if (@intFromEnum(id) >= self.program.native_modules.len) return error.InvalidModule;
    for (self.program.native_modules[@intFromEnum(id)].types) |item| try self.mark(item.type_id);
}

fn nodes(self: *Self, symbols: []const ir.Symbol, expressions: []const ir.Expression, contracts: []const ir.Contract) Error!void {
    for (symbols) |symbol| try self.mark(symbol.type_id);
    for (expressions) |expression| try self.mark(expression.type_id);

    for (contracts) |contract| {
        for (contract.symbols) |symbol| try self.mark(symbol.type_id);
        for (contract.expressions) |expression| try self.mark(expression.type_id);
    }
}
