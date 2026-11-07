const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const calls = @import("call.zig");
const generated = @import("generated_growth_renew");
const Input = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(Input, "source"));

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, value: node.ExpressionId, path: []const u32) Lower.Error!void {
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    var source = calls.prepare(self, .Renew, .{
        .element = @fromBackingInt(0),
        .value = value,
        .flag = !self.may_grow,
    });

    const Capture = std.meta.Child(@typeInfo(@FieldType(Source, "capture")).optional.child);
    var boundary: Capture = undefined;

    if (self.capture) |capture| {
        boundary = .{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) };
        source.capture = &boundary;
    }

    const input: Input = .{
        .source = &source,
        .types = &types,
        .type_id = @backingInt(type_id),
        .path = path,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(output.serial == self.serial);

    _ = try calls.publish(self, body, output);
}

pub fn bufferedPath(self: *const Lower, type_id: ir.TypeId, path: []const u32, inline_lists: bool) bool {
    const module = @import("generated_growth_renew_buffered");
    const Query = std.meta.Child(module.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Query, "types")), self.program.types);

    const input: Query = .{
        .types = &types,
        .type_id = @backingInt(type_id),
        .path = path,
        .inline_lists = inline_lists,
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(module.executeValue, empty.allocator(), &input) catch unreachable;
}

pub fn appendValue(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, reference: node.ExpressionId) Lower.Error!void {
    const module = @import("generated_growth_value");
    const Abi = std.meta.Child(module.Input);
    const Parameter = @typeInfo(@TypeOf(module.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Query = if (indirect) std.meta.Child(Parameter) else Parameter;
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Abi, "types")), self.program.types);
    const ValueSource = std.meta.Child(@FieldType(Abi, "source"));

    var source = zx.columns.view(ValueSource, calls.prepare(self, .Renew, .{
        .element = @fromBackingInt(0),
        .value = reference,
        .flag = !self.may_grow,
    }));

    const Capture = std.meta.Child(@typeInfo(@FieldType(ValueSource, "capture")).optional.child);
    var boundary: Capture = undefined;

    if (self.capture) |capture| {
        boundary = .{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) };
        source.capture = &boundary;
    }

    const input = zx.columns.view(Query, .{
        .source = @as(*const @TypeOf(source), &source),
        .types = &types,
        .type_id = @backingInt(self.program.expression(id).type_id),
        .owner = @backingInt(id),
        .records = self.plan.renewals,
        .inline_lists = if (self.iteration_value) |context| context.inline_lists else false,
    });

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = module.executeValue(memory.allocator(), if (indirect) &input else input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(result.serial == self.serial);

    const Output = std.meta.Child(@import("generated_growth_call").Output);
    const expressions = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), result.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Output, "forms")), result.forms);
    const statements = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), result.statements);
    const prefix = zx.columns.view(std.meta.Child(@FieldType(Output, "body")), result.body);

    const output: Output = .{
        .expressions = &expressions,
        .forms = &forms,
        .statements = &statements,
        .body = &prefix,
        .root = result.root,
        .serial = result.serial,
        .uses_allocator = result.uses_allocator,
        .valid = result.valid,
    };

    _ = try calls.publish(self, body, &output);
}
