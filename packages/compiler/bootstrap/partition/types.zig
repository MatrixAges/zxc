pub const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = struct {
    callees: []const []const u32,
    partitions: u32,
    roots: []const u32,
    sizes: []const u64,
};

pub const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 = struct {
    bytes: u64,
    index: u64,
    nodes: []const u32,
};

pub const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc = struct {
    bytes: []const u64,
    members: []const []const u32,
    owners: []const u64,
    used: []const []const bool,
};

pub const zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959 = struct {
    members: []const []const u32,
    owners: []const u64,
};

pub const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9 = struct {
    u64,
    u64,
};

pub const zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96 = struct {
    bytes: []const u64,
    capacity: u64,
    nodes: []const u32,
    used: []const []const bool,
    weights: []const u64,
};

pub const zx_type_284e9609f048619fd85acbbbd0a412feaf0f4b589cc640a258198e31ad6206de = struct {
    bytes: u64,
    members: []const u32,
    nodes: []const u32,
    used: []const bool,
    weights: []const u64,
};

pub const zx_type_be13154ab886b9e37fe0590606f43ddb042c5c0198a6335da65415338084d212 = struct {
    bytes: u64,
    members: []const u32,
    used: []const bool,
};

pub const zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04 = struct {
    graph: *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    index: u64,
};

pub const zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5 = struct {
    closures: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    graph: *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
};

pub const zx_type_14eb8c8832581050968abcb99e59b3595b37649f18a65e7db83bb8709cbb5928 = struct {
    capacity: u64,
    closures: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    groups: *const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc,
    weights: []const u64,
};

pub const zx_type_4ae9c38e491a5e74a082a4101b123b1edfcec9d56ea3305e1058b3e072eb1285 = struct {
    bytes: u64,
    cost: u64,
    index: u64,
    owner: u64,
};

pub const zx_type_12cf3c6ad4c46e78004e40a2f55bc563bcc100385920a29771cad0d441115bc4 = struct {
    bytes: u64,
    index: u64,
};

pub const zx_type_d78426142cc2123d6c538a517f0fc01e6508e8ccb4f4fc3251cd8e2f3727631c = struct {
    *const zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96,
    []const bool,
};

pub const zx_type_c6cbeeab456960e99a74f7dee8d9ae86c11e0041746706c1c5a7dcc46792f505 = struct {
    bytes: u64,
    index: u64,
    members: []const u32,
    used: []const bool,
};

pub const zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d = struct {
    []const u32,
    void,
};

pub const zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = struct {
    index: u64,
    result: []const bool,
    source: []const u64,
};

pub const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651 = struct {
    []const bool,
    void,
};

pub const zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce = struct {
    bytes: u64,
    head: u64,
    nodes: []const u32,
    pending: []const u32,
    seen: []const bool,
};

pub const zx_type_f92425d7c6883329dd70fe67bc4bc5bdd0e1d6c345720df8de48d4de7f199f6c = struct {
    index: u64,
    values: []const u32,
};

pub const zx_type_059ffc337beac9bfb2706c9b52ad2cb2dff0487b6ba2d7202324dd34e4060f8b = struct {};

pub const zx_type_d28fe3064e2fdd72452506f920bf877de2f90791750c1a0eb9e337bfbaebc47a = struct {
    bytes: u64,
    index: u64,
    seen: []const bool,
};

pub const zx_type_1464de3a4e7513afe9cec5d820efa15364b5c2722ecdb2a2cb224387f44ecc78 = struct {
    bytes: u64,
    seen: []const bool,
};

pub const zx_type_7a009bf46e6511484c9185707c767a5e830eac2fb0c5f96ecb002e443fe1fc46 = struct {
    []const u32,
    *const zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5,
};

pub const zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
};

pub const zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc = struct {
    []const u64,
    void,
};

pub const zx_type_5beece3d7f74e97fbe805db3c97fb32d8ce42de542035ed950f17cbbdc33c73c = struct {
    bytes: []const u64,
    index: u64,
    members: []const []const u32,
    owners: []const u64,
    used: []const []const bool,
};

