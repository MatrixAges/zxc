const std = @import("std");
const zx = @import("zx");
const naming = @import("lint");

pub fn check(allocator: std.mem.Allocator, view: anytype, reporter: *zx.Reporter) zx.Error!void {
    for (view.storage.declarations) |item| {
        const name = view.name(item.name);

        if (!naming.checkName(name.text, .type_decl)) return reporter.fail(.naming, name.span, "type names must use PascalCase");
    }

    for (view.storage.functions, 0..) |item, index| {
        const name = view.name(item.name);

        if (!naming.checkName(name.text, .callable)) return reporter.fail(.naming, name.span, "function names must use camelCase");

        for (view.storage.functions[0..index]) |previous| {
            if (std.mem.eql(u8, view.name(previous.name).text, name.text)) return reporter.fail(.name, name.span, "duplicate native function declaration");
        }

        const first: usize = @intCast(item.first_parameter);
        const count: usize = @intCast(item.count);
        const parameters = view.storage.parameters[first..][0..count];
        var names: std.StringHashMapUnmanaged(void) = .empty;

        defer names.deinit(allocator);

        for (parameters) |parameter| {
            const parameter_name = view.name(parameter.name);

            if (!naming.checkName(parameter_name.text, .value)) return reporter.fail(.naming, parameter_name.span, "parameter names must use snake_case");

            const entry = try names.getOrPut(allocator, parameter_name.text);

            if (entry.found_existing) return reporter.fail(.name, parameter_name.span, "duplicate native parameter name");
        }

        const first_error: usize = @intCast(item.first_error);
        const error_count: usize = @intCast(item.error_count);
        const errors = view.storage.errors[first_error..][0..error_count];

        for (errors, 0..) |position, error_index| {
            const error_name = view.name(position);

            if (!naming.checkName(error_name.text, .type_decl)) return reporter.fail(.naming, error_name.span, "error names must use PascalCase");

            for (errors[0..error_index]) |previous| {
                if (std.mem.eql(u8, view.name(previous).text, error_name.text)) return reporter.fail(.name, error_name.span, "duplicate native error name");
            }
        }
    }
}
