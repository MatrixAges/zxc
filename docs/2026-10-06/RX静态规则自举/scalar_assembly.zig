const scalar = @import("scalar");
const content = @import("content");

export fn hasContent(bytes: [*]const u8, length: usize) bool {
    return scalar.execute(content, bytes[0..length]);
}
