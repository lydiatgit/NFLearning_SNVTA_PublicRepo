

close all;
clear all;
addpath('/usr/local/MATLAB/R2016b/toolbox/NIfTI_20140122/');
addpath('/usr/local/MATLAB/R2016b/toolbox/spm8/toolbox/nansuite/');

%Define StudySets
% Cofeed Data
studyset = struct;
summary = struct;

% experiment folder
paths.output_path_base = '/media/sf_Share_NeuroDebian/data_james/analysis/extract_from_cons';

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
studyset(2).bool_group_control = subjects_description2.HealthyControl(:)*0;
studyset(2).values_degrees_of_learning = subjects_description2.degree_of_learning(:);

% 1 - ROIs identical between NF & MID
% 2 - ROIs from COntrol group
% 3 - ROIs from r4-r1 analog cognitive control review paper Niendam 2013,
% bit more far away Bartra 2013
% 4 - ROIs from PPI based on dlPFC seed for allruns 
% 5 - ROIs from NFPmodDelta and calculated r3-r2 contrast
% 6 - ROIs from NFPmodDelta and calculated r3 contrast only
% 7 - ROIs from NFPmodDelta and calculated r2 contrast only
% 8 - ROIs from GLM and calculated r4 contrast only
% 9 - ROIs from GLM and calculated r1 contrast only
bool_analysis = 8;
paths.masks = '';
maskFiles = '';
outputfilenidentifier = '';
if (1 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_20180917';
    maskFiles = {'ROI_NF_dlPFC.nii', 'ROI_NF_FFG.nii', 'ROI_NF_MTL.nii', 'ROI_NF_PCC.nii', 'ROI_NF_PHG.nii', 'ROI_NF_SFG.nii', 'ROI_NF_STN.nii', 'ROI_NF_Thalamus.nii'};
    outputfilenidentifier = 'GLM_r4-r1';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0020'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0017'};
elseif (2 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_Amygdala_CON_r4-r1.nii'};
    outputfilenidentifier = 'GLM_r4-r1_CON';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0020'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0017'};
elseif (3 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_Precuneus_r4-r1.nii', 'ROI_Caudate_r4-r1.nii', 'ROI_TemporalCortex_r4-r1.nii', 'ROI_SFG_r4-r1.nii', 'ROI_OFC_r4-r1.nii', 'ROI_MFG_r4-r1.nii', 'ROI_ACC_r4-r1.nii', 'ROI_rIFG_r4-r1.nii', 'ROI_dlPFC_r4-r1.nii', 'ROI_Thalamus_r4-r1.nii'};
    outputfilenidentifier = 'GLM_r4-r1_CognitiveControl';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0020'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0017'};
elseif (4 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_SN-VTA_PPIdlPFCbased.nii'};
    outputfilenidentifier = 'PPI_allruns_dlPFCseed';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns/PPI_VOI_dlPFC_NF_gPPI';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_(UP-DOWN)allruns'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6/PPI_VOI_dlPFC_NF_gPPI';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_(UP-DOWN)allruns'};
elseif (5 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_dlPFC_predictionError_NFPmodDelata_r3r2.nii'};
    outputfilenidentifier = 'GLMPmodDelta_r3-r2_dlPFC';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'FB3-FB2'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'FB3-FB2'};
elseif (6 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_dlPFC_predictionError_NFPmodDelata_r3r2.nii'};
    outputfilenidentifier = 'GLMPmodDelta_r3only_dlPFC';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0029'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0024'};
