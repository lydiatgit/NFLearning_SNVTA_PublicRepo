clear all;
clc;


% data_cofeed16 == 0
% data_james18 == 1;
bool_choose_data = 1;

if (0 == bool_choose_data)

    % experiment folder
    data_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/preproc/';
    roi_subfolder = 'ROI';
    epi_subfolders = {'r1', 'r2', 'r3', 'r4'};
    fname_epi = 'irbadvols.nii';
    fname_roi = 'r_r1_SN_VTA_ROI_LH.nii';
    fname_t2 = 'r_r1_t2_voi*.nii';
    new_prefix = 'w_lh_newreg';
    new_mask_name = 'w_lh_newreg_thr_SN_VTA_ROI_LH';
    
    % subjects
    subjects_description = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/ROIChecks_T2.csv', 'Delimiter',',','ReadVariableNames',true);
    ind = find(subjects_description.T2_exist==1);
    subjects = {'CoFeed_01_C101114E'}%subjects_description.SubjID(ind);
    
else
    % experiment folder
    data_path = '/media/sf_Share_NeuroDebian/data_james/preproc/';
    roi_subfolder = 'ROI';
    epi_subfolders = {'r1', 'r2', 'r3', 'r4', 'r5'};
    fname_epi = 'irbadvols.nii';
    fname_roi = 'rSN_1mm.nii';
    fname_t2 = '';
    new_prefix = 'w_lh_newreg';
    new_mask_name = 'w_lh_newreg_thr_SN_1mm';
    % subjects
    subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true);
    subjects = subjects_description.SubjID_sort(:);
    
end



for indSubjects = 1:numel(subjects)
    current_subjID = subjects{indSubjects};
    
    roi_file = fullfile(data_path, subjects{indSubjects}, roi_subfolder, fname_roi);
    t2_file_temp = dir(fullfile(data_path, subjects{indSubjects}, roi_subfolder, fname_t2));
    t2_file = fullfile(data_path, subjects{indSubjects}, roi_subfolder, t2_file_temp.name);
    
    for indSessions = 1:length(epi_subfolders)
        
        
        epi_files = spm_select('ExtFPList', fullfile(data_path, subjects{indSubjects}, epi_subfolders{indSessions}), ['^' fname_epi],Inf);
        current_align_file = fullfile(data_path, subjects{indSubjects}, epi_subfolders{indSessions}, [fname_epi ',1']);
        
        
        clear matlabbatch;
        
        %-----------------------------------------------------------------------
        % Job saved on 03-Jul-2017 13:10:48 by cfg_util (rev $Rev: 6460 $)
        % spm SPM - SPM12 (6906)
        % cfg_basicio BasicIO - Unknown
        %-----------------------------------------------------------------------
        matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {current_align_file};
        if (0 == bool_choose_data)
            %% take T2 
            matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = [cellstr(epi_files); cellstr(t2_file)];
            %%
        else
            matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = [cellstr(epi_files)];
        end
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/usr/local/MATLAB/R2016b/toolbox/spm12/tpm/TPM.nii'};
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1.5 1.5 1.5];
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = new_prefix;
        if (0 == bool_choose_data)
            matlabbatch{2}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Normalise: Estimate & Write: Deformation (Subj 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','def'));
            matlabbatch{2}.spm.spatial.normalise.write.subj.resample = cellstr(roi_file);
            matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                78 76 85];
            matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [1.5 1.5 1.5];
            matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 0;
            matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = new_prefix;
            
            matlabbatch{3}.spm.util.imcalc.input = cellstr(fullfile(data_path, subjects{indSubjects}, roi_subfolder, [new_prefix fname_roi]));
            matlabbatch{3}.spm.util.imcalc.output = new_mask_name;
            matlabbatch{3}.spm.util.imcalc.outdir = cellstr(fullfile(data_path, subjects{indSubjects}, roi_subfolder));
            matlabbatch{3}.spm.util.imcalc.expression = 'i1>0.1';
            matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{3}.spm.util.imcalc.options.mask = 0;
            matlabbatch{3}.spm.util.imcalc.options.interp = 0;
            matlabbatch{3}.spm.util.imcalc.options.dtype = 2;
        end
        spm_jobman('run', matlabbatch);
    end
end