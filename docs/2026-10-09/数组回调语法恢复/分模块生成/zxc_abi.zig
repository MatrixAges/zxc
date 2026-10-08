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

pub const zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c = struct {
    index: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
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

pub const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
};

pub const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2 = struct {
    is_native: []const bool,
    keys: []const []const u8,
};

pub const zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = struct {
    index: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = struct {
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    values: []const u32,
};

pub const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    found: bool,
    index: u64,
    module: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14 = struct {
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = struct {
    index: u64,
    member: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e = struct {
    ids: []const u32,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
};

pub const zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990 = struct {
    specifiers: []const []const u8,
};

pub const zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
};

pub const zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
};

pub const zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d = struct { []const u32, void, };

pub const zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3 = struct {
    kinds: []const u8,
    scalar_count: u64,
};

pub const zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
};

pub const zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
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

pub const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7 = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    type_imports: []const u32,
};

pub const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9 = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    type_imports: []const u32,
};

pub const zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989 = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, };
pub const zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0 = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, bool, };
pub const zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007 = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, };
pub const zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938 = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, bool, };
pub const zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, };
pub const zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, };
pub const zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_6ef70ff7358bddd7efece45d3d07e487e5944cea9506ed9dbebe477f175c6499 = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, };
pub const zx_type_d72497ed6c5bef4f5977b2877506bdb615f456941f058d07d0f5063cde1c46e7 = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, };
pub const zx_type_c22baa861c128ddc5b8d4d4a9a7f541930e246b3acb9e89667c1fd93655cc92b = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_c64c85b640c5d02f91f53700277cc6d1128242e9d7a8c05bc62b66b29675ef03 = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_072748f3cd4f164506ea5bbbfa298100296dd7879874c08957c9bb2b01968380 = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_c8e001f8013bd1b16e3e2c81c60e73ae09ecb11270f35bd1c1e1b1bb79c51440 = struct { *const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };

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

pub const value_zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c_68bebc01d99f6879dc43b8e7adb1a3f45ef4366c6f107510d452df8f6f575699 = struct {
    index: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c = null,
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

pub const value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    is_native: []const bool,
    keys: []const []const u8,
    zx_origin: ?*const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2 = null,
};

pub const value_zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67_6ad9b404c32acbbcf3ad3cc7752216d5550925c0c668cb46ed3996988e1b3d06 = struct {
    index: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67 = null,
};

pub const value_zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc_a558a11402cfe5a0c484e729ede41e136467821e3934aabc12476f3c1476f10f = struct {
    index: u64,
    member: u64,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    values: []const u32,
    zx_origin: ?*const zx_type_567e5247c4770baec29f080330fddf95c9e96aa748d9fdcfe5ead5a8258a91bc = null,
};

pub const value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd = struct {
    dependencies: value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a = null,
};

pub const value_zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356_78b5c756a603a336ba922f8d4ff6937ccd54f84e6c5b04bf1341824a08ceae4e = struct {
    dependencies: value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    found: bool,
    index: u64,
    module: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_ae88b2e1ff76ed22e09a51f68d8af2e15ee090cea2b4a67a6250fafec196f356 = null,
};

pub const value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319 = struct {
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14 = null,
};

pub const value_zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a_7cbafe97ab71b1857d9aef19ca8aee272240e74697afa4adda9895075b08fee3 = struct {
    index: u64,
    member: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_3c9e054bdf5edfba84361cf563ef1c91fe1cf1cd159c709e6b9b2eb872148d2a = null,
};

pub const value_zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e_4189088ef2050b9e5b16bc193b19a39cb02cc932c1e90ab4d4b2a647322cdcf0 = struct {
    ids: []const u32,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    zx_origin: ?*const zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e = null,
};

pub const value_zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535_a8f66867e355cc8bc8bdab2bbded7eed1be9fbc3bff8da2db47e8a55427c51ef = struct {
    ids: []const u32,
    index: u64,
    plan: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    zx_origin: ?*const zx_type_1e0a7abefd14d69473ff8d9faf44097140d8d9b956d3ed629e688cc75cd74535 = null,
};

pub const value_zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    specifiers: []const []const u8,
    zx_origin: ?*const zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990 = null,
};

pub const value_zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const []const u8,
    zx_origin: ?*const zx_type_254f60de0df197958d290a984f3584fb549aac1a2b6ea91056f38267b495720e = null,
};

pub const value_zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const []const u8,
    zx_origin: ?*const zx_type_556fe8b6c6679905fcc46d8726dbe795a0f0f08dcc0ecb520285f64c3deae27e = null,
};

pub const value_zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d, };

