% This script creates data matrix for final analysis
clear all;
clc;
addpath('/usr/local/MATLAB/R2016b/toolbox/spm12')

%Define StudySets
% Cofeed Data
studyset = struct;

% experiment folder
paths.output_path_base = '/media/sf_Share_NeuroDebian/data_james/analysis/';
studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
%studyset(1).paths.first_level_folder = 'stats_mni_allruns';
studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
%studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
regionnames = {'PPI_VOI_dlPFC_NF_gPPI', 'PPI_VOI_dlPFC_NF_gPPI_pmod'};

% subjlist to be included
% subjects
subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(1).subjects = subjects_description.SubjID_sort(:);
studyset(1).bool_group_intervention = subjects_description.Group_Intervention(:);
studyset(1).bool_group_control = subjects_description.Group_Control(:);
studyset(1).values_degrees_of_learning = subjects_description.degree_of_learning(:);




% subjlist to be included
% subjects
subjects_description2 = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(2).subjects = subjects_description2.SubjectID(:);
studyset(2).bool_group_intervention = subjects_description2.HealthyControl(:);
studyset(2).bool_group_control = zeros(length(studyset(2).subjects),1);
studyset(2).values_degrees_of_learning = subjects_description2.degree_of_learning(:);


%add covariate degrees of learning
bool_add_dofl = 1;

% choose the group to do analysis with 
% 1 NF groups
% 2 control groups
% 3 Patients - check if loop below
bool_choose_group = 1;


