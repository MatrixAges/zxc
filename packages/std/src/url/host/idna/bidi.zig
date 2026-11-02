const tables = @import("tables.zig");

pub fn required(labels: []const []const u21) bool {
    for (labels) |label| {
        for (label) |point| {
            switch (tables.inspect(point).bidi) {
                .R, .AL, .AN => return true,
                else => {},
            }
        }
    }

    return false;
}

pub fn validate(label: []const u21) !void {
    if (label.len == 0) return;

    const rtl = switch (tables.inspect(label[0]).bidi) {
        .R, .AL => true,
        .L => false,
        else => return error.InvalidDomain,
    };

    var last = tables.inspect(label[0]).bidi;
    var european = false;
    var arabic = false;

    for (label) |point| {
        const direction = tables.inspect(point).bidi;

        switch (direction) {
            .R, .AL, .AN => if (!rtl) return error.InvalidDomain,
            .L => if (rtl) return error.InvalidDomain,
            .EN, .ES, .CS, .ET, .ON, .BN, .NSM => {},
            else => return error.InvalidDomain,
        }

        if (direction != .NSM) last = direction;
        if (direction == .EN) european = true;
        if (direction == .AN) arabic = true;
    }

    if (rtl) {
        if (european and arabic) return error.InvalidDomain;
        if (last != .R and last != .AL and last != .EN and last != .AN) return error.InvalidDomain;
    } else if (last != .L and last != .EN) return error.InvalidDomain;
}
