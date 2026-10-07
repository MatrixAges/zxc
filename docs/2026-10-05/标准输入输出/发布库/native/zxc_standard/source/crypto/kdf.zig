const std = @import("std");
const Allocator = std.mem.Allocator;
const abi = @import("zxc_abi").native.@"std:crypto";
pub const Authentication = abi.hmacSha256.Input;
pub const Verification = abi.verifyHmacSha256.Input;
pub const Derivation = abi.hkdfSha256.Input;
pub const Password = abi.pbkdf2Sha256.Input;

pub fn Module(comptime Hmac: type) type {
    return struct {
        pub fn hmac(allocator: Allocator, input: Authentication) ![]const u8 {
            const output = try allocator.create([Hmac.mac_length]u8);

            Hmac.create(output, input.data, input.key);

            return output;
        }
        pub fn verifyHmac(input: Verification) !bool {
            if (input.tag.len != Hmac.mac_length) return error.InvalidTagLength;

            var tag: [Hmac.mac_length]u8 = undefined;

            defer std.crypto.secureZero(u8, &tag);
            Hmac.create(&tag, input.data, input.key);

            return std.crypto.timing_safe.eql([Hmac.mac_length]u8, tag, input.tag[0..Hmac.mac_length].*);
        }
        pub fn hkdf(allocator: Allocator, input: Derivation) ![]const u8 {
            const Hkdf = std.crypto.kdf.hkdf.Hkdf(Hmac);

            if (input.length > Hkdf.prk_length * 255) return error.OutputTooLong;

            const output = try allocator.alloc(u8, input.length);
            var key = Hkdf.extract(input.salt, input.key);

            defer std.crypto.secureZero(u8, &key);
            Hkdf.expand(output, input.info, key);

            return output;
        }
        pub fn pbkdf2(allocator: Allocator, input: Password) ![]const u8 {
            if (input.iterations == 0) return error.InvalidIterations;

            const output = try allocator.alloc(u8, input.length);

            errdefer {
                std.crypto.secureZero(u8, output);
                allocator.free(output);
            }

            try std.crypto.pwhash.pbkdf2(output, input.password, input.salt, input.iterations, Hmac);

            return output;
        }
    };
}
