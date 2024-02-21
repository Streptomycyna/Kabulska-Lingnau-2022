function corrCatFeat_DoWeightPlot
% Figure 4b
resDir = '~/Experiment_3/data';

load(fullfile(resDir,'corrCatFeat/bootstrap_output_weights'));
load(fullfile(resDir,'corrCatFeat/bootstrap_output_full_results'));

nameFeatures = {'Upper limbs', 'Hands','Lower limbs',... 
    'Head','Mouth','Targeting a mon-manipulable object',...
    'Targeting a manipulable object', 'Targeting a tool',...
    'Targeting a person','No object involved','Horizontal','Vertical',...
    'No movement','Unspecified trajectory','Circular arms','Circular legs',...
    'Rotating arms','Rotating legs','Abduction-Adduction arms','Abduction-Adduction legs',...
    'Sweeping arms','Sweeping legs','Up-Down arms','Up-Down legs',...
    'Straight posture', 'Bending', 'Sitting', 'Laying', 'No specific posture', 'Indoor', 'Outdoor',...
    'Keeping balance','Harm','Water','Season-dependence','Change of location','Duration','Contact with others',...
    'Pace','Use of force','Goal-directedness','Concentration','Noise','Valence'};
 
weights_avg = mean(full_weights,2);
%thisInd = ~isnan(y_weights);
thisInd=find(weights_avg);

weights_avg_selected = weights_avg(thisInd);
nameFeatures_selected = nameFeatures(thisInd);
full_weights_selected = full_weights(thisInd,:);

[val, indSorted]=sort(weights_avg_selected, 'descend');

% CI 95%
data = full_weights_selected';
CI = prctile(data,[5,95]);
CI_sorted = CI(:,indSorted');

val=val';
figure
bar(val)
set(gca, 'xtick', [1:1:length(nameFeatures_selected)]);
set(gca,'ticklength',[0 0]);
set(gca, 'xticklabel', nameFeatures_selected(indSorted));
rotateXLabels(gca, 45);
hxlab=xlabel('Features');
hylab=ylabel('Weights');
set(hxlab, 'Fontsize', 22);
set(hylab, 'Fontsize', 22);
hold on

% % If standaed error
% er = errorbar(val,stderrorSelected(indSorted))
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% % If confidence interval
CI_sorted_lb = val-CI_sorted(1,:);
CI_sorted_ub = CI_sorted(2,:)-val;
er = errorbar(1:length(val),val,CI_sorted_lb, CI_sorted_ub)
er.Color = [0 0 0];
er.LineStyle = 'none';
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 28, 10], 'PaperUnits', 'Inches', 'PaperSize', [20,12])
box off

savefig(fullfile(resDir, 'corrCatFeat/FeatureWeights-NonNegatLeastSq.fig'))
saveas(gcf,fullfile(resDir, 'corrCatFeat/FeatureWeights-NonNegatLeastSq.svg'))
saveas(gcf,fullfile(resDir, 'corrCatFeat/FeatureWeights-NonNegatLeastSq.jpg'))

close all

end

