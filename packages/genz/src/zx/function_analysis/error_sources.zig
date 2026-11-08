const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("generated_function_error_sources");
const Input = std.meta.Child(generated.Input);
const Context = std.meta.Child(@FieldType(Input, "context"));
const Tables = std.meta.Child(@FieldType(Context, "types"));
const Functions = std.meta.Child(@FieldType(Context, "functions"));

pub fn collect(allocator: std.mem.Allocator, types: ir.TypeTable, functions: ir.FunctionTable) std.mem.Allocator.Error!@import("zx").error_effects.Bodies {
    const count = functions.count();
    const own = try allocator.alloc(zx.error_effects.Own, count);

    errdefer allocator.free(own);

    const arenas = try allocator.alloc(std.heap.ArenaAllocator, @max(@min(zx.parallel.width(), count), 1));

    errdefer allocator.free(arenas);

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    errdefer for (arenas) |*arena| arena.deinit();

    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "base")), types);
    const delta = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "delta")), .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const borrowed_functions = zx.columns.borrow(Functions, &functions);
    const context: Context = .{ .types = &tables, .functions = &borrowed_functions };
    var work = Visits{ .context = &context, .own = own, .arenas = arenas };

    zx.parallel.spread(Visits, &work, Visits.run, arenas.len);

    if (work.failed.load(.monotonic)) return error.OutOfMemory;

    return .{ .allocator = allocator, .own = own, .arenas = arenas };
}

const Visits = struct {
    context: *const Context,
    own: []zx.error_effects.Own,
    arenas: []std.heap.ArenaAllocator,
    next: std.atomic.Value(usize) = .init(0),
    failed: std.atomic.Value(bool) = .init(false),
    fn run(self: *@This(), participant: usize) void {
        var scratch = std.heap.ArenaAllocator.init(std.heap.smp_allocator);

        defer scratch.deinit();

        const lasting = self.arenas[participant].allocator();

        while (!self.failed.load(.monotonic)) {
            const index = self.next.fetchAdd(1, .monotonic);

            if (index >= self.own.len) return;

            _ = scratch.reset(.retain_capacity);

            const input: Input = .{ .context = self.context, .index = index };

            const output = generated.executeIn(scratch.allocator(), &input) catch {
                self.failed.store(true, .monotonic);

                return;
            };

            self.own[index] = .{
                .unknown = output.unknown,
                .names = lasting.dupe([]const u8, output.names) catch {
                    self.failed.store(true, .monotonic);

                    return;
                },
                .callees = @ptrCast(lasting.dupe(u32, output.callees) catch {
                    self.failed.store(true, .monotonic);

                    return;
                }),
            };
        }
    }
};
