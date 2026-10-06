from pathlib import Path

root = Path.cwd()
drafts = root / 'docs/2026-10-06/统一语义类型表/草稿'

def save(path, text):
    p = Path(path)
    parts = p.parts[1:]

    if len(parts) > 1 and parts[1] == 'src':
        parts = (parts[0],) + parts[2:]

    draft = drafts / Path(*parts)
    draft.parent.mkdir(parents=True, exist_ok=True)
    draft.write_text(text)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text)

base = Path('packages/compiler/src/zx/analysis/semantic/ordering')
for name in ['sort.zx', 'sift.zx', 'columns.zig', 'columns.d.zx', 'sort.rx']:
    save(base / name, (drafts / 'compiler/semantic/ordering' / name).read_text())

p = Path('packages/compiler/src/zx/analysis/types/fields.zig')
s = p.read_text().replace('''pub fn sort(self: Self) void {
    std.sort.pdqContext(0, self.names.len, self);
}''', '''pub fn sort(self: Self) std.mem.Allocator.Error!void {
    if (!@import("parser_options").generated_parser) {
        std.sort.pdqContext(0, self.names.len, self);

        return;
    }

    const generated = @import("generated_field_sort");
    const columns = @import("field_columns");
    const data = columns.View{ .names = self.names, .types = self.types };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, @ptrCast(&data)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}''')
save(p,s)
p = Path('packages/compiler/src/zx/analysis/types.zig')
save(p,p.read_text().replace('    fields.sort();','    try fields.sort();'))
p = Path('packages/compiler/build/compiler.zig')
s = p.read_text().replace('nominal_lookup: *std.Build.Module };','nominal_lookup: *std.Build.Module, field_sort: *std.Build.Module, field_columns: *std.Build.Module };').replace('        frontend.addImport("generated_nominal_lookup", generated.nominal_lookup);','''        frontend.addImport("generated_nominal_lookup", generated.nominal_lookup);
        frontend.addImport("generated_field_sort", generated.field_sort);
        frontend.addImport("field_columns", generated.field_columns);''')
save(p,s)
p = Path('packages/compiler/build/generate_parser.zig')
s = p.read_text().replace('''    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[5 + entries.len], .data = nominal.types });''','''    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[5 + entries.len], .data = nominal.types });

    const ordering = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/ordering/sort.rx", true);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[6 + entries.len], .data = ordering.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[7 + entries.len], .data = ordering.types });''')
s = s.replace('''    const interfaces = [_]compiler.project.NativeInterface{.{''','''    const interfaces = [_]compiler.project.NativeInterface{.{''')
s = s.replace('''        .module = "integers",
    }};''','''        .module = "integers",
    }, .{
        .specifier = "zig:field_columns",
        .path = "zx/analysis/semantic/ordering/columns.d.zx",
        .source = @embedFile("field_columns_interface"),
        .module = "field_columns",
    }};''')
save(p,s)
p = Path('packages/compiler/build/parser.zig')
s=p.read_text().replace('    nominal_abi: std.Build.LazyPath,','''    nominal_abi: std.Build.LazyPath,
    field_sort: std.Build.LazyPath,
    field_abi: std.Build.LazyPath,''').replace('    executable.root_module.addAnonymousImport("semantic_integers",', '''    executable.root_module.addAnonymousImport("field_columns_interface", .{ .root_source_file = b.path("src/zx/analysis/semantic/ordering/columns.d.zx") });
    executable.root_module.addAnonymousImport("semantic_integers",''').replace('    const nominal_abi = run.addOutputFileArg("nominal_abi.zig");','''    const nominal_abi = run.addOutputFileArg("nominal_abi.zig");
    const field_sort = run.addOutputFileArg("field_sort.zig");
    const field_abi = run.addOutputFileArg("field_abi.zig");''').replace('.nominal_abi = nominal_abi };','.nominal_abi = nominal_abi, .field_sort = field_sort, .field_abi = field_abi };')
s=s.replace('''    return .{
        .nominal_lookup = nominal,''','''    const field_abi = b.createModule(.{ .root_source_file = source.field_abi, .target = target, .optimize = optimize });
    const columns = b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/ordering/columns.zig"), .target = target, .optimize = optimize });
    const ordering = b.createModule(.{ .root_source_file = source.field_sort, .target = target, .optimize = optimize });

    columns.addImport("zxc_abi", field_abi);
    ordering.addImport("zxc_abi", field_abi);
    ordering.addImport("field_columns", columns);

    return .{
        .field_columns = columns,
        .field_sort = ordering,
        .nominal_lookup = nominal,''')
save(p,s)
