//! SHA-256 that stays fast when the standard library is built for size. There the library reads each message word
//! through a loop over its bytes, which costs more than the rounds themselves; on x86 with the SHA extensions this
//! loads a block as vectors and swaps their bytes instead. Elsewhere it is the library's own.
const std = @import("std");
const builtin = @import("builtin");
pub const Sha256 = if (accelerated) Accelerated else std.crypto.hash.sha2.Sha256;
const accelerated = builtin.cpu.arch == .x86_64 and builtin.zig_backend == .stage2_llvm and builtin.cpu.hasAll(.x86, &.{ .sha, .avx2 });

const Accelerated = struct {
    pub const digest_length = 32;
    pub const block_length = 64;
    pub const Options = struct {};
    state: [8]u32 = .{ 0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19 },
    buffer: [64]u8 = undefined,
    used: usize = 0,
    total: u64 = 0,
    const Words = @Vector(4, u32);

    const constants = [64]u32{
        0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
        0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
        0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
        0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
        0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
        0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
        0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
        0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2,
    };
    pub fn init(_: Options) Accelerated {
        return .{};
    }
    pub fn hash(input: []const u8, out: *[digest_length]u8, options: Options) void {
        // Constants hashed while compiling go through the library, as the extensions only run on the machine.
        if (@inComptime()) return std.crypto.hash.sha2.Sha256.hash(input, out, .{});

        var self = init(options);

        self.update(input);
        self.final(out);
    }

    pub fn update(self: *Accelerated, input: []const u8) void {
        var rest = input;

        self.total += input.len;

        if (self.used != 0) {
            const taken = @min(block_length - self.used, rest.len);

            @memcpy(self.buffer[self.used..][0..taken], rest[0..taken]);

            self.used += taken;
            rest = rest[taken..];

            if (self.used < block_length) return;

            self.block(&self.buffer);

            self.used = 0;
        }

        while (rest.len >= block_length) : (rest = rest[block_length..]) self.block(rest[0..block_length]);

        @memcpy(self.buffer[0..rest.len], rest);

        self.used = rest.len;
    }

    pub fn final(self: *Accelerated, out: *[digest_length]u8) void {
        @memset(self.buffer[self.used..], 0);

        self.buffer[self.used] = 0x80;

        if (self.used >= block_length - 8) {
            self.block(&self.buffer);
            @memset(&self.buffer, 0);
        }

        self.buffer[block_length - 8 ..].* = @bitCast(std.mem.nativeToBig(u64, self.total * 8));

        self.block(&self.buffer);

        for (self.state, 0..) |word, index| out[4 * index ..][0..4].* = @bitCast(std.mem.nativeToBig(u32, word));
    }

    pub fn finalResult(self: *Accelerated) [digest_length]u8 {
        var result: [digest_length]u8 = undefined;

        self.final(&result);

        return result;
    }

    /// The rounds over one block, as the standard library runs them with the SHA extensions.
    fn block(self: *Accelerated, input: *const [block_length]u8) void {
        var schedule: [16]Words = undefined;

        inline for (0..4) |index| schedule[index] = @byteSwap(@as(*align(1) const Words, @ptrCast(input[16 * index ..])).*);

        var x: Words = .{ self.state[5], self.state[4], self.state[1], self.state[0] };
        var y: Words = .{ self.state[7], self.state[6], self.state[3], self.state[2] };

        inline for (0..16) |k| {
            if (k < 12) {
                var tmp = schedule[k];

                schedule[k + 4] = asm (
                    \\ sha256msg1 %[w4_7], %[tmp]
                    \\ vpalignr $0x4, %[w8_11], %[w12_15], %[result]
                    \\ paddd %[tmp], %[result]
                    \\ sha256msg2 %[w12_15], %[result]
                    : [tmp] "=&x" (tmp),
                      [result] "=&x" (-> Words),
                    : [_] "0" (tmp),
                      [w4_7] "x" (schedule[k + 1]),
                      [w8_11] "x" (schedule[k + 2]),
                      [w12_15] "x" (schedule[k + 3]),
                );
            }

            const w: Words = schedule[k] +% @as(Words, constants[4 * k ..][0..4].*);

            y = asm ("sha256rnds2 %[x], %[y]"
                : [y] "=x" (-> Words),
                : [_] "0" (y),
                  [x] "x" (x),
                  [_] "{xmm0}" (w),
            );

            x = asm ("sha256rnds2 %[y], %[x]"
                : [x] "=x" (-> Words),
                : [_] "0" (x),
                  [y] "x" (y),
                  [_] "{xmm0}" (@as(Words, @bitCast(@as(u128, @bitCast(w)) >> 64))),
            );
        }

        self.state[0] +%= x[3];
        self.state[1] +%= x[2];
        self.state[4] +%= x[1];
        self.state[5] +%= x[0];
        self.state[2] +%= y[3];
        self.state[3] +%= y[2];
        self.state[6] +%= y[1];
        self.state[7] +%= y[0];
    }
};
