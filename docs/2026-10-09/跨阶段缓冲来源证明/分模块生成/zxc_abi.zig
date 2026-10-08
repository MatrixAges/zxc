pub const zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_cba597263faf9115e05af19ef297c6cc2ef940004dc17f97b9afe58ccb17ada9 = struct {
    base: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    delta: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
};

pub const zx_type_9d3e204b74a8c5e80521eb8febbdd38a0289004a69fa46fcf8da9577fcaeadde = struct {
    delta: bool,
    first: u32,
    kind: zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd,
    label: []const u8,
    second: u32,
};

pub const zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_c315671c1fb285cb114d660ef40697183d55b548f4804d5c11049ee4487611e6 = struct {
    children: []const u32,
    fields: *const zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5,
    first: u32,
    kind: zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_adc5ff626ac9459c2d7000d4ac4980431e61d6d044a70ae3c8e1b079105ecf20 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_565a64859b4c2a1fcc18784c03a658f564f7d0d78b4981f55bb544c62bae6165 = struct {
    delta: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    id: u32,
};

pub const zx_type_b6b91594b55119018ddc4b3a5a1720f4e554bfc25640fce9b25be4bbc27c4dd3 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
};

pub const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a = struct {
    ids: []const u32,
    kinds: []const u8,
    members: []const []const u8,
    owners: []const []const u8,
};

pub const zx_type_94b518448bb42b8b024501313e7eebbf3f07b4b037cec6a06d16b2ee5f0419a7 = struct {
    base: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    delta: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
};

pub const zx_type_3aa7375d2c3e603569cf2c724bec998fac3c23f969d69c0189cdc4b4305ff560 = enum { Missing, Found, Conflict, };

pub const zx_type_aa061941ed6cd345ccb740c64e2a01599ac7186c71f84ce8d2cd6ac8200f98b1 = struct {
    id: u32,
    status: zx_type_3aa7375d2c3e603569cf2c724bec998fac3c23f969d69c0189cdc4b4305ff560,
};

pub const zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12 = enum { Invalid, MissingOrigin, Ready, };

pub const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
    origins: []const u64,
    status: zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12,
};

pub const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = struct {
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    roots: []const bool,
    scalar_count: u64,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
};

pub const zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac = struct {
    ids: []const u64,
    ready: []const bool,
};

pub const zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a = struct {
    index: u64,
    pending: *const zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
};

pub const zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc = struct { []const u64, void, };
pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct { []const bool, void, };

pub const zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = struct {
    first: u64,
    pending: *const zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac,
    remaining: u64,
    values: []const u32,
};

pub const zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
};

pub const zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    result: u64,
    valid: bool,
};

pub const zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = struct {
    index: u64,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = struct {
    pending: *const zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4 = struct { []const u64, ?u64, };
pub const zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148 = struct { []const bool, ?bool, };

pub const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
};

pub const zx_type_372da7c089c93fe6e642fa5da638cdcf3ff4918df5659a9290a0f95ae4c5db2d = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
};

pub const zx_type_ea1c3f5524fc6ccb66205dc4f3fcbcb9ae473dc988ad096232ad81fd3ccf294d = struct {
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
};

pub const zx_type_96eb926f4119f5d93da4266ffde63d658ebc0836b9608e39f968fff3000dc50e = struct {
    functions: *const zx_type_372da7c089c93fe6e642fa5da638cdcf3ff4918df5659a9290a0f95ae4c5db2d,
    index: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
};

