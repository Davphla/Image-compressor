# Image compressor

The Image Compressor consist of a simple k-means clustering algorithm in order to compress images.
It is written in Haskell.


## How to build

The Image Compressor is built using the Haskell Stack tool. To build it, simply run:

    make
    ,/imageCompressor -N 10 -L 0.1 -F image.png


## How to use

The Image Compressor is a simple command line tool. It takes the following arguments:

* `-N`: The number of clusters to use.

* `-L`: Convergence limit.

* `-F`: Path to the image to compress.

* `-h` or `--help`: Show the help message.


## Result :trophy:

|                          Label                        |      Note       |
|:----------------------------------------------------------:|:------------------:|
|           All | 47 / 52 |


