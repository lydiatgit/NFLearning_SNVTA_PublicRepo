% This script extracts timeseries from dlPFC and SNVTA for reviewer
% analysis
clear all;
clc;

%Define StudySets
% Cofeed Data
studyset = struct;

% experiment folder
paths.output_path_base = '/media/sf_Share_NeuroDebian/data_james/analysis/';
studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
studyset(1).paths.first_level_folder = 'stats_mni_allruns';
studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';

% subjlist to be included
% subjects
subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(1).subjects = subjects_description.SubjID_sort(:);

studyset(1).dcm_template_folder = {'/media/sf_Share_NeuroDebian/data_james/analysis/JSD_100_A030212P/stats_mni_allruns'};

subjects_description2 = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(2).subjects = subjects_description2.SubjectID(:);
% TODO check HEALTHY ONLY
bool_group_intervention = subjects_description2.HealthyControl(:);
studyset(2).subjects = studyset(2).subjects(bool_group_intervention==1);

studyset(2).dcm_template_folder = {'/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/CoFeed_60_U150216I/stats_mni_allruns_newreg6'};

% notes about DCM theory
% 1) Model selection -> take winner model by parameter averaging, BPA is
% equivalent to fixed effects analysis, prior is winning model
% 2) Bayesina Modell averaging
% no fix model since every subject might use another one (likely within cognitive tasks)
% weighted average from all models over all subjects
% -> group stats weights models of often used ones, which avoids problem of local optima by
% averaging out them

