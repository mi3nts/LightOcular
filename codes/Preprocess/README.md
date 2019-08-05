## Preprocess

Codes in this directory can be used to prepare raw data from the Konica Minolta CL-500A Illuminance Spectrophotometer and Tobii Pro Glasses 2. More information on specific codes can be found in the corresponding README file.

An overview of the data preparation process is as follows:

   1. Raw data is stored in the folder **raw**
   2. Data is read into Matlab using the codes located in the folder **codes/Preprocess/Read**
   3. Light and ocular data tables are synchronized for each trial using the codes located in the folder **codes/Preprocess/MergeAndSync**
   4. Data tables for all trials are concatenated using the codes located in the folder **codes/Preprocess/MergeRuns**
   5. Merged table is cleaned using the codes located in the folder **codes/Preprocess/DataCleaner**
   6. New variables (average pupil diameter and pupil diameter difference) are generated from the cleaned data using the codes located in the folder **codes/Preprocess/VariableGeneration**
