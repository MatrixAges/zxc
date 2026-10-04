import json,pathlib,struct,subprocess,signal
signal.alarm(150)
root=pathlib.Path('/var/folders/lf/4g9rspms3hq7smqmfx_vfpc80000gn/T/zxc-listen-probe-o_mlxmlu')
args=json.loads((root/'mirror-args.json').read_text());args[args.index('--cache-dir')+1]=str(root/'persistent-fail-cache');args+=['--name','persistent_restore']
header=root/'mirror-lib/libc/include/any-darwin-any/sys/_symbol_aliasing.h';old=header.read_bytes();header.unlink()
(root/'persistent-args.json').write_text(json.dumps(args,indent=2))
err=open(root/'persistent.stderr','wb');p=subprocess.Popen(args,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=err,cwd=root)
def exact(n):
    b=b''
    while len(b)<n:
        v=p.stdout.read(n-len(b))
        if not v:raise RuntimeError('early EOF')
        b+=v
    return b
def update(label):
    p.stdin.write(struct.pack('<II',1,0));p.stdin.flush();messages=[];raw=b''
    while True:
        h=exact(8);tag,n=struct.unpack('<II',h);body=exact(n);raw+=h+body;row={'tag':tag,'size':n}
        if tag==0:row['version']=body.decode()
        if tag==2:row['cache_hit']=bool(body[0]&1);row['emit_digest']=body[1:].hex()
        if tag==6:row['inputs']=[{'prefix':v[0]-1,'path':v[1:].decode()} for v in body.split(b'\0') if v]
        if tag==1:row['error_bundle_head']=body[:8].hex()
        messages.append(row)
        if tag==1:break
    (root/(label+'.bin')).write_bytes(raw);(root/(label+'.json')).write_text(json.dumps({'label':label,'pid':p.pid,'messages':messages},indent=2))
    print(json.dumps({'label':label,'pid':p.pid,'tags':[m['tag'] for m in messages],'hits':[m['cache_hit'] for m in messages if m['tag']==2],'headers':[v for m in messages if m['tag']==6 for v in m['inputs'] if v['path'].endswith('.h')],'errors':[m['error_bundle_head'] for m in messages if m['tag']==1]}),flush=True)
try:
    update('persistent-first-missing')
    header.write_bytes(old)
    update('persistent-restored-update')
    update('persistent-warm-update')
    p.stdin.write(struct.pack('<II',0,0));p.stdin.flush();p.wait(timeout=15)
finally:
    header.write_bytes(old)
    if p.poll() is None:p.kill();p.wait()
    err.close()
