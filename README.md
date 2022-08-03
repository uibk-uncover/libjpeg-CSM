# Effect of libjpeg version on CSM

This is the code repository for the paper The Effect of the JPEG Implementation on the Cover-Source Mismatch Error in Image Steganalysis [1]. It contains the codebase to replicate the CSM caused by a mismatch in libjpeg versions, which was described in our previous paper [2].
## Setup

This codebase uses Python and Matlab.

### Python

The code was executed on Python 3.8.11. Install dependencies with

```bash
pip3 install jpeglib==0.10.11 pillow==9.0.0 numpy==1.19.5
```

### Matlab

Matlab is executed locally in a Matlab environment.

You need the Matlab JPEG Toolbox by Phil Sallee. Prebuilt versions have been [published](https://digitnet.github.io/jpeg-toolbox/), or you can build it from source. In that case, you need to include and link libjpeg.

```matlab
mex -I/usr/local/include -I./include/jpegtbx include/jpegtbx/jpeg_read.c -L/usr/local/lib -ljpeg -v
mex -I/usr/local/include -I./include/jpegtbx include/jpegtbx/jpeg_write.c -L/usr/local/lib -ljpeg -v
```

In Matlab, you need to add `alice/`, `eve/` and `include` directories to path.


## Usage

We use the Python package `jpeglib` that allows the selection of the libjpeg version for compression and decompression.
However, for J-UNIWARD embedding, JSRM feature extraction and EFLD model training and evaluation we use the implementation of DDE/Jessica Fridrich [3].

### Alice: Downloading data

As pre-compressed covers $x_{\text{src}}$ we use the ALASKA2 dataset [4]. As it has around 16GB, you will have to download it directly from the original repository of the [ALASKA2 steganalysis challenge](https://alaska.utt.fr/).

Downloading can be done by

```bash
bash data/ALASKA_v2_TIFF_256_COLOR.sh
```

The script `data/ALASKA_v2_TIFF_256_COLOR.sh` was provided by the authors of the ALASKA2 steganalysis challenge. The dataset is stored in `data/ALASKA_v2_TIFF_256_COLOR`.

### Alice: Cover preparation

Once you downloaded the data, you have to compress and decompress it by different versions for Alice. In this step, 10,000 random data samples are drawn.

```bash
# perform Alice using 6b
python alice/create_covers.py 6b
# perform Alice using 7
python alice/create_covers.py 7
```

The compressed and decompressed images are stored in `data/ALASKA_6b` for version 6b and `data/ALASKA_7` for version 7.

### Alice: Embedding

Execute the Matlab code from `alice/create_stego.m` to create stego images from the covers with J-UNIWARD at rate 0.4bpnzac. The outputs are stored in `data/ALASKA_*/stego_juniward_0.4`.

### Eve: Image preparation

As an input, Eve uses `data/ALASKA_*/cover` and `data/ALASKA_*/stego_juniward_0.4`, so Alice' part needs to be performed before this step.

Compress and decompress the input with different libjpeg versions for Eve.

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

Execute the Matlab code from `eve/extract_jsrm.m` to extract JSRM features from the input files.

This will output the following MAT files in `data/` for cover and stego objects.

- `data/C_jsrm_6b_6b.mat`
- `data/C_jsrm_7_7.mat`
- `data/C_jsrm_6b_7.mat`
- `data/C_jsrm_7_6b.mat`
- `data/S_jsrm_6b_6b_0.4.mat`
- `data/S_jsrm_7_7_0.4.mat`
- `data/S_jsrm_6b_7_0.4.mat`
- `data/S_jsrm_7_6b_0.4.mat`

These MAT files contain either `C_jsrm` or `S_jsrm` objects.

### Eve: Model training

Execute the Matlab code from `eve/train_model.m` to train the model. Trained models are saved in the directory `model/`.

- `model/model_6b_6b_0.4.mat`
- `model/model_7_7_0.4.mat`
- `model/model_6b_7_0.4.mat`
- `model/model_7_6b_0.4.mat`

### Eve: Model evaluation

Execute the Matlab code from `eve/evaluate_model.m` to evaluate the model and print its performance.

## Repository structure

The repository has the following structure.

- `alice` = codebase for Alice
- `eve` = codebase for Eve
- `include` = shared codebase
- `data` = script for downloading data, destination for generated images
- `model` = trained models


## Reference

[1] Beneš, M., Hofer, N., and Böhme, R. The Effect of the JPEG Implementation on the Cover-Source Mismatch Error in Image Steganalysis. In Proceedings of the 30th European Signal Processing Conference (EUSIPCO). EURASIP, Belgrade, Serbia, 2022. [[PDF]](https://informationsecurity.uibk.ac.at/pdfs/BHB2022_EUSIPCO.pdf) [[Video]](https://www.youtube.com/watch?v=dZ7bDWldgiE)

[2] Beneš, M., Hofer, N., and Böhme, R. Know Your Library: How the libjpeg Version Influences Compression and Decompression Results. In Proceedings of the 10th ACM Workshop on Information Hiding and Multimedia Security (IH&MMSEC). ACM, 2022, pp. 19–25. [[PDF]](https://informationsecurity.uibk.ac.at/pdfs/BHB2022_IHMMSEC.pdf) [[Publisher]](https://dl.acm.org/doi/10.1145/3531536.3532962)

[3] Digital Data Embedding Laboratory. Department of Electrical and Computer Engineering. Binghamton University. [[URL]](http://dde.binghamton.edu/download/)

[4] Cogranne, R., Giboulot, Q., and Bas, P. The ALASKA Steganalysis Challenge: A First Step Towards Steganalysis “Into The Wild. In Proceedings of the ACM Workshop on Information Hiding and Multimedia Security (IH&MMSec). ACM, 2019, pp. 125-137. [[PDF]](https://hal.archives-ouvertes.fr/hal-02147763/document) [[Publisher]](https://doi.org/10.1145/3335203.3335726)