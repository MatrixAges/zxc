const std = @import("std");
const crypto = @import("standard").crypto;
const Cipher = enum { aes128, aes256, chacha };

test "crypto AEAD operations release allocations on success authentication failure and OOM" {
    inline for (.{ Cipher.aes128, Cipher.aes256, Cipher.chacha }) |cipher| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, CipherCheck(cipher).run, .{});
    }
}

fn CipherCheck(comptime cipher: Cipher) type {
    return struct {
        fn run(allocator: std.mem.Allocator) !void {
            const encrypt = comptime switch (cipher) {
                .aes128 => crypto.encryptAes128Gcm,
                .aes256 => crypto.encryptAes256Gcm,
                .chacha => crypto.encryptChaCha20Poly1305,
            };

            const decrypt = comptime switch (cipher) {
                .aes128 => crypto.decryptAes128Gcm,
                .aes256 => crypto.decryptAes256Gcm,
                .chacha => crypto.decryptChaCha20Poly1305,
            };

            const key = [_]u8{7} ** 32;
            const nonce = [_]u8{9} ** 12;
            const key_bytes = key[0..if (cipher == .aes128) 16 else 32];
            const data = "resource boundary plaintext";
            const aad = "authenticated metadata";
            const encrypted = try encrypt(allocator, &.{ .key = key_bytes, .nonce = &nonce, .data = data, .aad = aad });

            defer allocator.destroy(encrypted);
            defer allocator.free(encrypted.ciphertext);
            defer allocator.free(encrypted.tag);

            const plain = try decrypt(allocator, &.{ .key = key_bytes, .nonce = &nonce, .ciphertext = encrypted.ciphertext, .tag = encrypted.tag, .aad = aad });

            defer allocator.free(plain);

            try std.testing.expectEqualStrings(data, plain);

            var tag: [16]u8 = undefined;

            @memcpy(&tag, encrypted.tag);

            tag[0] ^= 1;

            const unexpected = decrypt(allocator, &.{ .key = key_bytes, .nonce = &nonce, .ciphertext = encrypted.ciphertext, .tag = &tag, .aad = aad }) catch |err| {
                if (err == error.OutOfMemory) return err;

                try std.testing.expectEqual(error.AuthenticationFailed, err);

                return;
            };

            defer allocator.free(unexpected);

            return error.TestExpectedError;
        }
    };
}

test "crypto HMAC and derivation operations release every failed allocation" {
    inline for (.{ 256, 512 }) |bits| {
        try std.testing.checkAllAllocationFailures(std.testing.allocator, DerivationCheck(bits).run, .{});
    }
}

fn DerivationCheck(comptime bits: usize) type {
    return struct {
        fn run(allocator: std.mem.Allocator) !void {
            const hmac = if (bits == 256) crypto.hmacSha256 else crypto.hmacSha512;
            const hkdf = if (bits == 256) crypto.hkdfSha256 else crypto.hkdfSha512;
            const pbkdf2 = if (bits == 256) crypto.pbkdf2Sha256 else crypto.pbkdf2Sha512;
            const tag = try hmac(allocator, &.{ .key = "key", .data = "message" });

            defer allocator.free(tag);

            const expanded = try hkdf(allocator, &.{ .key = "key", .salt = "salt", .info = "info", .length = 65 });

            defer allocator.free(expanded);

            const derived = try pbkdf2(allocator, &.{ .password = "password", .salt = "salt", .iterations = 2, .length = 65 });

            defer allocator.free(derived);

            try std.testing.expectEqual(@as(usize, bits / 8), tag.len);
            try std.testing.expectEqual(@as(usize, 65), expanded.len);
            try std.testing.expectEqual(@as(usize, 65), derived.len);
        }
    };
}
