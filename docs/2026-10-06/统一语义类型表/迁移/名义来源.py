from pathlib import Path
import re
root = Path.cwd()
draft = root / 'docs/2026-10-06/统一语义类型表/草稿'

def save(path, text):
    p = Path(path)
    copy = draft / Path(*[part for part in p.parts[1:] if part != 'src'])
    copy.parent.mkdir(parents=True, exist_ok=True)
    copy.write_text(text)
    p.write_text(text)

for p in Path('packages').rglob('*.zig'):
    if 'zig-cache' in str(p): continue
    old = p.read_text()
    s = old.replace('[]const Origins.Item', 'Origins.Table').replace('[]const NominalOrigins.Item', 'NominalOrigins.Table')
    s = re.sub(r'\[\]const (@import\("[^"\n]*nominal_origins.zig"\))\.Item', r'\1.Table', s)
    s = re.sub(r'((?:nominal_origins|origins|declared)\.items)\.items', r'\1.view()', s)
    s = re.sub(r'((?:nominal_origins|origins|declared)\.items)\.appendSlice\(', r'\1.appendTable(', s)
    s = s.replace('self.nominal_origins.items = .empty', 'self.nominal_origins.items = .{}')
    s = re.sub(r'(nominal_types[^\n=,]*= )&\.\{\}', r'\1.{}', s)
    s = s.replace('nominal_types.len', 'nominal_types.count()')
    s = re.sub(r'\.nominal_types\[(\d+)\]', r'.nominal_types.at(\1)', s)
    # Known loops only; no generic Zig rewriting.
    s = re.sub(r'for \((library.nominal_types|artifact.nominal_types|nominal_types|self.origins|self.origins.items.view\(\)|origins)\) \|item\| \{', lambda m: 'for (0..'+m[1]+'.count()) |origin_index| {\n        const item = '+m[1]+'.at(origin_index);\n', s)
    if s != old: save(p,s)

p = Path('packages/compiler/src/zx/modules/nominal_origins.zig')
s = p.read_text()
a = s.index('pub const Origin =')
b = s.index('allocator:', a)
s = s[:a]+'''pub const Origin = @import("nominal_origins/model.zig").Origin;
pub const Item = @import("nominal_origins/model.zig").Item;
pub const Table = @import("nominal_origins/table.zig");
pub const Storage = @import("nominal_origins/storage.zig");

'''+s[b:]
s = s.replace('items: std.ArrayList(Item) = .empty', 'items: Storage = .{}')
s = s.replace('values: []const Item', 'values: Table')
s = s.replace('    for (values, 0..) |item, index| {', '    if (!values.hasValidShape()) return error.InvalidNominalTypes;\n\n    for (0..values.count()) |index| {\n        const item = values.at(index);')
s = s.replace('for (values[0..index]) |previous| {','for (0..index) |previous_index| {\n            const previous = values.at(previous_index);')
s = s.replace('for (values) |item| try self.items.append(self.allocator, .{','for (0..values.count()) |index| {\n        const item = values.at(index);\n\n        try self.items.append(self.allocator, .{')
s = s[:-2]+'    }\n}\n'
save(p,s)
for name in ('model','storage','table'):
    p = Path('packages/compiler/src/zx/modules/nominal_origins') / (name+'.zig')
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_text((draft / 'compiler/zx/modules/nominal_origins' / p.name).read_text())
p = Path('packages/compiler/src/zx/modules/nominal_origins/table.zig')
s = p.read_text().replace('    return self.kinds.len == self.ids.len and self.owners.len == self.ids.len and\n        self.members.len == self.ids.len and self.names.len == self.ids.len;', '''    if (self.kinds.len != self.ids.len or self.owners.len != self.ids.len or
        self.members.len != self.ids.len or self.names.len != self.ids.len) return false;

    for (self.kinds, self.members) |kind, member| {
        if (kind > 2 or (kind != 2 and member.len != 0)) return false;
    }

    return true;''')
save(p,s)
# Raw table boundary validation before projection.
for file,anchor,insert in [
 ('zx/modules/link/types.zig','    const origins = try temporary.alloc','    if (!nominal_types.hasValidShape()) return error.InvalidModule;\n\n'),
 ('zx/modules/artifact/types.zig','    const mapping = try temporary.alloc','    if (!origins.hasValidShape()) return error.InvalidModule;\n\n'),
 ('zx/modules/semantic_cache/native_restore.zig','    for (0..artifact.nominal_types','    if (!artifact.nominal_types.hasValidShape()) return error.InvalidModule;\n\n'),
 ('backends/zig/names.zig','    const type_names = try','    if (!origins.hasValidShape()) return error.InvalidNominalOrigin;\n\n')]:
    p=Path('packages/compiler/src')/file
    s=p.read_text(); s=s.replace(anchor,insert+anchor,1)
    if file.endswith('names.zig'): s=s.replace('origins: []const NominalType','origins: @FieldType(@import("frontend").AnalysisResult, "nominal_types")')
    save(p,s)
p=Path('packages/compiler/src/zx/modules/compiled/load.zig'); s=p.read_text()
a=s.index('    const origins = try allocator.dupe'); b=s.index('    const function_mapping',a)
s=s[:a]+'''    var origins: Origins.Storage = .{};

    for (0..library.nominal_types.count()) |index| {
        var item = library.nominal_types.at(index);
        item.origin = switch (item.origin) {
            .source => |path| .{ .source = try identity.scope(allocator, library.instance, path) },
            .native => |key| .{ .native = try identity.nativeKey(allocator, library, key) },
            .external => |value| .{ .external = .{ .module = try identity.nativeKey(allocator, library, value.module), .member = value.member } },
        };

        try origins.append(allocator, item);
    }

    const type_mapping = try types.appendFrom(allocator, program.types, origins.view(), 0);
'''+s[b:]
save(p,s)
