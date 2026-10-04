from pathlib import Path
import json
import subprocess

folder = Path(__file__).resolve().parent
root = folder.parents[2]
binary = root / 'packages/cli/zig-out/bin/zxc'
results = []

for index, name in enumerate(['x', 'xx', 'x$', 'x_', r'\u{00_76}', r'\u{0076}']):
    source = 'export type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  const ' + name + ' = 1\n\n  return ' + name + '\n}\n'
    path = folder / f'名称{index + 1}.zx'
    path.write_text(source)
    result = subprocess.run([str(binary), str(path), '--out', str(path.with_suffix('.zig'))], capture_output=True, text=True)

    if index < 2:
        assert result.returncode == 0, result.stderr
        assert path.with_suffix('.zig').exists()
    else:
        assert result.returncode == 1, result
        expected = {
            2: ':6:10: syntax: expected =',
            3: ':6:9: naming: value names must use snake_case',
            4: ':6:9: lexical: unexpected character',
            5: ':6:9: lexical: unexpected character',
        }[index]
        assert expected in result.stderr, result.stderr

    results.append(dict(name=name, code=result.returncode, diagnostic=result.stderr))

(folder / '边界结果.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(results, ensure_ascii=False, indent=2))
