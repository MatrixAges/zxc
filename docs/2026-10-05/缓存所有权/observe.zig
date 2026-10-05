const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    var parsed = try compiler.parse(init.gpa, @embedFile("source.zx"), "source.zx");

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return error.InvalidSource;

    var analyzed = try compiler.analyze(init.gpa, parsed.value.parsed);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) return error.InvalidSource;

    var program = analyzed.value.ir;
    const original = try compiler.validateIr(init.gpa, program);
    const expressions = try init.gpa.dupe(@TypeOf(program.expressions[0]), program.expressions);

    defer init.gpa.free(expressions);

    program.expressions = expressions;

    const selected = for (expressions) |*expression| {
        if (expression.value == .object and expression.value.object.evaluation.len == 1 and expression.value.object.fields.len == 2) break &expression.value.object;
    } else return error.MissingSpread;

    const original_fields = selected.fields;
    const fields = try init.gpa.dupe(@TypeOf(selected.fields[0]), selected.fields);

    defer init.gpa.free(fields);

    fields[1].value = fields[0].value;
    selected.fields = fields;

    const shared = try compiler.validateIr(init.gpa, program);
    selected.fields = original_fields;

    const direct = for (expressions) |*expression| {
        if (expression.value == .object and expression.value.object.evaluation.len == 2 and expression.value.object.fields.len == 2) break &expression.value.object;
    } else return error.MissingConstruction;

    const direct_fields = try init.gpa.dupe(@TypeOf(direct.fields[0]), direct.fields);

    defer init.gpa.free(direct_fields);

    direct_fields[1].value = direct_fields[0].value;
    direct.fields = direct_fields;

    const shared_root = try compiler.validateIr(init.gpa, program);
    var buffer: [2048]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .original_accepted = original == null, .shared_field_accepted = shared == null, .shared_root_accepted = shared_root == null }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
