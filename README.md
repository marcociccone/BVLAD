# BVLAD
This is a matlab implementation of the BVLAD descriptor

# Introduction
This is my Digital Image Processing project. The work is entirely based on the paper [CAMERA-BASED INDOOR POSITIONING USING SCALABLE STREAMING OF COMPRESSED BINARY IMAGE SIGNATURES](http://www.lmt.ei.tum.de/forschung/publikationen/dateien/van%20Opdenbosch2014Camera-basedIndoorPositioningusing.pdf)  
The project is meant to be an implementation of a indoor positioning system: giving a query image that is not present in the database the system will give you the most probable position in the building according to image that you presented. The dataset used for testing is the following <http://www.navvis.lmt.ei.tum.de/dataset/>


# How to run
* Put your DB of images in "cell\_imgs/\*.jpg" and your query image in 'query\_imgs/\*.jpg'
* First, generate the dictionary using compute_dictionary.m. To do that you will need tons of images and probably use parallel toolbox on matlab, by the way kmeans matlab function is not so optimized to work on many cores, you need to pay attenction and do a lot of tests.
* Extract the BVLAD features of your database of images using compute_cell.m
* If you want you can use the files that I provide for the test ('centroidi.mat' or 'centroidi15M.mat', and 'cell_db.mat')
* Use main_cell.m

#Bag of words
There is also an implementation using Bag of words (BoW) but it's not manteained, and it's only for testing.

#Authors
* Marco Ciccone <marco.ciccone@mail.polimi.it> or <marco.ciccone88@gmail.com>

* Riccardo Delegà <riccardo.delega@gmail.com>