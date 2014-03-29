%% Robert Chen
% 3/28/2014
%
%
%% set path, etc
%REMEMBER TO ADD PATH FIRST!!!
addpath('./')

%directories for data - specify!
hardwareDataDir = '../scgData/';
echoDataDir = '../echoData/03-05-2014-Cardiac/';

%% load the data - hardware
%read in the hardware data
ecgHWfile_baseline = strcat(hardwareDataDir, 'ecgBaseline.txt');
scgStFile_baseline = strcat(hardwareDataDir, 'scg1Baseline.txt');
scgPmiFile_baseline = strcat(hardwareDataDir, 'scg2Baseline.txt');
ecgHWfile_exam = strcat(hardwareDataDir, 'ecgExam.txt');
scgStFile_exam = strcat(hardwareDataDir, 'scg1Exam.txt');
scgPmiFile_exam= strcat(hardwareDataDir, 'scg2Exam.txt');
ecgHW_exam = readDeviceData(ecgHWfile_exam);
scgSt_exam = readDeviceData(scgStFile_exam);
scgPmi_exam = readDeviceData(scgPmiFile_exam);


%% load the data - echo
dir_echo_bmode_files_only = dir(strcat(echoDataDir,'*b8'));
num_bmodes = length(dir_echo_bmode_files_only);
struct_this_subject_data = struct();
struct_this_subject_data.scenario_names = {};
struct_this_subject_data.echo_bmode.headers = {};
struct_this_subject_data.echo_bmode.data = {};
struct_this_subject_data.echo_ecg.headers = {};
struct_this_subject_data.echo_ecg.data = {};

for i = 1:num_bmodes
    bmode_filename = dir_echo_bmode_files_only(i).name;
    split_bmode_filename = regexp(bmode_filename, '\.', 'split');
    str_bmode_nameonly = split_bmode_filename{1};
    ecgEcho_filename = strcat(str_bmode_nameonly, '.ecg');
    [data_echoBmode header_echoBmode] = readEchoData(strcat(echoDataDir, bmode_filename));
    [data_echoEcg header_echoEcg] = readEchoData(strcat(echoDataDir, ecgEcho_filename));
    struct_this_subject_data.scenario_names{i} = str_bmode_nameonly;
    struct_this_subject_data.echo_bmode.headers{i} = header_echoBmode;
    struct_this_subject_data.echo_bmode.data{i} = data_echoBmode;
    struct_this_subject_data.echo_ecg.headers{i} = header_echoEcg;
    struct_this_subject_data.echo_ecg.data{i} = data_echoEcg;
end

