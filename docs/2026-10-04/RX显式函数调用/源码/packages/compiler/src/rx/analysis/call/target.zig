const std = @import("std");
const frontend = @import("frontend");
const dsl = @import("dsl");
const rx = @import("rx");
const zx = @import("zx");

pub const Options = struct {
    owner: []const u8,
    call: rx.ast.Node,
    sources: []const frontend.project.Source,
    project: frontend.project.Options = .{ .entry = "" },
};

pub const Function = struct {
    program: zx.ir.Program,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
};

pub const Diagnostic = struct { path: []const u8, location: rx.ast.Location, code: []const u8, message: []const u8 };
pub const Value = union(enum) { function: Function, diagnostic: Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn load(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try loadIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn loadIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    var checked = try dsl.validate(rx.flow.Call, allocator, options.call, {});

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failure(allocator, .{ .path = options.owner, .location = issue.location, .code = @tagName(issue.code), .message = issue.message });
    }

    const attributes = checked.value.data.attributes;

    if (attributes.service != null) return failure(allocator, .{ .path = options.owner, .location = attribute(options.call, "service").value_location, .code = "unsupported", .message = "service calls require RX module linking" });
    if (attributes.setter != null or options.project.context.stores.len != 0) return failure(allocator, .{ .path = options.owner, .location = options.call.location, .code = "unsupported", .message = "Store calls require explicit Store authorization and host linking" });

    const target = attribute(options.call, "fn");

    const path = rx.resolveFunctionPath(allocator, options.owner, target.value) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, .{ .path = options.owner, .location = target.value_location, .code = "module", .message = "Call.fn must reference a ZX file within the project root" });
    };

    var project = options.project;
    project.entry = path;
    var cache = frontend.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    for (options.sources, 0..) |source, index| {
        const parsed = try cache.get(source.source, source.path);

        if (parsed.value == .parsed) {
            const input = parsed.value.parsed;

            if (try @import("lint").source.check(allocator, .{ .source = input.source, .comments = input.lexed.comments, .program = input.ast })) |issue| {
                const location = zx.source.locate(options.sources[index].source, issue.span.start);

                return failure(allocator, .{ .path = source.path, .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column }, .code = @tagName(issue.code), .message = issue.message });
            }
        }
    }

    const analyzed = try frontend.project.analyzeWithCache(allocator, options.sources, project, &cache);

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        if (issue.source_index) |index| {
            const source = options.sources[index];
            const location = zx.source.locate(source.source, issue.span.start);

            return failure(allocator, .{ .path = source.path, .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column }, .code = @tagName(issue.code), .message = issue.message });
        }

        return failure(allocator, .{ .path = options.owner, .location = target.value_location, .code = @tagName(issue.code), .message = issue.message });
    }

    const callee = analyzed.value.ir;

    if (callee.type_only) return failure(allocator, .{ .path = options.owner, .location = target.value_location, .code = "module", .message = "Call.fn requires an executable ZX module with a default function" });

    return .{ .function = .{ .program = callee, .nominal_types = analyzed.nominal_types } };
}

pub fn attribute(node: rx.ast.Node, name: []const u8) rx.ast.Attribute {
    for (node.attributes) |item| {
        if (std.mem.eql(u8, item.name, name)) return item;
    }

    unreachable;
}

pub fn failure(allocator: std.mem.Allocator, issue: Diagnostic) std.mem.Allocator.Error!Value {
    return .{ .diagnostic = .{
        .path = try allocator.dupe(u8, issue.path),
        .location = issue.location,
        .code = issue.code,
        .message = try allocator.dupe(u8, issue.message),
    } };
}