pub const value_zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    kinds: []const u8,
    scalar_count: u64,
    zx_origin: ?*const zx_type_ab5c86f134be73cfc2195fb3f31f9284acacf6547829f0ee60d03145b0aa89c3 = null,
};

pub const value_zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u8,
    zx_origin: ?*const zx_type_ca7264f620b5afbd1c041301adccc5e110d4b14302f9e3025ab783dbb3456d8a = null,
};

pub const value_zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u8,
    zx_origin: ?*const zx_type_1dd03a3b7e64676bc60fad2035c76d7ce6957e03d50685240444f187c5fa5f3f = null,
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

pub const value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1 = struct {
    dependencies: value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7 = null,
};

pub const value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c = struct {
    dependencies: value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9 = null,
};

pub const value_zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989_6d9e1750b9dc48c0938aa2ac30bab75b173d85436f941cb6b1e6a70893b3b46a = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, ?*const zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989, };
pub const value_zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0_47fda4d3f05483967cdab92aa39f1b1a8a628d748940a28659fde352c6b33168 = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, ?*const zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0, };
pub const value_zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a_f65b384d705929099a04ca81a260f41b0833337a4c4982b958cbd0bbc226ca1a = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a, };
pub const value_zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007_ba7117c8189198b145774a1deb80e8c00c3b3955ad3770683638b4c34cd56d85 = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, ?*const zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007, };
pub const value_zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938_b4bdce0c22ba9fcd21b035f595a1e6ff422801720f1e9dbb9052ede6e014123e = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, ?*const zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938, };
pub const value_zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a_bcc77718ef8753ce2292cc1cfc53c0bc5181c8ace3e3d831b55abd3283313abf = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a, };
pub const value_zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4_2453b88f9ff0f058cf67f3e2aae4b57b1f792f4aa4bc8106ea9423849dc5da26 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, ?*const zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4, };
pub const value_zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52_80056fe358733769c185dbbb4338a2e514aa1d61e1d5a42da77a4fc33ee43ea0 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, ?*const zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52, };
pub const value_zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36_f2331b184dede23b05aaaed7691fef17c09f05dda3b0cf700a00d066d31fe693 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36, };
pub const value_zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39_aec30df4a6153f7fd1820ce13f1852801e3a92d905e0b06996038115c38ad70b = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39, };
pub const value_zx_type_6ef70ff7358bddd7efece45d3d07e487e5944cea9506ed9dbebe477f175c6499_650a06221519b1c0a8bfe7eeff05c4ec68a5b359688c9b8eaa164cb686cb4a09 = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, ?*const zx_type_6ef70ff7358bddd7efece45d3d07e487e5944cea9506ed9dbebe477f175c6499, };
pub const value_zx_type_d72497ed6c5bef4f5977b2877506bdb615f456941f058d07d0f5063cde1c46e7_384a0312826a4390b187be87aa813ba021080bcb4e6a51025feee70a229d6b96 = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, ?*const zx_type_d72497ed6c5bef4f5977b2877506bdb615f456941f058d07d0f5063cde1c46e7, };
pub const value_zx_type_c22baa861c128ddc5b8d4d4a9a7f541930e246b3acb9e89667c1fd93655cc92b_b42e7e8ebd73bbbb5f4dca636519f09a1e235eb6744d84d7515a46b83718007b = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_c22baa861c128ddc5b8d4d4a9a7f541930e246b3acb9e89667c1fd93655cc92b, };
pub const value_zx_type_c64c85b640c5d02f91f53700277cc6d1128242e9d7a8c05bc62b66b29675ef03_36c50fa60bcec728ddc8218a863082832789cf39f23fa7cbcb1190b530106ffe = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_c64c85b640c5d02f91f53700277cc6d1128242e9d7a8c05bc62b66b29675ef03, };
pub const value_zx_type_072748f3cd4f164506ea5bbbfa298100296dd7879874c08957c9bb2b01968380_e3a8209e2e11b2669766ea7f885de8bfc8af2dda92cb45f3e161bde7effb80d3 = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_072748f3cd4f164506ea5bbbfa298100296dd7879874c08957c9bb2b01968380, };
pub const value_zx_type_c8e001f8013bd1b16e3e2c81c60e73ae09ecb11270f35bd1c1e1b1bb79c51440_4f2bc43c2426ab210b256eb07bec1ecc5ae3f3917ae8f7660aef7516e4e0747a = struct { value_zx_type_3d30514734613f2a7ee85c27d113527a42be09b938c4a18f7958329d2ed08bd9_5bf22bad469f7dcbc760147071ecb5270113dd3bd58a889122673fd9ee78f01c, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_c8e001f8013bd1b16e3e2c81c60e73ae09ecb11270f35bd1c1e1b1bb79c51440, };

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

