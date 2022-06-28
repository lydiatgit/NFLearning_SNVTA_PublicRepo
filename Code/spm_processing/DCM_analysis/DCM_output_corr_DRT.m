% subjlist to be included
% subjects
subjects_description = readtable('/media/sf_Share_NeuroDebian/data_james/SubjectDescription.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(1).subjects = subjects_description.SubjID_sort(:);
bool_group_intervention = subjects_description.Group_Intervention(:);
studyset(1).subjects = studyset(1).subjects(bool_group_intervention==1);
studyset(1).values_degrees_of_learning = subjects_description.degree_of_learning(bool_group_intervention==1);


% subjlist to be included
% subjects
subjects_description2 = readtable('/media/sf_Share_NeuroDebian/cofeed16/cofeed16/SubjectDescriptionGroups2.csv', 'Delimiter',',','ReadVariableNames',true, 'TreatAsEmpty', {'','.','Na'});
studyset(2).subjects = subjects_description2.SubjectID(:);
bool_group_intervention = subjects_description2.HealthyControl(:);
studyset(2).subjects = studyset(2).subjects(bool_group_intervention==1);
studyset(2).values_degrees_of_learning = subjects_description2.degree_of_learning(bool_group_intervention==1);

% combine DRTs but exclude 115
values_degree_of_learning_all = [studyset(1).values_degrees_of_learning(1:14); studyset(2).values_degrees_of_learning];

%load DCM BMA output
r4 = load('/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4_modeffects_DIdlPFC2_INT/BMS.mat');
%r2 = load('/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r2_modeffects_DIdlPFC2_INT/BMS.mat');

r4ms = load('/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r4_modeffects_DIdlPFC2_INT/model_space.mat');
%r2ms = load('/media/sf_Share_NeuroDebian/data_james/analysis/group_stats_DCM_r2_modeffects_DIdlPFC2_INT/model_space.mat');

r4_DCM_output_mEPS_A12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
r4_DCM_output_mEPS_A21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
r4_DCM_output_mEPS_B12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
r4_DCM_output_mEPS_B21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
r4_DCM_output_mEPS_AB12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
r4_DCM_output_mEPS_AB21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));

% r2_DCM_output_mEPS_A12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
% r2_DCM_output_mEPS_A21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
% r2_DCM_output_mEPS_B12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
% r2_DCM_output_mEPS_B21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
% r2_DCM_output_mEPS_AB12 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));
% r2_DCM_output_mEPS_AB21 = zeros(1,length(r4.BMS.DCM.rfx.bma.mEps));


