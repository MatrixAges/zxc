const std = @import("std");
const Service = @import("root.zig").Service;

pub fn write(writer: *std.Io.Writer, service: Service, index: usize) std.Io.Writer.Error!void {
    try writer.print("fn invoke_{d}(scope: *State.Request, io: std.Io, process: std.process.Init.Minimal, request: *std.http.Server.Request) !void {{\n", .{index});
    if (!service.requires_io) try writer.writeAll("    _ = io;\n");
    if (!service.requires_process) try writer.writeAll("    _ = process;\n");
    try writer.writeAll("    const allocator = scope.arena.allocator();\n    const body = (try readBody(allocator, request)) orelse return;\n");
    try writer.print("    const input: service_{0d}.Input = if (service_{0d}.Input == void) blk: {{\n        if (body.len != 0) return respond(request, .bad_request, \"expected empty body\", &.{{}});\n        break :blk {{}};\n    }} else std.json.parseFromSliceLeaky(service_{0d}.Input, allocator, body, .{{ .allocate = .alloc_always }}) catch |err| {{\n        if (err == error.OutOfMemory) return err;\n        return respond(request, .bad_request, \"invalid JSON input\", &.{{}});\n    }};\n\n", .{index});
    if (service.slots.len != 0) try writer.print("    var context = Context_{d}.init(scope);\n", .{index});
    try writer.print("    const output = service_{d}.execute(&scope.arena, input{s}{s}{s}) catch |err| {{\n        if (err == error.OutOfMemory or err == error.Canceled) return err;\n        std.log.err(\"Gateway service failed: {{s}}\", .{{@errorName(err)}});\n        return respond(request, .internal_server_error, \"service failed\", &.{{}});\n    }};\n", .{ index, if (service.slots.len != 0) ", &context" else "", if (service.requires_io) ", io" else "", if (service.requires_process) ", process" else "" });
    try writer.print("    const encoded = if (service_{d}.Output == void) \"null\" else try std.json.Stringify.valueAlloc(allocator, output, .{{}});\n    return respond(request, .ok, encoded, &.{{.{{ .name = \"content-type\", .value = \"application/json\" }}}});\n}}\n\n", .{index});
}
