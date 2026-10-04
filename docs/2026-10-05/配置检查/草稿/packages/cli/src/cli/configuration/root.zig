const std = @import("std");
const Compile = @import("../compile.zig");
const kinds = @import("kind.zig");

pub fn run(context: Compile.Context) !Compile.Status {
    return execute(context) catch |err| {
        if (err == error.OutOfMemory or err == error.Canceled) return err;
        try context.stderr.print("{s}: configuration: {s}\n", .{ context.options.input, @errorName(err) });

        return .failed;
    };
}

fn execute(context: Compile.Context) !Compile.Status {
    const options = context.options;

    const kind = options.config_kind orelse kinds.infer(options.input) orelse {
        try context.stderr.writeAll("configuration kind is unknown; use --kind manifest, index or lock\n");

        return .failed;
    };

    const source = try std.Io.Dir.cwd().readFileAlloc(context.io, options.input, context.allocator, .limited(kinds.maximumBytes(kind)));

    defer context.allocator.free(source);

    if (!try @import("check.zig").run(context.allocator, kind, source, options.input, context.stderr)) return .failed;

    if (kind == .lock) {
        if (options.linting) return .success;
        try context.stderr.writeAll("pkg.lock.json is managed by zxc pkg install; use zxc lint for read-only validation\n");

        return .failed;
    }

    const formatted = switch (kind) {
        .manifest => try @import("yaml.zig").format(context.allocator, source),
        .index => try @import("lint").configuration.json.format(context.allocator, source),
        .lock => unreachable,
    };

    defer context.allocator.free(formatted);

    if (options.linting or options.check) {
        if (!std.mem.eql(u8, source, formatted)) {
            try context.stderr.print("{s}: configuration formatting required; run zxc fmt with the same --kind selection\n", .{options.input});

            return .failed;
        }
    } else if (options.write) {
        try @import("../artifacts.zig").write(context.io, options.input, formatted);
    } else try context.stdout.writeAll(formatted);

    return .success;
}
