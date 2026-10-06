# coding: utf-8
from pathlib import Path
import hashlib,json,re,subprocess,shlex

doc=Path(__file__).resolve().parent
root=doc.parents[2]
manifest=json.loads((doc/'输入清单.json').read_text())
worktree=Path(manifest['worktree'])
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=worktree).decode().strip()==manifest['source_commit']
for row in manifest['paths']+manifest['production_inputs']:
    for base in [root,worktree]:
        assert hashlib.sha256((base/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
for row in manifest['paths']:
    draft=doc/'草稿'/row['path'].removeprefix('packages/test/')
    assert hashlib.sha256(draft.read_bytes()).hexdigest()==row['sha256']
for row in json.loads((doc/'原有修改清单.json').read_text()):
    assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
expected=[('allocation','3','3'),('borrowing','20','20'),('guards','12','12')]
for mode in ['Debug','ReleaseSafe']:
    record=json.loads((doc/(mode+'执行.json')).read_text())
    raw=(doc/(mode+'执行.log')).read_bytes()
    assert record['exit_code']==0 and record['inputs']==manifest['paths']
    assert record['source_commit']==manifest['source_commit']
    assert hashlib.sha256(raw).hexdigest()==record['log_sha256']
    log=raw.decode()
    steps=re.search(r'Build Summary: (\d+)/(\d+) steps succeeded; 35/35 tests passed',log)
    assert steps and steps[1]==steps[2]
    leaves=re.findall(r'run test native-value-boundary-(\w+) (\d+) pass \((\d+) total\)',log[log.index('Build Summary:'):])
    assert sorted(leaves)==expected,leaves
    binaries=set()
    copied=set()
    for line in log.splitlines():
        if not line.startswith('info(verbose): '):continue
        args=shlex.split(line.removeprefix('info(verbose): '))
        if re.fullmatch(r'native-value-boundary-(borrowing|guards|allocation)',Path(args[0]).name):binaries.add(str(Path(args[0])))
        for arg in args:
            if arg.startswith('-Mnative_value_checks='):copied.add(Path(arg.split('=',1)[1]).parent)
    assert len(binaries)==3 and copied
    for directory in copied:
        for row in manifest['production_inputs']:
            path=directory/'zx'/row['path'].removeprefix('packages/genz/src/zx/')
            assert hashlib.sha256(path.read_bytes()).hexdigest()==row['sha256'],path
    replay=json.loads((doc/(mode+'产物执行.json')).read_text())
    assert len(replay)==3 and {item['binary'] for item in replay}==binaries
    for item in replay:
        assert item['exit_code']==0
        assert hashlib.sha256(Path(item['binary']).read_bytes()).hexdigest()==item['binary_sha256']
        assert hashlib.sha256((doc/item['log']).read_bytes()).hexdigest()==item['log_sha256']
        text=(doc/item['log']).read_text()
        source=root/('packages/test/tests/native/value_boundary/'+item['name']+'_test.zig')
        names=re.findall(r'test "([^"\n]+)"',source.read_text())
        actual=re.findall(r'^\d+/\d+ [^.]+\.test\.(.*?)\.\.\.OK$',text,re.M)
        assert actual==names,(item['name'],actual,names)
mutant=json.loads((doc/'旧实现反向核验.json').read_text())
assert mutant['exit_code']!=0
assert hashlib.sha256((doc/'草稿/核查/native_value_before.zig').read_bytes()).hexdigest()==mutant['replacement_sha256']
assert mutant['restored_sha256']==manifest['production_inputs'][0]['sha256']
assert hashlib.sha256((doc/'旧实现反向核验.log').read_bytes()).hexdigest()==mutant['log_sha256']
mutant_log=(doc/'旧实现反向核验.log').read_text()
assert '21/35 tests passed (14 failed)' in mutant_log
assert 'unexpected native boundary diagnostic' not in mutant_log
assert len(re.findall(r'compile test native-value-boundary-\w+ debug native success',mutant_log))==3
assert re.findall(r"error: '([^']+)' failed:",mutant_log)==json.loads((doc/'反向失败清单.json').read_text())
print('Verified: 35 actual tests per mode, exact names in 6 binary replays, 14 old-implementation failures, unchanged foreign files')
