# LightOcular

This repository contains codes and data for the in-review paper: Modeling Autonomic Pupillary Responses from External Stimuli Using Machine Learning. The data consists of spectral and pupillometric data collected during 3 outdoor/indoor walks using the Konica Minolta CL-500A Illuminance Spectrophotometer and Tobii Pro Glasses 2. Please be advised, files are designed to work in the directory structure of the repository, please use caution when moving and hacking codes. Although codes are commented for clarity, the codes here were not particularly written for public use, and therefore may be not be optimal or user friendly. Please post any issues in the "Issues" section of this repo, or feel free to contact the author directly: Shawhin Talebi -  shawhin.talebi@utdallas.edu

## Pre-processing

An overview of the data preparation process is as follows:

   1. Raw data is stored in the folder **raw**
   2. Data is read into Matlab using the codes located in the folder **codes/Preprocess/Read**
   3. Light and ocular data tables are synchronized for each trial using the codes located in the folder **codes/Preprocess/MergeAndSync**
   4. Data tables for all trials are concatenated using the codes located in the folder **codes/Preprocess/MergeRuns**
   5. Merged table is cleaned using the codes located in the folder **codes/Preprocess/DataCleaner**
   6. New variables (average pupil diameter and pupil diameter difference) are generated from the cleaned data using the codes located in the folder **codes/Preprocess/VariableGeneration**

## Analysis

The inputs and outputs of the five different machine learning regression models are given below. For all models 90% of data was used in training and 10% was used in testing. The fitrensemble function was used to train all the models.

   1.  **Output**: Average Pupil Diameter       
        **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses <br>
        **code**:   codes/Analysis/APD_ensemble_MT.m
   2.  **Output**: Left Pupil Diameter <br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses
        **code**:   codes/Analysis/LPD_ensemble_MT.m
   3.  **Output**: Right Pupil Diameter <br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses
        **code**:   codes/Analysis/RPD_ensemble_MT.m
   4.  **Output**: Pupil Diameter Difference <br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses
        **code**:   codes/Analysis/PDD_ensemble_MT.m
   5.  **Output**: Illuminance <br> **Inputs**:  Left pupil diameter, right pupil diameter, XYZ coordinates for gyroscope and accelerometer data in glasses <br> **code**:   codes/Analysis/ILM_ensemble_MT.m
        
## Post-processing

Codes to plot data are given in folder **codes/Postprocess/Plotters**

## Data store

Data can be found at: **10.5281/zenodo.3354602**
