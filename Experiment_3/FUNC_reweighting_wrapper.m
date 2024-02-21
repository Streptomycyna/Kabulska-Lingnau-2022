function [oneboot, ceiling_oneboot, oneboot_weights_full] = FUNC_reweighting_wrapper(refRDMs, model_RDMs, rw_options, cond_ids, subj_ids)
% Performs a single bootstrap sample in which multiple crossvalidation
% folds are performed. On each crossval fold, data are split into training
% and test portions, models are fitted to training portion, and
% tested on test portion. Intended to be embedded within a bootstrap loop,
% which supplies the indices of the selected subjects and conditions on
% this bootstrap

%% extract info from data
nConds = size(refRDMs,1);
nSubjs = size(refRDMs,3);
nWeights = size(model_RDMs.singFeatRDMs.RDM,2);
nThemeModels = length(model_RDMs.singThemeRDMs);
%% Cross-validation procedure
% create temporary storages for per-crossval fold results for each estimate
loop_store.singFeatRDMs = zeros([length(model_RDMs.singFeatRDMs), rw_options.nCVs]);
loop_store.rawRDM = zeros([1, rw_options.nCVs]);
loop_store.weightRawRDM = zeros([1, rw_options.nCVs]);
loop_store.singThemeRDMs = zeros([length(model_RDMs.singThemeRDMs), rw_options.nCVs]);

loop_store_ceilings.lower =  zeros([rw_options.nCVs,1]);
loop_store_ceilings.upper =  zeros([rw_options.nCVs,1]);