for indSubs = 1:length(r4.BMS.DCM.rfx.bma.mEps)
    r4_DCM_output_mEPS_A12(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(1,2);
    r4_DCM_output_mEPS_A21(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(2,1);
    r4_DCM_output_mEPS_B121(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2,1);
    r4_DCM_output_mEPS_B211(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1,1);
    r4_DCM_output_mEPS_B122(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2,2);
    r4_DCM_output_mEPS_B212(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1,2);
    r4_DCM_output_mEPS_AB12(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(1,2) + r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2);
    r4_DCM_output_mEPS_AB21(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(2,1) + r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1);
    r4_DCM_output_F(indSubs) = r4.BMS.DCM.rfx.F(indSubs,1);
    r4_DCM_output_mEPS_C1(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.C(1,1);
    r4_DCM_output_mEPS_C2(indSubs) = r4.BMS.DCM.rfx.bma.mEps{1,indSubs}.C(2,1);
    
%     r2_DCM_output_mEPS_A12(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(1,2);
%     r2_DCM_output_mEPS_A21(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(2,1);
%     r2_DCM_output_mEPS_B121(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2,1);
%     r2_DCM_output_mEPS_B211(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1,1);
%     r2_DCM_output_mEPS_B122(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2,2);
%     r2_DCM_output_mEPS_B212(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1,2);
%     r2_DCM_output_mEPS_AB12(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(1,2) + r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(1,2);
%     r2_DCM_output_mEPS_AB21(indSubs) = r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.A(2,1) + r2.BMS.DCM.rfx.bma.mEps{1,indSubs}.B(2,1);
%     r2_DCM_output_F(indSubs) = r2.BMS.DCM.rfx.F(indSubs,1);
%     
    r4ms_B121(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.B(1,2,1);
    r4ms_B211(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.B(2,1,1);
    r4ms_B122(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.B(1,2,2);
    r4ms_B212(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.B(2,1,2);
    r4ms_A12(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.A(1,2);
    r4ms_A21(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.A(2,1);
    r4ms_A11(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.A(1,1);
    r4ms_A22(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.A(2,2);
    r4ms_C21(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.C(2,1);
    r4ms_C22(indSubs) = r4ms.subj(indSubs).sess(1).model(1).Ep.C(2,2);
    
    
%     r2ms_B121(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.B(1,2,1);
%     r2ms_B211(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.B(2,1,1);
%     r2ms_B122(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.B(1,2,2);
%     r2ms_B212(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.B(2,1,2);
%     r2ms_A12(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.A(1,2);
%     r2ms_A21(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.A(2,1);
%     r2ms_A11(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.A(1,1);
%     r2ms_A22(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.A(2,2);
%     r2ms_C21(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.C(2,1);
%     r2ms_C22(indSubs) = r2ms.subj(indSubs).sess(1).model(1).Ep.C(2,2);
end

mean(r4ms_A11)
mean(r4ms_A12)
mean(r4ms_A21)
mean(r4ms_A22)
mean(r4ms_B121)
mean(r4ms_B211)
mean(r4ms_B122)
mean(r4ms_B212)
mean(r4ms_C21)
mean(r4ms_C22)


% mean(r2ms_A11)
% mean(r2ms_A12)
% mean(r2ms_A21)
% mean(r2ms_A22)
% mean(r2ms_B121)
% mean(r2ms_B211)
% mean(r2ms_B122)
% mean(r2ms_B212)
% mean(r2ms_C21)
% mean(r2ms_C22)

mat_DRT_A12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_A12.'];
[r,p] = corrcoef(mat_DRT_A12)

mat_DRT_A21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_A21.'];
[r,p] = corrcoef(mat_DRT_A21)

mat_DRT_B12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_B121.'];
[r,p] = corrcoef(mat_DRT_B12)

mat_DRT_B21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_B21.'];
[r,p] = corrcoef(mat_DRT_B21)

mat_DRT_AB12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_AB12.'];
[r,p] = corrcoef(mat_DRT_AB12)

mat_DRT_AB21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_AB21.'];
[r,p] = corrcoef(mat_DRT_AB21)

%

mat_DRT_A12 = [values_degree_of_learning_all, r2_DCM_output_mEPS_A12.'];
[r,p] = corrcoef(mat_DRT_A12)

mat_DRT_A21 = [values_degree_of_learning_all, r2_DCM_output_mEPS_A21.'];
[r,p] = corrcoef(mat_DRT_A21)

mat_DRT_B12 = [values_degree_of_learning_all, r2_DCM_output_mEPS_B12.'];
[r,p] = corrcoef(mat_DRT_B12)

mat_DRT_B21 = [values_degree_of_learning_all, r2_DCM_output_mEPS_B21.'];
[r,p] = corrcoef(mat_DRT_B21)

mat_DRT_AB12 = [values_degree_of_learning_all, r2_DCM_output_mEPS_AB12.'];
[r,p] = corrcoef(mat_DRT_AB12)

mat_DRT_AB21 = [values_degree_of_learning_all, r2_DCM_output_mEPS_AB21.'];
[r,p] = corrcoef(mat_DRT_AB21)

%

mat_DRT_A12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_A12.' - r2_DCM_output_mEPS_A12.'];
[r,p] = corrcoef(mat_DRT_A12)

mat_DRT_A21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_A21.' - r2_DCM_output_mEPS_A21.'];
[r,p] = corrcoef(mat_DRT_A21)

mat_DRT_B12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_B12.' - r2_DCM_output_mEPS_B12.'];
[r,p] = corrcoef(mat_DRT_B12)

mat_DRT_B21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_B21.' - r2_DCM_output_mEPS_B21.'];
[r,p] = corrcoef(mat_DRT_B21)

mat_DRT_AB12 = [values_degree_of_learning_all, r4_DCM_output_mEPS_AB12.' - r2_DCM_output_mEPS_AB12.'];
[r,p] = corrcoef(mat_DRT_AB12)

mat_DRT_AB21 = [values_degree_of_learning_all, r4_DCM_output_mEPS_AB21.' - r2_DCM_output_mEPS_AB21.'];
[r,p] = corrcoef(mat_DRT_AB21)




