"""
"""

import argparse
from pathlib import Path


def get_argument_input():
    # parse arguments
    parser = argparse.ArgumentParser(description='libjpeg CSM: cover creator')
    parser.add_argument('version', type=str, nargs="*", choices=['6b','7'], default="6b", help='libjpeg version')
    parser.add_argument('--datadir', '-d', type=str, help='data directory', default='data')
    args = parser.parse_args()
    # input/output
    version = ''.join(list(args.version))
    alaska_path = Path(args.datadir) / 'ALASKA_v2_TIFF_256_COLOR'
    dst_path = Path(args.datadir) / f'ALASKA_{version}'
    # create non-existent
    (dst_path/('cover')).mkdir(parents=True, exist_ok=True)
    (dst_path/('cover_decompressed%s'%version)).mkdir(parents=True, exist_ok=True)
    # return
    return version, (alaska_path, dst_path)

if __name__ == '__main__':
    raise RuntimeError('module not supposed to be executed directly')