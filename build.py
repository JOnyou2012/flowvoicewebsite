"""Publish an explicit allowlist; never include Git, SQL or environment files."""
from pathlib import Path
import shutil
root=Path(__file__).resolve().parent
out=root/'dist'
if out.exists():shutil.rmtree(out)
out.mkdir()
for path in root.iterdir():
 if path.is_file() and path.suffix in {'.html','.css','.js','.png','.ico'} and not path.name.startswith('supabase_email_'):
  shutil.copy2(path,out/path.name)
for name in ['fonts','images']:
 if (root/name).exists():shutil.copytree(root/name,out/name)
# Serve the complete landing page immediately at the base URL.
shutil.copy2(root/'website.html',out/'index.html')
print('Packaged FlowVoice, account pages and release links.')
