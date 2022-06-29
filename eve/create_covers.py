#!/usr/bin/env python3
"""
"""

import argparse
import numpy as np
import os
from pathlib import Path
from PIL import Image
import random
import sys
from typing import List

import jpeglib
jpeglib.version.set('6b')

sys.path.append('include')
from parse_args import get_argument_input


def compress_alaska_steganalyst(src_dir:Path, dst_dir:Path, versions:List[str]):
    """Compresses ALASKA covers to be used by steganographer. Uses the same version.
    
    Args:
        src_dir (pathlib.Path): Where is ALASKA (.tif).
        dst_dir (pathlib.Path): Where do you want the compressed and decompressed images to be saved.
        versions (str): What libjpeg version should be used.
    """
    """Compresses ALASKA covers to be used by steganalyst. Uses the same version."""
    # create directories
    for v in versions:
        (dst_dir/('cover_compressed%s'%v)).mkdir(parents=True, exist_ok=True)
        (dst_dir/('cover_decompressed%s'%v)).mkdir(parents=True, exist_ok=True)
    # choose random 10K
    random.seed(12345)
    fnames = random.sample(os.listdir(src_dir), k=10000)
    # iterate images
    for i,x_name in enumerate(fnames):
        print(i+1, '/', len(fnames), '     ', end='\r')
        jpeg_name = f'{".".join(x_name.split(".")[:-1])}.jpeg'
        png_name = f'{".".join(x_name.split(".")[:-1])}.png'
        for version in versions:
            # decompress
            with jpeglib.version(version):
                xc_path = str(dst_dir / 'cover' / jpeg_name)
                xcd = jpeglib.read_spatial(xc_path).spatial # x*
            # save as png
            xcd_path = str(dst_dir / ('cover_decompressed%s'%version) / png_name)
            Image.fromarray(xcd).save(xcd_path)
            # compress again
            with jpeglib.version(version):
                xcdc_path = str(dst_dir / ('cover_compressed%s'%version) / jpeg_name)
                jpeglib.from_spatial(xcd).write_spatial(xcdc_path) # x*'



if __name__ == '__main__':
    # parse args
    version, (src_dir,dst_dir) = get_argument_input()
    # compress
    compress_alaska_steganalyst(src_dir, dst_dir, ['6b','7'])
