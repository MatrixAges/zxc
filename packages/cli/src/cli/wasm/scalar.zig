var scalar_result: Scalar(application.Output) = undefined;
var scalar_ready = false;

comptime {
    if (isScalar(application.Input) and isScalar(application.Output)) {
        @export(if (application.Input == void) &scalarCallVoid else &scalarCall, .{ .name = "zxc_call" });

        if (application.Output != void) @export(&scalarResult, .{ .name = "zxc_scalar_result" });
    }
}

fn isScalar(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .void, .bool => true,
        .int => |value| value.bits <= 64,
        .float => |value| value.bits == 32 or value.bits == 64,
        else => false,
    };
}

fn Scalar(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .int => |value| if (value.bits <= 32) std.meta.Int(value.signedness, 32) else std.meta.Int(value.signedness, 64),
        .float => T,
        else => u32,
    };
}

fn scalarCall(value: Scalar(application.Input)) callconv(.c) u32 {
    const input_value: application.Input = switch (@typeInfo(application.Input)) {
        .bool => if (value <= 1) value == 1 else return scalarInvalid(),
        .int => std.math.cast(application.Input, value) orelse return scalarInvalid(),
        .float => value,
        else => unreachable,
    };

    return scalarExecute(input_value);
}

fn scalarCallVoid() callconv(.c) u32 {
    return scalarExecute({});
}

fn scalarResult() callconv(.c) Scalar(application.Output) {
    return if (scalar_ready) scalar_result else 0;
}

fn scalarInvalid() u32 {
    if (executing) return 2;

    zxc_reset();

    result = "InvalidScalarInput";

    return 1;
}

fn scalarExecute(value: application.Input) u32 {
    if (executing) return 2;

    zxc_reset();

    executing = true;

    defer executing = false;

    prepare() catch |err| {
        result = @errorName(err);

        return 1;
    };

    const current = &request.?;

    const output = (if (application.requires_io or application.requires_process) unreachable else if (stateful) current.execute(value) else application.execute(&current.arena, value)) catch |err| {
        result = @errorName(err);

        return 1;
    };

    scalar_result = switch (@typeInfo(application.Output)) {
        .void => 0,
        .bool => @intFromBool(output),
        .int, .float => output,
        else => unreachable,
    };

    scalar_ready = true;

    return 0;
}
