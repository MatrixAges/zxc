const generated = @import("generated_path_kind");
const Kind = @FieldType(@typeInfo(generated.Input).pointer.child, "kind");

pub fn check(path: []const u8, suffix: []const u8, kind: Kind) bool {
    return @import("../schema/scalar.zig").execute(generated, &.{ .path = path, .suffix = suffix, .kind = kind });
}