for indRegions = 2%3:numel(regionnames)
    
    current_region = cell2mat(regionnames(indRegions));
    
    bool_choose_analysis = 6;
    if (1 == bool_choose_analysis)
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        outdir={['group_stats_' current_region '_r4r1_s6_onesample_DOFL' num2str(bool_add_dofl)], ['group_stats_' current_region '_r2r3_s6_onesample_DOFL' num2str(bool_add_dofl)]};
        
        studyset(1).conlist={'con_(UP-DOWN)r4-r1','con_(UP-DOWN)r2+r3'};
        studyset(2).conlist={'con_(UP-DOWN)r4-r1','con_(UP-DOWN)r2+r3'};
        
        contrastnames={'r4-r1_onesample', 'UP-DOWN_all_onesample'};
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 1;
    elseif (2 == bool_choose_analysis)
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        outdir={['group_stats_' current_region '_allruns_s6_onesample_DOFL' num2str(bool_add_dofl)]};
        
        studyset(1).conlist={'con_(UP-DOWN)allruns'};
        studyset(2).conlist={'con_(UP-DOWN)allruns'};
        
        contrastnames={'allruns_onesample'};
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 1;
    elseif (3 == bool_choose_analysis)
        studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
        outdir={['group_stats_' current_region '_FBallruns_NFvaluesPmodDelta_onesample_DOFL' num2str(bool_add_dofl)], ['group_stats_' current_region '_FBr4r1_NFvaluesPmodDelta_onesample_DOFL' num2str(bool_add_dofl)], ['group_stats_' current_region '_FBr3r2_NFvaluesPmodDelta_onesample_DOFL' num2str(bool_add_dofl)], ['group_stats_' current_region '_FBr3+r2_NFvaluesPmodDelta_onesample_DOFL' num2str(bool_add_dofl)]};
        studyset(1).conlist={'FB_allruns', 'FB4-FB1','FB3-FB2','FB3+FB2'};
        studyset(2).conlist={'FB_allruns', 'FB4-FB1','FB3-FB2','FB3+FB2'};
        
        contrastnames={'FB_allruns_onesample', 'FB4-FB1_onesample', 'FB3-FB2_onesample', 'FB3+FB2_onesample'};

        
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 1;
    elseif (4 == bool_choose_analysis)
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        outdir={['group_stats_' current_region '_r4r1_s6_onesample_CON_DOFL' num2str(bool_add_dofl)], ['group_stats_' current_region '_r2r3_s6_onesample_CON_DOFL' num2str(bool_add_dofl)]};
        
        studyset(1).conlist={'con_(UP-DOWN)r4-r1','con_(UP-DOWN)r2+r3'};
        studyset(2).conlist={'con_(UP-DOWN)r4-r1','con_(UP-DOWN)r2+r3'};
        
        contrastnames={'r4-r1_onesample', 'UP-DOWN_all_onesample'};
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 2;
    elseif (5 == bool_choose_analysis)
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        outdir={['group_stats_' current_region '_allruns_s6_onesample_CON_DOFL' num2str(bool_add_dofl)]};
        
        studyset(1).conlist={'con_(UP-DOWN)allruns'};
        studyset(2).conlist={'con_(UP-DOWN)allruns'};
        
        contrastnames={'allruns_onesample'};
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 2;
    elseif (6 == bool_choose_analysis) % review analysis z trafo, set z version (zall vs zsingle) manually
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        studyset(1).values_degrees_of_learning = subjects_description.degree_of_learning_zsingle(:);
        studyset(2).values_degrees_of_learning = subjects_description2.degree_of_learning_zsingle(:);
        outdir={['group_stats_' current_region '_allruns_s6_onesample_DOFL_zsingle' num2str(bool_add_dofl)]};
        
        studyset(1).conlist={'con_(UP-DOWN)allruns'};
        studyset(2).conlist={'con_(UP-DOWN)allruns'};
        
        contrastnames={'allruns_onesample'};
        %add covariate degrees of learning
        bool_add_dofl = 1;
        bool_choose_group = 1;
    end
    
    
    for indContrasts = 1:length(studyset(1).conlist)
        
        % create outdir
        paths.output_path = cell2mat(fullfile(paths.output_path_base, outdir(indContrasts)));
        % set up output path for group stat
        if ~exist(fullfile(paths.output_path),'dir')
            mkdir(fullfile(paths.output_path));
        end
        
        
        % lists according to contrast and condition
        confiles_group1 = {};
        current_covariat_vec_group1 = [];
        current_covariat_vec_dofl1 = [];
        
        for indStudysetSubjects = 1:numel(studyset)
            
            current_contrast = cell2mat(studyset(indStudysetSubjects).conlist(indContrasts));
            current_subjects = studyset(indStudysetSubjects).subjects;
            current_values_dofl = studyset(indStudysetSubjects).values_degrees_of_learning;
            
            for  indSubj = 1:length(current_subjects)
                
                if (((1 == bool_choose_group) && (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj))) || ...
                ((2 == bool_choose_group) && (1 == studyset(indStudysetSubjects).bool_group_control(indSubj))) || ...
                ((3 == bool_choose_group) && (0 == studyset(indStudysetSubjects).bool_group_intervention(indSubj))))
                    subjID = cell2mat(current_subjects(indSubj));
                    currentPath = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder, current_region);
                    currentFile = dir(fullfile(currentPath, [current_contrast '.nii']));
                    if (isempty(currentFile))
                        currentFile = dir(fullfile(currentPath, [current_contrast '.img']));
                    end
                    if (~isempty(currentFile))
                        if (isempty(confiles_group1))
                            confiles_group1 = {fullfile(currentPath, currentFile.name)};
                        else
                            confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                        end
                        current_covariat_vec_group1 = [current_covariat_vec_group1; indStudysetSubjects];
                        current_covariat_vec_dofl1 = [current_covariat_vec_dofl1; current_values_dofl(indSubj)];
                    else
                        fprintf('Contrast file not found: %s', fullfile(currentPath, currentFile));
                    end
                end
            end % over all subjects
            
            
        end % end of studysets
        
        % create the batch now (no template needed)
        % fill with current con files and folder
        matlabbatch{1}.spm.stats.factorial_design.dir = {paths.output_path};
        %%
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(confiles_group1);
        % ADD COVARIATES
        matlabbatch{1}.spm.stats.factorial_design.cov(1).c = current_covariat_vec_group1;
        matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Studyset';
        matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
        if (1 == bool_add_dofl)
            matlabbatch{1}.spm.stats.factorial_design.cov(2).c = current_covariat_vec_dofl1;
            matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'DOFL';
            matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
        end
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/usr/local/MATLAB/R2016b/toolbox/spm12/tpm/rmask_ICV.nii,1'};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        if (1 == bool_add_dofl)
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Pos';
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Neg';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 0 0];
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'DOFL_Pos';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'DOFL_Neg';
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 -1];
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.delete = 0;
            matlabbatch{3}.spm.stats.con.delete = 0;
            
        else
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Pos';
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0];
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Neg';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 0];
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.delete = 0;
        end
        
        % save the batch
        
        matlab.io.saveVariablesToScript(fullfile(paths.output_path,'secondlevel_job.m'),'matlabbatch')
        spm('defaults','fMRI');
        % run the batch
        spm_jobman('run', matlabbatch);
        
        
    end
end



