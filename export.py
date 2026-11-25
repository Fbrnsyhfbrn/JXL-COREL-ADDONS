from pathlib import Path
from PIL import Image, ImageOps, ImageSequence
import os, tempfile, warnings
from .jxl import decode
FORMATS={'png':'PNG','gif':'GIF','jpg':'JPEG','webp':'WEBP','tiff':'TIFF','bmp':'BMP'}
def export(source, output, fmt, quality=95, backend='pillow', report=lambda message: None):
    source, output=Path(source).resolve(),Path(output).resolve()
    if fmt not in FORMATS or not 1<=quality<=100: raise ValueError('Invalid format or quality')
    if source==output or output.exists(): raise ValueError('Output must be new')
    with source.open('rb') as f: sig=f.read(12)
    if not (sig.startswith(b'\xff\x0a') or sig==b'\x00\x00\x00\x0cJXL \x0d\x0a\x87\x0a'): raise ValueError('Invalid JXL signature')
    report('Input signature validated; bytes='+str(source.stat().st_size))
    with tempfile.TemporaryDirectory() as d, warnings.catch_warnings():
        warnings.simplefilter('error', Image.DecompressionBombWarning)
        if backend=='pillow':
            import pillow_jxl
            path=source
        else:
            path=Path(d)/'decoded.png'; decode(source,path,backend,report)
        with Image.open(path) as im:
            n=getattr(im,'n_frames',1)
            report('Source header: %sx%s, mode=%s, frames=%s' % (im.width,im.height,im.mode,n))
            if n>1 and fmt not in ('gif','webp','tiff','png'): raise ValueError('Animated input requires GIF, WebP, TIFF or PNG')
            if n*im.width*im.height>120_000_000: raise ValueError('Frame pixel budget exceeded')
            opts={k:im.info[k] for k in ('icc_profile','dpi') if im.info.get(k) and fmt in ('png','jpg','tiff','webp') and not (fmt=='webp' and k=='dpi')}
            durations=[]; frames=[]; loop=im.info.get('loop',0)
            for frame in ImageSequence.Iterator(im):
                durations.append(frame.info.get('duration',100) or 100)
                frame=ImageOps.exif_transpose(frame).copy()
                if fmt in ('jpg','bmp'):
                    rgba=frame.convert('RGBA'); base=Image.new('RGB',rgba.size,'white'); base.paste(rgba,mask=rgba.getchannel('A')); frame=base
                elif fmt in ('gif','webp'): frame=frame.convert('RGBA')
                frames.append(frame)
            if fmt in ('jpg','webp'): opts['quality']=quality
            if fmt=='webp': opts['lossless']=quality==100
            if n>1:
                opts.update(save_all=True,append_images=frames[1:])
                if fmt!='tiff': opts.update(duration=durations,loop=loop)
            fd,tmp=tempfile.mkstemp(prefix='.novorius-',suffix='.'+fmt,dir=output.parent); os.close(fd)
            try:
                report('Encoding '+fmt.upper()+(' quality='+str(quality) if fmt in ('jpg','webp') else ' (quality not applicable)')+(' lossless=true' if fmt=='webp' and quality==100 else ''))
                frames[0].save(tmp,format=FORMATS[fmt],**opts)
                with Image.open(tmp) as check: check.verify()
                # exclusive creation prevents overwriting an existing output
                with open(tmp,'rb') as inp, output.open('xb') as out:
                    import shutil; shutil.copyfileobj(inp,out)
            finally: os.unlink(tmp)
            report('Output verified and saved; bytes='+str(output.stat().st_size))
            return {'width':frames[0].width,'height':frames[0].height,'frames':n,'format':fmt,'backend':backend,'quality':quality if fmt in ('jpg','webp') else None,'lossless':quality==100 if fmt=='webp' else None,'bytes':output.stat().st_size}