pub const zx_type_636ed0fd0ba630f2fdefb60f0fbdd78b89fe976ef68915f289bb575f89e0c8cf = struct {
    []const []const bool,
    void,
};

pub const zx_type_4ea0e7446315749598d29ee985e000c345894e6006eddda9237674d920279eb5 = struct {
    []const []const u32,
    void,
};

pub const zx_type_6db421537286f237e4817c2618608f5b9d693591cc90ea22476ebc9ef48e4c83 = struct {
    u64,
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const u32,
};

pub const zx_type_f8b7e47bdbb914e6c9070872dcfca43c89ff92be046c3fc0454d36a5f381d131 = struct {
    groups: *const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc,
    index: u64,
};

pub const zx_type_393365db78446a73641da6f33a7fa157ac20969eca56ef7b6dfd63bc5d18de32 = struct {
    index: u64,
    values: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
};

pub const zx_type_78368e947218a37280a9ca8a41987ee4169f6d9f28d92e221f565bf96932270d = struct {
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    void,
};

pub const zx_type_257bbf6edf90c8e149ed37bc5452758e9e1d7df173b612e21b9e2e95a864690b = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
};

pub const zx_type_6fbf3bb6a6db5654e0c502906237f167da04800469cf884d44f7654e6a714ad6 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
};

pub const zx_type_3d76a4d73be10d02d61b1f927dfba473a50638bb4c5031a9bb0d734982338178 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
};

pub const zx_type_46dcdc92e9b03b322b98ff02baaad7d251e3cc6d526cc52841f7c9e6633ca672 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
};

pub const zx_type_b5026b5c51ee50dcf7cbbe861870e1d1f278d212d59412f2ab236b7560e4ac2c = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
    *const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc,
};

pub const zx_type_9db89ada2f4a902401ca5a414cda265108cb7b9d5bd50fe0724459f148297331 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
    *const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc,
    *const zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959,
};

