const views = @import("type_views");
const Program = views.Indexed(@import("generated_parser").Output);
const Expression = views.Indexed(@import("generated_expression").Output);
const Declaration = views.Indexed(@import("generated_native").Output);
pub const Reader = @import("reader.zig").Reader(views.Native, Program, Expression, Declaration);

pub fn from(view: anytype) Reader {
    if (@TypeOf(view) == views.Native) return .{ .native = view };
    if (@TypeOf(view) == Program) return .{ .program = view };
    if (@TypeOf(view) == Expression) return .{ .expression = view };
    if (@TypeOf(view) == Declaration) return .{ .declaration = view };

    @compileError("unsupported type source view");
}
