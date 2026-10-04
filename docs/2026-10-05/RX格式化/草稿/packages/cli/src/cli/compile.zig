const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const Attempt = @import("watch/attempt.zig");
pub const Status = enum { success, failed, retry, backend_failed };

pub const Context = struct {
    io: std.Io,
    allocator: std.mem.Allocator,
    options: @import("options.zig").Options,
    environment: *const std.process.Environ.Map,
    stdout: *std.Io.Writer,
    stderr: *std.Io.Writer,
    watch: ?*Attempt = null,
};

pub fn run(context: Context) !Status {
    const allocator = context.allocator;
    const options = context.options;
    const stdout = context.stdout;
    const stderr = context.stderr;
    var library_inputs = if (context.watch == null and options.mode == .lib) try @import("watch/inputs.zig").init(context.io, allocator) else null;

    defer if (library_inputs) |*observed| observed.deinit();

    const inputs = if (context.watch) |attempt| attempt.inputs else if (library_inputs) |*observed| observed else null;
    const input_path = options.input;

    if (inputs) |observed| try observed.add(context.io, input_path);
    if (!options.formatting and std.mem.endsWith(u8, input_path, ".rx") and options.mode != .lib) return @import("rx/compile.zig").run(context);

    var loaded = if (options.formatting) @import("project.zig").Loaded{ .project = .{ .entry = input_path } } else @import("project.zig").loadWithInputs(context.io, allocator, input_path, options.project, inputs) catch |err| {
        if (err == error.OutOfMemory or err == error.Canceled) return err;
        try stderr.print("{s}: {s}\n", .{ options.project orelse "pkg.yaml", @errorName(err) });
        try stderr.flush();

        return .failed;
    };

    if (loaded.diagnostic) |message| {
        try stderr.print("{s}\n", .{message});
        try stderr.flush();

        return .failed;
    }

    var project = loaded.project;

    if (options.verifying and std.mem.eql(u8, std.fs.path.basename(input_path), "pkg.yaml")) {
        return @import("library/verify.zig").run(context, loaded, inputs) catch |err| {
            if (err == error.OutOfMemory or err == error.Canceled) return err;
            try stderr.print("{s}: public module verification: {s}\n", .{ input_path, @errorName(err) });
            try stderr.flush();

            return .failed;
        };
    }

    if (options.native and options.mode == .lib) {
        return @import("library/build.zig").run(context, loaded, inputs.?) catch |err| {
            if (err == error.OutOfMemory or err == error.Canceled) return err;
            try stderr.print("{s}: library build: {s}\n", .{ input_path, @errorName(err) });
            try stderr.flush();

            return .failed;
        };
    }

    if (!options.formatting and std.mem.endsWith(u8, input_path, ".rx")) return @import("rx/compile.zig").run(context);

    const source = std.Io.Dir.cwd().readFileAlloc(context.io, input_path, allocator, .limited(16 * 1024 * 1024)) catch |err| {
        if (err == error.OutOfMemory) return err;
        try stderr.print("{s}: {s}\n", .{ input_path, @errorName(err) });

        return .failed;
    };

    var semantic_cache = compiler.project.SemanticCache.init(allocator);

    defer semantic_cache.deinit();

    var storage = try @import("cache.zig").init(context.io, allocator, project.root_dir);

    defer storage.deinit();

    var libraries = @import("library/inputs.zig"){ .allocator = allocator };

    defer libraries.deinit();

    const sources = if (options.formatting) &.{} else @import("sources.zig").readWithLibraries(context.io, allocator, source, project, &semantic_cache.parse_cache, inputs, &libraries) catch |err| {
        if (err == error.OutOfMemory) return err;

        try stderr.print("{s}: source loading: {s}\n", .{ libraries.failure_path orelse input_path, @errorName(err) });
        try stderr.flush();

        return .failed;
    };

    project.compiled_libraries = libraries.libraries.items;
    loaded.project = project;

    if (options.cache and options.cache_stats and project.compiled_libraries.len != 0) try stderr.writeAll("zxc cache: compiled library inputs bypass semantic artifacts; parsing and generation caches remain available\n");

    if (options.cache and !options.formatting and project.compiled_libraries.len == 0) storage.load(sources, project, &semantic_cache) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        try stderr.print("zxc cache read: {s}\n", .{@errorName(err)});
    };

    if (options.verifying) {
        if (!try @import("verify.zig").run(context.io, allocator, sources, project, options, stderr, &semantic_cache)) {
            try stderr.flush();

            return .failed;
        }

        try storage.finish(&semantic_cache, options, stderr);

        return .success;
    }

    if (options.fpga) {
        if (!try @import("fpga.zig").run(context.io, allocator, sources, project, options, stderr, &semantic_cache)) {
            try stderr.flush();

            return .failed;
        }

        try storage.finish(&semantic_cache, options, stderr);

        return .success;
    }

    var type_output: std.Io.Writer.Allocating = .init(allocator);

    defer type_output.deinit();

    var module_bundle: ?compiler.zig.ModuleBundle = null;

    defer if (module_bundle) |*bundle| bundle.deinit();

    var generation_cache = try @import("generation_cache.zig").init(context.io, allocator, project.root_dir);

    defer generation_cache.deinit();

    var dependencies: std.ArrayList([]const u8) = .empty;
    const compile_options = compiler.CompileOptions{ .io = context.io, .sources = sources, .project = project, .parse_cache = if (options.cache) null else &semantic_cache.parse_cache, .semantic_cache = if (options.cache) &semantic_cache else null, .generation_cache = if (options.native and options.cache) &generation_cache else null, .solver = options.solver, .writer = stderr, .dependencies = &dependencies, .type_output = if (options.output != null) &type_output.writer else null };

    const result: compiler.Result = if (options.native) generated: {
        const compiled = try compiler.compileProjectModulesVerified(allocator, compile_options);

        switch (compiled) {
            .diagnostic => |issue| break :generated .{ .diagnostic = issue },
            .bundle => |bundle| {
                module_bundle = bundle;

                break :generated .{ .source = try allocator.dupe(u8, bundle.entry.source) };
            },
        }
    } else if (options.formatting) try compiler.format(allocator, source, input_path) else try compiler.compileProjectVerified(allocator, compile_options);

    defer result.deinit(allocator);

    switch (result) {
        .diagnostic => |issue| {
            const failed_source = if (issue.source_index) |index| sources[index].source else source;
            const failed_path = if (issue.source_index) |index| sources[index].path else input_path;
            const location = zx.source.locate(failed_source, issue.span.start);

            try stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ failed_path, location.line, location.column, issue.code, issue.message });
            try stderr.flush();

            return .failed;
        },
        .source => |text| {
            if (!options.formatting) try storage.finish(&semantic_cache, options, stderr);

            if (options.native) {
                try @import("generation_cache.zig").report(&generation_cache, options, stderr);

                const toolchain = @import("toolchain.zig").resolve(context.io, allocator, context.environment) catch |err| {
                    if (err == error.OutOfMemory or err == error.Canceled) return err;
                    try stderr.print("zxc toolchain cache: {s}\n", .{@errorName(err)});
                    try stderr.flush();

                    return .failed;
                };

                const native_project = try @import("standard.zig").resolve(allocator, loaded, dependencies.items, toolchain.standard);

                for (native_project.config.native_modules) |native| {
                    for (module_bundle.?.modules) |module| if (std.mem.eql(u8, native.name, module.name)) return error.ConflictingModuleName;
                }

                if (context.watch) |attempt| {
                    try attempt.prepareBackend(context.io);

                    var observed = try @import("build.zig").runObserved(context.io, allocator, module_bundle.?, options, native_project, toolchain, context.environment, attempt.inputs);

                    defer observed.deinit();

                    try attempt.finishBackend(observed.input_paths);
                    try stderr.writeAll(observed.response.stderr);
                    try observed.response.diagnostics.renderToWriter(.{}, stderr);
                    if (!observed.response.succeeded) return .backend_failed;
                    if (!observed.response.inputs_complete) return error.IncompleteBackendInputs;
                    if (!try observed.publish(context.io, allocator, attempt.inputs, options)) return .retry;
                } else if (!try @import("build.zig").run(context.io, allocator, module_bundle.?, options, native_project, toolchain, context.environment)) return .failed;
            } else if (options.check) {
                if (!std.mem.eql(u8, source, text)) {
                    try stderr.print("{s}: {s}\n", .{ input_path, @import("lint").source.formatting_required });
                    try stderr.flush();

                    return .failed;
                }
            } else if (options.write or options.output != null) {
                if (type_output.written().len != 0) {
                    const types_path = try std.fmt.allocPrint(allocator, "{s}.abi.zig", .{options.output.?});

                    try @import("artifacts.zig").write(context.io, types_path, type_output.written());
                }

                try @import("artifacts.zig").write(context.io, if (options.write) input_path else options.output.?, text);
            } else {
                try stdout.writeAll(text);
            }
        },
    }

    return .success;
}
