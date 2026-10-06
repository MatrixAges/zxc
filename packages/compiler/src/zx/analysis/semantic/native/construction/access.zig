pub const Writer = *const anyopaque;
pub const View = @import("construction_writer");

pub fn view(writer: Writer) *const View {
    return @ptrCast(@alignCast(writer));
}
