#!/usr/bin/env python3
import subprocess
import sys
import tempfile
from pathlib import Path

zig = "/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/zig"
arguments = sys.argv[1:]

if not arguments or arguments[0] != "test":
    raise SystemExit(subprocess.run([zig, *arguments]).returncode)

with tempfile.TemporaryDirectory(prefix="zxc-signature-test-") as directory:
    executable = str(Path(directory) / "test")
    compiled = subprocess.run([zig, *arguments, "--test-no-exec", "-femit-bin=" + executable])

    if compiled.returncode:
        raise SystemExit(compiled.returncode)

    subprocess.run(["codesign", "--force", "--sign", "-", executable], check=True, capture_output=True)
    raise SystemExit(subprocess.run([executable]).returncode)
