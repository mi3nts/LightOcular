## DataCleaner

This code "cleans" the output of **codes/Preprocess/MergeRuns/Minolta_Tobii_MergeRuns.m**. Specfically, the error variables from the Tobii data are evaluated, and any records returning an error (a non-zero value) are removed. Additionally, any records with a pupil diameter of 0 are removed. Finally, the error variables are removed from the data table. 
