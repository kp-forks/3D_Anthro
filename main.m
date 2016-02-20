%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Tutorial for 3D Anthropometry
%
% Wonsup Lee (mcury83@gmail.com)
% 19 Feb 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % delete all variables
close all; % close all figures

%% data loading
dir = 'source 3D images';
filename = 'face_W.ply';
filename_3D_scan = fullfile(dir, filename);
[ListVertex, ListFace, ListFace_backup, HEADER] = function_loading_ply_file(filename_3D_scan); % see Tutorial #1

filename = 'face_W_landmark.asc';
filename_landmark = fullfile(dir, filename);
landmark = textread(filename_landmark, '');


%% landmark identification
filename_save = 'DB_face_W_landmark.mat';
visualization = 0; % 1 = Yes || 0 = No
landmark = function_landmark_identification(ListFace, ListVertex, landmark, filename_save, visualization);


%% alignment
% The face will be aligned two landmarks (sellion(2) & supramentale(18))


%% facial measurement

% length dimensions (Euclidean distance)
subject_name = 'S1';
visualization = 0; % 1 = Yes || 0 = No
measurements = function_measurement(ListFace, ListVertex, landmark, subject_name, visualization);


% arc, circumference dimensions