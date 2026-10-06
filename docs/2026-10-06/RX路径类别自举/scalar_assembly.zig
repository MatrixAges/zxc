const scalar = @import("scalar");
const kind = @import("kind");

export fn isModuleFile(bytes: [*]const u8, length: usize) bool {
    return scalar.execute(kind, &.{ .path = bytes[0..length], .suffix = &.{}, .kind = .ModuleFile });
}
