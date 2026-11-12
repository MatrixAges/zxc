const std = @import("std");
const frontend = @import("frontend");
const dsl = @import("dsl");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("call/target.zig");
const expression = @import("expression.zig");
const initializer = @import("store/initializer.zig");
const Layout = @import("store/layout.zig");
pub const registry = @import("store/registry.zig");
pub const Options = struct { aliases: []const zx.ir.Export = &.{}, owner: []const u8, node: rx.ast.Node, types: zx.ir.TypeTable = .{}, nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types") = .{}, native_modules: zx.ir.NativeModuleTable = .{} };
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

    const value = try analyzeIn(arena.allocator(), allocator, options);

    return .{ .arena = arena, .value = value };
}

pub fn analyzeIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    var groups: ?rx.store.Groups = null;
    var checked = try dsl.validate(rx.store.Store, temporary, options.node, &groups);

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failure(allocator, options.owner, issue.location, @tagName(issue.code), issue.message);
    }

    const path = rx.normalizeStorePath(allocator, options.owner) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, options.owner, options.node.location, "module", "Store definition must have a project-relative .store.rx path");
    };

    const layout = try Layout.build(temporary, options.node, groups);
    const resolved = try @import("store/type.zig").resolve(allocator, temporary, path, layout, .{ .types = options.types, .nominal_types = options.nominal_types, .native_modules = options.native_modules }, options.aliases);

    if (resolved == .diagnostic) return diagnostic(allocator, path, resolved.diagnostic);

    var types = resolved.resolved.types;
    const values = try @import("project/type_imports.zig").values(temporary, types.view(), options.aliases);
    const native_modules = try frontend.native_context.copy(allocator, options.native_modules);
    const objects = try allocator.alloc(Object, layout.starts.len);

    for (layout.starts, objects) |first, *object| {
        const initialized = try initializer.compile(allocator, backing, .{
            .owner = path,
            .layout = layout,
            .first = first,
            .field_types = resolved.resolved.fields,
            .types = &types,
            .native_modules = native_modules,
            .aliases = values,
        });

        if (initialized == .diagnostic) return diagnostic(allocator, path, initialized.diagnostic);

        const name = target.attribute(layout.fragments[first], "name").value;

        object.* = .{ .name = try allocator.dupe(u8, name), .initial = initialized.program };
    }

    const complete = types.view();

    for (objects) |*object| object.initial.types = complete;

    return .{ .definition = .{ .source_path = path, .name = try allocator.dupe(u8, checked.value.data.attributes.name), .version = checked.value.data.attributes.version, .types = complete, .objects = objects } };
}

fn diagnostic(allocator: std.mem.Allocator, path: []const u8, issue: expression.Diagnostic) std.mem.Allocator.Error!Value {
    return failure(allocator, path, issue.location, @tagName(issue.issue.code), issue.issue.message);
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, code: []const u8, message: []const u8) std.mem.Allocator.Error!Value {
    const failed = try target.failure(allocator, .{ .path = path, .location = location, .code = code, .message = message });

    return .{ .diagnostic = failed.diagnostic };
}
