const std = @import("std");
const model = @import("root.zig");

pub const Options = struct { services: []const model.Service, routes: []const model.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();
    write(&output.writer, options) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn write(writer: *std.Io.Writer, options: Options) std.Io.Writer.Error!void {
    try writer.writeAll("const std = @import(\"std\");\npub const State = @import(\"zxc_gateway_state\");\n");
    try writer.print("pub const listen = \"{f}\";\npub const max_header_bytes = {d};\nconst max_body_bytes: usize = {d};\n", .{ std.zig.fmtString(options.listen), options.max_header_bytes, options.max_body_bytes });
    for (options.services, 0..) |service, index| try writer.print("const service_{d} = @import(\"{f}\");\n", .{ index, std.zig.fmtString(service.module_name) });
    try writer.writeAll("\npub fn dispatch(scope: *State.Request, io: std.Io, process: std.process.Init.Minimal, request: *std.http.Server.Request) !void {\n");

    if (options.routes.len == 0) {
        try writer.writeAll("    _ = scope;\n    _ = io;\n    _ = process;\n");
    } else {
        try writer.writeAll("    const target = request.head.target;\n    const path = target[0 .. std.mem.indexOfScalar(u8, target, '?') orelse target.len];\n");
    }

    for (options.routes, 0..) |route, index| {
        const first = for (options.routes[0..index]) |previous| {
            if (std.mem.eql(u8, previous.path, route.path)) break false;
        } else true;

        if (!first) continue;
        try writer.print("    if (std.mem.eql(u8, path, \"{f}\")) {{\n", .{std.zig.fmtString(route.path)});

        if (route.method == null) {
            try writer.print("        return invoke_{d}(scope, io, process, request);\n", .{route.service});
        } else {
            for (options.routes) |candidate| {
                if (!std.mem.eql(u8, candidate.path, route.path)) continue;
                try writer.print("        if (request.head.method == .{s}) return invoke_{d}(scope, io, process, request);\n", .{ candidate.method.?, candidate.service });
            }

            try writer.writeAll("        return respond(request, .method_not_allowed, \"method not allowed\", &.{.{ .name = \"allow\", .value = \"");

            var separator: []const u8 = "";

            for (options.routes) |candidate| {
                if (!std.mem.eql(u8, candidate.path, route.path)) continue;
                try writer.print("{s}{s}", .{ separator, candidate.method.? });

                separator = ", ";
            }

            try writer.writeAll("\" }});\n");
        }

        try writer.writeAll("    }\n");
    }

    try writer.writeAll("    return respond(request, .not_found, \"not found\", &.{});\n}\n\n");

    for (options.services, 0..) |service, index| {
        try model.adapter.write(writer, service, index);
        try @import("invoke.zig").write(writer, service, index);
    }

    try writer.writeAll(@embedFile("http.zig"));
}