pub const value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = struct {
    items: []const u32,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397 = struct {
    items: []const []const u32,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = struct {
    items: []const u64,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = struct {
    items: []const bool,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82 = struct {
    items: []const []const bool,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602 = struct {
    bytes: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    members: value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397,
    owners: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    used: value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82,
    zx_origin: ?*const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc = null,
};

pub const view_value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602 = struct {
    bytes: []const u64,
    members: []const []const u32,
    owners: []const u64,
    used: []const []const bool,
    zx_origin: ?*const zx_type_47feb2062b3514e75ba6cb33d0d9fd74f95c49c67cb393a20bfbbd967d53bffc = null,
};

pub const value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 = struct {
    members: value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397,
    owners: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    zx_origin: ?*const zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959 = null,
};

pub const view_value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 = struct {
    members: []const []const u32,
    owners: []const u64,
    zx_origin: ?*const zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959 = null,
};

pub const value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = struct {
    bytes: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    capacity: u64,
    nodes: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    used: value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82,
    weights: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    zx_origin: ?*const zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96 = null,
};

pub const view_value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134 = struct {
    bytes: []const u64,
    capacity: u64,
    nodes: []const u32,
    used: []const []const bool,
    weights: []const u64,
    zx_origin: ?*const zx_type_3ab2faf22b048a5f41cf1966fcf06d5b75d0467f9a399b040a5e881a76dbcc96 = null,
};

pub const value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = struct {
    bytes: u64,
    members: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    nodes: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    used: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    weights: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    zx_origin: ?*const zx_type_284e9609f048619fd85acbbbd0a412feaf0f4b589cc640a258198e31ad6206de = null,
};

pub const view_value_1cd714884cbefca33e1ca2db8f208cb32a450586abad8bc091732d891147361f = struct {
    bytes: u64,
    members: []const u32,
    nodes: []const u32,
    used: []const bool,
    weights: []const u64,
    zx_origin: ?*const zx_type_284e9609f048619fd85acbbbd0a412feaf0f4b589cc640a258198e31ad6206de = null,
};

pub const value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec = struct {
    bytes: u64,
    members: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    used: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    zx_origin: ?*const zx_type_be13154ab886b9e37fe0590606f43ddb042c5c0198a6335da65415338084d212 = null,
};

pub const view_value_48fbcce6967d7e256722fe31d1bd9ffb41523061584949ef50f1aadb1e00c6ec = struct {
    bytes: u64,
    members: []const u32,
    used: []const bool,
    zx_origin: ?*const zx_type_be13154ab886b9e37fe0590606f43ddb042c5c0198a6335da65415338084d212 = null,
};

pub const value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = struct {
    graph: *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    index: u64,
    zx_origin: ?*const zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04 = null,
};

pub const view_value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670 = value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670;

pub const value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = struct {
    items: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = struct {
    closures: value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    graph: *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    zx_origin: ?*const zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5 = null,
};

pub const view_value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015 = struct {
    closures: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    graph: *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    zx_origin: ?*const zx_type_88caf5f375b798af3825ffee7fccece78cb7d9d09bf019812fce5941dc54a9b5 = null,
};

pub const value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = struct {
    capacity: u64,
    closures: value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    groups: value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    weights: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    zx_origin: ?*const zx_type_14eb8c8832581050968abcb99e59b3595b37649f18a65e7db83bb8709cbb5928 = null,
};

pub const view_value_bed918aed054c9ed3f71729717ed0d2a2e3f722bbc913cecd312e92e9bf7e447 = struct {
    capacity: u64,
    closures: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    groups: view_value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    weights: []const u64,
    zx_origin: ?*const zx_type_14eb8c8832581050968abcb99e59b3595b37649f18a65e7db83bb8709cbb5928 = null,
};

pub const value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = struct {
    bytes: u64,
    cost: u64,
    index: u64,
    owner: u64,
    zx_origin: ?*const zx_type_4ae9c38e491a5e74a082a4101b123b1edfcec9d56ea3305e1058b3e072eb1285 = null,
};

pub const view_value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f = value_6bc5056830ac0e90c901751d75786745607fbfb29e202b8385b13aa95fc5675f;

pub const value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = struct {
    bytes: u64,
    index: u64,
    zx_origin: ?*const zx_type_12cf3c6ad4c46e78004e40a2f55bc563bcc100385920a29771cad0d441115bc4 = null,
};

pub const view_value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306 = value_0adaed0099fe86eb72a3e9576a2a319a101d28d79e9a699b62876c8e62533306;

pub const value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705 = struct {
    value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134,
    value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    ?*const zx_type_d78426142cc2123d6c538a517f0fc01e6508e8ccb4f4fc3251cd8e2f3727631c,
};

pub const view_value_16a0e6cc088ecaf6ff50e765bd1cac7b217733cfa9cf86fab53e535df4cea705 = struct {
    view_value_d258433300e7de70500c5c8fc47e8737c1c5bd38677f5f234afa5b28cdaec134,
    []const bool,
    ?*const zx_type_d78426142cc2123d6c538a517f0fc01e6508e8ccb4f4fc3251cd8e2f3727631c,
};

pub const value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = struct {
    bytes: u64,
    index: u64,
    members: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    used: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    zx_origin: ?*const zx_type_c6cbeeab456960e99a74f7dee8d9ae86c11e0041746706c1c5a7dcc46792f505 = null,
};

pub const view_value_d88ec01b1ed7292e96db3f829967713427955864a3530a80059644decf10eab7 = struct {
    bytes: u64,
    index: u64,
    members: []const u32,
    used: []const bool,
    zx_origin: ?*const zx_type_c6cbeeab456960e99a74f7dee8d9ae86c11e0041746706c1c5a7dcc46792f505 = null,
};

pub const value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb = struct {
    value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    void,
    ?*const zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d,
};

pub const view_value_3d83f3aef3243c4a187dc24f199667b9025833d928b2dbbdda28df7a7c2f4afb = struct {
    []const u32,
    void,
    ?*const zx_type_f1d287a749692d25ea6c57f24c74e61d215892c169173449ad3af6ec69aa557d,
};

pub const value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = struct {
    index: u64,
    result: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    source: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    zx_origin: ?*const zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
};

pub const view_value_d8aeefa442f86067bb8761b068b6a787b59f30800f1a65801e5b76ce7e2a779c = struct {
    index: u64,
    result: []const bool,
    source: []const u64,
    zx_origin: ?*const zx_type_d7a3c5c262cec0e2d10aabf8729d29a368bb1f24fad75e04ef755aa587f218f1 = null,
};

pub const value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0 = struct {
    value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    void,
    ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651,
};

pub const view_value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0 = struct {
    []const bool,
    void,
    ?*const zx_type_c12d2a08c98afd4d27338af0512960bd597d7e2b5955217439f123f17fdfe651,
};

pub const value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = struct {
    bytes: u64,
    head: u64,
    nodes: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    pending: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    seen: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    zx_origin: ?*const zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce = null,
};

pub const view_value_3a1ced1c09385e13bad823da28c8015739bb404b064b7db33c4d634443e996c1 = struct {
    bytes: u64,
    head: u64,
    nodes: []const u32,
    pending: []const u32,
    seen: []const bool,
    zx_origin: ?*const zx_type_7848ecdc206ddd756feab4308884da28ba4127a6e6400d73516a7b4c11f1d7ce = null,
};

pub const value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = struct {
    index: u64,
    values: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    zx_origin: ?*const zx_type_f92425d7c6883329dd70fe67bc4bc5bdd0e1d6c345720df8de48d4de7f199f6c = null,
};

pub const view_value_16d17c183016083ff7cb87f3f81ccac0d39e0ca330096687101f2f5d38721c22 = struct {
    index: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_f92425d7c6883329dd70fe67bc4bc5bdd0e1d6c345720df8de48d4de7f199f6c = null,
};

pub const value_f6cdf400d07a19f4fca1c983f529e0f79a3de8e2312ad4e71b1ed0a06e7cc388 = struct {
    ?*const zx_type_059ffc337beac9bfb2706c9b52ad2cb2dff0487b6ba2d7202324dd34e4060f8b,
};

pub const view_value_f6cdf400d07a19f4fca1c983f529e0f79a3de8e2312ad4e71b1ed0a06e7cc388 = value_f6cdf400d07a19f4fca1c983f529e0f79a3de8e2312ad4e71b1ed0a06e7cc388;

pub const value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = struct {
    bytes: u64,
    index: u64,
    seen: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    zx_origin: ?*const zx_type_d28fe3064e2fdd72452506f920bf877de2f90791750c1a0eb9e337bfbaebc47a = null,
};

pub const view_value_b84db68c4d5fc43dc19891b7301b97389273620ab2b0f55b4bce800629d7174f = struct {
    bytes: u64,
    index: u64,
    seen: []const bool,
    zx_origin: ?*const zx_type_d28fe3064e2fdd72452506f920bf877de2f90791750c1a0eb9e337bfbaebc47a = null,
};

pub const value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a = struct {
    bytes: u64,
    seen: value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
    zx_origin: ?*const zx_type_1464de3a4e7513afe9cec5d820efa15364b5c2722ecdb2a2cb224387f44ecc78 = null,
};

pub const view_value_0ab0c1fc0458cb4060a35430f7d2dad0d31df22bff54c55e6d645364d31a560a = struct {
    bytes: u64,
    seen: []const bool,
    zx_origin: ?*const zx_type_1464de3a4e7513afe9cec5d820efa15364b5c2722ecdb2a2cb224387f44ecc78 = null,
};

pub const value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b = struct {
    value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015,
    ?*const zx_type_7a009bf46e6511484c9185707c767a5e830eac2fb0c5f96ecb002e443fe1fc46,
};

pub const view_value_6ab6111e2c11ad41f33fa0fcc58d8cb39f48bcca20b04cf9f5e4aab5120b3c7b = struct {
    []const u32,
    view_value_0b9d76788d7cd6b65c77a85d6545e2213c36fb5edbac85725bcea9ce4dfc0015,
    ?*const zx_type_7a009bf46e6511484c9185707c767a5e830eac2fb0c5f96ecb002e443fe1fc46,
};

pub const value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1 = struct {
    index: u64,
    result: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    source: value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    zx_origin: ?*const zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = null,
};

pub const view_value_b1f628cc35727fee02d486d812aec67c6daf04150e7ea746cf5e2e6650009ce1 = struct {
    index: u64,
    result: []const u64,
    source: []const u32,
    zx_origin: ?*const zx_type_a370db56f140e705e4208d2583186c46de3c73169e1c0055a37e295337101ded = null,
};

pub const value_47cff92a9b46587c1b50630dc4fca58faeacd65edf899a985425b50990563280 = struct {
    value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    void,
    ?*const zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc,
};

pub const view_value_47cff92a9b46587c1b50630dc4fca58faeacd65edf899a985425b50990563280 = struct {
    []const u64,
    void,
    ?*const zx_type_a65ca64a5081ce73d932d5efbadd7371a7d5d6b792897c2e7113be9121cba7bc,
};

pub const value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = struct {
    bytes: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    index: u64,
    members: value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397,
    owners: value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e,
    used: value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82,
    zx_origin: ?*const zx_type_5beece3d7f74e97fbe805db3c97fb32d8ce42de542035ed950f17cbbdc33c73c = null,
};

pub const view_value_734c80617124a5fc0ae7d9b595da88f8b560b84f45d77996afaf2c74b77f8943 = struct {
    bytes: []const u64,
    index: u64,
    members: []const []const u32,
    owners: []const u64,
    used: []const []const bool,
    zx_origin: ?*const zx_type_5beece3d7f74e97fbe805db3c97fb32d8ce42de542035ed950f17cbbdc33c73c = null,
};

pub const value_d7bceb86a1d91974bdcf463ca8da12910084f072ba4f837b870c8bbbd765982e = struct {
    value_32074469ff0d4a12433201ddefdc885bbd90a876af0c5338c36866d82ae9ca82,
    void,
    ?*const zx_type_636ed0fd0ba630f2fdefb60f0fbdd78b89fe976ef68915f289bb575f89e0c8cf,
};

pub const view_value_d7bceb86a1d91974bdcf463ca8da12910084f072ba4f837b870c8bbbd765982e = struct {
    []const []const bool,
    void,
    ?*const zx_type_636ed0fd0ba630f2fdefb60f0fbdd78b89fe976ef68915f289bb575f89e0c8cf,
};

pub const value_b716869decc621a5e3ca152b1c4c05d948ca99a713f3252bcb7225f8b5858e08 = struct {
    value_b4e524448f2745cc406d7784dc5bc06bbfd18296034108aed7705d2c271c7397,
    void,
    ?*const zx_type_4ea0e7446315749598d29ee985e000c345894e6006eddda9237674d920279eb5,
};

pub const view_value_b716869decc621a5e3ca152b1c4c05d948ca99a713f3252bcb7225f8b5858e08 = struct {
    []const []const u32,
    void,
    ?*const zx_type_4ea0e7446315749598d29ee985e000c345894e6006eddda9237674d920279eb5,
};

pub const value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285 = struct {
    u64,
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
    ?*const zx_type_6db421537286f237e4817c2618608f5b9d693591cc90ea22476ebc9ef48e4c83,
};

pub const view_value_e7c8b9d0925e308790a511586f5ea6e05e0f94d89b32c65f6fde33c5b6282285 = struct {
    u64,
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const u32,
    ?*const zx_type_6db421537286f237e4817c2618608f5b9d693591cc90ea22476ebc9ef48e4c83,
};

pub const value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = struct {
    groups: value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    index: u64,
    zx_origin: ?*const zx_type_f8b7e47bdbb914e6c9070872dcfca43c89ff92be046c3fc0454d36a5f381d131 = null,
};

pub const view_value_a26b9c7097cd6435a7b45cabd1086f718dda66d6464231745339731ceca5ae8f = struct {
    groups: view_value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    index: u64,
    zx_origin: ?*const zx_type_f8b7e47bdbb914e6c9070872dcfca43c89ff92be046c3fc0454d36a5f381d131 = null,
};

pub const value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = struct {
    index: u64,
    values: value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    zx_origin: ?*const zx_type_393365db78446a73641da6f33a7fa157ac20969eca56ef7b6dfd63bc5d18de32 = null,
};

pub const view_value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = struct {
    index: u64,
    values: []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    zx_origin: ?*const zx_type_393365db78446a73641da6f33a7fa157ac20969eca56ef7b6dfd63bc5d18de32 = null,
};

pub const value_815ae0977cc108d3872b516d613b6f7677cf0c29ff030c881161032de451261c = struct {
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    void,
    ?*const zx_type_78368e947218a37280a9ca8a41987ee4169f6d9f28d92e221f565bf96932270d,
};

pub const view_value_815ae0977cc108d3872b516d613b6f7677cf0c29ff030c881161032de451261c = struct {
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    void,
    ?*const zx_type_78368e947218a37280a9ca8a41987ee4169f6d9f28d92e221f565bf96932270d,
};

pub const value_dadbb93389dff17e1b10e98c30a42837b00dc1da676dde828bf832d4733f5e84 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    ?*const zx_type_257bbf6edf90c8e149ed37bc5452758e9e1d7df173b612e21b9e2e95a864690b,
};

pub const view_value_dadbb93389dff17e1b10e98c30a42837b00dc1da676dde828bf832d4733f5e84 = value_dadbb93389dff17e1b10e98c30a42837b00dc1da676dde828bf832d4733f5e84;

pub const value_982e46388b6c7f8212701209648724a47a34588db847e90c7ff406d10f82fc14 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    ?*const zx_type_6fbf3bb6a6db5654e0c502906237f167da04800469cf884d44f7654e6a714ad6,
};

pub const view_value_982e46388b6c7f8212701209648724a47a34588db847e90c7ff406d10f82fc14 = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    ?*const zx_type_6fbf3bb6a6db5654e0c502906237f167da04800469cf884d44f7654e6a714ad6,
};

pub const value_07d7b8b053d5163ed4c448cb3ba03e63d0294276bd3dabdae713c5eb96cc9d1e = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    ?*const zx_type_3d76a4d73be10d02d61b1f927dfba473a50638bb4c5031a9bb0d734982338178,
};

pub const view_value_07d7b8b053d5163ed4c448cb3ba03e63d0294276bd3dabdae713c5eb96cc9d1e = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    ?*const zx_type_3d76a4d73be10d02d61b1f927dfba473a50638bb4c5031a9bb0d734982338178,
};

pub const value_0fe5bb85d6114a4a48d4f7bbc55be4d90ce03eaa202e2b6caed5e31b04bd3f2d = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    u64,
    ?*const zx_type_46dcdc92e9b03b322b98ff02baaad7d251e3cc6d526cc52841f7c9e6633ca672,
};