% cycle through crossvalidation procedure, which splits data into both separate
% stimuli and subject groups. This xval loop has the purpose of stabilising
% the estimates obtained within each bootstrap sample
for loop = 1:rw_options.nCVs
    
    %% 1. Preparation: split data into training and test partitions
    
    % STIMULI: We select exactly nTestImages that *are present* in this
    % bootstrap sample (and then sample multiply according to how many
    % times they are present in the sample)
    cond_ids_test = datasample(unique(cond_ids), rw_options.nTestImages, 'Replace', false);
    cond_ids_train = setdiff(unique(cond_ids),cond_ids_test); % use the others for training
    
    % find locations of where these are present in the bootstrapped sample,
    % and append to two lists of cond_id entries we're going to use for
    % training and testing. Note that these change size from boot to boot:
    cond_locs_test = [];
    for i = 1:length(cond_ids_test)
        cond_locs_test = [cond_locs_test, find(cond_ids==cond_ids_test(i))];
    end
    cond_locs_train = [];
    for i = 1:length(cond_ids_train)
        cond_locs_train = [cond_locs_train, find(cond_ids==cond_ids_train(i))];
    end
    
    % SUBJECTS: apply same logic here, only selecting *available* subjects
    subj_ids_test = datasample(unique(subj_ids), rw_options.nTestSubjects, 'Replace', false);
    subj_ids_train = setdiff(unique(subj_ids),subj_ids_test); % use the others for training
    
    % find locations of any of these present in the (possibly) bootstrapped sample,
    % and append to two lists of subj_id entries we're going to use for
    % training and testing:
    subj_locs_test = [];
    for i = 1:length(subj_ids_test)
        subj_locs_test = [subj_locs_test, find(subj_ids==subj_ids_test(i))];
    end
    subj_locs_train = [];
    for i = 1:length(subj_ids_train)
        subj_locs_train = [subj_locs_train, find(subj_ids==subj_ids_train(i))];
    end
    
    % training data
    c_sel_train = cond_ids(cond_locs_train);
    s_sel_train = subj_ids(subj_locs_train);
    dataRDM_train = refRDMs(c_sel_train,c_sel_train,s_sel_train);
    dataRDM_train = mean(dataRDM_train,3);
    % need to replace diagonals with zeros so we can use squareform
    dataRDM_train(logical(eye(size(dataRDM_train,1)))) = 0;
    dataRDM_train_ltv = squareform(dataRDM_train);
    
    % test data
    c_sel_test = cond_ids(cond_locs_test);
    s_sel_test = subj_ids(subj_locs_test);
    dataRDMs_test = refRDMs(c_sel_test,c_sel_test,s_sel_test);
    clear dataRDMs_test_ltv % to avoid problems with size changes from boot to boot
    for s = 1:size(dataRDMs_test,3)
        this_subj = dataRDMs_test(:,:,s);
        this_subj(logical(eye(size(this_subj,1)))) = 0;
        dataRDMs_test_ltv(s,:) = squareform(this_subj); 
    end
    
    % also create an RDM of ALL subjects' data for test images,
    % for calculating the UPPER bound of the noise ceiling
    dataRDMs_test_all_subjs = refRDMs(c_sel_test,c_sel_test,subj_ids); % nb. if bootstrapping Ss, this can contain duplicates
    for s = 1:size(dataRDMs_test_all_subjs,3)
       dataRDMs_test_all_subjs(:,:,s) = tiedrank(dataRDMs_test_all_subjs(:,:,s));
       %dataRDMs_test_one_subj = dataRDMs_test_all_subjs(:,:,s);
       %dataRDMs_test_one_subj(logical(eye(size(dataRDMs_test_one_subj,1)))) = 0;
       %dataRDMs_test_all_subjs(:,:,s) = squareform(tiedrank(squareform(dataRDMs_test_one_subj)));
    end
    
    dataRDMs_test_all_subjs = mean(dataRDMs_test_all_subjs,3); % we only ever need the mean
    dataRDMs_test_all_subjs(logical(eye(size(dataRDMs_test_all_subjs,1)))) = 0;
    dataRDMs_test_all_subjs_ltv = squareform(dataRDMs_test_all_subjs); 
    
    % ...plus an RDM of TRAINING subjects' data for TEST images,
    % for calculating the LOWER bound of the noise ceiling
    dataRDMs_test_train_subjs = refRDMs(c_sel_test,c_sel_test,s_sel_train); % nb. if bootstrapping Ss, this can contain duplicates - but cannot overlap w training data
    dataRDMs_test_train_subjs = mean(dataRDMs_test_train_subjs,3); % we only ever need the mean
    dataRDMs_test_train_subjs(logical(eye(size(dataRDMs_test_train_subjs,1)))) = 0;
    dataRDMs_test_train_subjs_ltv = squareform(dataRDMs_test_train_subjs); 
    
    % remove NaN columns from human test data because lsqnonneg function
    % doesn't handle NaNs, and we don't want to inflate our correlation
    % by setting the values to zeros. Provided we do the same to human and
    % model data we can simply remove  those pairwise comparisons -
    % i.e. this is removing same-image-comparison entries in the RDM
    dataRDM_train_ltv = dataRDM_train_ltv(~isnan(dataRDM_train_ltv));
    if size(dataRDMs_test_ltv,1) > 1 % multiple test subjects - eliminate by columns
        dataRDMs_test_ltv = dataRDMs_test_ltv(:,all(~isnan(dataRDMs_test_ltv)));
    else % just one subject - eliminate individual entries
        dataRDMs_test_ltv = dataRDMs_test_ltv(~isnan(dataRDMs_test_ltv));
    end
    dataRDMs_test_all_subjs_ltv = dataRDMs_test_all_subjs_ltv(~isnan(dataRDMs_test_all_subjs_ltv));
    dataRDMs_test_train_subjs_ltv = dataRDMs_test_train_subjs_ltv(~isnan(dataRDMs_test_train_subjs_ltv));
    

    % A. Calculate correlation for single feature models
    for thisModel = 1:nWeights
        singleFeature_test = model_RDMs.singFeatRDMs.RDM(thisModel).RDM;
        singleFeature_test(logical(eye(size(singleFeature_test,1)))) = NaN; % put NaNs in diagonal
        singleFeature_test = singleFeature_test(c_sel_test,c_sel_test); % resample rows and columns
        singleFeature_test(logical(eye(size(singleFeature_test,1)))) = 0; % put zeros in diagonal
        singleFeature_test_ltv = squareform(singleFeature_test); 
        singleFeature_test_ltv = singleFeature_test_ltv(~isnan(singleFeature_test_ltv)); % drop NaNs
        clear tm % very temp storage
        for test_subj = 1:size(dataRDMs_test_ltv,1)
            %tm(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(singleFeature_test_ltv)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');
            tm(test_subj) = corr(singleFeature_test_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
            %tm(test_subj) = corr(singleFeature_test_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Spearman');
        end
        % get means of the correlations over held-out subjects
        loop_store.singFeatRDMs(thisModel,loop) = mean(tm);
    end
    
    % B. Calculate correlation for raw feature model
    rawRDM_test = model_RDMs.rawRDM.RDM;
    rawRDM_test(logical(eye(size(rawRDM_test,1)))) = NaN; % put NaNs in diagonal
    rawRDM_test = rawRDM_test(c_sel_test,c_sel_test); % resample rows and columns
    rawRDM_test(logical(eye(size(rawRDM_test,1)))) = 0; % put zeros in diagonal
    rawRDM_test_ltv = squareform(rawRDM_test); 
    rawRDM_test_ltv = rawRDM_test_ltv(~isnan(rawRDM_test_ltv)); % drop NaNs
    clear tm % very temp storage
    for test_subj = 1:size(dataRDMs_test_ltv,1)
        %tm(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(rawRDM_test_ltv)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');
        tm(test_subj) = corr(rawRDM_test_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
    end
    % get means of the correlations over held-out subjects
    loop_store.rawRDM(1,loop) = mean(tm);
    
    % C. Calculate correlation for single theme models
    for thisModel = 1:nThemeModels
        singleTheme_test = model_RDMs.singThemeRDMs.RDM(thisModel).RDM;
        singleTheme_test(logical(eye(size(singleTheme_test,1)))) = NaN; % put NaNs in diagonal
        singleTheme_test = singleTheme_test(c_sel_test,c_sel_test); % resample rows and columns
        singleTheme_test(logical(eye(size(singleTheme_test,1)))) = 0; % put zeros in diagonal
        singleTheme_test_ltv = squareform(singleTheme_test); 
        singleTheme_test_ltv = singleTheme_test_ltv(~isnan(singleTheme_test_ltv)); % drop NaNs
        clear tm % very temp storage
        for test_subj = 1:size(dataRDMs_test_ltv,1)
            %tm(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(singleTheme_test_ltv)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');

            tm(test_subj) = corr(singleTheme_test_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
        end
        % get means of the correlations over held-out subjects
        loop_store.singThemeRDMs(thisModel,loop) = mean(tm);
    end
    
    % D. Calculated weights from the raw model and then the correlation
    clear modelRDMs_train_ltv modelRDMs_test_ltv
    for component = 1:length(model_RDMs.singFeatRDMs.RDM)
        cModelRDM_train = model_RDMs.singFeatRDMs.RDM(component).RDM;
        cModelRDM_train(logical(eye(size(cModelRDM_train,1)))) = NaN; % put NaNs in diagonal
        cModelRDM_train = cModelRDM_train(c_sel_train,c_sel_train); % resample rows and columns
        cModelRDM_train(logical(eye(size(cModelRDM_train,1)))) = 0; % put zeros in diagonal
        modelRDMs_train_ltv(:,component) = squareform(cModelRDM_train);
        %modelRDMs_train_ltv(:,component) = rankTransform(squareform(cModelRDM_train)); %% 03.02.2022
        
        cModelRDM_test = model_RDMs.singFeatRDMs.RDM(component).RDM;
        cModelRDM_test(logical(eye(size(cModelRDM_test,1)))) = NaN; % put NaNs in diagonal
        cModelRDM_test = cModelRDM_test(c_sel_test,c_sel_test); % resample rows and columns
        cModelRDM_test(logical(eye(size(cModelRDM_test,1)))) = 0; % put zeros in diagonal
        modelRDMs_test_ltv(:,component) = squareform(cModelRDM_test);
        %modelRDMs_test_ltv(:,component) = rankTransform(squareform(cModelRDM_test));

    end
    
    % do regression to estimate layer weights
    
    % dropping same-image-pair entries
    modelRDMs_train_ltv = modelRDMs_train_ltv(all(~isnan(modelRDMs_train_ltv),2),:); % as before, but with rows
    modelRDMs_test_ltv = modelRDMs_test_ltv(all(~isnan(modelRDMs_test_ltv),2),:);
    
    % main call to fitting library - this could be replaced with
    % glmnet for ridge regression, etc., but GLMnet is not compiled
    % to work in Matlab post ~2014ish.
    
    weights = lsqnonneg(double(modelRDMs_train_ltv), double(dataRDM_train_ltv'));
    weights_full(:,loop) = weights;
    % combine each layer in proportion to the estimated weights
    %raw_model_train_ltv_weighted = modelRDMs_train_ltv*weights;  
    raw_model_test_ltv_weighted = modelRDMs_test_ltv*weights;

    %raw_model_test_ltv_weighted = rankTransform(raw_model_test_ltv_weighted); 

    % calculate performance on the held out subjects and images
    
    % Now we have added the reweighted version to our list of models,
    % evaluate each one, along with the noise ceiling
    % - need to do this individually against each of the test Ss
    % Note that if bootstrapping Ss, the test subjects may not be
    % unique, but may contain duplicates. This equates to weighting
    % each subject's data according to how frequently it occurs in this
    % bootstrapped sample.
    clear tm % very temp storage
    for test_subj = 1:size(dataRDMs_test_ltv,1)
        %tm(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(raw_model_test_ltv_weighted)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');
        tm(test_subj) = corr(raw_model_test_ltv_weighted, dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
    end
    loop_store.weightRawRDM(1,loop) = mean(tm);
    
    %% 6. Estimate noise ceilings #####################
    clear tcl tcu % very temp storages
    for test_subj = 1:size(dataRDMs_test_ltv,1)
        % Model for lower bound = correlation between each subject and mean
        % of test data from TRAINING subjects (this captures a "perfectly fitted"
        % model, which has not been allowed to peek at any of the training Ss' data)
        %tcl(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(dataRDMs_test_train_subjs_ltv)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');
        tcl(test_subj) = corr(dataRDMs_test_train_subjs_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
        
        % Model for upper noise ceiling = correlation between each subject
        % and mean of ALL train and test subjects' data, including themselves (overfitted)
        
        %tcu(test_subj)=rankCorr_Kendall_taua(vectorizeRDMs(dataRDMs_test_all_subjs_ltv)',vectorizeRDMs(dataRDMs_test_ltv(test_subj,:))');
        tcu(test_subj) = corr(dataRDMs_test_all_subjs_ltv', dataRDMs_test_ltv(test_subj,:)', 'Type', 'Kendall');
    end
    loop_store_ceilings.lower(loop) = mean(tcl);
    loop_store_ceilings.upper(loop) = mean(tcu);
    
end % end of crossvalidation loops

% average over crossvalidation loops at the end of this bootstrap sample
oneboot_weights_full = mean(weights_full,2);
oneboot.singFeatRDMs = mean(loop_store.singFeatRDMs,2);
oneboot.rawRDM = mean(loop_store.rawRDM);
oneboot.weightRawRDM = mean(loop_store.weightRawRDM);
oneboot.singThemeRDMs = mean(loop_store.singThemeRDMs,2);

ceiling_oneboot.lower = mean(loop_store_ceilings.lower);
ceiling_oneboot.upper = mean(loop_store_ceilings.upper);

end
