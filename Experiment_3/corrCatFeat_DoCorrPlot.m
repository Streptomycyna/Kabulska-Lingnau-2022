function corrCatFeat_DoCorrPlot
% Figure 4a and Figure S14
resDir = '~/Experiment_3/data';

%addpath('/Toolboxes/rsatoolbox-develop/+rsa');

import rsa.*
import rsa.fig.*
import rsa.fmri.*
import rsa.rdm.*
import rsa.sim.*
import rsa.spm.*
import rsa.stat.*
import rsa.util.*
userOptions.RDMrelatednessThreshold = 0.05;
userOptions.boot_options.nboots = 1000;

%% Do the graph
candidateNames = {'Upper limbs', 'Hands','Lower limbs',... 
    'Head','Mouth','Targeting a non-manipulable object',...
    'Targeting a manipulable object', 'Targeting a tool',...
    'Targeting a person','No object involved','Horizontal','Vertical',...
    'No movement','Unspecified trajectory','Circular arms','Circular legs',...
    'Rotating arms','Rotating legs','Abduction-Adduction arms','Abduction-Adduction legs',...
    'Sweeping arms','Sweeping legs','Up-Down arms','Up-Down legs',...
    'Straight posture', 'Bending', 'Sitting', 'Laying', 'No specific posture', 'Indoor', 'Outdoor',...
    'Keeping balance','Harm','Water','Season-dependence','Change of location','Duration','Contact with others',...
    'Pace','Use of force','Goal-directedness','Concentration','Noise','Valence', 'Unweighted multi-feature',...
    'Weighted multi-feature', 'Body parts' 'Object-directedness',...
    'Trajectory', 'Type of limb movement', 'Posture', 'Location'};
load(fullfile(resDir,'corrCatFeat/bootstrap_output_full_results'));
load(fullfile(resDir,'corrCatFeat/bootstrap_output_weights'));
load(fullfile(resDir,'corrCatFeat/bootstrap_output_ceilings'));
model_corrs  = [full_results.singFeatRDMs' full_results.rawRDMs' full_results.weightRawRDMs' full_results.singThemeRDMs'];
   
%y = mean(model_corrs,1);
y = nanmean(model_corrs,1);
thisInd = ~isnan(y);
candidateNames=candidateNames(thisInd);
[y_sorted,sortedIs]=sort(y(thisInd),'descend');
candidateNames = candidateNames(sortedIs);
stats_p_r.orderedCandidateRDMnames = candidateNames;

% Figure
nModels = length(y_sorted);
h = figure;
set(h, 'Color', 'w');
for barI = 1:nModels
    h=patch([barI-0.4 barI-0.4 barI+0.4 barI+0.4],[0 y_sorted(barI) y_sorted(barI) 0],[-0.01 -0.01 -0.01 -0.01],[68/225 131/225 149/225],'edgecolor','none');hold on;
    hold on
end


%% About the noise ceiling
low_ceiling_corrs = ceiling_results.lower;
upp_ceiling_corrs = ceiling_results.upper;
ceilingLowerBound = mean(ceiling_results.lower);
ceilingUpperBound = mean(ceiling_results.upper);
stats_p_r.ceiling = [ceilingLowerBound,ceilingUpperBound];

model_corrs = model_corrs(:,thisInd);

% CI 95%
data = model_corrs;
CI = prctile(data,[5,95]);
CI_sorted = CI(:,sortedIs);
CI_sorted_lb = y_sorted-CI_sorted(1,:);
CI_sorted_ub = CI_sorted(2,:)-y_sorted;
errorbar(1:nModels,y_sorted,CI_sorted_lb, CI_sorted_ub,'Color',[0 0 0],'LineWidth',...
    2,'LineStyle','none','CapSize',0)

set(gcf, 'Units', 'Inches', 'Position', [0, 0, 28, 10], 'PaperUnits', 'Inches', 'PaperSize', [20,12])

hold on

% calculate and store matrices of raw differences and statistical tests
% of differences between each pair of models
y = y(thisInd);
for testi = 1:nModels
    for testj = 1:nModels
        stats_p_r.candDifferences_r(testi,testj) = y(testi)-y(testj);
    end
end
stats_p_r.candDifferences_r = stats_p_r.candDifferences_r(sortedIs,sortedIs);

