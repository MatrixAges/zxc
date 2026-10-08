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

pub const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = struct {
    inputs: []const u32,
    native_modules: []const ?u32,
    outputs: []const u32,
};

pub const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c = struct {
    ids: []const u32,
    inputs: []const u32,
    outputs: []const u32,
};

pub const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = struct {
    functions: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
};

pub const zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27 = struct {
    imports: *const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    signatures: *const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c,
};

pub const zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = struct {
    index: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    signatures: *const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c,
};

pub const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a = struct {
    imports: *const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    signatures: *const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c,
};

pub const zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = struct {
    imports: *const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c,
    index: u64,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    signatures: *const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c,
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

pub const zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce = struct {
    inputs: []const u32,
};

pub const zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
};

pub const zx_type_0676a418e02b6c2fd3247aed85d7a0fe6a155606d0d15b65f23e9e5be7bde8a2 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
};

pub const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7 = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    natives: *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    state: *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108,
    type_imports: []const u32,
};

pub const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8 = struct {
    dependencies: *const zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2,
    function_imports: *const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c,
    modules: *const zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960,
    request: *const zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77,
    signatures: *const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c,
    type_imports: []const u32,
};

pub const zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989 = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, };
pub const zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0 = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, bool, };
pub const zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a = struct { *const zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007 = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, };
pub const zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938 = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, bool, };
pub const zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a = struct { *const zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_3c01fa00694285db8981dab5207d0cf3a2e6637b612ecb982755ea28ee6a8f16 = struct { *const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, };
pub const zx_type_d212e146f61156d762df05751a6d86eec054f119eaae007ac8c565675c788a33 = struct { *const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, };
pub const zx_type_27edb23019357c3580473364636c3525c377ee7d6d75170d14267aa70b4a7df6 = struct { *const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, bool, };
pub const zx_type_955ed277826ff947465784dad6aafdccf33b535b7ffb606f4106ffb38b74d630 = struct { *const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, bool, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, };
pub const zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, };
pub const zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, };
pub const zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39 = struct { *const zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_6c0674545919fa55a6ac60a6e39569b80aced080046d4297dffbacba86befa98 = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, };
pub const zx_type_73b18113036b57d9f483ea99322bb3ee47de017957390e2cd8ea0ede83028b81 = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, };
pub const zx_type_168d6a5c2fadef5ea6a3641a086c2f83e5c73f2e6245fd9b00280e559806e112 = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_f8a064c8ba003d0ab25a4cb9f7504dc6bcc40ed3c439c1a168e6ebfb245d4c24 = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, };
pub const zx_type_ebde3537f92350f78e93e930708e581853d8f597282e25e1644e9fe5da8ba3a0 = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_4f8f73cc9273be122de9d964728b69b8f0ccb06e6889085698e48a893576391e = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, };
pub const zx_type_6d3672c70cf150254914f1b0656d8cff611a298199bf8ee15fd9f339b955401d = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, };
pub const zx_type_56e8251d0e61e9820b5b89a932f937955dc458eda3eee8e7cdeb6f66c8fa64cb = struct { *const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, };

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

pub const value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    inputs: []const u32,
    native_modules: []const ?u32,
    outputs: []const u32,
    zx_origin: ?*const zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c = null,
};

pub const value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    ids: []const u32,
    inputs: []const u32,
    outputs: []const u32,
    zx_origin: ?*const zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c = null,
};

pub const value_zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27_31a2a617a7f259541cad3eb5e55b88b3dd05fe2d30b0430d2baab53409fdc15d = struct {
    imports: value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    signatures: value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27 = null,
};

pub const value_zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517_3e086e4328ead747238fc4c842fdcae596d4014a170d2310c54262b0dec97fd7 = struct {
    index: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517 = null,
};

pub const value_zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77 = struct {
    imports: value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a = null,
};

pub const value_zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba_c2d79b4fed05fec307011b3dcc024c5f8a10e6715d4b7eb82c924ff237bb930c = struct {
    imports: value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    index: u64,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    plan: *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    zx_origin: ?*const zx_type_472473126f0dd617ef846d20f1152305bee9875f0d3b1f059626e1bc5b9b97ba = null,
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

pub const value_zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    inputs: []const u32,
    zx_origin: ?*const zx_type_416f79136eee607a19982f85f28a70b44d6a7ffe30434c34cf222155938091ce = null,
};

pub const value_zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
    zx_origin: ?*const zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = null,
};

