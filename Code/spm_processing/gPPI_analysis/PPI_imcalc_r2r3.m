clear all;
clc;

bool_OS_linux = 1;
Study_Dir='/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/';
Mask_Dir='/media/sf_Share_NeuroDebian/cofeed16/cofeed16/preproc/';
first_level_folder = 'stats_mni_allruns_newreg6';

% subjects
if (1 == bool_OS_linux)
    subjects_description = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true);
else
    subjects_description = readtable('D:\Share_NeuroDebian\cofeed16\cofeed16\SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true);
end
subjects = subjects_description.SubjectID(:);


regionfile={};

regionname={'VOI_probSNVTA_gPPI', 'VOI_dlPFC_NF_gPPI'};

for indSubjects = 1:numel(subjects)
    current_subjID = subjects{indSubjects};
    current_analysis_path = fullfile(Study_Dir, current_subjID);
    
    for indRegions = 1:numel(regionname)
        
        current_foldername_PPI = sprintf('PPI_%s', cell2mat(regionname(indRegions)));
        current_confile_name1 = fullfile(current_analysis_path, first_level_folder, current_foldername_PPI, sprintf('con_PPI_UP-DOWN_r2_%s.img,1', current_subjID));
        current_confile_name2 = fullfile(current_analysis_path, first_level_folder, current_foldername_PPI, sprintf('con_PPI_UP-DOWN_r3_%s.img,1', current_subjID));
        
        clear matlabbatch;
        %-----------------------------------------------------------------------
        % Job saved on 22-Mar-2018 05:59:39 by cfg_util (rev $Rev: 6460 $)
        % spm SPM - SPM12 (6906)
        % cfg_basicio BasicIO - Unknown
        %-----------------------------------------------------------------------
        matlabbatch{1}.spm.util.imcalc.input = cellstr([current_confile_name1; current_confile_name2]);
        matlabbatch{1}.spm.util.imcalc.output = 'con_(UP-DOWN)r2+r3';
        matlabbatch{1}.spm.util.imcalc.outdir = cellstr(fullfile(current_analysis_path, first_level_folder, current_foldername_PPI));
        matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 0;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        spm('defaults', 'FMRI');
        matlab.io.saveVariablesToScript(fullfile(current_analysis_path, first_level_folder, current_foldername_PPI,'imcalcr2r3_PPI.m'),'matlabbatch')
        spm_jobman('run', matlabbatch);
         
    end
end

