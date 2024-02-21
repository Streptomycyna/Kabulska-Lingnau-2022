%% Generate flat Plots
% Figure 3 and Figure S12
resDir = '~/Experiment_3/data';

nCategories = 11;
for i =12:nCategories
    catOne = i;
    catTwo = 2; %For the 'categoryVsRest_zscores', this doesn't matter
    type = 'categoryVsRest_zscores';% twoCategories, categoryVsRest_zscores, categoryVsRest_mean, categoryVsRest_WelchTest
    correctionMethod = 'FDR'; % 'Bonferroni' or 'FDR'

    quantitativePlots_calculate(catOne, catTwo, type,resDir,correctionMethod)
    quantitativePlots_visualize(catOne, catTwo, type,resDir,correctionMethod)
end
