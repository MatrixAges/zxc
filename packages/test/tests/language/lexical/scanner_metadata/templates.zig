pub const all = [_][]const u8{
    "`plain`",
    "`raw\nline`",
    "`a${\"}\"}b`",
    "`a${{value:1}}b`",
    "`a${/* } ` $ */1}b`",
    "`a${// } ` $\n1}b`",
    "`a${`inner${1}`}b`",
    "`a${`inner\n${/*\n*/1}`}b`",
    "`\\${literal}`",
    "`\\`quoted\\``",
};
