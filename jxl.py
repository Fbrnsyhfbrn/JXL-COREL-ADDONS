import os, shutil, subprocess, sys, warnings
from pathlib import Path
from PIL import Image

def decode(source, output, backend='pillow', report=lambda message: None):
    source, output = Path(source).resolve(), Path(output).resolve()
    if source == output or output.exists(): raise ValueError('Output must be a new file')
    with source.open('rb') as f: sig=f.read(12)
    if not (sig.startswith(b'\xff\x0a') or sig == b'\x00\x00\x00\x0cJXL \x0d\x0a\x87\x0a'): raise ValueError('Invalid JXL signature')
    report('Input signature validated; bytes='+str(source.stat().st_size))
    tmp=output.with_name(output.stem+'.partial.png')
    if tmp.exists(): raise ValueError('Partial output already exists')
    try:
        if backend=='pillow':
            import pillow_jxl
            with warnings.catch_warnings():
                warnings.simplefilter('error', Image.DecompressionBombWarning)
                with Image.open(source) as im:
                    if getattr(im,'n_frames',1)!=1: raise ValueError('Animated JXL is not supported')
                    report('Decoding %sx%s, mode=%s' % (im.width,im.height,im.mode))
                    im.load()
                    report('Encoding PNG (lossless; quality slider not applicable)')
                    if im.mode not in ('RGB','RGBA','L','LA','I;16'): raise ValueError('Unsupported pixel mode: '+im.mode)
                    opts={k:im.info[k] for k in ('icc_profile','dpi') if im.info.get(k)}
                    im.save(tmp,format='PNG',**opts)
        else:
            exe=shutil.which(backend)
            if not exe: raise RuntimeError(backend+' not found on PATH')
            cmd=[exe,str(source),str(tmp)] if backend=='djxl' else [exe,'-nostdin','-v','error','-xerror','-i',str(source),'-frames:v','1',str(tmp)]
            p=subprocess.run(cmd,capture_output=True,timeout=180,creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
            if p.returncode: raise RuntimeError(p.stderr.decode(errors='replace')[-4000:])
        with Image.open(tmp) as im:
            im.verify()
        with Image.open(tmp) as im:
            info={'width':im.width,'height':im.height,'mode':im.mode,'icc':bool(im.info.get('icc_profile')),'backend':backend}
        os.replace(tmp,output)
        info['bytes']=output.stat().st_size
        report('PNG verified; bytes='+str(info['bytes']))
        return info
    finally:
        if tmp.exists(): tmp.unlink()
