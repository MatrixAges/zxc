const std = @import("std");
pub const NameKind = enum { value, callable, type_decl, imported_value };

pub fn checkName(name: []const u8, requested: NameKind) bool {
    const kind = if (requested == .imported_value) (if (name.len > 0 and std.ascii.isUpper(name[0])) NameKind.type_decl else NameKind.value) else requested;

    if (name.len == 0) return false;

    if (kind == .type_decl) {
        if (!std.ascii.isUpper(name[0])) return false;
    } else if (!std.ascii.isLower(name[0])) return false;

    var after_underscore = false;

    for (name) |byte| {
        if (kind == .value and byte == '_') {
            if (after_underscore) return false;

            after_underscore = true;

            continue;
        }

        if (!std.ascii.isAlphanumeric(byte)) return false;
        if (kind == .value and std.ascii.isUpper(byte)) return false;

        after_underscore = false;
    }

    return !after_underscore;
}
