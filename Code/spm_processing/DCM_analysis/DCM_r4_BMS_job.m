% This script does bayes model selection for our three models
% analysis
clear all;
clc;

%Define StudySets
% Cofeed Data
studyset = struct;

% 0 - single triage of models
% 1 - all models combined 
bool_all_models = 0;

outdir = '';
dcm_model_names = {};
% 0 - DCM_DCM_r4_ModelX.mat
% 1 - DCM_DCM_r4_ModelX_modeffects.mat
model_spec_modefects = 1;
% 0 - intervention
% 1 - control group
bool_group = 0;

% which regressor
% '' - UP and DOWN
% '_UP' - UP only
GLM_regressor = '';

% driving input
% dlPFC and SN/VTA - ''
% dlPFC only - 'DIdlPFC'
driving_input_spec = '_DIdlPFC2';

% which run to analyse
dcm_run_to_analyse = 4;

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
% ONLY INT GROUP
bool_group_intervention = subjects_description.Group_Intervention(:);
if (1 == bool_group)
    studyset(1).subjects = studyset(1).subjects(bool_group_intervention==0);
elseif (0 == bool_group)
    studyset(1).subjects = studyset(1).subjects(bool_group_intervention==1);
end

subjects_description2 = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(2).subjects = subjects_description2.SubjectID(:);
% TODO check HEALTHY ONLY
bool_group_intervention = subjects_description2.HealthyControl(:);
if (1 == bool_group)
    studyset(2).subjects = studyset(2).subjects(bool_group_intervention==2); % kick 'em all out
elseif (0 == bool_group)
    studyset(2).subjects = studyset(2).subjects(bool_group_intervention==1);
end

if (0 == model_spec_modefects)
    
        dcm_model_names = {sprintf('DCM_DCM_r%d_Model1%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
    
elseif (1 == model_spec_modefects)
    dcm_model_names = {sprintf('DCM_DCM_r%d_Model1_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
end

%%matlabbatch starts
matlabbatch = {};
matlabbatch{1}.spm.dcm.bms.inference.dir = {};


if (0 == bool_all_models)
    if (0 == bool_group)
        if (0 == model_spec_modefects)
            %matlabbatch{1}.spm.dcm.bms.inference.dir = {'/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4_INT'};
            outdir = fullfile(paths.output_path_base, sprintf('group_stats_DCM_r%d%s%s_INT', dcm_run_to_analyse, GLM_regressor, driving_input_spec));
        elseif (1 == model_spec_modefects)
            %matlabbatch{1}.spm.dcm.bms.inference.dir = {'/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4_modeffects_INT'};
            outdir = fullfile(paths.output_path_base, sprintf('group_stats_DCM_r%d_modeffects%s%s_INT', dcm_run_to_analyse, GLM_regressor, driving_input_spec));
        end
    elseif (1 == bool_group)
        if (0 == model_spec_modefects)
            %matlabbatch{1}.spm.dcm.bms.inference.dir = {'/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4_CON'};
            outdir = fullfile(paths.output_path_base, sprintf('group_stats_DCM_r%d%s%s_CON', dcm_run_to_analyse, GLM_regressor, driving_input_spec));
            
        elseif (1 == model_spec_modefects)
            outdir = fullfile(paths.output_path_base,sprintf('group_stats_DCM_r%d_modeffects%s%s_CON', dcm_run_to_analyse, GLM_regressor, driving_input_spec));
        end
    end
    
    % if output dir exists, delete it
    if (7 == exist(outdir, 'dir'))
        rmdir(outdir, 's');
        mkdir(outdir);
    else
        mkdir(outdir);
    end
    
    indAllParticipants = 1;
    for indStudysetSubjects = 1:numel(studyset)
        
        current_subjects = studyset(indStudysetSubjects).subjects;
        
        
        for  indSubj = 1:length(current_subjects)
            subjID = cell2mat(current_subjects(indSubj));
            if (1 == strcmp('JSD_114_T091212M', subjID))
                continue;
            end
            disp(subjID);
            current_path = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder);
            matlabbatch{1}.spm.dcm.bms.inference.dir = {outdir};
            matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{indAllParticipants}.dcmmat = {
                fullfile(current_path, dcm_model_names{1})
                fullfile(current_path, dcm_model_names{2})
                fullfile(current_path, dcm_model_names{3})
                };
            indAllParticipants = indAllParticipants +1;
            
        end
    end
    
elseif (1 == bool_all_models)
    
    if (0 == bool_group)
        outdir = fullfile(paths.output_path_base, sprintf('group_stats_DCM_r%d_6models_INT', dcm_run_to_analyse));
    elseif (1 == bool_group)
        outdir = fullfile(paths.output_path_base, sprintf('group_stats_DCM_r%d_6models_CON', dcm_run_to_analyse));
    end
    
    GLM_regressor = '';
    dcm_model_names_1 = {sprintf('DCM_DCM_r%d_Model1_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
    %dcm_model_names_2 = {sprintf('DCM_DCM_r%d_Model1%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
    GLM_regressor = '_UP';
    dcm_model_names_3 = {sprintf('DCM_DCM_r%d_Model1_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3_modeffects%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
    %dcm_model_names_4 = {sprintf('DCM_DCM_r%d_Model1%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model2%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec), sprintf('DCM_DCM_r%d_Model3%s%s.mat', dcm_run_to_analyse, GLM_regressor, driving_input_spec)};
    
    %dcm_model_names = [dcm_model_names_1, dcm_model_names_2, dcm_model_names_3, dcm_model_names_4];
    dcm_model_names = [dcm_model_names_1, dcm_model_names_3];

    % if output dir exists, delete it
    if (7 == exist(outdir, 'dir'))
        rmdir(outdir, 's');
        mkdir(outdir);
    else
        mkdir(outdir);
    end
    
    matlabbatch{1}.spm.dcm.bms.inference.dir = {outdir};
    indAllParticipants = 1;
    for indStudysetSubjects = 1:numel(studyset)
        
        current_subjects = studyset(indStudysetSubjects).subjects;
        
        
        for  indSubj = 1:length(current_subjects)
            subjID = cell2mat(current_subjects(indSubj));
            if (1 == strcmp('JSD_114_T091212M', subjID))
                continue;
            end
            disp(subjID);
            current_path = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder);
            matlabbatch{1}.spm.dcm.bms.inference.dir = {outdir};
            matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{indAllParticipants}.dcmmat = {
                fullfile(current_path, dcm_model_names{1})
                fullfile(current_path, dcm_model_names{2})
                fullfile(current_path, dcm_model_names{3})
                fullfile(current_path, dcm_model_names{4})
                fullfile(current_path, dcm_model_names{5})
                fullfile(current_path, dcm_model_names{6})
%                 fullfile(current_path, dcm_model_names{7})
%                 fullfile(current_path, dcm_model_names{8})
%                 fullfile(current_path, dcm_model_names{9})
%                 fullfile(current_path, dcm_model_names{10})
%                 fullfile(current_path, dcm_model_names{11})
%                 fullfile(current_path, dcm_model_names{12})
                };
            indAllParticipants = indAllParticipants +1;
            
        end
    end
    
end


matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'RFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_yes.bma_all = 'famwin';
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

matlab.io.saveVariablesToScript(fullfile(outdir,'DCM_bms_job.m'),'matlabbatch');
spm('defaults','fMRI');
% run the batch
spm_jobman('run', matlabbatch);