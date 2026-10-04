const std = @import("std");
const frontend = @import("frontend");
const generating = @import("genz").zx.state;
const modules = @import("modules.zig");
const names = @import("names.zig");
const Cache = @import("cache.zig");

pub const Options = struct { analysis: *const frontend.AnalysisResult, cache: ?*Cache = null };
pub const Error = names.Error || error{ InvalidAnalysis, MissingInitializer, InvalidInitializer, DuplicateState };

pub fn append(bundle: *modules.Bundle, options: Options) Error!void {
    if (options.analysis.value != .ir) return error.InvalidAnalysis;

    const program = options.analysis.value.ir;

    if (program.stores.len == 0) return;
    for (bundle.modules) |file| if (std.mem.eql(u8, file.name, "zxc_state")) return error.DuplicateState;

    const allocator = bundle.arena.allocator();
    const shared = try names.create(allocator, program, options.analysis.nominal_types);
    const objects = try allocator.alloc(generating.Object, program.stores.len);
    const imports = try allocator.alloc([]const u8, objects.len + 1);

    imports[0] = "application";

    for (program.stores, objects, 0..) |slot, *object, index| {
        const initial = for (bundle.store_initializers) |candidate| {
            if (std.mem.eql(u8, candidate.identity, slot.path)) break candidate;
        } else return error.MissingInitializer;

        if (!std.mem.eql(u8, initial.type_name, shared.types[@intFromEnum(slot.type_id)])) return error.InvalidInitializer;

        object.* = .{ .module_name = initial.module_name, .writable = slot.writable };
        imports[index + 1] = initial.module_name;
    }

    const io_functions = try @import("genz").zx.io.functions(allocator, program);
    const needs_io = @import("genz").zx.io.uses(program.expressions, program.contracts, io_functions);
    const source = try emit(allocator, objects, needs_io, options.cache);
    const files = try allocator.alloc(modules.File, bundle.modules.len + 1);

    @memcpy(files[0..bundle.modules.len], bundle.modules);

    files[bundle.modules.len] = .{ .name = "zxc_state", .source = source, .imports = imports };
    bundle.modules = files;
    bundle.state_module = "zxc_state";
}

fn emit(allocator: std.mem.Allocator, objects: []const generating.Object, needs_io: bool, cache: ?*Cache) std.mem.Allocator.Error![]const u8 {
    const store = cache orelse return generating.renderWithIo(allocator, objects, needs_io);
    const metadata = try std.json.Stringify.valueAlloc(allocator, .{ .objects = objects, .needs_io = needs_io }, .{});
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    hash.update("zxc.zig.state.memory.v3");
    hash.update(metadata);

    const key = hash.finalResult();

    if (try store.get("zxc_state", key)) |source| return allocator.dupe(u8, source);

    const source = try generating.renderWithIo(allocator, objects, needs_io);

    store.generated += 1;

    try store.put("zxc_state", key, source);

    return source;
}
