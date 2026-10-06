# coding: utf-8
from pathlib import Path
import json,hashlib,subprocess,datetime

doc=Path(__file__).resolve().parent
manifest=json.loads((doc/'输入清单.json').read_text())
root=Path(manifest['worktree'])
path=manifest['production_inputs'][0]['path']
target=root/path
original=target.read_bytes()
assert hashlib.sha256(original).hexdigest()==manifest['production_inputs'][0]['sha256']
old=subprocess.check_output(['git','show','04dbf0b7^:'+path],cwd=root)
snapshot=doc/'草稿/核查/native_value_before.zig'
snapshot.parent.mkdir(parents=True,exist_ok=True)
snapshot.write_bytes(old)
argv=['zig','build','test-native-value-boundary','-Doptimize=Debug','-Dzig-archive=/tmp/zig-x86_64-macos-0.17.0.tar.xz','-j2','--summary','all','--cache-dir','/tmp/zxc-native-value-准备debug-'+manifest['source_commit'][:8]]
record={'argv':argv,'cwd':str(root/'packages/test'),'replacement_source':'04dbf0b7^:'+path,'replacement_sha256':hashlib.sha256(old).hexdigest(),'original_sha256':hashlib.sha256(original).hexdigest(),'started_at':datetime.datetime.now(datetime.timezone.utc).isoformat()}
try:
    target.write_bytes(old)
    with (doc/'旧实现反向核验.log').open('wb') as log:
        result=subprocess.run(argv,cwd=root/'packages/test',stdout=log,stderr=subprocess.STDOUT)
    record['exit_code']=result.returncode
finally:
    target.write_bytes(original)
    record['restored_sha256']=hashlib.sha256(target.read_bytes()).hexdigest()
record['completed_at']=datetime.datetime.now(datetime.timezone.utc).isoformat()
record['log_sha256']=hashlib.sha256((doc/'旧实现反向核验.log').read_bytes()).hexdigest()
(doc/'旧实现反向核验.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
assert result.returncode!=0
log=(doc/'旧实现反向核验.log').read_text()
print(next(line for line in log.splitlines() if line.startswith('Build Summary:')))
print('Restored original source:',record['restored_sha256']==record['original_sha256'])
