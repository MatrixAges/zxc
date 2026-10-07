from pathlib import Path
import hashlib
import json
import re
import shlex

root = Path(__file__).resolve().parent
observations = []

for mode in ["Debug", "ReleaseSafe"]:
    evidence = json.loads((root / (mode + "证据.json")).read_text())

    for route in ["source", "library"]:
        name = "object-reduce-subject-" + route
        command = next(item["command"] for item in evidence["commands"] if "--name " + name + " " in item["command"])
        source = next(Path(arg.split("=", 1)[1]) for arg in shlex.split(command) if arg.startswith("-Mprogram="))
        data = source.read_bytes()
        complete_text = data.decode()

        assert complete_text.count("pub fn execute(") == 1

        text = complete_text.split("pub fn execute(", 1)[1]
        binding = re.search(r"const (\w+) = @rem\(", text)

        assert binding is not None
        assert text.count("@rem(") == 1

        subject = binding.group(1)

        for value in [0, 1]:
            assert text.count("(" + subject + " == @as(u64, " + str(value) + "))") == 1

        loop_start = text.index("        for (")
        loop_end = re.search(r"(?m)^        break :block_\d+", text[loop_start:])

        assert loop_end is not None

        body = text[loop_start:loop_start + loop_end.start()]

        assert ".create(" not in body
        assert "state_changed_" in body
        assert "value_1 =" in body

        sha = hashlib.sha256(data).hexdigest()
        saved = root / "生成物" / (sha + ".zig.txt")

        assert saved.read_bytes() == data

        observations.append({"mode": mode, "route": route, "source": str(source), "sha256": sha, "subject_binding": subject, "public_entry_rem_expressions": 1, "whole_file_rem_expressions": complete_text.count("@rem("), "comparison_values": [0, 1], "loop_object_allocations": 0})

(root / "subject生成结构证据.json").write_text(json.dumps(observations, ensure_ascii=False, indent=2) + "\n")
print("PASS: all four executed subject consumers bind one remainder expression, reuse its value in both comparisons, and do not allocate objects inside the loop")