pub const view_value_0fe5bb85d6114a4a48d4f7bbc55be4d90ce03eaa202e2b6caed5e31b04bd3f2d = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
    ?*const zx_type_46dcdc92e9b03b322b98ff02baaad7d251e3cc6d526cc52841f7c9e6633ca672,
};

pub const value_58caf6bf4af7b18924bafb2344a1b8fa17bf2c5ef78df3266cdd86909262de4b = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    u64,
    value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    ?*const zx_type_b5026b5c51ee50dcf7cbbe861870e1d1f278d212d59412f2ab236b7560e4ac2c,
};

pub const view_value_58caf6bf4af7b18924bafb2344a1b8fa17bf2c5ef78df3266cdd86909262de4b = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
    view_value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    ?*const zx_type_b5026b5c51ee50dcf7cbbe861870e1d1f278d212d59412f2ab236b7560e4ac2c,
};

pub const value_e619efafac589e2e5d693b0fc6ef76e4f8cb7626a1d17f1aabadac3515b6c5ab = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4,
    u64,
    value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77,
    ?*const zx_type_9db89ada2f4a902401ca5a414cda265108cb7b9d5bd50fe0724459f148297331,
};

pub const view_value_e619efafac589e2e5d693b0fc6ef76e4f8cb7626a1d17f1aabadac3515b6c5ab = struct {
    *const zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    []const *const zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0,
    u64,
    view_value_027dedca472ddabf6de6c7e25ac327e352467be081874c3968b8f45bd04e7602,
    view_value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77,
    ?*const zx_type_9db89ada2f4a902401ca5a414cda265108cb7b9d5bd50fe0724459f148297331,
};

