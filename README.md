# Effect of libjpeg version on CSM

This is the code repository for the paper The Effect of the JPEG Implementation on the Cover-Source Mismatch Error in Image Steganalysis [1]. It contains the codebase to replicate the experiment when mismatch in libjpeg version causes CSM.
## Setup

Codebase uses Python and Matlab.

### Python

The code was executed on Python 3.8.11. Install dependencies with

```bash
pip3 install jpeglib==0.10.11 pillow==9.0.0 numpy==1.19.5
```

### Matlab

Matlab is executed locally in a Matlab environment.

You need Matlab JPEG Toolbox by Phil Sallee. Prebuilt versions have been [published](https://digitnet.github.io/jpeg-toolbox/), or you can build it from source. In that case, you need include and link libjpeg.

```matlab
mex -I/usr/local/include -I./include/jpegtbx include/jpegtbx/jpeg_read.c -L/usr/local/lib -ljpeg -v
mex -I/usr/local/include -I./include/jpegtbx include/jpegtbx/jpeg_write.c -L/usr/local/lib -ljpeg -v
```

In Matlab, you need to add `alice/`, `eve/` and `include` directories to path.


## Usage

We use Python package `jpeglib` that allows selection of libjpeg version for compression and decompression.
However J-UNIWARD embedding, JSRM feature extraction and EFLD model training and evaluation

### Alice: Downloading data

As pre-compressed covers $x_{\text{src}}$ we use ALASKA2 dataset. As it has around 16GB, you will have to download it directly from the original repository of the [ALASKA2 steganalysis challenge](https://alaska.utt.fr/).

Downloading can be done by

```bash
bash data/ALASKA_v2_TIFF_256_COLOR.sh
```

The script `data/ALASKA_v2_TIFF_256_COLOR.sh` was provided by the authors of ALASKA2 steganalysis challenge. Dataset is stored in `data/ALASKA_v2_TIFF_256_COLOR`.

### Alice: Cover preparation

Once you downloaded the data, you have to compress and decompress it by different versions to be Alice. In this step, 10000 data samples are already drawn.

```bash
# perform Alice using 6b
python alice/create_covers.py 6b
# perform Alice using 7
python alice/create_covers.py 7
```

The compressed and decompressed images are stored in `data/ALASKA_6b` for version 6b and `data/ALASKA_7` for version 7.

### Alice: Embedding

Execute the Matlab code from `alice/create_stego.m` to create stego images from covers with J-UNIWARD at rate 0.4bpnzac. The outputs are stored in `data/ALASKA_*/stego_juniward_0.4`.

### Eve: Image preparation

As an input, Eve uses `data/ALASKA_*/cover` and `data/ALASKA_*/stego_juniward_0.4`, so Alice' part needs to be performed before this step.

Compress and decompress the input by different version by Eve.

```bash
# perform Eve using 6b and 7, when Alice used 6b
python eve/create_covers.py 6b
python eve/create_stego.py 6b
# perform Eve using 6b and 7, when Alice used 7
python eve/create_covers.py 7
python eve/create_stego.py 7
```

The compressed and decompressed images are stored in `data/ALASKA_*/cover_compressed6b` and `data/ALASKA_*/cover_decompressed6b` for Eve using version 6b and `data/ALASKA_*/cover_compressed7` and `data/ALASKA_*/cover_decompressed7` for Eve using version 7.

### Eve: Feature extraction

Execute the Matlab code from `eve/extract_jsrm.m` to extract JSRM features from input files. The output are following MAT files in `data/` directory for cover and stego objects.

- `data/C_jsrm_6b_6b.mat`
- `data/C_jsrm_7_7.mat`
- `data/C_jsrm_6b_7.mat`
- `data/C_jsrm_7_6b.mat`
- `data/S_jsrm_6b_6b_0.4.mat`
- `data/S_jsrm_7_7_0.4.mat`
- `data/S_jsrm_6b_7_0.4.mat`
- `data/S_jsrm_7_6b_0.4.mat`

These MAT files contain `C_jsrm` or `S_jsrm` object.

### Eve: Model training

Execute the Matlab code from `eve/train_model.m` to train the model and export it to a directory `model/`.

- `model/model_6b_6b_0.4.mat`
- `model/model_7_7_0.4.mat`
- `model/model_6b_7_0.4.mat`
- `model/model_7_6b_0.4.mat`

### Eve: Model evaluation

Execute the Matlab code from `eve/evaluate_model.m` to evaluate the model and print out the performance.

## Repository structure

The repository has following structure.

- `alice` = codebase for Alice
- `eve` = codebase for Eve
- `include` = shared codebase
- `data` = script for downloading data, destination for generated images
- `model` = trained models


## Reference

[2] M. Benes, N. Hofer, and R. Böhme. 2022. The Effect of the JPEG Implementation on the Cover-Source Mismatch Error in Image Steganalysis. In EUSIPCO. IEEE, ?-?.

[2] M. Benes, N. Hofer, and R. Böhme. 2022. Know Your Library: How the libjpeg Version Influences Compression and Decompression Results. In IH&MMSec. ACM, ?-?.
