const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Builder = @import("../program/builder.zig");
const inlineValue = @import("../program/expression.zig").inlineValue;
const expression = @import("../expression.zig");
const target = @import("../call/target.zig");
const Layout = @import("layout.zig");
const Field = struct { name: []const u8, type_id: zx.ir.TypeId, initial: zx.ir.Program };
const Value = union(enum) { program: zx.ir.Program, diagnostic: expression.Diagnostic };

const Options = struct {
    owner: []const u8,
    layout: Layout,
    first: u32,
    field_types: []const zx.ir.TypeId,
    types: *zx.ir.TypeStorage,
    native_modules: zx.ir.NativeModuleTable,
    aliases: []const zx.ir.Export,
};

pub fn compile(allocator: std.mem.Allocator, backing: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const layout = options.layout;
    var fragment: ?u32 = options.first;
    var count: usize = 0;

    while (fragment) |index| : (fragment = layout.next[index]) {
        count += layout.offsets[index + 1] - layout.offsets[index];
    }

    const fields = try temporary.alloc(Field, count);
    var cursor: usize = 0;
    fragment = options.first;

    while (fragment) |index| : (fragment = layout.next[index]) {
        for (layout.offsets[index]..layout.offsets[index + 1]) |row| {
            const node = layout.fields[row].*;
            const attribute = target.attribute(node, "value");
            const id = options.field_types[row];
            var parsed = try @import("../attribute.zig").parse(backing, attribute, options.owner);

            defer parsed.deinit();

            const initial = try expression.compileParsed(temporary, &parsed, attribute, .{
                .types = options.types.view(),
                .borrow_types = true,
                .type_storage = options.types,
                .type_allocator = allocator,
                .native_modules = options.native_modules,
                .aliases = options.aliases,
                .expected = id,
                .scratch_backing = backing,
            }, false);

            if (initial.value == .diagnostic) {
                var issue = initial.value.diagnostic;
                issue.issue = try issue.issue.clone(allocator);

                return .{ .diagnostic = issue };
            }

            fields[cursor] = .{ .name = target.attribute(node, "name").value, .type_id = id, .initial = initial.value.ir };
            cursor += 1;
        }
    }

    var reporter: zx.Reporter = .{};

    const program = build(allocator, temporary, options, fields, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const location = layout.fragments[options.first].location;

        return .{ .diagnostic = .{ .location = location, .issue = try reporter.diagnostic.?.clone(allocator) } };
    };

    return .{ .program = program };
}

fn build(allocator: std.mem.Allocator, temporary: std.mem.Allocator, options: Options, source: []const Field, reporter: *zx.Reporter) zx.Error!zx.ir.Program {
    var table = frontend.types{ .allocator = allocator, .reporter = reporter, .declarations = &.{}, .items = options.types.* };
    defer options.types.* = table.items;
    const fields = try frontend.types.Fields.init(allocator, source.len);

    for (source, 0..) |field, index| fields.set(index, try allocator.dupe(u8, field.name), field.type_id);

    const output = try table.object(fields);
    const positions = try canonicalPositions(temporary, source, table.get(output).object.names);
    var builder = Builder{ .allocator = allocator, .types = table.items.view(), .native_modules = options.native_modules };

    defer builder.linking_scratch.deinit();

    const span = zx.Span{ .start = 0, .end = 0 };
    const input: zx.ir.TypeId = @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void)));

    _ = try builder.symbol("in", input, span);
    const evaluation = try allocator.alloc(zx.ir.ExprId, source.len);
    const values = try allocator.alloc(zx.ir.ObjectField, source.len);

    for (source, positions, evaluation, values) |*field, position, *evaluated, *value| {
        const id = inlineValue(&builder, field.initial) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return reporter.fail(.contract, span, "Store initializer expression cannot be linked");
        };

        value.* = .{ .index = position, .value = id };
        evaluated.* = id;
    }

    const object = try builder.expression(.{ .type_id = output, .span = span, .value = .{ .object = .{ .fields = values, .evaluation = evaluation } } });

    var program = zx.ir.Program{
        .file_name = options.owner,
        .types = table.items.view(),
        .native_modules = options.native_modules,
        .symbols = builder.symbols.view(),
        .expressions = builder.expressions.view(),
        .input_type = input,
        .output_type = output,
        .body = try zx.ir.ControlBody.fromValues(allocator, &.{.{ .result = object }}),
    };

    program.output_ownership = try frontend.analyzeOwnership(allocator, program, reporter);

    if (try frontend.validateIr(allocator, program)) |issue| return reporter.fail(issue.code, issue.span, issue.message);

    return program;
}

fn canonicalPositions(allocator: std.mem.Allocator, source: []const Field, canonical: []const []const u8) std.mem.Allocator.Error![]const u32 {
    if (source.len == 1) return &.{0};

    if (comptime !@import("rx_options").generated_graph) {
        const positions = try allocator.alloc(u32, source.len);

        for (source, positions) |*field, *position| {
            const index = std.sort.binarySearch([]const u8, canonical, field.name, compare).?;

            position.* = @intCast(index);
        }

        return positions;
    }

    const names = try allocator.alloc([]const u8, source.len);

    for (source, names) |*field, *name| name.* = field.name;

    const rule = @import("generated_rx_store_field_positions");
    const input: std.meta.Child(rule.Input) = .{ .source = names, .canonical = canonical };

    return zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}

fn compare(left: []const u8, right: []const u8) std.math.Order {
    return std.mem.order(u8, left, right);
}