pub const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

pub inline fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{
    OutOfMemory,
}![]T {
    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    return (try zxAllocate(T, allocator, items, count, false, 0));
}

pub inline fn zxReserveBounded(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, minimum: usize) error{
    OutOfMemory,
}![]T {
    if (((items).len == 0)) {
        return (try zxAllocate(T, allocator, items, count, true, minimum));
    }

    return (try zxReserve(T, allocator, items, count, true));
}

pub fn zxAllocate(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime exact: bool, minimum: usize) error{
    OutOfMemory,
}![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));
    const capacity: usize = (if ((exact or (@max(count, minimum) == 0))) @max(count, minimum) else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(@max(count, minimum), 8)));

    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (((@import("std")).math).add(usize, offset, (((@import("std")).math).mul(usize, capacity, @sizeOf(T)) catch {
        return error.OutOfMemory;
    })) catch {
        return error.OutOfMemory;
    })));

    const data: [*]T = @ptrCast(@alignCast(((bytes).ptr + offset)));
    const fresh: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, ((bytes).ptr + offset)) - @sizeOf(ZxHeader))));

    (fresh).* = .{
        .capacity = capacity,
        .committed = count,
    };

    @memcpy((data)[0..(items).len], items);

    return (data)[0..count];
}

pub fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

