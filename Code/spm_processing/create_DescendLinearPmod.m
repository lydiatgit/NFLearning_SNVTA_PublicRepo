%load('/media/sf_Share_NeuroDebian/data_james/analysis/timeseries_analysis/linear_pmod.mat');
load('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/timeseries_analysis/linear_pmod.mat');

%subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true);
subjects_description = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true);

subjects = subjects_description.SubjectID(:);
subjects_BIDS = subjects_description.SubjID_BIDS(:);
% sessions
sessions = {'r1', 'r2', 'r3', 'r4'};
%sessions = {'r1', 'r2', 'r3', 'r4', 'r5'};

for indSubjects = 1:numel(subjects)
    for indSessions = 1:numel(sessions)
        
        output.(cell2mat(subjects_BIDS(indSubjects)))(indSessions).timecourse = sort(output.(cell2mat(subjects_BIDS(indSubjects)))(indSessions).timecourse, 'descend');
        
    end
end

%save('/media/sf_Share_NeuroDebian/data_james/analysis/timeseries_analysis/descend_linear_pmod.mat', 'output');
save('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/analysis/timeseries_analysis/descend_linear_pmod.mat', 'output');