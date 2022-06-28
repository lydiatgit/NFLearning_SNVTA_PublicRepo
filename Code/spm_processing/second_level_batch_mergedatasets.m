% This script creates data matrix for final analysis
clear all;
clc;

%Define StudySets
% Cofeed Data
studyset = struct;

% experiment folder
paths.output_path_base = '/media/sf_Share_NeuroDebian/data_james/analysis/';
studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmod';
studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
%studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';


% subjlist to be included
% subjects
subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(1).subjects = subjects_description.SubjID_sort(:);
studyset(1).bool_group_intervention = subjects_description.Group_Intervention(:);
studyset(1).bool_group_control = subjects_description.Group_Control(:);
bool_learners_lydia_r32_rSN = subjects_description.Learner_Lydia_r3_r2_rSN(:);
bool_learners_lydia_r41_rSN = subjects_description.Learner_Lydia_r4_r1_rSN(:);
bool_learners_lydia_r32_prob = subjects_description.Learner_Lydia_r3_r2_prob(:);
bool_learners_lydia_r41_prob = subjects_description.Learner_Lydia_r4_r1_prob(:);
studyset(1).values_degrees_of_learning = subjects_description.degree_of_learning(:);



% subjlist to be included
% subjects
subjects_description2 = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(2).subjects = subjects_description2.SubjectID(:);
studyset(2).bool_group_intervention = subjects_description2.HealthyControl(:);
studyset(2).bool_group_control = subjects_description2.HealthyControl(:)*0;
studyset(2).values_degrees_of_learning = subjects_description2.degree_of_learning(:);

