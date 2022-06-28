function [jobfiles] = create_firstlevel_jobs( data_path, stat_dir, first_level_folder, subjects, sessions, conditions, tParams, conOpt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% load the template
matlabbatch = firstlevel_job_template();

jobfiles = cell(numel(subjects),1);

% do the rest of filling out the matlabbatch
for indSubjects = 1:numel(subjects)
    for indSessions = 1:numel(sessions)
        
        output_path = fullfile(stat_dir);
        if (~exist(output_path, 'dir'))
            mkdir(output_path);
        end
        
        session_dir = fullfile(output_path, subjects{indSubjects}, strcat(sessions{indSessions}));
        if (~exist(session_dir, 'dir'))
            mkdir(session_dir);
        end
        
        current_stat_dir = fullfile(output_path, subjects{indSubjects}, strcat(sessions{indSessions}), first_level_folder);
        if (~exist(current_stat_dir, 'dir'))
            mkdir(current_stat_dir);
        end
        
        cd(current_stat_dir);
        
        % specify session directory
        matlabbatch{1}.spm.stats.fmri_spec.dir = {current_stat_dir};
        
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = tParams.TR;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = tParams.mic_res;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = tParams.mic_onset;
        
        % load preprocessed file and put into structure
        files = spm_select('ExtFPList', fullfile(data_path, subjects{indSubjects}, sessions{indSessions}), '^siw.*\.nii',Inf);
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(files);
        
        
        % load multiple regressors? if yes, then do it
        if strcmp(tParams.motion_regress,'yes')
            reg_file = spm_select('FPList', fullfile(data_path,subjects{indSubjects}, sessions{indSessions}), '^tc_wm_csf_rp_iwrbadvols.*\.txt$');
        else
            reg_file = [];
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {reg_file};
        
        % save mat file and run job
        batch_file_name = strcat('firstLev_batch_',sessions{indSessions},'.mat');
        save(fullfile(current_stat_dir,batch_file_name),'matlabbatch');
        jobfiles((indSubjects-1)*numel(sessions)+indSessions) = {fullfile(current_stat_dir,batch_file_name)};
        
    end
end

end

