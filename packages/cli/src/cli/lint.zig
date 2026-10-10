const std = @import("std");
const compiler = @import("compiler");
const lint = @import("lint");
const rx = @import("rx");
const zx = @import("zx");
const Compile = @import("compile.zig");

pub fn run(context: Compile.Context) !Compile.Status {
    if (context.options.workspace_lint) return @import("lint/workspace.zig").run(context);
    if (context.options.semantic_lint) return @import("lint/semantic.zig").run(context);

    const path = context.options.input;

    if (context.options.config_kind != null or @import("configuration/kind.zig").infer(path) != null) return @import("configuration/root.zig").run(context);

    const is_rx = std.mem.endsWith(u8, path, ".rx");

    if (!is_rx and !std.mem.endsWith(u8, path, ".zx")) {
        try context.stderr.writeAll("lint requires ZX, RX, pkg.yaml, pkg.lock.json or an explicit --kind selection\n");

        return .failed;
    }

    const source = std.Io.Dir.cwd().readFileAlloc(context.io, path, context.allocator, .limited(16 * 1024 * 1024)) catch |err| {
        if (err == error.OutOfMemory or err == error.Canceled) return err;
        try context.stderr.print("{s}: {s}\n", .{ path, @errorName(err) });

        return .failed;
    };

    defer context.allocator.free(source);

    return checkSource(context, source);
}

pub fn checkSource(context: Compile.Context, source: []const u8) !Compile.Status {
    const path = context.options.input;

    if (std.mem.endsWith(u8, path, ".rx")) {
        var parsed = try rx.parseXml(context.allocator, source);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) return rxDiagnostic(context, parsed.value.diagnostic);

        var checked = try rx.validate(context.allocator, path, parsed.value.node);

        defer checked.deinit();

        if (checked.value == .diagnostic) return rxDiagnostic(context, checked.value.diagnostic);

        if (try @import("rx_analysis").expression.checkValues(context.allocator, parsed.value.node, path)) |diagnostic| {
            defer diagnostic.issue.deinit();

            try context.stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, diagnostic.location.line, diagnostic.location.column, diagnostic.issue.code, diagnostic.issue.message });

            return .failed;
        }

        const formatted = try lint.rx.format(context.allocator, source, parsed.value.node);

        defer context.allocator.free(formatted);

        if (!std.mem.eql(u8, source, formatted)) {
            try context.stderr.print("{s}: {s}\n", .{ path, lint.source.formatting_required });

            return .failed;
        }
    } else {
        if (try compiler.checkSource(context.allocator, source, path)) |diagnostic| {
            defer diagnostic.deinit();

            const location = zx.source.locate(source, diagnostic.span.start);

            try context.stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, location.line, location.column, diagnostic.code, diagnostic.message });

            return .failed;
        }

        const formatted = try compiler.format(context.allocator, source, path);

        defer formatted.deinit(context.allocator);

        if (!std.mem.eql(u8, source, formatted.source)) {
            try context.stderr.print("{s}: {s}\n", .{ path, lint.source.formatting_required });

            return .failed;
        }

        if (lint.length.check(source, context.options.max_lines orelse lint.length.default_maximum)) |exceeded| {
            try context.stderr.print("{s}: length: {d} lines exceed the lint limit of {d}; split by responsibility or pass --max-lines\n", .{ path, exceeded.lines, exceeded.maximum });

            return .failed;
        }
    }

    return .success;
}

fn rxDiagnostic(context: Compile.Context, issue: rx.Diagnostic) !Compile.Status {
    try context.stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ context.options.input, issue.location.line, issue.location.column, issue.code, issue.message });

    return .failed;
}