pub const zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744 = struct {
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    selected: []const bool,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e = struct {
    selected: []const bool,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad = struct {
    including: bool,
    index: u64,
    member: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    selected: []const bool,
};

pub const zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
};

pub const zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748 = struct {
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = struct {
    index: u64,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0 = struct {
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_b477c57147f352a34d7177c7f72bd05f673d2d9b856995d796cfe8cf9990e686 = struct { *const zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, };
pub const zx_type_7e16683d7c4a62c88a3a5f5dcffdde3f7b467499ebeb803dca73a06521f498ae = struct { *const zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, bool, };
pub const zx_type_bf85f7c57b449fce31196fc8205a19fc3233053c321d2307b6cd13f4b15ff758 = struct { *const zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, bool, *const zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, };
pub const zx_type_81219dff5dee8573a3e2b57b24788fa26917f7c6904ed3b6001d6c58a4b30599 = struct { *const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0, };
pub const zx_type_56397a194be5ff11fe20e5deb88e8063c5e5b93aabf80fdbb1e170a005905a24 = struct { *const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_4f27ad11a4102c8fb2b6c1ee0a1276d632d44afc665ae73d45a3e2bed1746a29 = struct { *const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_9557c19a29619a8aa8cc6c6c8f745b1d50ce32c26f5c223fc3c7f733a3a73fad = struct { *const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, []const bool, };
pub const zx_type_fbb6a6d1124ddc26cf5e1629375130f43e6cba3233726faa8e8be35dd94dfa32 = struct { *const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, []const bool, *const zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, };

pub const value_zx_type_cba597263faf9115e05af19ef297c6cc2ef940004dc17f97b9afe58ccb17ada9_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    delta: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    zx_origin: ?*const zx_type_cba597263faf9115e05af19ef297c6cc2ef940004dc17f97b9afe58ccb17ada9 = null,
};

pub const value_zx_type_9d3e204b74a8c5e80521eb8febbdd38a0289004a69fa46fcf8da9577fcaeadde_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_9d3e204b74a8c5e80521eb8febbdd38a0289004a69fa46fcf8da9577fcaeadde = null,
};

pub const value_zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5 = null,
};

pub const value_zx_type_c315671c1fb285cb114d660ef40697183d55b548f4804d5c11049ee4487611e6_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_7806445e39bc3ad667336ed0fc6527c9e8e36360713283ce07293fd7ba8c84b5_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_8343d61df47dc08799469d009fa54856f704296e89042b3b8056129cb40e08fd,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_c315671c1fb285cb114d660ef40697183d55b548f4804d5c11049ee4487611e6 = null,
};

pub const value_zx_type_adc5ff626ac9459c2d7000d4ac4980431e61d6d044a70ae3c8e1b079105ecf20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_adc5ff626ac9459c2d7000d4ac4980431e61d6d044a70ae3c8e1b079105ecf20 = null,
};

pub const value_zx_type_565a64859b4c2a1fcc18784c03a658f564f7d0d78b4981f55bb544c62bae6165_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    id: u32,
    zx_origin: ?*const zx_type_565a64859b4c2a1fcc18784c03a658f564f7d0d78b4981f55bb544c62bae6165 = null,
};

pub const value_zx_type_b6b91594b55119018ddc4b3a5a1720f4e554bfc25640fce9b25be4bbc27c4dd3_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    kind: u8,
    member: []const u8,
    owner: []const u8,
    zx_origin: ?*const zx_type_b6b91594b55119018ddc4b3a5a1720f4e554bfc25640fce9b25be4bbc27c4dd3 = null,
};

pub const value_zx_type_94b518448bb42b8b024501313e7eebbf3f07b4b037cec6a06d16b2ee5f0419a7_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    delta: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    zx_origin: ?*const zx_type_94b518448bb42b8b024501313e7eebbf3f07b4b037cec6a06d16b2ee5f0419a7 = null,
};

pub const value_zx_type_aa061941ed6cd345ccb740c64e2a01599ac7186c71f84ce8d2cd6ac8200f98b1_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    id: u32,
    status: zx_type_3aa7375d2c3e603569cf2c724bec998fac3c23f969d69c0189cdc4b4305ff560,
    zx_origin: ?*const zx_type_aa061941ed6cd345ccb740c64e2a01599ac7186c71f84ce8d2cd6ac8200f98b1 = null,
};

pub const value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    roots: []const bool,
    scalar_count: u64,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    zx_origin: ?*const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77 = null,
};

pub const value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    ids: []const u64,
    ready: []const bool,
    zx_origin: ?*const zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac = null,
};

pub const value_zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    pending: value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    zx_origin: ?*const zx_type_0bb8cd176b4b340a14b635705c0216b51a272ac8e8474bd4b2cdf3c5b76d527a = null,
};

pub const value_zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u64, void, ?*const zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc, };
pub const value_zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651, };

pub const value_zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814_c5a2300cf5307649bd7a97bf709d5bc11bac4cc46c28151b6352040a077a30d5 = struct {
    first: u64,
    pending: value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    remaining: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_386da26c19cd3af21fa6311b4d568e09dd14f69d92abe1dc5618cb77b93c4814 = null,
};

