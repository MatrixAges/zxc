import hashlib
import itertools
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parent
program = Path(sys.argv[1]).resolve()
reference = Path(sys.argv[2]).resolve()
cases = {}


def add(name, source):
    cases.setdefault(source, name)


alphabet = [9, 10, 13, 32, 34, 39, 36, 42, 43, 45, 46, 47, 48, 49, 65, 95, 96, 101, 123, 125]

for length in range(4):
    for index, value in enumerate(itertools.product(alphabet, repeat=length)):
        add(f"short/{length}/{index}", bytes(value))

for byte in range(256):
    add(f"single_byte/{byte}", bytes([byte]))

operators = [33, 38, 46, 60, 61, 62, 63, 124]

for length in range(1, 4):
    for index, value in enumerate(itertools.product(operators, repeat=length)):
        operator = bytes(value)
        add(f"operator/{length}/{index}/bare", operator)
        add(f"operator/{length}/{index}/identifier", b"a" + operator + b"b")
        add(f"operator/{length}/{index}/number", b"1" + operator + b"2")

sequences = [bytes.fromhex(value) for value in ["c280", "dfbf", "e0a080", "ed9fbf", "ee8080", "efbfbf", "f0908080", "f48fbfbf"]]

for index, sequence in enumerate(sequences):
    variants = [sequence[:length] for length in range(len(sequence) + 1)]

    for offset in range(len(sequence)):
        for byte in [0, 0x7f, 0x80, 0x9f, 0xa0, 0xbf, 0xc0, 0xff]:
            changed = bytearray(sequence)
            changed[offset] = byte
            variants.append(bytes(changed))

    for variant, data in enumerate(variants):
        add(f"utf8/{index}/{variant}/raw", data)
        add(f"utf8/{index}/{variant}/string", b'"' + data + b'"')

fragments = [b"", b"x", b"\n", b"\r\n", b"/* x */", b"// x\n", b"'x'", b'"x"', b"${x}", b"\\`", b"\\${x}", b"\\"]

for left, right in itertools.product(fragments, repeat=2):
    for prefix, suffix in [(b"`", b"`"), (b"/*", b"*/"), (b'"', b'"')]:
        add("delimiters/" + (prefix + left + right + suffix).hex(), prefix + left + right + suffix)

for depth in [1, 2, 3, 31, 127, 254, 255, 256, 257, 258]:
    source = b"x"

    for _ in range(depth):
        source = b"`${" + source + b"}`"

    add(f"depth/{depth}/complete", source)
    add(f"depth/{depth}/unterminated", source[:-1])


def execute(command):
    try:
        result = subprocess.run(command, capture_output=True, timeout=15)
    except subprocess.TimeoutExpired:
        return {"execution_error": "timeout"}

    if result.returncode != 0:
        return {"execution_error": result.returncode, "stderr": result.stderr.decode("utf8", errors="replace")}

    try:
        return json.loads(result.stdout)
    except (ValueError, UnicodeDecodeError):
        return {"execution_error": "invalid_json", "stdout": result.stdout.hex()}


started = time.monotonic()
failures = []

with tempfile.TemporaryDirectory(prefix="zxc-lexer-differential-") as temporary:
    source_path = Path(temporary) / "source.bin"

    with (root / "输入清单.jsonl").open("w") as inventory, (root / "失败差异.jsonl").open("w") as differences:
        for index, (source, name) in enumerate(cases.items(), 1):
            record = {"name": name, "hex": source.hex(), "sha256": hashlib.sha256(source).hexdigest()}
            inventory.write(json.dumps(record) + "\n")
            source_path.write_bytes(source)
            expected = execute([str(reference), str(source_path)])
            actual = execute([str(program), json.dumps(list(source), separators=(",", ":"))])

            if expected != actual or "execution_error" in expected or "execution_error" in actual:
                failure = {**record, "expected": expected, "actual": actual}
                differences.write(json.dumps(failure, ensure_ascii=False) + "\n")
                differences.flush()
                failures.append(name)

            if index % 256 == 0:
                print(json.dumps({"completed": index, "total": len(cases), "failures": len(failures)}), flush=True)

summary = {
    "cases": len(cases),
    "failure_count": len(failures),
    "failures": failures,
    "seconds": time.monotonic() - started,
    "program_sha256": hashlib.sha256(program.read_bytes()).hexdigest(),
    "reference_sha256": hashlib.sha256(reference.read_bytes()).hexdigest(),
}
(root / "验证结果.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
print(json.dumps(summary, ensure_ascii=False), flush=True)
sys.exit(1 if failures else 0)
