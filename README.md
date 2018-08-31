# EgoHands Augmentations
[Yuval Nirkin](http://www.nirkin.com/), [Iacopo Masi](http://www-bcf.usc.edu/~iacopoma/), [Anh Tuan Tran](https://sites.google.com/site/anhttranusc/), [Tal Hassner](http://www.openu.ac.il/home/hassner/), and [Gerard Medioni](http://iris.usc.edu/people/medioni/index.html).

## Overview
Code for the hand augmentation, based on the data provided by the [EgoHands Project](http://vision.soic.indiana.edu/projects/egohands/), described in the paper:

Yuval Nirkin, Iacopo Masi, Anh Tuan Tran, Tal Hassner, Gerard Medioni, "[On Face Segmentation, Face Swapping, and Face Perception](https://arxiv.org/abs/1704.06729)", IEEE Conference on Automatic Face and Gesture Recognition (FG), Xi'an, China on May 2018

Please see [project page](http://www.openu.ac.il/home/hassner/projects/faceswap/) for more details, more resources and updates on this project.

If you find this code useful, please make sure to cite our paper in your work.

## Installation
- git clone https://github.com/YuvalNirkin/egohands_augmentations
- Download and extract [egohands_data.zip](http://vision.soic.indiana.edu/egohands_files/egohands_data.zip) from the [EgoHands Project](http://vision.soic.indiana.edu/projects/egohands/) to the root directory if you intend to filter the images yourself otherwise download and extract [selected.zip](https://github.com/YuvalNirkin/egohands_augmentations/releases/download/v1.0/selected.zip)

## Usage
```Matlab
extractHands('initial_extract');
mkdir selected

% Select good segmentations and copy them to "selected" together with their images
% or use the images from the "selected.zip" file

mkdir selected_transformed
transformHands('selected', 'selected_transformed');

mkdir selected_transformed_images
mkdir selected_transformed_segmentations
mv selected_transformed/*.jpg selected_transformed_images
mv selected_transformed/*.png selected_transformed_segmentations

% For a generic dataset use:
createHandAugmentations(<face_images_dir>,<face_segmentations_dir>, 'selected_transformed_images', 'selected_transformed_segmentations', <output_images_dir>, <output_segmentations_dir>);

% For LFW dataset use:
createLFWHandAugmentations(<lfw_root_dir>, 'selected_transformed_images', 'selected_transformed_segmentations', <output_dir>, 'hand_pixels', 2400)
```

## Citation

Please cite our paper with the following bibtex if you use found our code useful:

``` latex
@inproceedings{nirkin2018_faceswap,
      title={On Face Segmentation, Face Swapping, and Face Perception},
      booktitle = {IEEE Conference on Automatic Face and Gesture Recognition},
      author={Nirkin, Yuval and Masi, Iacopo and Tran, Anh Tuan and Hassner, Tal and Medioni, G\'{e}rard},
      year={2018},
    }
```

## Related projects
- [End-to-end, automatic face swapping pipeline](https://github.com/YuvalNirkin/face_swap), example application using out face segmentation method.
- [Deep face segmentation](https://github.com/YuvalNirkin/face_segmentation), used to segment face regions in the face swapping pipeline.
- [Interactive system for fast face segmentation ground truth labeling](https://github.com/YuvalNirkin/face_video_segment), used to produce the training set for our deep face segmentation.
- [CNN3DMM](http://www.openu.ac.il/home/hassner/projects/CNN3DMM/), used to estimate 3D face shapes from single images.
- [ResFace101](http://www.openu.ac.il/home/hassner/projects/augmented_faces/), deep face recognition used in the paper to test face swapping capabilities. 

## Copyright
Copyright 2017, Yuval Nirkin, Iacopo Masi, Anh Tuan Tran, Tal Hassner, and Gerard Medioni 

The SOFTWARE provided in this page is provided "as is", without any guarantee made as to its suitability or fitness for any particular use. It may contain bugs, so use of this tool is at your own risk. We take no responsibility for any damage of any sort that may unintentionally be caused through its use.