pub const value_zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    zx_origin: ?*const zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae = null,
};

pub const value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    id: u64,
    index: u64,
    name: []const u8,
    names: []const []const u8,
    origins: *const zx_type_e6565d325e5a6718dd4a61e83128595de1597de5475e80c852f96194a25cc81a,
    result: u64,
    valid: bool,
    zx_origin: ?*const zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a = null,
};

pub const value_zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    index: u64,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3 = null,
};

pub const value_zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef_548d03a1c937aa175a4ae6dc65848134fd43039f0f2deb8397102cde1a357280 = struct {
    pending: value_zx_type_aeeb2c91423013a52741b012b6b6becacbb4903ab7109cb50008962026d383ac_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_62262566e719148b8ea78f3aaad3b2415b91181b684d4fc8b80f20b255328eef = null,
};

pub const value_zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const u64, ?u64, ?*const zx_type_3f0e8cb2524785c7f65f993bacdb7710e25e484679c330dbb2ae5d8aba4e77c4, };
pub const value_zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148_344581c368434156cd88cf3641a6cfe630cd1d8ac42f32876816bef0967e7754 = struct { []const bool, ?bool, ?*const zx_type_7223ab0e97bdc00daaf20445f7a25396153358293956374b9429c41a2a0b5148, };

pub const value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    identities: []const ?[]const u8,
    import_names: []const []const u8,
    specifiers: []const []const u8,
    type_ids: []const []const u32,
    type_names: []const []const []const u8,
    type_namespaces: []const []const []const u8,
    zx_origin: ?*const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960 = null,
};

pub const value_zx_type_372da7c089c93fe6e642fa5da638cdcf3ff4918df5659a9290a0f95ae4c5db2d_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    input_types: []const u32,
    native_concurrent: []const bool,
    native_errors: []const ?[]const []const u8,
    native_exports: []const ?[]const u8,
    native_fallible: []const bool,
    native_members: []const []const []const u8,
    native_modules: []const ?u32,
    output_types: []const u32,
    zx_origin: ?*const zx_type_372da7c089c93fe6e642fa5da638cdcf3ff4918df5659a9290a0f95ae4c5db2d = null,
};

pub const value_zx_type_ea1c3f5524fc6ccb66205dc4f3fcbcb9ae473dc988ad096232ad81fd3ccf294d_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    table: *const zx_type_a92ac60b6f02144e9a317c9cecfc133596400d0598775e3a9a8a5f3f67c5af0f,
    zx_origin: ?*const zx_type_ea1c3f5524fc6ccb66205dc4f3fcbcb9ae473dc988ad096232ad81fd3ccf294d = null,
};

pub const value_zx_type_96eb926f4119f5d93da4266ffde63d658ebc0836b9608e39f968fff3000dc50e_1dad68e6b0d0122b1476653abf673933ed027adc2ebd5fd855aec9b533a7b0ea = struct {
    functions: value_zx_type_372da7c089c93fe6e642fa5da638cdcf3ff4918df5659a9290a0f95ae4c5db2d_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b,
    index: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_96eb926f4119f5d93da4266ffde63d658ebc0836b9608e39f968fff3000dc50e = null,
};

pub const value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0 = struct {
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    selected: []const bool,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744 = null,
};

pub const value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    selected: []const bool,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e = null,
};

pub const value_zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad_59cc0b95c3352e6c8999d0d862710db065b5e69af4a6c29d87f309d8509902dd = struct {
    including: bool,
    index: u64,
    member: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    selected: []const bool,
    zx_origin: ?*const zx_type_64ab619e51882c0f9ca86b840828a8c77d0180879771d9e51b9be9e30e2005ad = null,
};

pub const value_zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3 = null,
};

pub const value_zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    mapping: []const u64,
    order: []const u32,
    scalar_count: u64,
    zx_origin: ?*const zx_type_70da11292a655aa1cbad9cf6c7a7bad4d1e1a5d052256cf0484e16ab4ea5cc2c = null,
};

pub const value_zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748_9102c782dc8c0eb3c4baee9f5b2d3320448d90aaddd79e535802fef289774189 = struct {
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_657ae129b406842c26b946d7db7bf0dd32100952e4c0e9c8b4389b284edfe748 = null,
};

