exec(open('/tmp/zxc_listen_headers.py').read().split("run('mirror-cold')")[0])
original_args=args[:]
for label,rel in [('first-missing-transitive','libc/include/any-darwin-any/sys/_symbol_aliasing.h'),('first-missing-root','libc/include/any-darwin-any/math.h')]:
    header=mirror/rel;old=header.read_bytes();header.unlink()
    args=original_args[:];args[args.index('--cache-dir')+1]=str(root/(label+'-cache'))
    try:run(label)
    finally:header.write_bytes(old)
args=original_args+['--name','probe_named']
run('named-output')
