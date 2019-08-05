## Plotters

The codes in this folder can be used to evaluate the machine learning regression models and visualize the data. An overview of the codes is given below. Plots are saved by type in the **codes/Postprocess/Plotters/Plots** folder.

1. **code**: ensemble_Plotter.m <br> **Description**: Plots and saves an error histogram, predictor importance ranking, and scatter plot for the APD, LPD, RPD, PDD, and ILM models based on the true and estimated values of each dependant variable.
2. **code**: ensemble_oppMdl_Plotter.m <br> **Description**: Plots and saves an error histogram, predictor importance ranking, and scatter plot for the prediction of the LPD using the RPD model and vice-versa.
3. **code**: ensemble_oppMdl_Setup.m <br> **Description**: Creates a workspace with the LPD model and the true RPD values. To get a workspace with the RPD model and the true values for the LPD, the order in which the workspaces are loaded must be switched manually.
4. **code**: spectralContourPlot3_withPD2.m <br> **Description**: Plots the spectrum over time for each trial with the left and right pupil diameters plotted underneath. Spectral data is normalized by dividing values by the maximum value within each trial.

### Example Plots

Scatter plot for average pupil diameter model.

![picture alt](https://github.com/mi3nts/LightOcular/blob/master/codes/Postprocess/Plotters/Plots/examplePlots/Average%20Pupil%20Diameter_Ensemble_Scatter2.png?raw=true)

Predictor importance ranking for average pupil diameter model.

![picture alt](https://github.com/mi3nts/LightOcular/blob/master/codes/Postprocess/Plotters/Plots/examplePlots/Average%20Pupil%20Diameter_Ensemble_ImpRank_T20.png?raw=true)
