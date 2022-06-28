

close all;
clear all;
addpath('/usr/local/MATLAB/R2016b/toolbox/NIfTI_20140122/');

bool_extract_from_con = 1;
data_path = '';
data_filenames = '';
stats_path = '';

if (1 == bool_extract_from_con)
    data_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    data_filenames = {'con_0012', 'con_0013', 'con_0014','con_0015', 'con_0016'};
    stats_path = 'stats_mni_allruns';
else
    disp('No data given!')
end

% choose the current mask 
% 1 - rSN Maske
% 2 Adcock probSNVTA mask
% 3 Parahippocampus - JUST FOR REVIEW!!
mask_chosen = 2;
mask_path = '';
mask_filename = '';
mask_output_name = '';
if (1 == mask_chosen)
    mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    mask_filename = 'rSN_1mm.nii'; %
    mask_output_name = 'rSN1mm';
elseif (2 == mask_chosen)
    mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    mask_filename = 'rmask_probSNVTA.nii'; %rSN_1mm
    mask_output_name = 'probSNVTA';
elseif (3 == mask_chosen)
    mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    mask_filename = 'rParahippocampus_wfu.nii'; %
    mask_output_name = 'Parahippocampus_review';
end

output_path = '/media/sf_Share_NeuroDebian/data_james/analysis/extract_from_cons';
if (0 == exist(output_path,'dir'))
    mkdir(output_path)
end

% subjects
subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true);
subjects = subjects_description.SubjID_sort(:);

output = struct();
for indSubject = 1:numel(subjects)
    
    % Maske MNI SPace
    mask_file = fullfile(mask_path, mask_filename);
    mask_data = load_nii(mask_file);
    
    for indSession = 1:length(data_filenames)
        file_path = fullfile(data_path, subjects{indSubject}, stats_path, [cell2mat(data_filenames(indSession)) '.nii']);
        con_data = load_nii(file_path);
        
        
        % mult epi * mask
        [mix,miy,miz]=ind2sub(size(mask_data.img),find(mask_data.img > 0));
        mi=[mix,miy,miz];
        mask_voxels = [];
        mask_weights = [];
        for indInd=1:size(mi,1)
            mask_voxels(:,indInd) = double(squeeze(con_data.img(mi(indInd,1),mi(indInd,2),mi(indInd,3),:)));
            mask_weights(:,indInd) = double(squeeze(mask_data.img(mi(indInd,1),mi(indInd,2),mi(indInd,3),:)));
        end
        
        output.(subjects{indSubject})(indSession).mean = nanmean(mask_voxels);
        output.(subjects{indSubject})(indSession).std = nanstd(mask_voxels);
        output.(subjects{indSubject})(indSession).weighted_mean = nansum(mask_voxels)/nansum(mask_weights);
        
        
    end % end of session
    
    
    
    
    
    
    
end % end of subjects

save(fullfile(output_path, ['con_extractions_' mask_output_name '_summary.mat']), 'output');


%% make stats about this using correlations

% first, take data james from this script
tmp_nam = fieldnames(output);
% i = sessionNr
r1 = cell2mat(cellfun(@(x)(output.(x)(1).weighted_mean),tmp_nam,'UniformOutput',false));
r2 = cell2mat(cellfun(@(x)(output.(x)(2).weighted_mean),tmp_nam,'UniformOutput',false));
r3 = cell2mat(cellfun(@(x)(output.(x)(3).weighted_mean),tmp_nam,'UniformOutput',false));
r4 = cell2mat(cellfun(@(x)(output.(x)(4).weighted_mean),tmp_nam,'UniformOutput',false));
r5 = cell2mat(cellfun(@(x)(output.(x)(5).weighted_mean),tmp_nam,'UniformOutput',false));
dort = r5-r1;
dort_INT = dort(1:14);
dort_CON = dort(15:end);
slope = r4-r2;
slope_INT = slope(1:14);
slope_CON = slope(15:end);


% load data from MK - make sure it's only HC data in!
load('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/extract_from_cons/con_extractions_probSNVTA_summary.mat');
tmp_nam = fieldnames(output);
r1 = cell2mat(cellfun(@(x)(output.(x)(1).weighted_mean),tmp_nam,'UniformOutput',false));
r2 = cell2mat(cellfun(@(x)(output.(x)(2).weighted_mean),tmp_nam,'UniformOutput',false));
r3 = cell2mat(cellfun(@(x)(output.(x)(3).weighted_mean),tmp_nam,'UniformOutput',false));
r4 = cell2mat(cellfun(@(x)(output.(x)(4).weighted_mean),tmp_nam,'UniformOutput',false));

dort_INT_MK = r4-r1;
slope_INT_MK = r3-r2;

dort_INT = [dort_INT; dort_INT_MK];
slope_INT = [slope_INT; slope_INT_MK];


mat_INT_slope = [dort_INT, slope_INT];
mat_CON_slope = [dort_CON, slope_CON];

table_INT = array2table(mat_INT_slope);
table_INT.Properties.VariableNames(1:2) = {'DORT', 'slope'}
outputfile = fullfile(output_path, 'DRTslope_INT.csv');
writetable(table_INT,outputfile);
table_CON = array2table(mat_CON_slope);
table_CON.Properties.VariableNames(1:2) = {'DORT', 'slope'}
outputfile = fullfile(output_path, 'DRTslope_CON.csv');
writetable(table_CON,outputfile);



[r,p] = corrcoef(mat_INT_slope)
[r,p] = corrcoef(mat_CON_slope)

% Kruskal Wallis for DORT between groups
groups = [ones(length(dort_CON),1); 2*ones(length(dort_INT_MK),1); 3*ones(length(dort_INT)-length(dort_INT_MK),1)];
dorts = [dort_CON; dort_INT_MK; dort(1:14)];
[p, anova,stats] = kruskalwallis(dorts,groups,'off')