pub const value_zx_type_0676a418e02b6c2fd3247aed85d7a0fe6a155606d0d15b65f23e9e5be7bde8a2_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const u32,
    source: []const u32,
    zx_origin: ?*const zx_type_0676a418e02b6c2fd3247aed85d7a0fe6a155606d0d15b65f23e9e5be7bde8a2 = null,
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

pub const value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4 = struct {
    dependencies: value_zx_type_994165b4555bc47041955e3e592360c466f45e9cc4b2e297af0135f7212b3fd2_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    function_imports: value_zx_type_531250c5013b3773a3603bc2eb688d72b084b6fc564cd2e35302be22d6c0ac1c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    modules: value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    request: value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701,
    signatures: value_zx_type_87cd045f993c23529708cef5bb5aae69266c82d73f40f31ac61780e1c43a609c_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    type_imports: []const u32,
    zx_origin: ?*const zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8 = null,
};

pub const value_zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989_6d9e1750b9dc48c0938aa2ac30bab75b173d85436f941cb6b1e6a70893b3b46a = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, ?*const zx_type_22343c787dcb07b6d6417c0dddc95726eeedae1bcd414fbd35c9e8db99738989, };
pub const value_zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0_47fda4d3f05483967cdab92aa39f1b1a8a628d748940a28659fde352c6b33168 = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, ?*const zx_type_87cd39eb37586ca7f2105b11fb4bcbccf72230319adeda885c4d4b8daf2831c0, };
pub const value_zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a_f65b384d705929099a04ca81a260f41b0833337a4c4982b958cbd0bbc226ca1a = struct { value_zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a_99824312652db8a0a87f76a6cc2f4e3087c0dde301b873c8853f30b7efea85bd, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_3ab55bb7f3b99b84e0b42f78103582559c5524e0bf5e6cdbca45fcae3740177a, };
pub const value_zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007_ba7117c8189198b145774a1deb80e8c00c3b3955ad3770683638b4c34cd56d85 = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, ?*const zx_type_a3e3792f648ba0c695c48f554065a071f9f86bb824a588fecb729af749916007, };
pub const value_zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938_b4bdce0c22ba9fcd21b035f595a1e6ff422801720f1e9dbb9052ede6e014123e = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, ?*const zx_type_ba2119772e8827f2d7737ca871eeba906902c69b385376526132bb4290cca938, };
pub const value_zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a_bcc77718ef8753ce2292cc1cfc53c0bc5181c8ace3e3d831b55abd3283313abf = struct { value_zx_type_235d340324e1c77936dadf45f17aab2b6d0a936c3d15126c73102843f3b98f14_2dfc722cd996da326c23caa11499f306caf6a0136c02475bf8741284f0595319, bool, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_37c2bccb6af6bda920b8a61f3d2116b26326659b42ca97a5df8ef40e6c9efb7a, };
pub const value_zx_type_3c01fa00694285db8981dab5207d0cf3a2e6637b612ecb982755ea28ee6a8f16_2682cedb643d4921b472cd8ebcd27a7fcee8c27053a5b8da474fef72311ce312 = struct { value_zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, ?*const zx_type_3c01fa00694285db8981dab5207d0cf3a2e6637b612ecb982755ea28ee6a8f16, };
pub const value_zx_type_d212e146f61156d762df05751a6d86eec054f119eaae007ac8c565675c788a33_c1053b537205caa78f705636bd0b6d46385c930e3dcd229220ae7b4cf28c678c = struct { value_zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, ?*const zx_type_d212e146f61156d762df05751a6d86eec054f119eaae007ac8c565675c788a33, };
pub const value_zx_type_27edb23019357c3580473364636c3525c377ee7d6d75170d14267aa70b4a7df6_cd624e99c1c7fdf5d63e6e5fc52c80f8a1ce1ef0a9db9dde81696b1cf14bd590 = struct { value_zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, bool, ?*const zx_type_27edb23019357c3580473364636c3525c377ee7d6d75170d14267aa70b4a7df6, };
pub const value_zx_type_955ed277826ff947465784dad6aafdccf33b535b7ffb606f4106ffb38b74d630_a10943e2c45184fc503e34a2f575567115f10674db8e3aac1ea46cfaa3228089 = struct { value_zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a_cb5c56e7ac223e5d769df3f41fffc150e43b2cfd78bab6c78615af8de4242b77, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, bool, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, ?*const zx_type_955ed277826ff947465784dad6aafdccf33b535b7ffb606f4106ffb38b74d630, };
pub const value_zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4_2453b88f9ff0f058cf67f3e2aae4b57b1f792f4aa4bc8106ea9423849dc5da26 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, ?*const zx_type_2862c79ef898a7fcded31574022f1dafa90c15a66857ba37b2f2dfd8dd0068b4, };
pub const value_zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52_80056fe358733769c185dbbb4338a2e514aa1d61e1d5a42da77a4fc33ee43ea0 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, ?*const zx_type_4589a112e2bc37df1d1c0a27ebc3b54a30190aaa7065dddd354929ec552bdc52, };
pub const value_zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36_f2331b184dede23b05aaaed7691fef17c09f05dda3b0cf700a00d066d31fe693 = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_4ace1e06ae015e31d11664299ef7e6bfe37d4ce4b7f26645278d4b4a2ad94d36, };
pub const value_zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39_aec30df4a6153f7fd1820ce13f1852801e3a92d905e0b06996038115c38ad70b = struct { value_zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7_dc75918ddf8a8d0927112f1de7a1d16a96b9b14304b0dbfd9f85322043cb98f1, bool, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_c9ca3f595f8e4474c9fb080d821490bd4e3cc4b6d23e0ec2b420fe9c5fc5be39, };
pub const value_zx_type_6c0674545919fa55a6ac60a6e39569b80aced080046d4297dffbacba86befa98_1529af9371ba522b576cd37653d0ebf6ce58d694b97ef1712f18b581d52cfe7b = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, ?*const zx_type_6c0674545919fa55a6ac60a6e39569b80aced080046d4297dffbacba86befa98, };
pub const value_zx_type_73b18113036b57d9f483ea99322bb3ee47de017957390e2cd8ea0ede83028b81_6c27cf42060f86f038a84b808aa72e941dc14d0fa441094472b0d87496dc6fad = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, ?*const zx_type_73b18113036b57d9f483ea99322bb3ee47de017957390e2cd8ea0ede83028b81, };
pub const value_zx_type_168d6a5c2fadef5ea6a3641a086c2f83e5c73f2e6245fd9b00280e559806e112_cec7910b5923aa6cf291abf7c4f89cd27ee5770968cd46d62e1ec46593435364 = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_168d6a5c2fadef5ea6a3641a086c2f83e5c73f2e6245fd9b00280e559806e112, };
pub const value_zx_type_f8a064c8ba003d0ab25a4cb9f7504dc6bcc40ed3c439c1a168e6ebfb245d4c24_5369a22f6ea316cc94ece3afc064f7ba7c6cfdd267121a4df591f8bf80749a7f = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, ?*const zx_type_f8a064c8ba003d0ab25a4cb9f7504dc6bcc40ed3c439c1a168e6ebfb245d4c24, };
pub const value_zx_type_ebde3537f92350f78e93e930708e581853d8f597282e25e1644e9fe5da8ba3a0_9f02de83a025d33c1b17ca82eb27e0f65f1cc5f50e734fbef35fdf37d2a475f4 = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_ebde3537f92350f78e93e930708e581853d8f597282e25e1644e9fe5da8ba3a0, };
pub const value_zx_type_4f8f73cc9273be122de9d964728b69b8f0ccb06e6889085698e48a893576391e_d389aaf94842ee6fce1b915722f134d796d29f0c829621b52ac524d5cc138ca5 = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, ?*const zx_type_4f8f73cc9273be122de9d964728b69b8f0ccb06e6889085698e48a893576391e, };
pub const value_zx_type_6d3672c70cf150254914f1b0656d8cff611a298199bf8ee15fd9f339b955401d_4d532ff75d71bdd009eaea2aad366fccf531762fc1436da20f87e39a079ecf03 = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, ?*const zx_type_6d3672c70cf150254914f1b0656d8cff611a298199bf8ee15fd9f339b955401d, };
pub const value_zx_type_56e8251d0e61e9820b5b89a932f937955dc458eda3eee8e7cdeb6f66c8fa64cb_4156b17414b3df07a073d3eb72552530fc37cdd7c58885ee7815d8480d260778 = struct { value_zx_type_8b4564f003472215677dc8a8e43f8dbb22563c7e24173fe296a65fc2b9dedec8_9c5f9422c41361412f92a98d16684fc70ef4d125230b31e2eccc208985b3c2a4, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, *const zx_type_dd5f5c77e4b08910450d9082a71388d41cdb69ecb59ec09f3f4cdb425cff4add, *const zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, ?*const zx_type_56e8251d0e61e9820b5b89a932f937955dc458eda3eee8e7cdeb6f66c8fa64cb, };

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

