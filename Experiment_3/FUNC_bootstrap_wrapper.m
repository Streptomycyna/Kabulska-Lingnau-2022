function [full_results, ceiling_results,full_weights] = FUNC_bootstrap_wrapper(refRDMs, model_RDMs, highlevel_options)
% Bootstrap resamples conditions and/or subjects and passes the resampled
% data to another function to perform crossvalidated reweighting of the
% component model RDMs.
% -- can feed a "sampling_order" to, to use pre-specified boot samples

% create temporary storages accessible within parfoor loop
tmp_full_weights = zeros(length(model_RDMs.singFeatRDMs.RDM),highlevel_options.boot_options.nboots);
tmp_full_singFeatRDMs = zeros([length(model_RDMs.singFeatRDMs.RDM),highlevel_options.boot_options.nboots]);
tmp_full_rawRDM = zeros([1,highlevel_options.boot_options.nboots]);
tmp_full_weightRawRDM = zeros([1,highlevel_options.boot_options.nboots]);
tmp_full_singThemeRDMs = zeros([length(model_RDMs.singThemeRDMs.RDM),highlevel_options.boot_options.nboots]);

tmp_ceiling_lower = zeros([highlevel_options.boot_options.nboots,1]);
tmp_ceiling_upper = zeros([highlevel_options.boot_options.nboots,1]);

for boot = 1:highlevel_options.boot_options.nboots %parfor
    fprintf(' %d ... ',boot)
    
    cond_ids = 1:size(refRDMs,1);
    subj_ids = 1:size(refRDMs,3);

    % Calculates results for a single bootstrap sample:
    [oneboot, ceiling_oneboot,oneboot_weights_full] = FUNC_reweighting_wrapper(refRDMs, model_RDMs, highlevel_options.rw_options, cond_ids, subj_ids); % only needs sampling order info for this boot
    
    tmp_full_weights(:,boot) = oneboot_weights_full;
    tmp_full_singFeatRDMs(:,boot) = oneboot.singFeatRDMs;
    tmp_full_rawRDM(1,boot) = oneboot.rawRDM;
    tmp_full_weightRawRDM(:,boot) = oneboot.weightRawRDM;
    tmp_full_singThemeRDMs(:,boot) = oneboot.singThemeRDMs;
    
    tmp_ceiling_lower(boot) = ceiling_oneboot.lower;
    tmp_ceiling_upper(boot) = ceiling_oneboot.upper;

end

% assign temporary values to structures
full_weights = tmp_full_weights;
full_results.singFeatRDMs = tmp_full_singFeatRDMs;
full_results.rawRDMs = tmp_full_rawRDM;
full_results.weightRawRDMs = tmp_full_weightRawRDM;
full_results.singThemeRDMs = tmp_full_singThemeRDMs;

ceiling_results.lower = tmp_ceiling_lower;
ceiling_results.upper = tmp_ceiling_upper;
end