%% create con list
for indAnalysis = 8
    bool_choose_analysis = indAnalysis;
    
    if (1 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4-r1_MK_JS_' str_outfolder], ['group_stats_HCBS_UP-DOWN_allruns_MK_JS_' str_outfolder]};
        studyset(1).conlist={'con_0020','con_0019'};
        studyset(2).conlist={'con_0017','con_0016'};
        separate_by={'Group','Group'};
        contrasts={[1 -1],[-1 1],[1 -1],[-1 1]};
        contrastnames={'r4-r1_JS>MK','r4-r1_MK>JS','UP-DOWN_all_JS>MK', 'UP-DOWN_all_MK>JS'};
        bool_use_dofl_cov = 0;
    elseif (2 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4-r1_INT_L_NL_' str_outfolder], ['group_stats_HCBS_UP-DOWN_allruns_INT_L_NL_' str_outfolder]};
        studyset(1).conlist={'con_0020','con_0019'};
        studyset(2).conlist={'con_0017','con_0016'};
        separate_by={'INTLearn','INTLearn'};
        contrasts={[1 -1],[-1 1],[1 -1],[-1 1]};
        contrastnames={'r4-r1_INT_L>NL','r4-r1_INT_NL>L', 'UP-DOWN_all_INT_L>NL', 'UP-DOWN_all_INT_NL>L'};
        bool_use_dofl_cov = 0;
    elseif(3 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_mni_allruns_(UP-DOWN)r4-r1_INTCON_L_NL_' str_outfolder], ['group_stats_mni_allruns_UP-DOWN_allruns_INTCON_L_NL_' str_outfolder]};
        studyset(1).conlist={'con_0020','con_0019'};
        studyset(2).conlist={'con_0017','con_0016'};
        separate_by={'LearnBoth','LearnBoth'};
        contrasts={[1 -1],[-1 1],[1 -1],[-1 1]};
        contrastnames={'r4-r1_INTCON_L>NL','r4-r1_INTCON_NL>L', 'UP-DOWN_all_INTCON_L>NL', 'UP-DOWN_all_INTCON_NL>L'};
        bool_use_dofl_cov = 0;
    elseif (4 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4-r1_INT_L_NL_DOFL' str_outfolder], ['group_stats_HCBS_UP-DOWN_allruns_INT_L_NL_DOFL' str_outfolder]};
        studyset(1).conlist={'con_0020','con_0019'};
        studyset(2).conlist={'con_0017','con_0016'};
        separate_by={'INTLearn','INTLearn'};
        contrasts={[0 0 0 1],[0 0 0 -1],[0 0 0 1],[0 0 0 -1]};
        contrastnames={'r4-r1_INT_DOFL','r4-r1_INT_NEGDOFL', 'UP-DOWN_all_INT_DOFL', 'UP-DOWN_all_INT_NEGDOFL'};
        bool_use_dofl_cov = 1;
    elseif (5 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
        outdir={['group_stats_HCBS_UP-DOWN_r3_INT_L_NL_NFvaluesDelta_' str_outfolder], ['group_stats_HCBS_UP-DOWN_r2_INT_L_NL_NFvaluesDelta_' str_outfolder]};
        studyset(1).conlist={'con_0019','con_0018'};
        studyset(2).conlist={'con_0016','con_0015'};
        separate_by={'INTLearn','INTLearn'};
        contrasts={[1 -1],[-1 1],[1 -1],[-1 1]};
        contrastnames={'r3_NFValuesPmod_L>NL','r3_NFValuesPmod_NL>L', 'r2_NFValuesPmod_L>NL', 'r2_NFValuesPmod_NL>L'};
        bool_use_dofl_cov = 0;
    elseif (6 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4_r1_L_NL' str_outfolder]};
        studyset(1).conlist={'con_0020','con_0019'};
        studyset(2).conlist={'con_0017','con_0016'};
        separate_by={'INTLearn','INTLearn'};
        contrasts={[0 0 0 1],[0 0 0 -1],[0 0 0 1],[0 0 0 -1]};
        contrastnames={'r4-r1_INT','r4-r1_INT_NEGDOFL', 'UP-DOWN_all_INT_DOFL', 'UP-DOWN_all_INT_NEGDOFL'};
        bool_use_dofl_cov = 1;
    elseif (7 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4_r1_INT_CON_DOFL']};
        studyset(1).conlist={'con_0020'};
        studyset(2).conlist={'con_0017'};
        separate_by={'INTCON'};
        contrasts={[0 0 0 1 -1],[0 0 0 -1 1]};
        contrastnames={'r4-r1_INT>CON_DOFL','r4-r1_CON>INT_DOFL'};
        bool_use_dofl_cov = 1;
    elseif (7 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns';
        outdir={['group_stats_HCBS_(UP-DOWN)r4_r1_INT_CON_DOFL']};
        studyset(1).conlist={'con_0020'};
        studyset(2).conlist={'con_0017'};
        separate_by={'INTCON'};
        contrasts={[0 0 0 1 -1],[0 0 0 -1 1]};
        contrastnames={'r4-r1_INT>CON_DOFL','r4-r1_CON>INT_DOFL'};
        bool_use_dofl_cov = 1;
    elseif (8 == bool_choose_analysis)
        studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6/PPI_VOI_dlPFC_NF_gPPI';
        studyset(1).paths.first_level_folder = 'stats_mni_allruns/PPI_VOI_dlPFC_NF_gPPI';
        outdir={['group_stats_HCBS_PPI_INT_CON_DOFL']};
        studyset(1).conlist={'con_(UP-DOWN)allruns'};
        studyset(2).conlist={'con_(UP-DOWN)allruns'};
        separate_by={'INTCON'};
        contrasts={[0 0 0 1 -1],[0 0 0 -1 1]};
        contrastnames={'allruns_INT>CON_DOFL','allruns_CON>INT_DOFL'};
        bool_use_dofl_cov = 1;
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
        confiles_group2 = {};
        current_covariat_vec_group1 = [];
        current_covariat_vec_group2 = [];
        current_covariat_vec_dofl1 = [];
        current_covariat_vec_dofl2 = [];
        
        for indStudysetSubjects = 1:numel(studyset)
            
            current_contrast = cell2mat(studyset(indStudysetSubjects).conlist(indContrasts));
            current_subjects = studyset(indStudysetSubjects).subjects;
            current_values_dofl = studyset(indStudysetSubjects).values_degrees_of_learning;
            
            
            for  indSubj = 1:length(current_subjects)
                subjID = cell2mat(current_subjects(indSubj));
                currentPath = fullfile(studyset(indStudysetSubjects).paths.analysis_path, subjID, studyset(indStudysetSubjects).paths.first_level_folder);
                currentFile = dir(fullfile(currentPath, [current_contrast,'.nii']));
                 if (isempty(currentFile))
                    currentFile = dir(fullfile(currentPath, [current_contrast '.img']));
                end
                
                if (~isempty(currentFile))
                    if (strcmp('Learn',separate_by(indContrasts)))
                        if (1 == studyset(indStudysetSubjects).bool_learners(indSubj))
                            if (isempty(confiles_group1))
                                confiles_group1 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group1 = [current_covariat_vec_group1; indStudysetSubjects];
                            current_covariat_vec_dofl1 = [current_covariat_vec_dofl1; current_values_dofl(indSubj)];
                        else
                            if (isempty(confiles_group2))
                                confiles_group2 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group2 = [confiles_group2; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group2 = [current_covariat_vec_group2; indStudysetSubjects];
                            current_covariat_vec_dofl2 = [current_covariat_vec_dofl2; current_values_dofl(indSubj)];
                        end
                    elseif (strcmp('Group',separate_by(indContrasts)))
                        if (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && (1 == indStudysetSubjects))
                            if (isempty(confiles_group1))
                                confiles_group1 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                            end
                            
                        elseif (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && (2 == indStudysetSubjects))
                            if (isempty(confiles_group2))
                                confiles_group2 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group2 = [confiles_group2; fullfile(currentPath, currentFile.name)];
                            end
                            
                        end
                    elseif  (strcmp('INTLearn',separate_by(indContrasts)))
                        if (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && 1 == studyset(indStudysetSubjects).bool_learners(indSubj))
                            if (isempty(confiles_group1))
                                confiles_group1 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group1 = [current_covariat_vec_group1; indStudysetSubjects];
                            current_covariat_vec_dofl1 = [current_covariat_vec_dofl1; current_values_dofl(indSubj)];
                        elseif ((1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && 0 == studyset(indStudysetSubjects).bool_learners(indSubj)))
                            if (isempty(confiles_group2))
                                confiles_group2 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group2 = [confiles_group2; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group2 = [current_covariat_vec_group2; indStudysetSubjects];
                            current_covariat_vec_dofl2 = [current_covariat_vec_dofl2; current_values_dofl(indSubj)];
                        end
                    elseif  (strcmp('LearnBoth',separate_by(indContrasts)))
                        if (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && 1 == studyset(indStudysetSubjects).bool_learners(indSubj))
                            if (isempty(confiles_group1))
                                confiles_group1 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group1 = [current_covariat_vec_group1; indStudysetSubjects];
                            current_covariat_vec_dofl1 = [current_covariat_vec_dofl1; current_values_dofl(indSubj)];
                        elseif ((0 == studyset(indStudysetSubjects).bool_group_intervention(indSubj) && 1 == studyset(indStudysetSubjects).bool_learners(indSubj)))
                            if (isempty(confiles_group2))
                                confiles_group2 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group2 = [confiles_group2; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group2 = [current_covariat_vec_group2; indStudysetSubjects];
                            current_covariat_vec_dofl2 = [current_covariat_vec_dofl2; current_values_dofl(indSubj)];
                        end
                    elseif  (strcmp('INTCON',separate_by(indContrasts)))
                        if (1 == studyset(indStudysetSubjects).bool_group_intervention(indSubj))
                            if (isempty(confiles_group1))
                                confiles_group1 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group1 = [confiles_group1; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group1 = [current_covariat_vec_group1; indStudysetSubjects];
                            current_covariat_vec_dofl1 = [current_covariat_vec_dofl1; current_values_dofl(indSubj)];
                        elseif ((1 == studyset(indStudysetSubjects).bool_group_control(indSubj)))
                            if (isempty(confiles_group2))
                                confiles_group2 = {fullfile(currentPath, currentFile.name)};
                            else
                                confiles_group2 = [confiles_group2; fullfile(currentPath, currentFile.name)];
                            end
                            current_covariat_vec_group2 = [current_covariat_vec_group2; indStudysetSubjects];
                            current_covariat_vec_dofl2 = [current_covariat_vec_dofl2; current_values_dofl(indSubj)];
                        end
                    end
                else
                    fprintf('Contrast file not found: %s', fullfile(currentPath, currentFile));
                end
            end % over all subjects
        end
        % load the template
        matlabbatch = secondlevel_job_template_ttests_cov();
        % fill with current con files and folder
        matlabbatch{1}.spm.stats.factorial_design.dir = {paths.output_path};
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(confiles_group1);
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(confiles_group2);
        
        % ADD COVARIATE
        if (0 == strcmp('Group',separate_by(indContrasts)))
            matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [current_covariat_vec_group1; current_covariat_vec_group2];
            matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Studyset';
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
            if ( 1 == bool_use_dofl_cov)
                current_covariat_vec_dofl1 = current_covariat_vec_dofl1 -mean(current_covariat_vec_dofl1);
                current_covariat_vec_dofl2 = current_covariat_vec_dofl2 - mean(current_covariat_vec_dofl2);
                matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [current_covariat_vec_dofl1; zeros(length(current_covariat_vec_dofl2),1)];
                matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'DOFL';
                matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
                matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 5;
                matlabbatch{1}.spm.stats.factorial_design.cov(3).c = [zeros(length(current_covariat_vec_dofl1),1); current_covariat_vec_dofl2];
                matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'DOFL';
                matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
                matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 5;
            end
        end
        % TODO: set names of contrasts
        
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = cell2mat(contrastnames((indContrasts-1)*2+1));
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = cell2mat(contrasts((indContrasts-1)*2+1));
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = cell2mat(contrastnames((indContrasts-1)*2+2));
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = cell2mat(contrasts((indContrasts-1)*2+2));
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
        % save the batch
        
        matlab.io.saveVariablesToScript(fullfile(paths.output_path,'secondlevel_job.m'),'matlabbatch')
        % run the batch
        spm('defaults','fMRI');
        spm_jobman('run', matlabbatch);
        
        
    end
    
    
end
