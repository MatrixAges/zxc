from pathlib import Path
import hashlib
import json
import subprocess

base = Path(__file__).resolve().parent
cli = Path('/tmp/zxc-template-newline-cli/bin/zxc')
results = []

for name in ['lf', 'cr', 'crlf', 'ls', 'ps']:
    source = base / f'{name}.zx'
    generated = base / f'{name}.zig'
    binary = f'/tmp/zxc-template-newline-{name}'
    commands = [
        [str(cli), str(source), '--no-cache', '--out', str(generated)],
        ['zig', 'build-exe', '--dep', 'program', f'-Mroot={base / "probe.zig"}', f'-Mprogram={generated}', f'-femit-bin={binary}'],
        [binary],
    ]
    logs = []
    outcome = None

    for command in commands:
        outcome = subprocess.run(command, capture_output=True, text=True)
        logs.append({'command': command, 'exit_code': outcome.returncode, 'stdout': outcome.stdout, 'stderr': outcome.stderr})
        if outcome.returncode:
            break

    (base / f'{name}_execution.json').write_text(json.dumps(logs, ensure_ascii=False, indent=2) + '\n')
    expected = {'lf': '410a42', 'cr': '410a42', 'crlf': '410a42', 'ls': '41e280a842', 'ps': '41e280a942'}[name]
    actual = outcome.stderr.strip() if outcome and outcome.returncode == 0 and len(logs) == 3 else None
    results.append({'name': name, 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(), 'expected_js_hex': expected, 'actual_zx_hex': actual, 'match': actual == expected})

(base / '实际差异.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(results, ensure_ascii=False, indent=2))
raise SystemExit(0 if all(row['match'] for row in results) else 1)
