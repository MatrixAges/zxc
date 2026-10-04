const h = @import("check.zig");

test "Store text requires name" {
    try h.reject("<Store version='1'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .missing_attribute, "name");
}

test "Store text requires version" {
    try h.reject("<Store name='state'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .missing_attribute, "version");
}

test "Store text rejects negative version" {
    try h.reject("<Store name='state' version='-1'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .invalid_attribute, "version");
}

test "Store text rejects overflowing version" {
    try h.reject("<Store name='state' version='4294967296'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .invalid_attribute, "version");
}

test "Store text rejects fractional version" {
    try h.reject("<Store name='state' version='1.5'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .invalid_attribute, "version");
}

test "Store text rejects blank name" {
    try h.reject("<Store name=' ' version='1'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text rejects reference attributes" {
    try h.reject("<Store from='state'/>", .unknown_attribute, "from");
}

test "Store text requires objects" {
    try h.reject("<Store name='state' version='1'></Store>", .child_count, null);
}

test "Store text rejects direct Field" {
    try h.reject("<Store name='state' version='1'><Field name='cursor' type='u64' value='0'/></Store>", .unexpected_element, null);
}

test "Store text rejects flow Call" {
    try h.reject("<Store name='state' version='1'><Call fn='load' in='$in'/></Store>", .unexpected_element, null);
}

test "Store text Object requires name" {
    try h.reject("<Store name='state' version='1'><Object><Field name='cursor' type='u64' value='0'/></Object></Store>", .missing_attribute, "name");
}

test "Store text Object rejects blank name" {
    try h.reject("<Store name='state' version='1'><Object name=' '><Field name='cursor' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text Object requires fields" {
    try h.reject("<Store name='state' version='1'><Object name='state'/></Store>", .child_count, null);
}

test "Store text Object rejects nested Object" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Object></Store>", .unexpected_element, null);
}

test "Store text Field requires name" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field type='u64' value='0'/></Object></Store>", .missing_attribute, "name");
}

test "Store text Field requires type" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' value='0'/></Object></Store>", .missing_attribute, "type");
}

test "Store text Field requires value" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' type='u64'/></Object></Store>", .missing_attribute, "value");
}

test "Store text Field rejects blank name" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name=' ' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text Field rejects blank type" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' type=' ' value='0'/></Object></Store>", .context, "type");
}

test "Store text Field rejects unknown attribute" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' type='u64' value='0' mutable='true'/></Object></Store>", .unknown_attribute, "mutable");
}

test "Store text Field rejects children" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' type='u64' value='0'><Field name='cursor' type='u64' value='0'/></Field></Object></Store>", .child_count, null);
}

test "Store text Field rejects text" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='x' type='u64' value='0'>value</Field></Object></Store>", .unexpected_text, null);
}

test "Store text Object rejects duplicate field" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='cursor' type='u64' value='0'/><Field name='cursor' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text rejects duplicate path across fragments" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text rejects duplicate path across separated fragments" {
    try h.reject("<Store name='state' version='1'><Object name='state'><Field name='cursor' type='u64' value='0'/></Object><Object name='other'><Field name='cursor' type='u64' value='0'/></Object><Object name='state'><Field name='cursor' type='u64' value='0'/></Object></Store>", .context, "name");
}

test "Store text rejects Module root" {
    try h.reject("<Module/>", .unexpected_element, null);
}

test "Store text rejects Gateway root" {
    try h.reject("<Gateway name='api'/>", .unexpected_element, null);
}

test "Store text rejects decoded duplicate field names" {
    try h.reject("<Store name='s' version='1'><Object name='state'><Field name='x' type='u64' value='0'/><Field name='&#120;' type='string' value=''/></Object></Store>", .context, "name");
}

test "Store text rejects decoded duplicate object field paths" {
    try h.reject("<Store name='s' version='1'><Object name='state'><Field name='x' type='u64' value='0'/></Object><Object name='st&#97;te'><Field name='x' type='string' value=''/></Object></Store>", .context, "name");
}
