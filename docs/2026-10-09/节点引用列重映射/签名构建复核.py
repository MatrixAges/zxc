import json
import os
import pathlib
import signal
import subprocess
import time

root = pathlib.Path.cwd()
evidence = root / "docs/2026-10-09/节点引用列重映射"
command = ["/Users/xiewendao/.local/share/zig/zig-x86_64-macos-0.17.0/zig", "build", "-j2"]
repairs = []

for attempt in range(5):
    with (evidence / ("构建复核-" + str(attempt) + ".txt")).open("wb") as log:
        process = subprocess.Popen(command, stdout=log, stderr=log)
        repaired = False
        while process.poll() is None:
            time.sleep(2)
            rows = []
            for line in subprocess.check_output(["ps", "-axo", "pid,ppid,stat,comm"], text=True).splitlines()[1:]:
                fields = line.strip().split(None, 3)
                if len(fields) == 4:
                    rows.append((int(fields[0]), int(fields[1]), fields[2], fields[3]))
            descendants = {process.pid}
            changed = True
            while changed:
                before = len(descendants)
                descendants.update(pid for pid, parent, state, path in rows if parent in descendants)
                changed = len(descendants) != before
            for pid, parent, state, name in rows:
                if pid == process.pid or pid not in descendants or not state.startswith("U"):
                    continue
                executable = (root / name).resolve()
                if not executable.is_file() or root / ".zig-cache" not in executable.parents:
                    continue
                checked = subprocess.run(["codesign", "--verify", "--verbose=2", str(executable)], capture_output=True, text=True)
                if "not signed at all" not in checked.stderr:
                    continue
                subprocess.run(["codesign", "--force", "--sign", "-", str(executable)], check=True, capture_output=True)
                subprocess.run(["codesign", "--verify", str(executable)], check=True, capture_output=True)
                repairs.append({"attempt": attempt, "pid": pid, "path": str(executable), "before": checked.stderr})
                print("Signed unsigned build helper: " + executable.name, flush=True)
                for child in descendants - {process.pid}:
                    try:
                        os.kill(child, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                process.terminate()
                process.wait()
                repaired = True
                break
            if repaired:
                break
        status = process.wait()
    record = {"command": command, "attempt": attempt, "exit_code": status, "repairs": repairs, "restart_after_repair": repaired}
    (evidence / "标准构建结果.json").write_text(json.dumps(record, ensure_ascii=False, indent=2))
    if not repaired:
        print("Build exit code: " + str(status), flush=True)
        raise SystemExit(status)
raise SystemExit("Build did not complete within verified signature repairs")
