import importlib.util
import json
import sys
from pathlib import Path

sys.dont_write_bytecode = True

root = Path(__file__).resolve().parents[3]
helper_path = root / "docs/2026-10-06/RX公开推导迁移/迁移材料.py"
sys.path.insert(0, str(helper_path.parent))
spec = importlib.util.spec_from_file_location("migration", helper_path)
migration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(migration)

base = root / "packages/test/tests/rx/runtime"
changes = {
    "fixtures/order.rx": {
        '<Call fn="increment" in={ctx.ab} />': '<Call fn="increment_discard" in={ctx.ab} />',
    },
    "fixtures/service_owned_main.rx": {
        "<Call service='./bridge.rx' in={$in} name='right'/>": "<Call service='./bridge_other.rx' in={$in} name='right'/>",
    },
    "fixtures/control/owned_main.rx": {
        '<Call service="./leaf.rx" in={ctx.items} name="twice" />': '<Call service="./leaf_again.rx" in={ctx.items} name="twice" />',
    },
    "io/fixtures/workflow.rx": {
        '<Call fn="read" in={{path: $in.destination, max_bytes: $in.max_bytes}} name="after" />': '<Call fn="read_after" in={{path: $in.destination, max_bytes: $in.max_bytes}} name="after" />',
    },
    "store/io/fixtures/write.rx": {
        '<Call fn="read" in={{path: $in.after_path, max_bytes: $in.max_bytes}} />': '<Call fn="read_after" in={{path: $in.after_path, max_bytes: $in.max_bytes}} />',
    },
    "store/fixtures/main.rx": {
        '<Call service="advance" in={$in} name="second" />': '<Call service="advance_next" in={$in} name="second" />',
    },
    "store/fixtures/services.rx": {
        '<Call service="bridge" in={$in} name="second" />': '<Call service="bridge_next" in={$in} name="second" />',
    },
    "store/dual/fixtures/main.rx": {
        '<Call fn="snapshot" in={store.left.counter} name="before_left" />': '<Call fn="snapshot_before_left" in={store.left.counter} name="before_left" />',
        '<Call fn="snapshot" in={store.right.counter} name="before_right" />': '<Call fn="snapshot_before_right" in={store.right.counter} name="before_right" />',
        '<Call fn="snapshot" in={store.right.counter} name="untouched" />': '<Call fn="snapshot_untouched" in={store.right.counter} name="untouched" />',
        '<Call fn="snapshot" in={store.left.counter} name="after_left" />': '<Call fn="snapshot_after_left" in={store.left.counter} name="after_left" />',
        '<Call fn="snapshot" in={store.right.counter} name="after_right" />': '<Call fn="snapshot_after_right" in={store.right.counter} name="after_right" />',
    },
    "store/dual/fixtures/union.rx": {
        '<Call fn="read_pair" in={{first: store.right.counter.value, second: store.right.counter.value}} name="after" />': '<Call fn="read_pair_after" in={{first: store.right.counter.value, second: store.right.counter.value}} name="after" />',
        '<Call fn="write_pair" in={{first: store.right.counter.value, second: store.right.counter.value, increment: $in}} setter={[store.right.counter]} name="overlap" />': '<Call fn="write_pair_overlap" in={{first: store.right.counter.value, second: store.right.counter.value, increment: $in}} setter={[store.right.counter]} name="overlap" />',
        '<Call fn="write_pair" in={{first: $in, second: $in, increment: $in}} setter={[store.right.counter]} name="only" />': '<Call fn="write_pair_only" in={{first: $in, second: $in, increment: $in}} setter={[store.right.counter]} name="only" />',
    },
}

paths = [
    *base.glob("fixtures/**/*.rx"),
    *base.glob("io/fixtures/*.rx"),
    *base.glob("store/**/*.rx"),
    base / "parallel/library/consumer.rx",
    base / "parallel/library/consumer_void.rx",
]
modified = []

for path in sorted(paths):
    original = path.read_text()
    source = original

    for before, after in changes.get(str(path.relative_to(base)), {}).items():
        source = source.replace(before, after)

    updated = migration.convert_xml(source)

    if updated == original:
        continue

    modified.append(str(path.relative_to(root)))
    path.write_text(updated)

print(json.dumps({"files": modified}, ensure_ascii=False, indent=2))
