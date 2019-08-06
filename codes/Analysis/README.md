## Analysis

The codes in this directory take a MATLAB table and produce a machine learning regression model with an output corresponding to the name. The workspaces are saved to the **objects/Workspaces** folder. From there, models can be evaluated by using the codes in the **codes/Postprocess/Plotter** folder. 

The code ensemble_Runner.m will run all codes in the directory. If possible, it is recoemmended that codes are run on a multi-core computer or server. The codes here are written for 16 available cores. This can be changed by updating the input of the parpool() function.

### Overview of Codes:

   1.  **Output**: Average Pupil Diameter (APD)     
        **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses<br>
        **code**:   codes/Analysis/APD_ensemble_MT.m <br>
        **table**:  objects/MinoltaTobii/Clean_APD_MT_Table.mat
   2.  **Output**: Left Pupil Diameter (LPD)<br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses<br>
        **code**:   codes/Analysis/LPD_ensemble_MT.m<br>
        **table**:  objects/MinoltaTobii/Clean_All_MT_Table.mat
   3.  **Output**: Right Pupil Diameter (RPD)<br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses<br>
        **code**:   codes/Analysis/RPD_ensemble_MT.m<br>
        **table**:  objects/MinoltaTobii/Clean_All_MT_Table.mat
   4.  **Output**: Pupil Diameter Difference (PDD)<br> **Inputs**:  Illuminance, Spectrum from 360 -- 780 nm in 1 nm bins, XYZ coordinates for gyroscope and accelerometer data in glasses<br>
        **code**:   codes/Analysis/PDD_ensemble_MT.m<br>
        **table**:  objects/MinoltaTobii/Clean_PDD_MT_Table.mat
   5.  **Output**: Illuminance (ILM)<br> **Input**:  Left pupil diameter, right pupil diameter, XYZ coordinates for gyroscope and accelerometer data in glasses <br> **code**:   codes/Analysis/ILM_ensemble_MT.m<br>
        **table**:  objects/MinoltaTobii/Clean_All_MT_Table.mat
