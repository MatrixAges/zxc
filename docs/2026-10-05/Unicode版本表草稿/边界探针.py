from pathlib import Path
import json
import subprocess

root = Path(__file__).resolve().parents[3]
folder = Path(__file__).resolve().parent
binary = root / 'packages/cli/zig-out/bin/zxc'
rows = [json.loads(line) for line in (folder / '原文证据.jsonl').read_text().strip().split('\n')]
results = []

for index, row in enumerate(rows):
    name = row['probe']
    source = 'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const ' + name + ' = 1\n\n  return 1\n}\n'
    path = folder / f'名称{index + 1}.zx'
    path.write_text(source)
    result = subprocess.run([str(binary), str(path), '--out', str(path.with_suffix('.zig'))], capture_output=True, text=True)
    position = next(index for index, char in enumerate(name) if char == '\\' or ord(char) > 127)
    offset = source.index(name) + position
    line = source[:offset].count('\n') + 1
    column = offset - source.rfind('\n', 0, offset)
    expected = f':{line}:{column}: lexical: unexpected character'

    assert result.returncode == 1 and expected in result.stderr, (row['path'], result)
    results.append({'path': row['path'], 'name': name, 'status': result.returncode, 'expected_location': [line, column], 'diagnostic': result.stderr})

(folder / '边界结果.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'lexical_rejections': len(results)}))