for indGLMregressor =  1:1
    for indModelSpec = 1:1
        for indRun = 4
            
            
            % 1 -> voi exctract
            % 2 -> input specification
            % 3 -> DCM estimate
            dcm_part_todo = 3;
            
            % which regressor
            % 1 - UP and DOWN
            % 2 - UP only
            GLM_regressor = indGLMregressor;
            
            % model specification
            % 1 - mod effects
            % 2 - no mod effects
            model_spec_modefects = indModelSpec;
            
            % driving input
            % dlPFC and SN/VTA - ''
            % dlPFC only - 'DIdlPFC'
            driving_input_spec = '_DIdlPFC2';
            
            
            % which run to analyse
            dcm_run_to_analyse = indRun;
            
            %% Now do the job
            dcm_model_names = {};
            region_spec_input_val = {0 0 0};
            if (2 == dcm_run_to_analyse)
                if (1 == model_spec_modefects)
                    if (1 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r2_Model1_modeffects%s', driving_input_spec), sprintf('DCM_DCM_r2_Model2_modeffects%s', driving_input_spec), sprintf('DCM_DCM_r2_Model3_modeffects%s', driving_input_spec)};
                        region_spec_input_val = {0 1 1};
                    elseif (2 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r2_Model1_modeffects_UP%s', driving_input_spec), sprintf('DCM_DCM_r2_Model2_modeffects_UP%s', driving_input_spec), sprintf('DCM_DCM_r2_Model3_modeffects_UP%s', driving_input_spec)};
                        region_spec_input_val = {0 0 1};
                    end
                else
                    if (1 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r2_Model1%s', driving_input_spec), sprintf('DCM_DCM_r2_Model2%s', driving_input_spec), sprintf('DCM_DCM_r2_Model3%s', driving_input_spec)};
                        region_spec_input_val = {0 1 1};
                    elseif (2 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r2_Model1_UP%s', driving_input_spec), sprintf('DCM_DCM_r2_Model2_UP%s', driving_input_spec), sprintf('DCM_DCM_r2_Model3_UP%s', driving_input_spec)};
                        region_spec_input_val = {0 0 1};
                    end
                end
                studyset(2).session = 2;
                studyset(1).session = 2;
            elseif (4 == dcm_run_to_analyse)
                if (1 == model_spec_modefects)
                    if (1 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r4_Model1_modeffects%s', driving_input_spec), sprintf('DCM_DCM_r4_Model2_modeffects%s', driving_input_spec), sprintf('DCM_DCM_r4_Model3_modeffects%s', driving_input_spec)};
                        region_spec_input_val = {0 1 1};
                    elseif (2 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r4_Model1_modeffects_UP%s', driving_input_spec), sprintf('DCM_DCM_r4_Model2_modeffects_UP%s', driving_input_spec), sprintf('DCM_DCM_r4_Model3_modeffects_UP%s', driving_input_spec)};
                        region_spec_input_val = {0 0 1};
                    end
                else
                    if (1 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r4_Model1%s', driving_input_spec), sprintf('DCM_DCM_r4_Model2%s', driving_input_spec), sprintf('DCM_DCM_r4_Model3%s', driving_input_spec)};
                        region_spec_input_val = {0 1 1};
                    elseif (2 == GLM_regressor)
                        dcm_model_names = {sprintf('DCM_DCM_r4_Model1_UP%s', driving_input_spec), sprintf('DCM_DCM_r4_Model2_UP%s', driving_input_spec), sprintf('DCM_DCM_r4_Model3_UP%s', driving_input_spec)};
                        region_spec_input_val = {0 0 1};
                    end
                end
                studyset(2).session = 3;
                studyset(1).session = 4;
                %
            else
                disp('model names undefined for this run')
                return;
            end
            
            for indStudysetSubjects = 1:numel(studyset)
                
                current_subjects = studyset(indStudysetSubjects).subjects;
                current_session =  studyset(indStudysetSubjects).session;
                
                current_run = dcm_run_to_analyse;
                
                for  indSubj = 1:length(current_subjects)
                    
                    subjID = cell2mat(current_subjects(indSubj));
                    % voi extract did not work for 114, so exlcude it for anything
                    % further
                    if (1 == strcmp('JSD_114_T091212M', subjID))
                        continue;
                    end
                    current_path = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder);
                    
                    
                    
                    matlabbatch = {};
                    if (1 == dcm_part_todo)
                        % create matlabbatch for VOI extraction
                        matlabbatch{1}.spm.util.voi.spmmat = cellstr(fullfile(current_path, 'SPM.mat'));
                        matlabbatch{1}.spm.util.voi.adjust = 1;
                        matlabbatch{1}.spm.util.voi.session = current_session;
                        matlabbatch{1}.spm.util.voi.name = 'dlPFC';
                        matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [40 10 38];
                        matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 10;
                        matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.spmmat = {''};
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.contrast = 1;
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.conjunction = 1;
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.thresh = 0.05;
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.extent = 0;
                        matlabbatch{1}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
                        matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
                        matlabbatch{2}.spm.util.voi.spmmat = cellstr(fullfile(current_path, 'SPM.mat'));
                        matlabbatch{2}.spm.util.voi.adjust = 1;
                        matlabbatch{2}.spm.util.voi.session = current_session;
                        matlabbatch{2}.spm.util.voi.name = 'SNVTA';
                        matlabbatch{2}.spm.util.voi.roi{1}.sphere.centre = [-2 -16 -15];
                        matlabbatch{2}.spm.util.voi.roi{1}.sphere.radius = 10;
                        matlabbatch{2}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.spmmat = {''};
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.contrast = 1;
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.conjunction = 1;
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.threshdesc = 'none';
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.thresh = 0.05;
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.extent = 0;
                        matlabbatch{2}.spm.util.voi.roi{2}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
                        matlabbatch{2}.spm.util.voi.expression = 'i1&i2';
                        
                        % save the batch
                        
                        matlab.io.saveVariablesToScript(fullfile(current_path, sprintf('DCM_r%d_extract_vois_job.m', current_run)),'matlabbatch');
                        spm('defaults','fMRI');
                        % run the batch
                        spm_jobman('run', matlabbatch);
                    elseif (2 == dcm_part_todo)
                        disp(subjID);
                        % copy dcm_template to current participant except the template ones
                        for indModel = 1:3
                            current_dcm_model = indModel;
                            %current_dcm_template = cell2mat(fullfile(studyset(indStudysetSubjects).dcm_template_folder, dcm_model_names(current_dcm_model)));
                            current_dcm_template = cell2mat(fullfile(studyset(indStudysetSubjects).dcm_template_folder, sprintf('%s_Vanilla.mat',dcm_model_names{current_dcm_model})));
                            %current_dcm_modelname = cell2mat(fullfile(studyset(indStudysetSubjects).dcm_template_folder, sprintf('%s.mat',dcm_model_names{current_dcm_model})));
                            current_dcm_subj = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder, sprintf('%s.mat',dcm_model_names{current_dcm_model}));
                            
                            copyfile(current_dcm_template, current_dcm_subj);
                            
                            
                            matlabbatch{1}.spm.dcm.spec.fmri.regions.dcmmat = cellstr(current_dcm_subj);
                            matlabbatch{1}.spm.dcm.spec.fmri.regions.voimat = {(fullfile(current_path, sprintf('VOI_SNVTA_%d.mat', current_session)))
                                fullfile(current_path, sprintf('VOI_dlPFC_%d.mat', current_session))};
                            
                            
                            matlabbatch{2}.spm.dcm.spec.fmri.inputs.dcmmat = cellstr(current_dcm_subj);
                            matlabbatch{2}.spm.dcm.spec.fmri.inputs.spmmat = cellstr(fullfile(current_path, 'SPM.mat'));
                            matlabbatch{2}.spm.dcm.spec.fmri.inputs.session = current_session;
                            matlabbatch{2}.spm.dcm.spec.fmri.inputs.val = region_spec_input_val;
                            
                            
                            
                            % save the batch
                            
                            matlab.io.saveVariablesToScript(fullfile(current_path, sprintf('DCM_r%d_spec_input_job.m', current_run)),'matlabbatch');
                            spm('defaults','fMRI');
                            % run the batch
                            spm_jobman('run', matlabbatch);
                        end
                    elseif (3 == dcm_part_todo)
                        disp(subjID);
                        
                        %             matlabbatch{1}.spm.dcm.estimate.dcms.model.dcmmat = {
                        %                                                     fullfile(current_path, sprintf('DCM_DCM_r%d_Model1_modeffects.mat', current_run))
                        %                                                     fullfile(current_path, sprintf('DCM_DCM_r%d_Model2_modeffects.mat', current_run))
                        %                                                     fullfile(current_path, sprintf('DCM_DCM_r%d_Model3_modeffects.mat', current_run))
                        %                                                     };
                        matlabbatch{1}.spm.dcm.estimate.dcms.model.dcmmat = {
                            fullfile(current_path, sprintf('%s.mat', dcm_model_names{1}))
                            fullfile(current_path, sprintf('%s.mat', dcm_model_names{2}))
                            fullfile(current_path, sprintf('%s.mat', dcm_model_names{3}))
                            };
                        
                        
                        %matlabbatch{1}.spm.dcm.estimate.output.single.dir = {sprintf('/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r%d_modeffects',current_run)};
                        %matlabbatch{1}.spm.dcm.estimate.output.single.name = sprintf('DCM_r%d_modeffects_allsubj_allmodels', current_run);
                        matlabbatch{1}.spm.dcm.estimate.output.separate = struct([]);
                        matlabbatch{1}.spm.dcm.estimate.est_type = 1;
                        matlabbatch{1}.spm.dcm.estimate.fmri.analysis = 'time';
                        
                        
                        %             matlabbatch{1}.spm.dcm.estimate.dcms.subj.dcmmat = cellstr(current_dcm_subj);
                        %             matlabbatch{1}.spm.dcm.estimate.output.single.dir = {'/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4'};
                        %             matlabbatch{1}.spm.dcm.estimate.output.single.name = 'DCM_group_r4';
                        %             matlabbatch{1}.spm.dcm.estimate.est_type = 1;
                        %             matlabbatch{1}.spm.dcm.estimate.fmri.analysis = 'time';
                        % save the batch
                        
                        matlab.io.saveVariablesToScript(fullfile(current_path,sprintf('DCM_r%d_estimate_allmodels_dcm_job.m',current_run)),'matlabbatch');
                        %matlab.io.saveVariablesToScript(fullfile(current_path,sprintf('DCM_r%d_modeffects_estimate_allmodels_dcm_job.m',current_run)),'matlabbatch');
                        spm('defaults','fMRI');
                        % run the batch
                        spm_jobman('run', matlabbatch);
                    end
                end
            end
            
        end
    end
end