% TODO: implement alternatives to Bonferonni correction
% Current policy:
% - three sets of tests are performed. These are separately Bonferonni
% corrected within each set:
%   1. Each pair of models against one another.
%   2. Each model against zero (i.e. is it significantly correlated
%      with the reference RDM?)
%   3. Each model against the lower noise ceiling (i.e. do other
%      subjects explain significantly more variance than this model?)

%% Analysis 1 - pairwise model comparisons
% Option 1: with Bonferroni
% num_tests = (nModels*nModels - nModels)/2;
% thresh = userOptions.RDMrelatednessThreshold/num_tests;
% 
% model_vs_model = nan(nModels, nModels); % create matrix for storing pairwise model tests
% for m = 1:nModels
%     for n = 1:nModels
%         % calculate then test model-difference distribution
%         m_v_n_corrs = model_corrs(:,m) - model_corrs(:,n);
%         ci = quantile(m_v_n_corrs, [thresh/2, 1-(thresh/2)]); % two-tailed test of whether CI contains zero
%         if all(ci > 0) || all(ci < 0) % two-tailed test of whether CI contains zero
%             model_vs_model(m, n) = 0; % i.e. zero if IS significant
%         else
%             model_vs_model(m, n) = 1; % one if NOT significant
%         end
%     end
% end
% stats_p_r.candDifferences_p = model_vs_model(sortedIs,sortedIs);

% Option 2: with FDR (p-value) == from Nili's toolbox (+rsa/+stat/bootCofint)

nBoots = userOptions.boot_options.nboots;
model_vs_model = nan(nModels, nModels); % create matrix for storing pairwise model tests
for m = 1:nModels
    for n = 1:nModels
        % calculate then test model-difference distribution
        m_v_n_corrs = model_corrs(:,m) - model_corrs(:,n);
        % 'two-tailed': Two-tailed p-value for null hypothesis that true value
        % lies within confidence interval
        p = max((min(sum(m_v_n_corrs < 0), sum(m_v_n_corrs >= 0)) / nBoots) * 2, 1/nBoots);
        model_vs_model(m, n) = p;
        
    end
end

thresh = userOptions.RDMrelatednessThreshold;
pMat = model_vs_model;
pMat(logical(eye(nModels))) = 0;
allPairwisePs = squareform(pMat);

