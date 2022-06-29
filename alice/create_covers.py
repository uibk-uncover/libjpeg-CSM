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


def compress_alaska_steganographer(src_dir, dst_dir, version):
    """Compresses ALASKA covers to be used by steganographer. Uses the same version.
    
    Args:
        src_dir (pathlib.Path): Where is ALASKA (.tif).
        dst_dir (pathlib.Path): Where do you want the compressed and decompressed images to be saved.
        version (str): What libjpeg version should be used.
    """
    # choose random 10K
    random.seed(12345)
    fnames = random.sample(os.listdir(src_dir), k=10000)
    # iterate images
    for i,x_name in enumerate(fnames):
        print(i+1, '/', len(fnames), '     ', end='\r')
        if x_name.split('.')[-1] != 'tif': continue
        # load image
        x = np.array(Image.open(src_dir / x_name))
        # compress
        xc_name = f'{".".join(x_name.split(".")[:-1])}.jpeg'
        xc_path = str(dst_dir / 'cover' / xc_name)
        with jpeglib.version(version):
            jpeglib.from_spatial(x).write_spatial(xc_path) # x'
        # decompress and save
        xcd_name = f'{".".join(x_name.split(".")[:-1])}.png'
        xcd_path = str(dst_dir / ('cover_decompressed%s'%version) / xcd_name)
        with jpeglib.version(version):
            xcd = jpeglib.read_spatial(xc_path)
            Image.fromarray(xcd.spatial).save(xcd_path) # x*



if __name__ == '__main__':
    # parse args
    version,(src_dir,dst_dir) = get_argument_input()
    # compress
    compress_alaska_steganographer(src_dir, dst_dir, version)
