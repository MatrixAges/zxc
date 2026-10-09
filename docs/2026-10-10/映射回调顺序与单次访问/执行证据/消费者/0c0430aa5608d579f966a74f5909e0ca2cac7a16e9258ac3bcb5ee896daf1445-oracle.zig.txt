pub const Method = enum { map, filter, every, some };
pub const Result = struct { values: [8192]i64 = undefined, len: usize = 0, count: usize = 0, decision: bool };

pub fn evaluate(method: Method, input: []const i64, context: i64) Result {
    var result = Result{ .decision = method == .every };

    for (input) |item| {
        result.count += 1;

        switch (method) {
            .map => {
                result.values[result.len] = item + context;
                result.len += 1;
            },
            .filter => if (item > context) {
                result.values[result.len] = item;
                result.len += 1;
            },
            .every => if (item <= context) {
                result.decision = false;

                break;
            },
            .some => if (item > context) {
                result.decision = true;

                break;
            },
        }
    }

    return result;
}
