const std = @import("std");
const Allocator = std.mem.Allocator;
const abi = @import("zxc_abi").native.@"std:crypto";
pub const Encryption = abi.encryptAes128Gcm.Input;
pub const Decryption = abi.decryptAes128Gcm.Input;
pub const Encrypted = abi.encryptAes128Gcm.Output;

pub fn Module(comptime Cipher: type, comptime maximum: u64) type {
    return struct {
        pub fn encrypt(allocator: Allocator, input: Encryption) !Encrypted {
            try validate(input.key, input.nonce, input.data.len, input.aad.len);

            const ciphertext = try allocator.alloc(u8, input.data.len);

            errdefer allocator.free(ciphertext);

            const tag = try allocator.create([Cipher.tag_length]u8);

            errdefer allocator.destroy(tag);

            const output = try allocator.create(abi.encryptAes128Gcm.OutputValue);

            Cipher.encrypt(ciphertext, tag, input.data, input.aad, input.nonce[0..Cipher.nonce_length].*, input.key[0..Cipher.key_length].*);

            output.* = .{ .ciphertext = ciphertext, .tag = tag };

            return output;
        }
        pub fn decrypt(allocator: Allocator, input: Decryption) ![]const u8 {
            try validate(input.key, input.nonce, input.ciphertext.len, input.aad.len);

            if (input.tag.len != Cipher.tag_length) return error.InvalidTagLength;

            const output = try allocator.alloc(u8, input.ciphertext.len);

            errdefer {
                std.crypto.secureZero(u8, output);
                allocator.free(output);
            }

            try Cipher.decrypt(output, input.ciphertext, input.tag[0..Cipher.tag_length].*, input.aad, input.nonce[0..Cipher.nonce_length].*, input.key[0..Cipher.key_length].*);

            return output;
        }
        fn validate(key: []const u8, nonce: []const u8, length: usize, aad_length: usize) !void {
            if (key.len != Cipher.key_length) return error.InvalidKeyLength;
            if (nonce.len != Cipher.nonce_length) return error.InvalidNonceLength;
            if (length > maximum or aad_length > std.math.maxInt(u64) / 8) return error.InputTooLong;
        }
    };
}
