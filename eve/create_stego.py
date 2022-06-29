#!/usr/bin/env python3
"""
"""

import numpy as np
import os
from pathlib import Path
from PIL import Image
import sys

import jpeglib
jpeglib.version.set('6b')

sys.path.append('include')
from parse_args import get_argument_input

# compress alaska
def compress_stego(dir, version, bpnzac):
    """Compresses ALASKA stegos to be used by steganalyst. Uses the same version."""
    # create directories
    stego_src_dir = dir / ('stego_juniward_%.1f' % bpnzac)
    stego_decompress_dir = dir / ('stego_juniward_%.1f_decompressed%s' % (bpnzac,version))
    stego_dst_dir = dir / ('stego_juniward_%.1f_compressed%s' % (bpnzac,version))
    stego_decompress_dir.mkdir(parents=True, exist_ok=True)
    stego_dst_dir.mkdir(parents=True, exist_ok=True)
    # iterate images
    fnames = os.listdir(stego_src_dir)
    for i,x_name in enumerate(fnames):
        print(i+1, '/', len(fnames), '     ', end='\r')
        if x_name.split('.')[-1] != 'jpeg': continue
        png_name = '.'.join(x_name.split('.')[:-1]) + '.png'
        stego_src_path = str(stego_src_dir / x_name)
        stego_dst_path = str(stego_dst_dir / x_name)
        # decompress x' to x*
        with jpeglib.version(version):
            x = jpeglib.read_spatial(stego_src_path).spatial # x*
        stego_decompress_path = str(stego_decompress_dir / png_name)
        Image.fromarray(x).save(stego_decompress_path) # save x* as png
        # compress x* to x*'
        with jpeglib.version(version):
            jpeglib.from_spatial(x).write_spatial(stego_dst_path) # x*'


def compare_pairs(dir, v_decompress, bpnzac):
    """Compare pairs of cover and stego."""
    # iterate images
    dir = Path(dir)
    cover_dir,stego_dir = dir / 'cover', dir / ('stego_juniward_%.1f' % bpnzac)
    fnames = os.listdir(cover_dir)
    for i,fname in enumerate(fnames):
        if fname.split('.')[-1] != 'jpeg': continue
        # get cover-stego pair
        cover_path = str(cover_dir / fname)
        stego_path = str(stego_dir / fname)
        cover = np.array(Image.open(cover_path))
        stego = np.array(Image.open(stego_path))
        # compare
        D = np.abs(cover.astype("int16") - stego.astype("int16"))
        print(fname, ':', (D != 0).mean())


if __name__ == '__main__':
    # parse args
    _, (_,dst_dir) = get_argument_input()
    # compress
    compress_stego(dst_dir, '6b', .4)
    compress_stego(dst_dir, '7', .4)
    compare_pairs(alaska_path, '6b', .4)