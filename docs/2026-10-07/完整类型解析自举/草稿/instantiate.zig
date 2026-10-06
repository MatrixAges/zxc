const Native = @import("native_view");
const Indexed = @import("indexed_view");
const Program = Indexed.View(@import("program").Output);
const Expression = Indexed.View(@import("expression").Output);
const Declaration = Indexed.View(@import("declaration").Output);
const Reader = @import("reader.zig").Reader(Native, Program, Expression, Declaration);

export fn instantiate(reader: *const Reader, value: *const Reader.Ref, index: usize) void {
    _ = reader.declarationCount();
    _ = reader.declarationAt(index);
    _ = reader.kind(value.*);
    _ = reader.name(value.*);
    _ = reader.child(value.*);
    _ = reader.count(value.*, true);
    _ = reader.count(value.*, false);
    _ = reader.firstPosition(value.*, true);
    _ = reader.firstPosition(value.*, false);
    _ = reader.nextPosition(value.*, index, true);
    _ = reader.nextPosition(value.*, index, false);
    _ = reader.fieldAt(value.*, index);
    _ = reader.childAt(value.*, index);
    _ = reader.memberCount(value.*);
    _ = reader.memberAt(value.*, index);
}
