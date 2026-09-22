pub const Location = struct {
    offset: usize,
    line: usize,
    column: usize,
};

pub const Attribute = struct {
    name: []const u8,
    value: []const u8,
    location: Location,
    value_location: Location,
};

pub const Text = struct {
    value: []const u8,
    location: Location,
};

pub const Node = struct {
    name: []const u8,
    location: Location,
    attributes: []const Attribute = &.{},
    children: []const Node = &.{},
    text: []const Text = &.{},
};