%Calculate new threshold after FDR (Nili's method)
threshold = FDRthreshold(allPairwisePs,thresh);
pmodel_vs_pmodel = nan(nModels, nModels); % create matrix for storing pairwise model tests

for m = 1:nModels
    for n = 1:nModels
        if model_vs_model(m, n) <= threshold 
            pmodel_vs_pmodel(m, n) = 0; % i.e. zero if IS significant
        else
            pmodel_vs_pmodel(m, n) = 1; % one if NOT significant
        end
    end
end

model_vs_model=pmodel_vs_pmodel;
stats_p_r.candDifferences_p = model_vs_model(sortedIs,sortedIs);


% Analysis 2 - models vs zero
nBoots = userOptions.boot_options.nboots;
model_vs_zero = ones(1,nModels); 

for m = 1:nModels
    B = model_corrs(:,m);
    % One-tailed p-value for testing whether model CI > zero
    p = max(sum(B < 0) / nBoots, 1/nBoots);
    model_vs_zero(m) = p;  
end
threshold_FDR = mafdr(model_vs_zero, 'BHFDR',true);  
this_signif = find(threshold_FDR < 0.05);  
pmodel_vs_zero = ones(1,nModels); % create matrix for storing pairwise model tests
pmodel_vs_zero(this_signif) = 0;
model_vs_zero = pmodel_vs_zero;
stats_p_r.candRelatedness_p = model_vs_zero(sortedIs);


% Analysis 3 - models vs lower ceiling
model_vs_ceil = ones(1,nModels);
for m = 1:nModels
    m_v_c_corrs = low_ceiling_corrs - model_corrs(:,m);
    % One-tailed p-value for testing whether ceiling vs model CI > zero
    p = max(sum(m_v_c_corrs < 0) / nBoots, 1/nBoots);
    model_vs_ceil(m) = p;  
end
threshold_FDR = mafdr(model_vs_ceil, 'BHFDR',true);  
this_signif = find(threshold_FDR < 0.05);  
pmodel_vs_ceil = ones(1,nModels); % create matrix for storing pairwise model tests
pmodel_vs_ceil(this_signif) = 0;
model_vs_ceil = pmodel_vs_ceil;
stats_p_r.ceilingRelatedness_p = model_vs_ceil(sortedIs);


%% display the ceiling
set(gcf,'Renderer','OpenGL');

h=patch([0.1 0.1 nModels+1 nModels+1],[ceilingLowerBound ceilingUpperBound ceilingUpperBound ceilingLowerBound],[0.1 0.1 0.1 0.1],[.7 .7 .7],'edgecolor','none');hold on;
alpha(h, 0.5);

%% add the significance indicators from RDM relatedness tests to plots
ps = stats_p_r.candRelatedness_p(1,:);

pStringCell = cell(1, nModels);

% TODO: make correction selection options compatible with reweighting
% procedure (or warn clearly that they have no effect if using
% reweighting)
% For 'userOptions.reweighting == true'
% in this case we want to use the tests we've already calculated
thresh = 0.5; % hack so that all entries == 0 will be classed as significant, and all == 1 will not

for test = 1:nModels
    if ps(test) <= thresh
        pStringCell{test} = '*';
    else
        pStringCell{test} = '';
    end
end%for:test

for test = 1:nModels % was -0.03
    text(test, -0.1, ['\bf\fontsize{14}',deunderscore(pStringCell{test})], 'Rotation', 0, 'Color', [0 0 0],'HorizontalAlignment','center');
end


%% if using reweighting option, add the significance indicators from noise ceiling tests to plots

ps = stats_p_r.ceilingRelatedness_p(1,:);

pStringCell = cell(1, nModels);
% we want to use the tests we've already calculated
thresh = 0.5; % hack so that all entries == 0 will be classed as significant, and all == 1 will not

for test = 1:nModels
    if ps(test) <= thresh
        pStringCell{test} = '*';
    else
        pStringCell{test} = 'ns';
    end
end%for:test

for test = 1:nModels
    text(test, ceilingLowerBound+0.02, ['\bf\fontsize{11}',deunderscore(pStringCell{test})], 'Rotation', 0, 'Color', [0.2 0.2 0.2],'HorizontalAlignment','center');
end

%% label the bars with the names of the candidate RDMs

Ymin = 0;
for test = 1:nModels
    text(test, Ymin-0.17, [deunderscore(candidateNames{test})], 'Rotation', 45, 'Color', [0 0 0],'HorizontalAlignment','right');
end

%% add the pairwise comparison horizontal lines

% for 'userOptions.reweighting == true'
% in this case we want to use the tests we've already calculated
threshold = 0.5; % hack so that all entries == 0 will be counted as significant, and all == 1 will not
yy=addComparisonBars(stats_p_r.candDifferences_p,(ceilingUpperBound+0.1),threshold);
cYLim = get(gca, 'YLim');
cYMax = cYLim(2);
labelBase = cYMax + 0.1;
nYMax = labelBase;
nYLim = [0, nYMax];
set(gca, 'YLim', nYLim);
hold on;

maxYTickI=ceil(max([y_sorted ceilingUpperBound])*10);
% set(gca,'YTick',[0 1:maxYTickI]./10);
% set(gca,'XTick',[]);
axis off;

% plot pretty vertical axis
lw=1;
for YTickI=0:maxYTickI
    plot([0 0.1],[YTickI YTickI]./10,'k','LineWidth',lw);
    text(0,double(YTickI/10),num2str(YTickI/10,1),'HorizontalAlignment','right');
end
plot([0.1 0.1],[0 YTickI]./10,'k','LineWidth',lw);
text(-1.2,double(maxYTickI/10/2),{'RDM correlation ',['\rm[mean Kendall \tau \alpha corr. across ', deunderscore(num2str(userOptions.boot_options.nboots)), ' bootstraps]']},'HorizontalAlignment','center','Rotation',90);

if ~exist('yy','var')
    ylim([Ymin max(y_sorted)+max(es)+.05]);
else
    ylim([Ymin yy+.1]);
end

%title({['\bf\fontsize{11} How closely is the reference RDM related to each of the candidate RDMs?'],['\rm Using bootstrapped reweighting procedure.']})

axis square
h=get(gcf,'Position');
h(4)=h(4)+100;

axis([0 nModels+0.5 -0.5 yy+0.1]);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 15, 13], 'PaperUnits', 'Inches', 'PaperSize', [20,20])

savefig(fullfile(resDir, 'corrCatFeat/corr_cand2ref_52featModels.fig'))
saveas(gcf,fullfile(resDir, 'corrCatFeat/corr_cand2ref_52featModels.svg'))
saveas(gcf,fullfile(resDir, 'corrCatFeat/corr_cand2ref_52featModels.jpg'))

end

