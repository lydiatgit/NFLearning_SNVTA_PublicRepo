function [jobfiles] = create_firstlevel_jobs_mni_allruns_singleTRs( data_path, stat_dir, first_level_folder,filename_wildcard, subjects, subjects_BIDS, sessions, fb_values, conditions, tParams, conOpt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% load the template
matlabbatch = firstlevel_job_mni_allruns_template_singleTRs();

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
        
        current_stat_dir = fullfile(output_path, subjects{indSubjects}, first_level_folder);
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
        files = spm_select('ExtFPList', fullfile(data_path, subjects{indSubjects}, sessions{indSessions}), [filename_wildcard '*.nii'],Inf);
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).scans = cellstr(files);
        
        % 
        blmean_feedback = mean(fb_values.output.(cell2mat(subjects_BIDS(indSubjects)))(indSessions).timecourse(1:5).');
        feedback_wo_bl = fb_values.output.(cell2mat(subjects_BIDS(indSubjects)))(indSessions).timecourse - blmean_feedback;
        delta_feedbacks = feedback_wo_bl;%[feedback_wo_bl(1) diff(feedback_wo_bl)];
        
        % load all params for cond
        %%
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).name = 'BL';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).onset = 0:2:8;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).pmod.name = 'FeedbackValues';% = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).pmod.param = delta_feedbacks(1:5).';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).pmod.poly = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(1).orth = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).name = 'DOWN';
        if (4 == numel(sessions))
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).onset = [[10:2:28].';
                [50:2:68].';
                [90:2:108].';
                [130:2:148].';
                [170:2:188].';
                [210:2:228].';
                [250:2:268].';
                [290:2:308].';
                [330:2:348].';
                [370:2:388].'];
        elseif(5 == numel(sessions))
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).onset = [[10:2:28].';
                [50:2:68].';
                [90:2:108].';
                [130:2:148].';
                [170:2:188].';
                [210:2:228].';
                [250:2:268].';
                [290:2:308].';
                [330:2:348].';];
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).pmod.name = 'FeedbackValues';
        % load timecourse for this subject via BIDS ID
        % looks complicated because of stupid artifical nans in jame's data
        % due to mean calc from extract_timecourses - don't bother
        if (4 == numel(sessions))
        inds = [[10:2:28].';
            [50:2:68].';
            [90:2:108].';
            [130:2:148].';
            [170:2:188].';
            [210:2:228].';
            [250:2:268].';
            [290:2:308].';
            [330:2:348].';
            [370:2:388].']/2;
        elseif (5 == numel(sessions))
            inds = [[10:2:28].';
            [50:2:68].';
            [90:2:108].';
            [130:2:148].';
            [170:2:188].';
            [210:2:228].';
            [250:2:268].';
            [290:2:308].';
            [330:2:348].']/2;
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).pmod.param = delta_feedbacks(inds).';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).pmod.poly = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(2).orth = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).name = 'UP';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).onset = [[30:2:48].';
            [70:2:88].';
            [110:2:128].';
            [150:2:168].';
            [190:2:208].';
            [230:2:248].';
            [270:2:288].';
            [310:2:328].';
            [350:2:368].'];
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).pmod.name = 'FeedbackValues';
        % load timecourse for this subject via BIDS ID
        % looks complicated because of stupid artifical nans in jame's data
        % due to mean calc from extract_timecourses - don't bother
        inds = [[30:2:48].';
            [70:2:88].';
            [110:2:128].';
            [150:2:168].';
            [190:2:208].';
            [230:2:248].';
            [270:2:288].';
            [310:2:328].';
            [350:2:368].']/2;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).pmod.param = delta_feedbacks(inds).';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).pmod.poly = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).cond(3).orth = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).hpf = 128;
        
        % load multiple regressors? if yes, then do it
        if strcmp(tParams.motion_regress,'yes')
            reg_file = spm_select('FPList', fullfile(data_path,subjects{indSubjects}, sessions{indSessions}), '^tc_wm_csf_rp_iwrbadvols.*\.txt$');
        else
            reg_file = [];
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSessions).multi_reg = {reg_file};
    end
    
    % define the contrasts
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'eoi';
    if (4 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [eye(6) zeros(6,66); zeros(6,18) eye(6) zeros(6,48); zeros(6,36) eye(6) zeros(6,30); zeros(6,54) eye(6) zeros(6,12)];
    elseif(5 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [eye(6) zeros(6,84); zeros(6,18) eye(6) zeros(6,66); zeros(6,36) eye(6) zeros(6,48); zeros(6,54) eye(6) zeros(6,30); zeros(6,72) eye(6) zeros(6,12)];
    end
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    
    
    contrast_basic_names = {'UP_r', 'DOWN_r', 'UP-DOWN_r', 'UP_FB', 'DOWN_FB', 'UP-DOWN_FB'};
    contrast_weights = {[0 0 0 0 1 0], [0 0 1 0 0 0], [0 0 -1 0 1 0], [0 0 0 0 0 1], [0 0 0 1 0 0], [0 0 0 -1 0 1]};
    contrast_index = 1;
    for indContrast = 1:numel(contrast_basic_names)
        for indSessions = 1:numel(sessions)
            contrast_index = (indContrast -1 )* numel(sessions) + indSessions + 1;
            contrast_name = sprintf('%s%d', cell2mat(contrast_basic_names(indContrast)), indSessions);
            matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = contrast_name;
            weight = [zeros(1, (indSessions-1)*12) zeros(1, (indSessions-1)*6) cell2mat(contrast_weights(indContrast)) zeros(1, (numel(sessions)-indSessions+1)*12 + (numel(sessions)-indSessions)*6)];
            matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
            matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
        end
    end
    
    % add four contrasts at the end
    contrast_index = contrast_index + 1;
    if (4 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP_r4-r1';
        weight = [[0 0 0 0 -1 0] zeros(1,48) [0 0 0 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    else
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP_r5-r1';
        weight = [[0 0 0 0 -1 0] zeros(1,66) [0 0 0 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    end
    
    contrast_index = contrast_index + 1;
    if (4 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'DOWN_r4-r1';
        weight = [[0 0 -1 0 0 0] zeros(1,48) [0 0 1 0 0 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    else
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'DOWN_r5-r1';
        weight = [[0 0 -1 0 0 0] zeros(1,66) [0 0 1 0 0 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    end
    
    contrast_index = contrast_index + 1;
    if (4 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP-DOWN_allruns';
        weight = [[0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    else
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP-DOWN_allruns';
        weight = [[0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12) [0 0 -1 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    end
    
    contrast_index = contrast_index + 1;
    if (4 == numel(sessions))
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP-DOWN_r4-r1';
        weight = [[0 0 1 0 -1 0] zeros(1,48) [0 0 -1 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    else
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP-DOWN_r5-r1';
        weight = [[0 0 1 0 -1 0] zeros(1,66) [0 0 -1 0 1 0] zeros(1,12)];
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
        matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
    end
    
%     cons for feedbackvalue regressor
%     contrast_index = contrast_index + 1;
%     if (4 == numel(sessions))
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'UP_FB_r2r3';
%         weight = [zeros(1,31) [1] zeros(1,15) [1] zeros(1,16)];
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
%     else
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'FB_r2r3r4';
%         weight = [zeros(1,31) [1] zeros(1,15) [1] zeros(1,15) [1] zeros(1,16)];
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
%     end
%     
%     % not sure if I will ever look at this contrast
%     contrast_index = contrast_index + 1;
%     if (4 == numel(sessions))
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'FB_r1r2r3r4';
%         weight = [zeros(1,15) [1] zeros(1,15) [1] zeros(1,15) [1] zeros(1,15) [1]];
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
%     else
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.name = 'FB_r1r2r3r4r5';
%         weight = [zeros(1,15) [1] zeros(1,15) [1] zeros(1,15) [1] zeros(1,15) [1] zeros(1,15) [1]];
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.weights = weight;
%         matlabbatch{3}.spm.stats.con.consess{contrast_index}.tcon.sessrep = 'none';
%     end
%     
    
    % save mat file and run job
    batch_file_name = strcat('firstLev_batch_mni_allruns.mat');
    save(fullfile(current_stat_dir,batch_file_name),'matlabbatch');
    jobfiles(indSubjects) = {fullfile(current_stat_dir,batch_file_name)};
    
    
end

end

