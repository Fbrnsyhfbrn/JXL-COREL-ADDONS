import argparse, json, sys, traceback
from pathlib import Path
from tools.jxl import decode
from tools.export import export

def report(message):
    print(message, file=sys.stderr, flush=True)

def main():
    p=argparse.ArgumentParser(prog='novorius'); sub=p.add_subparsers(dest='tool',required=True)
    j=sub.add_parser('jxl'); j.add_argument('action',choices=['decode','import']); j.add_argument('input'); j.add_argument('--output',required=True); j.add_argument('--backend',choices=['pillow','djxl','ffmpeg'],default='pillow')
    job=sub.add_parser('job'); job.add_argument('directory'); job.add_argument('--backend',choices=['pillow','djxl','ffmpeg'],default='pillow')
    e=sub.add_parser('export'); e.add_argument('input'); e.add_argument('output'); e.add_argument('--format',required=True); e.add_argument('--quality',type=int,default=95); e.add_argument('--backend',choices=['pillow','djxl','ffmpeg'],default='pillow')
    sub.add_parser('doctor')
    for command in (j,job,e): command.add_argument("--live",action="store_true")
    a=p.parse_args()
    emit=report if getattr(a,"live",False) else lambda message: None
    if a.tool=='export':
        print(json.dumps(export(a.input,a.output,a.format,a.quality,a.backend,emit))); return 0
    if a.tool=='doctor':
        import pillow_jxl
        from PIL import Image
        print(json.dumps({'python':sys.version,'pillow':Image.__version__,'decoder':pillow_jxl.__file__})); return 0
    if a.tool=='job':
        d=Path(a.directory).resolve(); log=d/'result.txt'
        try:
            src=(d/'input.txt').read_text(encoding='utf-16').strip('\r\n')
            info=decode(src,d/'image.png',a.backend,emit)
            log.write_text('OK\n'+json.dumps(info),encoding='utf-16'); return 0
        except Exception:
            detail=traceback.format_exc()
            log.write_text(detail,encoding='utf-16'); emit(detail); return 1
    print(json.dumps(decode(a.input,a.output,a.backend,emit))); return 0

if __name__=='__main__':
    try: sys.exit(main())
    except Exception as e: print('JXL NOVORIUS:',e,file=sys.stderr); sys.exit(1)