elseif (7 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_dlPFC_predictionError_NFPmodDelata_r3r2.nii'};
    outputfilenidentifier = 'GLMPmodDelta_r2only_dlPFC';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0028'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_NFvaluesPmodDelta';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0023'};
elseif (8 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_Precuneus_r4-r1.nii', 'ROI_Caudate_r4-r1.nii', 'ROI_TemporalCortex_r4-r1.nii', 'ROI_SFG_r4-r1.nii', 'ROI_OFC_r4-r1.nii', 'ROI_MFG_r4-r1.nii', 'ROI_ACC_r4-r1.nii', 'ROI_rIFG_r4-r1.nii', 'ROI_dlPFC_r4-r1.nii', 'ROI_Thalamus_r4-r1.nii'};
    outputfilenidentifier = 'GLM_r4only_CognitiveControl';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0016'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0013'};
elseif (9 == bool_analysis)
    paths.masks = '/media/sf_Share_NeuroDebian/masks_general/Mask_extracts/Masks_Figures';
    maskFiles = {'ROI_Precuneus_r4-r1.nii', 'ROI_Caudate_r4-r1.nii', 'ROI_TemporalCortex_r4-r1.nii', 'ROI_SFG_r4-r1.nii', 'ROI_OFC_r4-r1.nii', 'ROI_MFG_r4-r1.nii', 'ROI_ACC_r4-r1.nii', 'ROI_rIFG_r4-r1.nii', 'ROI_dlPFC_r4-r1.nii', 'ROI_Thalamus_r4-r1.nii'};
    outputfilenidentifier = 'GLM_r1only_CognitiveControl';
    studyset(1).paths.first_level_folder = 'stats_mni_allruns';
    studyset(1).paths.analysis_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
    studyset(1).data_filenames = {'con_0012'};
    studyset(2).paths.first_level_folder = 'stats_mni_allruns_newreg6';
    studyset(2).paths.analysis_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
    studyset(2).data_filenames = {'con_0010'};

end

if (0 == exist(paths.output_path_base,'dir'))
    mkdir(output_path)
end

indSubjectAllStudysets = 0;
for indStudyset = 1:numel(studyset)
    group = indStudyset;
    subjects = studyset(indStudyset).subjects;
        
    output = struct();
    for indSubject = 1:numel(subjects)
        subjID = cell2mat(subjects(indSubject));
        current_DOFL = studyset(indStudyset).values_degrees_of_learning(indSubject);
        currentPath = fullfile(studyset(indStudyset).paths.analysis_path, subjID, studyset(indStudyset).paths.first_level_folder);
        currentFile = dir(fullfile(currentPath, [cell2mat(studyset(indStudyset).data_filenames),'.nii']));
        if (isempty(currentFile))
            currentFile = dir(fullfile(currentPath, [cell2mat(studyset(indStudyset).data_filenames),'.img']));
        end
        if (isempty(currentFile))
            % cocaine subjects might be missing - check IDs
            fprintf('Missing subject: %s\n', subjID);
            continue;
        end
        indSubjectAllStudysets = indSubjectAllStudysets + 1;
        
        
        for indMask = 1:length(maskFiles)
            % Maske MNI SPace
            mask_file = fullfile(paths.masks, maskFiles(indMask));
            mask_data = load_nii(cell2mat(mask_file));
            file_path = fullfile(currentPath, currentFile.name);
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
            
            summary(indSubjectAllStudysets).subject = subjID;
            summary(indSubjectAllStudysets).studyset = indStudyset;
            summary(indSubjectAllStudysets).control = studyset(indStudyset).bool_group_control(indSubject);
            summary(indSubjectAllStudysets).intervention = studyset(indStudyset).bool_group_intervention(indSubject);
            summary(indSubjectAllStudysets).dofl = current_DOFL;
            
            vname_mean = replace([genvarname(cell2mat(strtok(maskFiles(indMask),'.'))) '_mean'], '0x2D','');
            vname_std = replace([genvarname(cell2mat(strtok(maskFiles(indMask),'.'))) '_std'], '0x2D','');
            summary(indSubjectAllStudysets).(vname_mean) = nanmean(mask_voxels);
            summary(indSubjectAllStudysets).(vname_std) = nanstd(mask_voxels);
            %summary(indSubjectAllStudysets).(genvarname(strtok(maskFiles(indMask),'.nii'))) = nanstd(mask_voxels); 
            
            
        end % end of mask
        
        
        
        
    end % end of subjects
end % end of studyset

table = struct2table(summary);
outputfile = fullfile(paths.output_path_base, ['extractedData_FromContrast_' outputfilenidentifier '.csv'] );
writetable(table,outputfile,'Delimiter',',','QuoteStrings',true)
%save(fullfile(output_path, 'con_extractions_GLM_ROIs_summary.mat'), 'output');
%
% Note to read in again and sort by runs, use
% tmp_nam = fieldnames(output)
% i = sessionNr
% ri = cell2mat(cellfun(@(x)(output.(x)(i).mean),tmp_nam,'UniformOutput',false))

%Calculate tertile via
%y = prctile(r3r2,[33.3 66.6])