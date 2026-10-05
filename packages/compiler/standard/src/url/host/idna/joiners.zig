const tables = @import("tables.zig");
const normalization = @import("normalization.zig");

pub fn validate(label: []const u21) !void {
    for (label, 0..) |point, index| {
        if (point != 0x200c and point != 0x200d) continue;
        if (index > 0 and normalization.combiningClass(label[index - 1]) == 9) continue;
        if (point == 0x200d) return error.InvalidDomain;

        var left = index;
        var preceding: tables.Joining = .U;

        while (left > 0) {
            left -= 1;
            preceding = tables.inspect(label[left]).joining;

            if (preceding != .T) break;
        }

        if (preceding != .L and preceding != .D) return error.InvalidDomain;

        var right = index + 1;
        var following: tables.Joining = .U;

        while (right < label.len) : (right += 1) {
            following = tables.inspect(label[right]).joining;

            if (following != .T) break;
        }

        if (following != .R and following != .D) return error.InvalidDomain;
    }
}
