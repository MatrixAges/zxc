from pathlib import Path

def save(name,s):
 p=Path(name); d=Path('docs/2026-10-06/统一语义类型表/草稿')/Path(*[part for part in p.parts[1:] if part != 'src']); d.parent.mkdir(parents=True,exist_ok=True); d.write_text(s); p.write_text(s)

p='packages/test/tests/incremental/nominal/check.zig'; s=Path(p).read_text().replace('for (result.nominal_types, 0..) |item, index| {','for (0..result.nominal_types.count()) |index| {\n        const item = result.nominal_types.at(index);\n').replace('for (result.nominal_types[0..index]) |previous| try std.testing.expect(previous.type_id != item.type_id);','for (0..index) |previous| try std.testing.expect(result.nominal_types.at(previous).type_id != item.type_id);'); save(p,s)
for p,var,old in [('packages/test/tests/incremental/type_merge/invalid_test.zig','source.value','origins'),('packages/test/tests/incremental/artifact/invalid_test.zig','analysis','duplicate')]:
 s=Path(p).read_text(); start=s.index('    const '+old+' = [_]'); end=s.index('\n\n',start)
 s=s[:start]+f'''    inline for (@typeInfo(@TypeOf({var}.nominal_types)).@"struct".field_names) |name| {{
        const column = @field({var}.nominal_types, name);

        @field({var}.nominal_types, name) = try {var.split('.')[0]}.arena.allocator().dupe(@TypeOf(column[0]), &.{{ column[0], column[0] }});
    }}'''+s[end:]
 s=s.replace('    var origin = source.value.nominal_types.at(0);\n    origin.name = "Other";\n    source.value.nominal_types = (&origin)[0..1];','    source.value.nominal_types.names = &.{"Other"};')
 save(p,s)
p='packages/test/tests/native/references/library/mutation.zig'; s=Path(p).read_text(); s=s.replace('    const nominal = try allocator.dupe(@TypeOf(value.nominal_types.at(0)), value.nominal_types);','''    const kinds = try allocator.dupe(u8, value.nominal_types.kinds);
    const owners = try allocator.dupe([]const u8, value.nominal_types.owners);
    const names = try allocator.dupe([]const u8, value.nominal_types.names);''').replace('    value.nominal_types = nominal;','''    value.nominal_types.kinds = kinds;
    value.nominal_types.owners = owners;
    value.nominal_types.names = names;''').replace('.source_origin => nominal[0].origin = .{ .source = "types.zx" },','''.source_origin => {
            kinds[0] = 0;
            owners[0] = "types.zx";
        },''').replace('.other_origin => nominal[0].origin = .{ .native = "another-owner" },','.other_origin => owners[0] = "another-owner",').replace('.nominal_name => nominal[0].name = "Other",','.nominal_name => names[0] = "Other",').replace('.duplicate_nominal => value.nominal_types = try allocator.dupe(@TypeOf(nominal[0]), &.{ nominal[0], nominal[0] }),','''.duplicate_nominal => {
            inline for (@typeInfo(@TypeOf(value.nominal_types)).@"struct".field_names) |name| {
                const column = @field(value.nominal_types, name);

                @field(value.nominal_types, name) = try allocator.dupe(@TypeOf(column[0]), &.{ column[0], column[0] });
            }
        },'''); save(p,s)
p='packages/test/tests/library/codec/rejection_test.zig'; s=Path(p).read_text().replace('root.getPtr("nominal_types").?.array.items[0].object.get("type_id").?', 'root.getPtr("nominal_types").?.object.getPtr("ids").?.array.items[0]').replace('root.getPtr("nominal_types").?.array.items[0].object.getPtr("type_id").?.*','root.getPtr("nominal_types").?.object.getPtr("ids").?.array.items[0]').replace('.origins => root.getPtr("nominal_types").?.array.items.len = 0,','''.origins => {
            var columns = root.getPtr("nominal_types").?.object.valueIterator();

            while (columns.next()) |column| column.array.items.len = 0;
        },'''); save(p,s)
p='packages/core/src/root.zig'; s=Path(p).read_text().replace('ir_version: u32 = 23','ir_version: u32 = 24'); save(p,s)
