const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const ir = @import("zx").ir;
const target = @import("target.zig");
const wrapper = @import("compiled_wrapper.zig");
const compiled = frontend.project.compiled;
const Paths = frontend.project.source_index.Map;
const Self = @This();
const Error = std.mem.Allocator.Error;
const Value = union(enum) { ports: frontend.project.signature_project.Ports, diagnostic: target.Diagnostic };

const Call = struct {
    owner: []const u8,
    location: rx.ast.Location,
    setter: bool,
    selected: compiled.Target,
};

const Bound = struct {
    functions: ir.FunctionStorage = .{},
    exports: Paths,
    checked: std.DynamicBitSetUnmanaged,
    validated: bool = false,
};

allocator: std.mem.Allocator,
scratch: std.heap.ArenaAllocator,
bound: std.AutoHashMapUnmanaged(usize, *Bound) = .empty,
pub fn bind(self: *Self, project: *frontend.project.Options, call: Call) Error!Value {
    const libraries = project.compiled_libraries;
    const backing = self.scratch.child_allocator;

    const index = switch (try compiled.resolve.library(backing, libraries, project.root_dir, call.selected)) {
        .found => |value| value,
        .conflict => return self.fail(call, "module", "compiled package instance has conflicting artifacts"),
        .missing => return self.fail(call, "module", "compiled library is missing from the input set"),
    };

    const library = &libraries[index];

    const binding = self.bound.get(index) orelse block: {
        const loaded = self.load(project, library) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return self.fail(call, "module", "compiled library cannot be linked to the shared type table");
        };

        try self.bound.put(self.scratch.allocator(), index, loaded);

        break :block loaded;
    };

    const row = binding.exports.get(call.selected.name) orelse return self.fail(call, "module", "compiled package does not export the requested public module");
    const exported = &library.exports[row];

    if (wrapper.reject(exported.function, &binding.functions, call.setter)) |issue| return self.fail(call, issue.code, issue.message);

    const id = exported.function.?;
    const function = @backingInt(id);

    if (!binding.checked.isSet(function)) {
        var temporary = std.heap.ArenaAllocator.init(backing);

        defer temporary.deinit();

        const context = &project.context;
        const functions = binding.functions.view();

        const program = try wrapper.build(temporary.allocator(), .{
            .file_name = exported.path,
            .offset = call.location.offset,
            .id = id,
            .types = context.types,
            .functions = functions,
            .native_modules = context.native_modules,
        });

        if (try frontend.validateIrExtending(backing, program, if (binding.validated) functions else .{})) |issue| return self.fail(call, @tagName(issue.code), issue.message);

        binding.validated = true;

        binding.checked.set(function);
    }

    return .{ .ports = .{
        .input_type = @fromBackingInt(binding.functions.input_types.items[function]),
        .output_type = @fromBackingInt(binding.functions.output_types.items[function]),
    } };
}

fn load(self: *Self, project: *frontend.project.Options, library: *const compiled.Library) !*Bound {
    const temporary = self.scratch.allocator();
    const binding = try temporary.create(Bound);
    binding.* = .{ .exports = .empty, .checked = .{} };
    const context = &project.context;
    var natives = try frontend.native_context.storage(self.allocator, context.native_modules);

    const result = try compiled.loadCalls(self.allocator, .{ .functions = temporary, .temporary = self.scratch.child_allocator }, .{
        .library = library.*,
        .types = context.types,
        .nominal_types = context.nominal_types,
        .functions = &binding.functions,
        .native_modules = &natives,
    });

    binding.exports = try Paths.init(temporary, library.exports.len);
    binding.checked = try std.DynamicBitSetUnmanaged.initEmpty(temporary, binding.functions.count());

    for (library.exports, 0..) |*exported, index| {
        if (!binding.exports.claim(index, exported.name)) return error.InvalidLibrary;
    }

    context.types = result.types;
    context.nominal_types = result.nominal_types;
    context.native_modules = natives.view();

    return binding;
}

fn fail(self: *const Self, call: Call, code: []const u8, message: []const u8) Error!Value {
    const result = try target.failure(self.allocator, .{ .path = call.owner, .location = call.location, .code = code, .message = message });

    return .{ .diagnostic = result.diagnostic };
}
