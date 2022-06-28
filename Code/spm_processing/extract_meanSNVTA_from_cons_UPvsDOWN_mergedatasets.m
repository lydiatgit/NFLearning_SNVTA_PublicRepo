

close all;
clear all;
bool_running_on_winOS = 1;
if (1==bool_running_on_winOS)
    addpath('C:\Users\lhellrung\Documents\MATLAB\Add-Ons\Toolboxes\NIfTI_20140122\');
    addpath('C:\Users\lhellrung\Documents\MATLAB\Add-Ons\Toolboxes\boxplotGroup');
else
    addpath('/usr/local/MATLAB/R2016b/toolbox/NIfTI_20140122/');    
end

bool_extract_from_con = 1;
bool_data_JS = 1; % MK data otherwise
data_path = '';
data_filenames = '';
stats_path = '';

if (1 == bool_extract_from_con)
    if (1 == bool_data_JS)
        if (1==bool_running_on_winOS)
            data_path = 'H:\Share_NeuroDebian\data_james\analysis';
        else
            data_path = '/media/sf_Share_NeuroDebian/data_james/analysis';
        end
        data_filenames = {'con_0002', 'con_0003', 'con_0004','con_0005', 'con_0006', 'con_0007', 'con_0008', 'con_0009', 'con_0010', 'con_0011'};
        stats_path = 'stats_mni_allruns';
    else
        if (1==bool_running_on_winOS)
            data_path = 'H:\Share_NeuroDebian\cofeed16\cofeed16\analysis';
        else
            data_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis';
        end
        data_filenames = {'con_0002', 'con_0003', 'con_0004','con_0005', 'con_0006', 'con_0007', 'con_0008', 'con_0009'};
        stats_path = 'stats_mni_allruns_newreg6';
    end
    
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
    if (1==bool_running_on_winOS)
        mask_path = 'H:\Share_NeuroDebian\cofeed16\cofeed16\masks';
    else
        mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    end
    mask_filename = 'rSN_1mm.nii'; %
    mask_output_name = 'rSN1mm';
elseif (2 == mask_chosen)
    if (1==bool_running_on_winOS)
        mask_path = 'H:\Share_NeuroDebian\cofeed16\cofeed16\masks';
    else
        mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    end
    mask_filename = 'rmask_probSNVTA.nii'; %rSN_1mm
    mask_output_name = 'probSNVTA';
elseif (3 == mask_chosen)
    if (1==bool_running_on_winOS)
        mask_path = 'H:\Share_NeuroDebian\cofeed16\cofeed16\masks';
    else
        mask_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/masks';
    end
    mask_filename = 'rParahippocampus_wfu.nii'; %
    mask_output_name = 'Parahippocampus_review';
end

if (1 == bool_data_JS)
    if (1==bool_running_on_winOS)
        output_path = 'H:\Share_NeuroDebian\data_james\analysis\extract_from_cons'; 
    else
        output_path = '/media/sf_Share_NeuroDebian/data_james/analysis/extract_from_cons';
    end
    % subjects
    if (1==bool_running_on_winOS)
        subjects_description = readtable('H:\Share_NeuroDebian\data_james\SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true); 
    else
        subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true);
    end
    % DEFINE group for the moment!!!!!!!!
    subjects = subjects_description.SubjID_sort(subjects_description.Group_Intervention==1);

else
    if (1==bool_running_on_winOS)
        output_path = 'H:\Share_NeuroDebian\cofeed16\cofeed16\analysis\extract_from_cons'; 
    else
        output_path = '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/extract_from_cons';
    end
    if (1==bool_running_on_winOS)
         subjects_description = readtable('H:\Share_NeuroDebian\cofeed16\cofeed16\SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true);
    else
        subjects_description = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true);
    end
    % DEFINE group for the moment!!!!!!!!
    subjects = subjects_description.SubjectID(subjects_description.HealthyControl == 1);
end
if (0 == exist(output_path,'dir'))
    mkdir(output_path)
end



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

save(fullfile(output_path, ['con_extractions_' mask_output_name '_UPvsDOWN.mat']), 'output');


%% make stats about this using correlations

% first, take data james from this script
tmp_nam = fieldnames(output);
% i = sessionNr
UP_values(1,:) = cell2mat(cellfun(@(x)(output.(x)(1).mean),tmp_nam,'UniformOutput',false));
UP_values(2,:) = cell2mat(cellfun(@(x)(output.(x)(2).mean),tmp_nam,'UniformOutput',false));
UP_values(3,:) = cell2mat(cellfun(@(x)(output.(x)(3).mean),tmp_nam,'UniformOutput',false));
UP_values(4,:) = cell2mat(cellfun(@(x)(output.(x)(4).mean),tmp_nam,'UniformOutput',false));
UP_values(5,:) = cell2mat(cellfun(@(x)(output.(x)(5).mean),tmp_nam,'UniformOutput',false));

DOWN_values(1,:) = cell2mat(cellfun(@(x)(output.(x)(6).mean),tmp_nam,'UniformOutput',false));
DOWN_values(2,:) = cell2mat(cellfun(@(x)(output.(x)(7).mean),tmp_nam,'UniformOutput',false));
DOWN_values(3,:) = cell2mat(cellfun(@(x)(output.(x)(8).mean),tmp_nam,'UniformOutput',false));
DOWN_values(4,:) = cell2mat(cellfun(@(x)(output.(x)(9).mean),tmp_nam,'UniformOutput',false));
DOWN_values(5,:) = cell2mat(cellfun(@(x)(output.(x)(10).mean),tmp_nam,'UniformOutput',false));


% append MK data
if (1==bool_running_on_winOS)
    output2 = load('H:\Share_NeuroDebian\cofeed16\cofeed16\analysis\extract_from_cons\con_extractions_probSNVTA_UPvsDOWN.mat');
else
    output2 = load('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/extract_from_cons/con_extractions_probSNVTA_UPvsDOWN.mat');
end
tmp_nam2 = fieldnames(output2.output);
UP(1,:) = [UP_values(1,:) cell2mat(cellfun(@(x)(output2.output.(x)(1).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
UP(2,:) = [UP_values(2,:) cell2mat(cellfun(@(x)(output2.output.(x)(2).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
UP(3,:) = [UP_values(3,:) cell2mat(cellfun(@(x)(output2.output.(x)(3).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
% MK data mean run 4 == Transfer, that's why different combination
nanvec(1:length(tmp_nam2)) = nan;
UP(4,:) = [UP_values(4,:) nanvec];
UP(5,:) = [UP_values(5,:) cell2mat(cellfun(@(x)(output2.output.(x)(4).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
DOWN(1,:) = [DOWN_values(1,:) cell2mat(cellfun(@(x)(output2.output.(x)(5).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
DOWN(2,:) = [DOWN_values(2,:) cell2mat(cellfun(@(x)(output2.output.(x)(6).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
DOWN(3,:) = [DOWN_values(3,:) cell2mat(cellfun(@(x)(output2.output.(x)(7).weighted_mean),tmp_nam2,'UniformOutput',false)).'];
DOWN(4,:) = [DOWN_values(4,:) nanvec];
DOWN(5,:) = [DOWN_values(5,:) cell2mat(cellfun(@(x)(output2.output.(x)(8).weighted_mean),tmp_nam2,'UniformOutput',false)).'];

plotme = [nanmean(UP_values.'); nanmean(DOWN_values.')];
plotme2 = [nanstd(UP_values.')/length(UP_values); nanstd(DOWN_values.')/length(DOWN_values)];
mean = plotme.';
se = plotme2.';

UPtable = array2table(UP.');
UPtable.Properties.VariableNames(1:5) = {'run1', 'run2', 'run3', 'run4', 'run5'}
outputfile = fullfile(output_path, 'UP.csv');
writetable(UPtable,outputfile);

DOWNtable = array2table(DOWN.');
DOWNtable.Properties.VariableNames(1:5) = {'run1', 'run2', 'run3', 'run4', 'run5'}
outputfile = fullfile(output_path, 'DOWN.csv');
writetable(DOWNtable,outputfile);

figure
b = bar(mean, 'grouped')
b(1).FaceColor = [.8 .8 .8];
b(2).FaceColor = [.3 .3 .3];
legend(b,'off')
set(gca,'xticklabel',{'Baseline', 'Training 1', 'Training 2', 'Training 3', 'Transfer'})
ylabel('% signal change SN/VTA')
hold on
[ngroups, nbars] = size(mean);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(b(i).XEndPoints, mean(:,i), se(:,i), 'k', 'linestyle', 'none','Color','k','LineWidth',2);
    if (1 == i)
        scatter(repmat(b(i).XEndPoints(1), 43, 1),UPtable.run1,20,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(2), 43, 1),UPtable.run2,20,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(3), 43, 1),UPtable.run3,20,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(4), 43, 1),UPtable.run4,20,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(5), 43, 1),UPtable.run5,20,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
    else 
        scatter(repmat(b(i).XEndPoints(1), 43, 1),DOWNtable.run1,20,'MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(2), 43, 1),DOWNtable.run2,20,'MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(3), 43, 1),DOWNtable.run3,20,'MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(4), 43, 1),DOWNtable.run4,20,'MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
        scatter(repmat(b(i).XEndPoints(5), 43, 1),DOWNtable.run5,20,'MarkerFaceColor',[.3 .3 .3],'MarkerEdgeColor',[.3 .3 .3],'LineWidth',1,'XJitter','randn','XJitterWidth',.05);
    end
end
legend('IMAGINE REWARD','REST');

hold off
if (1==bool_running_on_winOS)
    print(gcf, 'H:\Share_NeuroDebian\cofeed16\cofeed16\analysis_pics\Figures_Paper_NF_MID\Figure_Review_UPvsDOWN\JSMK_UPvsDOWN_barplot', '-dpng', '-r300')
else
    print(gcf, '/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis_pics/Figures_Paper_NF_MID/Figure_Review_UPvsDOWN/JSMK_UPvsDOWN_barplot', '-dpng', '-r300')
end

D2 = squeeze(mat2cell(permute(cat(3,UP',DOWN'),[1,3,2]),size(UP',1),2,ones(1,size(UP',2))));
boxplotGroup(D2', 'PrimaryLabels',{'Baseline' 'Training 1' 'Training 2' 'Training 3' 'Transfer'}, 'SecondaryLabels',{'IMAGINE REWARD', 'REST'}, 'InterGroupSpace', 2)

x = {rand(100,3), rand(120,3)*1.3};

