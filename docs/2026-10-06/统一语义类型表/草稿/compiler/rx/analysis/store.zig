const std = @import("std");
const frontend = @import("frontend");
const dsl = @import("dsl");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("call/target.zig");
const expression = @import("expression.zig");
const initializer = @import("store/initializer.zig");
pub const Options = struct { owner: []const u8, node: rx.ast.Node, types: zx.ir.TypeTable = .{}, nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types") = .{}, native_modules: []const zx.ir.NativeModule = &.{} };
pub const Binding = struct { name: []const u8, slot: zx.ir.StoreSlot };
pub const Object = struct { name: []const u8, initial: zx.ir.Program };
pub const Definition = struct { source_path: []const u8, name: []const u8, version: u32, types: zx.ir.TypeTable, objects: []const Object };
pub const Value = union(enum) { definition: Definition, diagnostic: target.Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn analyze(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try analyzeIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn analyzeIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var checked = try dsl.validate(rx.store.Store, allocator, options.node, {});

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failure(allocator, options.owner, issue.location, @tagName(issue.code), issue.message);
    }

    const path = rx.normalizeStorePath(allocator, options.owner) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, options.owner, options.node.location, "module", "Store definition must have a project-relative .store.rx path");
    };

    var types = options.types;
    var objects: std.ArrayList(Object) = .empty;

    for (options.node.children) |node| {
        const name = target.attribute(node, "name").value;
        var seen = false;

        for (objects.items) |object| if (std.mem.eql(u8, object.name, name)) {
            seen = true;
        };

        if (seen) continue;

        var fields: std.ArrayList(initializer.Field) = .empty;

        for (options.node.children) |fragment| {
            if (!std.mem.eql(u8, target.attribute(fragment, "name").value, name)) continue;

            for (fragment.children) |field| {
                const resolved = try @import("store/type.zig").resolve(allocator, path, target.attribute(field, "type"), .{ .types = types, .nominal_types = options.nominal_types, .native_modules = options.native_modules });

                if (resolved == .diagnostic) return diagnostic(allocator, path, resolved.diagnostic);

                types = resolved.resolved.types;
                const initial = try expression.compile(allocator, path, target.attribute(field, "value"), .{ .types = types, .native_modules = options.native_modules, .expected = resolved.resolved.id });

                if (initial.value == .diagnostic) return diagnostic(allocator, path, initial.value.diagnostic);

                types = initial.value.ir.types;

                try fields.append(allocator, .{ .name = target.attribute(field, "name").value, .type_id = resolved.resolved.id, .initial = initial.value.ir });
            }
        }

        var reporter: zx.Reporter = .{};

        const program = initializer.build(allocator, path, fields.items, types, options.native_modules, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            const issue = reporter.diagnostic.?;

            return failure(allocator, path, node.location, @tagName(issue.code), issue.message);
        };

        types = program.types;

        try objects.append(allocator, .{ .name = try allocator.dupe(u8, name), .initial = program });
    }

    for (objects.items) |*object| object.initial.types = types;

    return .{ .definition = .{ .source_path = try allocator.dupe(u8, path), .name = try allocator.dupe(u8, checked.value.data.attributes.name), .version = checked.value.data.attributes.version, .types = types, .objects = objects.items } };
}

fn diagnostic(allocator: std.mem.Allocator, path: []const u8, issue: expression.Diagnostic) std.mem.Allocator.Error!Value {
    return failure(allocator, path, issue.location, @tagName(issue.issue.code), issue.issue.message);
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, code: []const u8, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = path, .location = location, .code = code, .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
