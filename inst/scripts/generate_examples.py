# /// script
# requires-python = "==3.13.0"
# dependencies = [
#   "ome-zarr==0.13.0"
# ]
# ///
import os
import shutil
import zipfile
import numpy as np
from ome_zarr.writer import write_image
from ome_zarr.format import (
  FormatV01, 
  FormatV02, 
  FormatV03, 
  FormatV04, 
  FormatV05
)

size_xy = 128
size_z = 2
rng = np.random.default_rng(0)
data = rng.poisson(lam=10, size=(size_z, size_xy, size_xy)).astype(np.uint8)

versions = {
    "01": FormatV01(),
    "02": FormatV02(),
    "03": FormatV03(),
    "04": FormatV04(),
    "05": FormatV05()
}

for v, fmt in versions.items():
    path = f"../extdata/test_ngff_image_v{v}.ome.zarr"

    if os.path.exists(path) and os.path.isdir(path):
        shutil.rmtree(path)

    write_image(
        data,
        path,
        axes=['c', 'y', 'x'],
        fmt=fmt,
        scale_factors=[2, 4]
    )

    zip_path = f"{path}.zip"
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(path):
            dirs.sort()
            files.sort()
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, path)
                z.write(full_path, arcname=rel_path)

    shutil.rmtree(path)
