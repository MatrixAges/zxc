# coding: utf-8
from pathlib import Path
import hashlib,json,subprocess,sys,datetime

doc=Path(__file__).resolve().parent
manifest=json.loads((doc/'输入清单.json').read_text())
root=Path(manifest['worktree'])
mode=sys.argv[1]
label=sys.argv[2] if len(sys.argv)>2 else mode
assert mode in ['Debug','ReleaseSafe']
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root).decode().strip()==manifest['source_commit']
for row in manifest['paths']:
    assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
argv=['zig','build','test-native-borrowed-runtime','-Doptimize='+mode,'-Dzig-archive=/tmp/zig-x86_64-macos-0.17.0.tar.xz','-j2','--summary','all','--verbose','--cache-dir','/tmp/zxc-borrowed-native-'+mode.lower()+'-'+manifest['source_commit'][:8]]
record={'argv':argv,'cwd':str(root/'packages/test'),'source_commit':manifest['source_commit'],'inputs':manifest['paths'],'started_at':datetime.datetime.now(datetime.timezone.utc).isoformat()}
with (doc/(label+'执行.log')).open('wb') as log:
    result=subprocess.run(argv,cwd=root/'packages/test',stdout=log,stderr=subprocess.STDOUT)
record['completed_at']=datetime.datetime.now(datetime.timezone.utc).isoformat()
record['exit_code']=result.returncode
record['log_sha256']=hashlib.sha256((doc/(label+'执行.log')).read_bytes()).hexdigest()
(doc/(label+'执行.json')).write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'label':label,'exit_code':result.returncode},ensure_ascii=False),flush=True)
for line in (doc/(label+'执行.log')).read_text().splitlines():
    if line.startswith('Build Summary:') or 'unexpected' in line or 'error:' in line:print(line[:350],flush=True)
sys.exit(result.returncode)
