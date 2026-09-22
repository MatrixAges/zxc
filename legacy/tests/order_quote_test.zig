const std = @import("std");
const subject = @import("subject");

test "rejects an empty order" {
    const result = subject.execute(.{
        .subtotal_cents = 8_000,
        .base_shipping_cents = 800,
        .item_count = 0,
        .fraud_score = 10,
        .inventory_available = true,
        .internal_approved = false,
        .customer_tier = subject.CustomerTier.Standard,
        .region = subject.Region.Domestic,
        .channel = subject.SalesChannel.Online,
    });

    try std.testing.expect(!result.ok);
    try std.testing.expectEqual(subject.DecisionCode.InvalidItemCount, result.code);
    try std.testing.expectEqual(@as(u64, 0), result.payable_cents);
    try std.testing.expectEqualStrings("item_count_must_be_positive", result.reason.?);
}

test "requires approval for the internal channel" {
    const result = subject.execute(.{
        .subtotal_cents = 5_000,
        .base_shipping_cents = 800,
        .item_count = 2,
        .fraud_score = 10,
        .inventory_available = true,
        .internal_approved = false,
        .customer_tier = subject.CustomerTier.Silver,
        .region = subject.Region.Domestic,
        .channel = subject.SalesChannel.Internal,
    });

    try std.testing.expect(!result.ok);
    try std.testing.expectEqual(subject.DecisionCode.InternalApprovalRequired, result.code);
    try std.testing.expectEqual(@as(u64, 0), result.discount_cents);
    try std.testing.expectEqualStrings("internal_approval_required", result.reason.?);
}

test "calculates a discounted Gold order with free shipping" {
    const result = subject.execute(.{
        .subtotal_cents = 20_000,
        .base_shipping_cents = 1_200,
        .item_count = 12,
        .fraud_score = 20,
        .inventory_available = true,
        .internal_approved = false,
        .customer_tier = subject.CustomerTier.Gold,
        .region = subject.Region.International,
        .channel = subject.SalesChannel.Online,
    });

    try std.testing.expect(result.ok);
    try std.testing.expectEqual(subject.DecisionCode.Approved, result.code);
    try std.testing.expectEqual(@as(u64, 4_000), result.discount_cents);
    try std.testing.expectEqual(@as(u64, 0), result.shipping_cents);
    try std.testing.expectEqual(@as(u64, 16_000), result.payable_cents);
    try std.testing.expect(result.reason == null);
}