pub fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8, comptime exact: bool) error{
    OutOfMemory,
}!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path, exact));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path, exact));
                (target).* = fresh;
            }
        } else {
            if (((path).len == 0)) {
                if ((!(((target).*).storage == .exclusive))) {
                    ((target).*).items = (try zxAllocate(((@typeInfo(@TypeOf(((target).*).items))).pointer).child, allocator, ((target).*).items, (((target).*).items).len, exact, 0));
                    ((target).*).storage = .exclusive;
                }
            } else {
                if (@hasField(V, ((path)[0])[1])) {
                    @field((target).*, ((path)[0])[1]) = null;
                }

                (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..], exact));
            }
        }
    }
}

pub const native = struct {
    pub const @"std:integer" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const widenShort = struct {
            pub const Input = u16;
            pub const Output = u64;
            pub const InputValue = u16;
            pub const OutputValue = u64;
        };
        pub const widenByte = struct {
            pub const Input = u8;
            pub const Output = u64;
            pub const InputValue = u8;
            pub const OutputValue = u64;
        };
        pub const widenSigned = struct {
            pub const Input = u32;
            pub const Output = i64;
            pub const InputValue = u32;
            pub const OutputValue = i64;
        };
        pub const narrow = struct {
            pub const Input = u64;
            pub const Output = u32;
            pub const InputValue = u64;
            pub const OutputValue = u32;
        };
        pub const narrowByte = struct {
            pub const Input = u64;
            pub const Output = u8;
            pub const InputValue = u64;
            pub const OutputValue = u8;
        };
        pub const narrowSigned = struct {
            pub const Input = i64;
            pub const Output = u32;
            pub const InputValue = i64;
            pub const OutputValue = u32;
        };
        pub const bitMask = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
        pub const andBits = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const orBits = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const shiftLeft = struct {
            pub const Input = *const zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const Output = u64;
            pub const InputValue = zx_type_ae6651c9887b48c931a6403be40a5a1f94c3645f53da759472b124d54169c5b9;
            pub const OutputValue = u64;
        };
        pub const hash = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
    };
};

pub const layouts = struct {
    pub const @"std:integer" = struct {};
};
