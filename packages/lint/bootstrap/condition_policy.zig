pub fn check(terms: u64, list: bool, branch: bool) bool {
    return if (branch) terms > 2 else !list and terms > 3;
}
