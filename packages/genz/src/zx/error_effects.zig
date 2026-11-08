const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("lower.zig");
const enabled = @import("genz_options").generated_analysis;
const generated = if (enabled) @import("generated_error_queries") else void;
const Input = if (enabled) std.meta.Child(generated.Input) else void;
const Output = if (enabled) std.meta.Child(generated.Output) else void;
pub const Cache = if (enabled) std.meta.Child(@FieldType(Output, "cache")) else struct { errors: ?[]const []const u8 };
const Request = if (enabled) std.meta.Child(@FieldType(Input, "request")) else void;
const Context = if (enabled) std.meta.Child(@FieldType(Request, "context")) else void;
const Tables = if (enabled) std.meta.Child(@FieldType(Context, "types")) else void;
const Functions = if (enabled) std.meta.Child(@FieldType(Context, "functions")) else void;

pub fn program(self: *Lower) Lower.Error!?[]const []const u8 {
    if (!enabled) return zx.error_effects.programWith(self.allocator, self.program, self.function_errors);

    const result = try query(self, null, if (self.error_cache) |*cache| cache else null);

    self.error_cache = result;

    return result.errors;
}

pub fn forFunction(self: *Lower, id: ir.FunctionId) Lower.Error!void {
    if (!enabled) return;

    const entry = @import("generated_function_error_cache");
    const Parameter = std.meta.Child(entry.Input);
    const input: Parameter = .{ .known = self.function_errors, .index = @backingInt(id) };
    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
    self.error_cache = if (output) |value| .{ .errors = value.errors } else null;
}

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!?[]const []const u8 {
    if (!enabled) return zx.error_effects.expressionWith(self.allocator, self.program.types, self.program.functions, self.program.expressions, id, self.function_errors);

    return (try query(self, id, null)).errors;
}

fn query(self: *Lower, id: ?ir.ExprId, cache: ?*const Cache) Lower.Error!Cache {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "base")), self.program.types);
    const delta = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "delta")), .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const functions = zx.columns.borrow(Functions, @as(*const ir.FunctionTable, &self.program.functions));
    const context: Context = .{ .types = &tables, .functions = &functions };

    const request: Request = .{
        .context = &context,
        .expressions = zx.columns.pointer(@FieldType(Request, "expressions"), @as(*const ir.ExpressionTable, &self.program.expressions)),
        .control = zx.columns.pointer(@FieldType(Request, "control"), self.program.body.control),
        .root = if (self.program.body.root) |root| @backingInt(root) else null,
        .contracts = zx.columns.pointer(@FieldType(Request, "contracts"), @as(*const ir.ContractTable, &self.program.contracts)),
        .stores = self.program.stores.count() != 0,
        .expression = if (id) |value| @backingInt(value) else 0,
        .program = id == null,
        .known = self.function_errors,
    };

    const input: Input = .{ .cache = cache, .request = &request };

    const output = zx.columns.invoke(generated.executeValue, scratch.allocator(), @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    var result: Cache = .{ .errors = output.cache.errors };

    if (output.fresh) {
        result.errors = if (result.errors) |names| try self.allocator.dupe([]const u8, names) else null;
    }

    return result;
}
