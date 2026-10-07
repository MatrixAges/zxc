const std = @import("std");
const Workspace = @import("flow_workspace");
const Writer = *const anyopaque;

fn view(writer: Writer) *Workspace {
    return @ptrCast(@alignCast(@constCast(writer)));
}

pub fn push(writer: Writer, kind: u64, a: u64, b: u64, c: u64) std.mem.Allocator.Error!void {
    const data = view(writer);

    try data.events.append(data.allocator, .{ .kind = kind, .a = a, .b = b, .c = c });
}

pub fn pop(writer: Writer) void {
    const data = view(writer);

    data.current = data.events.pop().?;
}

pub fn eventCount(writer: Writer) u64 {
    return view(writer).events.items.len;
}

pub fn eventKind(writer: Writer) u64 {
    return view(writer).current.kind;
}

pub fn eventA(writer: Writer) u64 {
    return view(writer).current.a;
}

pub fn eventB(writer: Writer) u64 {
    return view(writer).current.b;
}

pub fn eventC(writer: Writer) u64 {
    return view(writer).current.c;
}

pub fn active(writer: Writer, index: u64) bool {
    return view(writer).active[@intCast(index)];
}

pub fn setActive(writer: Writer, index: u64, value: bool) std.mem.Allocator.Error!void {
    try view(writer).setActive(@intCast(index), value);
}

pub fn activeMark(writer: Writer) u64 {
    return view(writer).history.items.len;
}

pub fn restoreActive(writer: Writer, mark: u64) void {
    view(writer).restoreActive(@intCast(mark));
}

pub fn declared(writer: Writer, index: u64) bool {
    return view(writer).declared[@intCast(index)];
}

pub fn setDeclared(writer: Writer, index: u64) void {
    view(writer).declared[@intCast(index)] = true;
}

pub fn owner(writer: Writer, index: u64) u64 {
    return view(writer).owners[@intCast(index)];
}

pub fn setOwner(writer: Writer, index: u64, value: u64) void {
    view(writer).owners[@intCast(index)] = value;
}

pub fn factMark(writer: Writer) u64 {
    return view(writer).facts.nonnull.items.len;
}

pub fn captureMark(writer: Writer) u64 {
    return view(writer).facts.captures.items.len;
}

pub fn restoreFacts(writer: Writer, facts: u64, captures: u64) void {
    view(writer).facts.restore(.{ .nonnull = @intCast(facts), .captures = @intCast(captures) });
}

pub fn contains(writer: Writer, symbol: u64) bool {
    return view(writer).facts.contains(@fromBackingInt(@intCast(symbol)));
}

pub fn appendFact(writer: Writer, symbol: u64) std.mem.Allocator.Error!void {
    const data = view(writer);

    try data.facts.nonnull.append(data.allocator, @fromBackingInt(@intCast(symbol)));
}

pub fn appendCapture(writer: Writer, err: u64, result: u64) std.mem.Allocator.Error!void {
    const data = view(writer);

    try data.facts.captures.append(data.allocator, .{ .err = @fromBackingInt(@intCast(err)), .result = @fromBackingInt(@intCast(result)) });
}

pub fn captureError(writer: Writer, index: u64) u64 {
    return @backingInt(view(writer).facts.captures.items[@intCast(index)].err);
}

pub fn captureResult(writer: Writer, index: u64) u64 {
    return @backingInt(view(writer).facts.captures.items[@intCast(index)].result);
}
