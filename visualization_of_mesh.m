%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Tutorial for 3D Anthropometry
% Tutorial #2. Simple visualization of mesh
%
% Wonsup Lee
% 07 Sep 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % delete all variables

dir = 'source 3D images';
filename = sprintf('%s\\bunny.ply', dir);
[ListVertex, ListFace] = function_loading_ply_file(filename); % loading PLY file

%% visualization
f = figure(1);
    set(f, 'Name', 'Simple visualization of Mesh');
    set(f, 'MenuBar', 'none');
    set(f, 'ToolBar', 'none');
    
    h = trisurf(ListFace, ListVertex(:, 1), ListVertex(:, 2), ListVertex(:, 3));
        set(h, 'FaceColor',[1 0.88 0.77])
        set(h, 'EdgeColor', 'none');

        view(2);
        axis equal;
        light('Position', [3 5 7], 'Style', 'infinite');
        lighting gouraud;
        material dull;