from pathlib import Path

def save(path,s):
 p=Path(path); d=Path('docs/2026-10-06/统一语义类型表/草稿')/Path(*[part for part in p.parts[1:] if part != 'src'])
 d.parent.mkdir(parents=True,exist_ok=True); d.write_text(s); p.parent.mkdir(parents=True,exist_ok=True); p.write_text(s)
base=Path('packages/compiler/src/zx/analysis/semantic')
for name in ['find.zx','model.zx']:
 save(base/'types/nominal'/name,(Path('docs/2026-10-06/统一语义类型表/草稿/compiler/semantic/types/nominal')/name).read_text())
save(base/'nominal.rx','''<Module>
  <Call fn="types/nominal/find" in={$in} />

  <Return value={$ctx.find} />
</Module>
''')
# Keep generated ABI assembly separate from semantic decisions.
p=base/'lookup.zig'; s=p.read_text(); start=s.index('    const candidate: Candidate = .{'); end=s.index('\n\n    const input:',start)
expr=s[start:end].replace('    const candidate: Candidate = ', '    return ').replace('.fields = &fields', '.fields = fields')
save(base/'candidate.zig','''const ir = @import("zx").ir;

pub fn borrow(comptime Candidate: type, value: ir.TypeValue, fields: @FieldType(Candidate, "fields")) Candidate {
'''+expr+'\n}\n')
s=s[:start]+'    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);'+s[end:]; save(p,s)
save(base/'nominal.zig','''const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");
pub const Error = std.mem.Allocator.Error || error{ConflictingNominalType};

pub fn find(table: ir.TypeTable, bindings: Origins.Table, origin: Origins.Origin, value: ir.TypeValue) Error!?ir.TypeId {
    if (!@import("parser_options").generated_parser) return @import("seed_nominal.zig").find(table, bindings, origin, value);

    const generated = @import("generated_nominal_lookup");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Table = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const Binding = @typeInfo(@FieldType(Bindings, "base")).pointer.child;
    const Origin = @typeInfo(@FieldType(Input, "origin")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;

    const base = ir.TypeTable.borrow(Table, table);
    const delta = ir.TypeTable.borrow(Table, .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const bound = Origins.Table.borrow(Binding, bindings);
    const empty = Origins.Table.borrow(Binding, .{});
    const origins: Bindings = .{ .base = &bound, .delta = &empty };
    const identity: Origin = .{
        .kind = switch (origin) { .source => 0, .native => 1, .external => 2 },
        .owner = switch (origin) { .source, .native => |text| text, .external => |entry| entry.module },
        .member = if (origin == .external) origin.external.member else "",
    };
    const fields: Fields = .{ .names = &.{}, .types = &.{} };
    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);
    const input: Input = .{ .tables = &tables, .origins = &origins, .origin = &identity, .candidate = &candidate };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return switch (result.status) {
        .Missing => null,
        .Found => @fromBackingInt(result.id),
        .Conflict => error.ConflictingNominalType,
    };
}
''')
save(base/'seed_nominal.zig','''const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");

pub fn find(table: ir.TypeTable, bindings: Origins.Table, origin: Origins.Origin, value: ir.TypeValue) error{ConflictingNominalType}!?ir.TypeId {
    for (0..bindings.count()) |index| {
        const item = bindings.at(index);

        if (!std.mem.eql(u8, item.name, value.nominalName().?) or !Origins.same(item.origin, origin)) continue;

        const existing = table.at(@backingInt(item.type_id));

        if (std.meta.activeTag(existing) != std.meta.activeTag(value)) return error.ConflictingNominalType;
        if (value == .enumeration) {
            if (existing.enumeration.members.len != value.enumeration.members.len) return error.ConflictingNominalType;

            for (existing.enumeration.members, value.enumeration.members) |left, right| {
                if (!std.mem.eql(u8, left, right)) return error.ConflictingNominalType;
            }
        }

        return item.type_id;
    }

    return null;
}
''')
p=Path('packages/compiler/src/zx/modules/link/types.zig'); s=p.read_text(); a=s.index('    for (0..self.origins.items.view().count())'); b=s.index('\n    const id = try self.insert(value);',a)
s=s[:a]+'''    if (try @import("../../analysis/semantic/nominal.zig").find(self.items.view(), self.origins.items.view(), origin, value)) |id| return id;
'''+s[b:]; save(p,s)
p=Path('packages/compiler/build/generate_parser.zig'); s=p.read_text(); anchor='    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3 + entries.len], .data = semantic.types });'; s=s.replace(anchor,anchor+'''

    const nominal = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/nominal.rx", true);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4 + entries.len], .data = nominal.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[5 + entries.len], .data = nominal.types });'''); save(p,s)
p=Path('packages/compiler/build/compiler.zig'); s=p.read_text().replace('type_lookup: *std.Build.Module }','type_lookup: *std.Build.Module, nominal_lookup: *std.Build.Module }').replace('        frontend.addImport("generated_type_lookup", generated.type_lookup);','        frontend.addImport("generated_type_lookup", generated.type_lookup);\n        frontend.addImport("generated_nominal_lookup", generated.nominal_lookup);'); save(p,s)
p=Path('packages/compiler/build/parser.zig'); s=p.read_text().replace('    semantic_abi: std.Build.LazyPath,','    semantic_abi: std.Build.LazyPath,\n    nominal_lookup: std.Build.LazyPath,\n    nominal_abi: std.Build.LazyPath,').replace('    const semantic_abi = run.addOutputFileArg("semantic_abi.zig");','    const semantic_abi = run.addOutputFileArg("semantic_abi.zig");\n    const nominal_lookup = run.addOutputFileArg("nominal_lookup.zig");\n    const nominal_abi = run.addOutputFileArg("nominal_abi.zig");').replace('.semantic_abi = semantic_abi };','.semantic_abi = semantic_abi, .nominal_lookup = nominal_lookup, .nominal_abi = nominal_abi };').replace('    return .{\n        .type_lookup = lookup,','''    const nominal = b.createModule(.{ .root_source_file = source.nominal_lookup, .target = target, .optimize = optimize });

    nominal.addImport("integers", b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.zig"), .target = target, .optimize = optimize }));
    nominal.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.nominal_abi, .target = target, .optimize = optimize }));

    return .{
        .nominal_lookup = nominal,
        .type_lookup = lookup,'''); save(p,s)
