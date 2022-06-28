clear all;
clc;


% data_cofeed16 == 0
% data_james18 == 1;
bool_choose_data = 0;

if (0 == bool_choose_data)

    % experiment folder
    data_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/preproc/';
    roi_subfolder = 'ROI';
    epi_subfolders = {'r1', 'r2', 'r3', 'r4'};
    fname_epi = 'w_lh_newregirbadvols.nii';
    % subjects
    subjects_description = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/ROIChecks_T2.csv', 'Delimiter',',','ReadVariableNames',true);
    ind = find(subjects_description.T2_exist==1);
    subjects = subjects_description.SubjID(ind);
    
else
    % experiment folder
    data_path = '/media/sf_Share_NeuroDebian/data_james/preproc/';
    roi_subfolder = 'ROI';
    epi_subfolders = {'r1', 'r2', 'r3', 'r4', 'r5'};
    fname_epi = 'w_lh_newregirbadvols.nii';
    % subjects
    subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true);
    subjects = subjects_description.SubjID_sort(:);
    
end

for indSubjects = 1:numel(subjects)
    current_subjID = subjects{indSubjects}
    
    for indSessions = 1:length(epi_subfolders)
        
        epi_files = spm_select('ExtFPList', fullfile(data_path, subjects{indSubjects}, epi_subfolders{indSessions}), ['^' fname_epi],Inf);
        
        clear matlabbatch;%-----------------------------------------------------------------------
        % Job saved on 12-Mar-2018 09:15:55 by cfg_util (rev $Rev: 6460 $)
        % spm SPM - SPM12 (6906)
        % cfg_basicio BasicIO - Unknown
        %-----------------------------------------------------------------------
        matlabbatch{1}.spm.spatial.smooth.data = cellstr(epi_files);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's6';
        spm_jobman('run', matlabbatch);
    end
end