const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const generating = @import("genz").zx.state;
const modules = @import("modules.zig");
const names = @import("names.zig");
const Cache = @import("cache.zig");

pub const Options = struct { analysis: *const frontend.AnalysisResult, cache: ?*Cache = null };
pub const Error = names.Error || error{ InvalidAnalysis, MissingInitializer, InvalidInitializer, DuplicateState };

pub fn append(bundle: *modules.Bundle, options: Options) Error!void {
    if (comptime !@import("parser_options").generated_parser) return @import("state_seed.zig").append(bundle, .{ .analysis = options.analysis, .cache = options.cache });

    var scratch = std.heap.ArenaAllocator.init(bundle.arena.child_allocator);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    if (!try available(temporary, bundle, options.analysis)) return;

    const program = options.analysis.value.ir;
    const allocator = bundle.arena.allocator();
    const shared = try names.create(allocator, bundle.arena.child_allocator, program, options.analysis.nominal_types);
    const independent = try frontend.storesOwnValues(allocator, program);
    const entry = @import("generated_state_bindings");
    const Input = std.meta.Child(entry.Input);
    const Stores = std.meta.Child(@FieldType(Input, "stores"));
    const stores = zx.columns.borrow(Stores, &program.stores);
    const initializers = try zx.columns.pointers(@FieldType(Input, "initializers"), temporary, bundle.store_initializers);

    const input: Input = .{
        .stores = &stores,
        .type_names = shared.types,
        .initializers = initializers,
        .has_requirements = bundle.requirements != null,
    };

    const plan = zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| return failure(err);

    switch (plan.status) {
        .Ready => {},
        .MissingInitializer => return error.MissingInitializer,
        .InvalidInitializer => return error.InvalidInitializer,
        .InvalidAnalysis => return error.InvalidAnalysis,
        else => unreachable,
    }

    const objects = try allocator.alloc(generating.Object, program.stores.count());

    for (plan.imports[1..], program.stores.writable, objects) |module_name, writable, *object| {
        object.* = .{ .module_name = module_name, .writable = writable, .independent = independent };
    }

    const imports = plan.imports;
    const requirements = bundle.requirements.?;
    const source = try emit(allocator, objects, requirements, options.cache);
    const files = try allocator.alloc(modules.File, bundle.modules.len + 1);

    @memcpy(files[0..bundle.modules.len], bundle.modules);

    files[bundle.modules.len] = .{ .name = "zxc_state", .source = source, .imports = imports };
    bundle.modules = files;
    bundle.state_module = "zxc_state";
}

fn available(allocator: std.mem.Allocator, bundle: *const modules.Bundle, analysis: *const frontend.AnalysisResult) Error!bool {
    const entry = @import("generated_state_available");
    const valid_ir = analysis.value == .ir;
    const count = if (valid_ir) analysis.value.ir.stores.count() else 0;
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .valid_ir = valid_ir,
        .store_count = count,
        .modules = zx.columns.slice(@FieldType(Input, "modules"), bundle.modules),
    };

    const status = entry.executeValue(allocator, if (comptime @typeInfo(Parameter) == .pointer) &input else input) catch |err| return failure(err);

    return switch (status) {
        .Ready => true,
        .NoChange => false,
        .InvalidAnalysis => error.InvalidAnalysis,
        .DuplicateState => error.DuplicateState,
        else => unreachable,
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}

fn emit(allocator: std.mem.Allocator, objects: []const generating.Object, requirements: generating.Requirements, cache: ?*Cache) std.mem.Allocator.Error![]const u8 {
    const store = cache orelse return generating.renderWithCapabilities(allocator, objects, requirements);
    const metadata = try std.json.Stringify.valueAlloc(allocator, .{ .objects = objects, .requirements = requirements }, .{});
    var hash = @import("zx").Sha256.init(.{});

    hash.update("zxc.zig.state.memory.v5");
    hash.update(metadata);

    const key = hash.finalResult();

    if (try store.get("zxc_state", key)) |source| return allocator.dupe(u8, source);

    const source = try generating.renderWithCapabilities(allocator, objects, requirements);

    store.generated += 1;

    try store.put("zxc_state", key, source);

    return source;
}
