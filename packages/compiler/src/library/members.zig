const std = @import("std");
const frontend = @import("frontend");
const columns = @import("zx").columns;
const Member = frontend.project.FunctionImport;
const Nodes = frontend.ArtifactNodes;
const Error = frontend.project.artifact.Error;
const generated = @import("parser_options").generated_parser;

pub fn complete(owned: std.mem.Allocator, temporary: std.mem.Allocator, analysis: *const frontend.AnalysisResult, entry_path: []const u8, nodes: *Nodes) Error![]const Member {
    var result: std.ArrayList(Member) = .empty;

    try append(owned, temporary, &result, analysis.public_functions, false, nodes);

    for (analysis.modules) |record| {
        if (!std.mem.eql(u8, record.path, entry_path)) continue;
        try append(owned, temporary, &result, record.reexports.functions, true, nodes);
    }

    return result.items;
}

fn append(owned: std.mem.Allocator, temporary: std.mem.Allocator, result: *std.ArrayList(Member), source: []const Member, barrel: bool, nodes: *Nodes) Error!void {
    if (source.len == 0) return;
    if (!generated) return appendSeed(owned, result, source, barrel, nodes);

    const entry = @import("generated_library_public_members");
    const Input = std.meta.Child(entry.Input);
    const Source = std.meta.Child(@FieldType(Input, "source"));
    const mapping = nodes.types.mapped;
    const functions = nodes.functions.indexed;
    const first = if (functions.len == 0) 0 else @backingInt(functions[0].?);
    var arena = std.heap.ArenaAllocator.init(temporary);
    var buffer: [1024]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const members = columns.columns(Source, try frontend.functionImportColumns(memory, source));

    const input: Input = .{
        .source = &members,
        .mapping = @as([*]const u32, @ptrCast(mapping.ptr))[0..mapping.len],
        .first = first,
        .function_count = functions.len,
        .barrel = barrel,
    };

    const output = (columns.invoke(entry.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    }) orelse return error.InvalidModule;

    try result.ensureUnusedCapacity(owned, output.names.len);

    for (output.names, 0..) |name, index| {
        result.appendAssumeCapacity(.{
            .name = try owned.dupe(u8, name),
            .id = if (output.ids[index]) |id| @fromBackingInt(id) else null,
            .input_type = if (output.input_types[index]) |id| @fromBackingInt(id) else null,
            .output_type = if (output.output_types[index]) |id| @fromBackingInt(id) else null,
            .intrinsic = if (output.intrinsics[index]) |operation| @fromBackingInt(@intCast(@backingInt(operation))) else null,
        });
    }
}

fn appendSeed(owned: std.mem.Allocator, result: *std.ArrayList(Member), source: []const Member, barrel: bool, nodes: *Nodes) Error!void {
    for (source) |item| {
        if (barrel and item.name.len == 0 and item.intrinsic == null) continue;

        var member = item;
        member.namespace = null;
        member.name = try owned.dupe(u8, item.name);
        member.id = if (item.id) |id| try nodes.functionId(id) else null;
        member.input_type = if (item.input_type) |id| try nodes.types.include(id) else null;
        member.output_type = if (item.output_type) |id| try nodes.types.include(id) else null;

        try result.append(owned, member);
    }
}
