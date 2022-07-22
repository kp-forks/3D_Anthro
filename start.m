%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab codees for 3D Anthropometry and Digital Human Modeling
%
% Wonsup Lee (mcury83@gmail.com)
% updated in 23 June 2020
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subdirs = split(genpath('functions'),';');
addpath(strjoin(subdirs(~contains(subdirs,'.git')),';'));
disp('Functions for 3D Anthropometry & DHM is successfully loaded');
clear subdirs