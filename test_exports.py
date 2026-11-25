import sys,tempfile,unittest
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'engine'))
from tools.export import export,FORMATS
class Exports(unittest.TestCase):
 def test_formats(self):
  with tempfile.TemporaryDirectory() as d:
   for fmt in FORMATS:
    with self.subTest(fmt=fmt):
     p=Path(d)/('image.'+fmt)
     export(ROOT/'tests/fixtures/alpha_lossless.jxl',p,fmt,95,'ffmpeg')
     with Image.open(p) as im: self.assertEqual(im.size,(40,24)); self.assertEqual(im.format,FORMATS[fmt]); im.load()
     with self.assertRaises(ValueError): export(ROOT/'tests/fixtures/alpha_lossless.jxl',p,fmt,95,'ffmpeg')
 def test_corrupt(self):
  with tempfile.TemporaryDirectory() as d:
   with self.assertRaises(ValueError): export(ROOT/'tests/fixtures/invalid.jxl',Path(d)/'bad.gif','gif',95,'ffmpeg')
if __name__=='__main__': unittest.main()