pub const value_zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28_e31035308a5386ac6027517d84ca7992d1d22dc27407e4e23f1c47cf8666bd31 = struct {
    index: u64,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_762b07d0c928a3b050608eb4b3d96b01204b53f4937704dece544f5272d40a28 = null,
};

pub const value_zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990 = null,
};

pub const value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420 = struct {
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0 = null,
};

pub const value_zx_type_b477c57147f352a34d7177c7f72bd05f673d2d9b856995d796cfe8cf9990e686_dac9ba8687978d9ffb0eb052e3f6ae7d521e650e450750dbb67fdd4751cbc531 = struct { value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, ?*const zx_type_b477c57147f352a34d7177c7f72bd05f673d2d9b856995d796cfe8cf9990e686, };
pub const value_zx_type_7e16683d7c4a62c88a3a5f5dcffdde3f7b467499ebeb803dca73a06521f498ae_2285c4cde9fb0898f4554d4360971713477b056f9b9a04577986492b58877f5a = struct { value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, bool, ?*const zx_type_7e16683d7c4a62c88a3a5f5dcffdde3f7b467499ebeb803dca73a06521f498ae, };
pub const value_zx_type_bf85f7c57b449fce31196fc8205a19fc3233053c321d2307b6cd13f4b15ff758_7af08bfd7add2d7c9efd8ec9c0af55045720978afe3e10a67ef5aa69d9149d6a = struct { value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, bool, value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_bf85f7c57b449fce31196fc8205a19fc3233053c321d2307b6cd13f4b15ff758, };
pub const value_zx_type_81219dff5dee8573a3e2b57b24788fa26917f7c6904ed3b6001d6c58a4b30599_d793c03486993bd03513fd063427e911d2e1da19cd778de268e674560c322001 = struct { value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, ?*const zx_type_81219dff5dee8573a3e2b57b24788fa26917f7c6904ed3b6001d6c58a4b30599, };
pub const value_zx_type_56397a194be5ff11fe20e5deb88e8063c5e5b93aabf80fdbb1e170a005905a24_f0fa6b51541720230634bee8e095d5016a5c2df914f8741f5ea3ff22223d9297 = struct { value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_56397a194be5ff11fe20e5deb88e8063c5e5b93aabf80fdbb1e170a005905a24, };
pub const value_zx_type_4f27ad11a4102c8fb2b6c1ee0a1276d632d44afc665ae73d45a3e2bed1746a29_33767f0c35ae583a4e366333ab584bc92ee951eaaac4d2fb775642ad614a8152 = struct { value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_4f27ad11a4102c8fb2b6c1ee0a1276d632d44afc665ae73d45a3e2bed1746a29, };
pub const value_zx_type_9557c19a29619a8aa8cc6c6c8f745b1d50ce32c26f5c223fc3c7f733a3a73fad_204652f06f5fed163853ae5a5979b56274ba97129482411bba2c818e22cdaf2b = struct { value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, []const bool, ?*const zx_type_9557c19a29619a8aa8cc6c6c8f745b1d50ce32c26f5c223fc3c7f733a3a73fad, };
pub const value_zx_type_fbb6a6d1124ddc26cf5e1629375130f43e6cba3233726faa8e8be35dd94dfa32_3e9e95181de45f44227bec13aa232f6e6be6f9e34fc9fab4a480b972c32e8abe = struct { value_zx_type_6fddaa120775c1327c9f059473195a232f27bfbe31ecf1cc5c3e57039c6ccca0_e38fe9d22cc193e1fc9461302c4075ef410b144f5301e145aa2c687f89d11420, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, []const bool, value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_fbb6a6d1124ddc26cf5e1629375130f43e6cba3233726faa8e8be35dd94dfa32, };

pub const native = struct {
    pub const @"zig:integers" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const widenByte = struct {
            pub const Input = u8;
            pub const Output = u64;
            pub const InputValue = u8;
            pub const OutputValue = u64;
        };
        pub const narrow = struct {
            pub const Input = u64;
            pub const Output = u32;
            pub const InputValue = u64;
            pub const OutputValue = u32;
        };
    };
};

pub const layouts = struct {
    pub const @"zig:integers" = struct {
    };
};

