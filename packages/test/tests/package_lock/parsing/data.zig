pub const digest = &@as([64:0]u8, @splat('a'));
pub const dependency = "{\"name\":\"dep\",\"requirement\":\"^1.0.0\",\"development\":false,\"target\":1}";
pub const root = "{\"name\":\"root\",\"version\":\"1.0.0\",\"source\":{\"workspace\":\".\"},\"dependencies\":[" ++ dependency ++ "]}";
pub const archive = "{\"name\":\"dep\",\"version\":\"1.2.3\",\"source\":{\"archive\":{\"archive\":\"dep.tgz\",\"sha256\":\"" ++ digest ++ "\"}},\"dependencies\":[]}";
pub const source = "{\"format_version\":1,\"packages\":[" ++ root ++ "," ++ archive ++ "]}";
