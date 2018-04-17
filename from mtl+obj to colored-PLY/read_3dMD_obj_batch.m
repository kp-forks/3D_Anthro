clc
clear

% based on code of D. Kroon, University of Twente (June 2010)

filefolder = '../Hand/pinch';
list = dir(sprintf('%s/*.obj', filefolder));

for f = 1:size(list, 1)
%% data loading
    filename_obj = fullfile(filefolder, list(f).name);
    filename_MTL = strrep(filename_obj, 'obj', 'mtl');
    filename_BMP = strrep(filename_obj, 'obj', 'bmp');
    filename_save = strrep(filename_obj, 'obj', 'ply');

    % Open a DI3D OBJ textfile
    fprintf('- Opening the OBJ file: %s (%d out of %d)\n', filename_obj, f , size(list, 1));
    fid = fopen(filename_obj,'r');
        file_text=fread(fid, inf, 'uint8=>char')';
    fclose(fid);
    file_lines = regexp(file_text, '\n+', 'split');
    file_words = regexp(file_lines, '\s+', 'split');
    clear file_text

    % Count number of lines
    cnt = zeros(1, 4);
    for i = 1:length(file_words)
    % for i = 1:10
        if strcmp(file_words{i}{1}, '#')
        elseif strcmp(file_words{i}{1}, 'v')
            cnt(1) = cnt(1)+1;
        elseif strcmp(file_words{i}{1}, 'vn')
            cnt(2) = cnt(2)+1;
        elseif strcmp(file_words{i}{1}, 'vt')
            cnt(3) = cnt(3)+1;
        elseif strcmp(file_words{i}{1}, 'f')
            cnt(4) = cnt(4)+1;
        end
    end

%% Main Calculation (most time-consuming part)
    % Searching vertex and faces
    fprintf('- Searching vertex and face list        ');

    header = {};
    vertex = zeros(cnt(1), 3);
    vertex_normal = zeros(cnt(2), 3);
    vertex_texture_map = zeros(cnt(3), 2);
    face = zeros(cnt(4), 3);
    vertex_texture = zeros(cnt(2), 4);

    cnt = zeros(1, 4);
    for i = 1:length(file_words)
    % for i = 1:10
        if(mod(i,10000) == 0)
            fprintf('\b\b\b\b\b\b\b(%3d %%)', round(i/length(file_words)*100));
        end
        if strcmp(file_words{i}{1}, '#')
            header = [header; file_lines{i}]; % this header will not be used in any further process
        elseif strcmp(file_words{i}{1}, 'v') % list of vertex
            cnt(1) = cnt(1) + 1;
            vertex(cnt(1), 1:3) = [str2double(file_words{i}{2}), str2double(file_words{i}{3}), str2double(file_words{i}{4})];
        elseif strcmp(file_words{i}{1}, 'vn') % list of vertex normal (not necessary in PLY format)
    %         cnt(2) = cnt(2) + 1;
    %         vertex_normal(cnt(2), 1:3) = [str2double(file_words{i}{2}), str2double(file_words{i}{3}), str2double(file_words{i}{4})];
        elseif strcmp(file_words{i}{1}, 'vt') % list of texture
            cnt(3) = cnt(3) + 1;
            vertex_texture_map(cnt(3), 1:2) = [str2double(file_words{i}{2}), str2double(file_words{i}{3})];
        elseif strcmp(file_words{i}{1}, 'f')
            cnt(4) = cnt(4) + 1;
            f1 = strsplit(file_words{i}{2}, '/');
            f2 = strsplit(file_words{i}{3}, '/');
            f3 = strsplit(file_words{i}{4}, '/');
            face(cnt(4), 1:3) = [str2double(f1{1}), str2double(f2{1}), str2double(f3{1})];
            vertex_texture(str2double(f1{1}), 1) = str2double(f1{2});
            vertex_texture(str2double(f2{1}), 1) = str2double(f2{2});
            vertex_texture(str2double(f3{1}), 1) = str2double(f3{2});
        end
    end

%% saving as PLY format
    im = imread(filename_BMP);
    for i = 1:size(vertex_texture, 1)
        if vertex_texture(i, 1) ~= 0 && ...
           vertex_texture_map(vertex_texture(i, 1), 1) ~= 0 && ...
           vertex_texture_map(vertex_texture(i, 1), 2) ~= 0
            X = round(size(im, 1) * (1-vertex_texture_map(vertex_texture(i, 1), 2)), 0);
            Y = round(size(im, 2) * (vertex_texture_map(vertex_texture(i, 1), 1)), 0);
            if X == 0
                X = 1;
            end
            if Y == 0
                Y = 1;
            end
            vertex_texture(i, 2) = im(X, Y, 1);
            vertex_texture(i, 3) = im(X, Y, 2);
            vertex_texture(i, 4) = im(X, Y, 3);
        end
    end

    % vertex_texture(vertex_texture(:, 1) == 0, :) = [];

    % tmp(1:size(vertex_texture, 1), 1) = [1:size(vertex_texture, 1)];
    % tmp(:, 2:4) = 0;
    % vertex_texture = [vertex_texture; tmp];
    % vertex_texture = unique(vertex_texture, 'stable');
    % vertex_texture(1:size(vertex_texture_backup, 1), 2:4) = vertex_texture_backup(:, 2:4);
    % vertex_texture(vertex_texture(:, 1) == 0, :) = [];

    ListVertex = [vertex(:, 1:3), vertex_texture(:, 2:4)];
    ListFace = [repmat(3, size(face, 1), 1), face];
    ListFace(:, 2:4) = ListFace(:, 2:4) - 1;

    Header{1, 1}  = sprintf('ply\n');
    Header{2, 1}  = sprintf('format ascii 1.0\n');
    Header{3, 1}  = sprintf('comment Exported by Matlab\n');
    Header{4, 1}  = sprintf('element vertex %d\n', size(ListVertex, 1));
    Header{5, 1}  = sprintf('property float x\n');
    Header{6, 1}  = sprintf('property float y\n');
    Header{7, 1}  = sprintf('property float z\n');
    Header{8, 1}  = sprintf('property uchar red\n');
    Header{9, 1}  = sprintf('property uchar green\n');
    Header{10, 1} = sprintf('property uchar blue\n');
    Header{11, 1} = sprintf('element face %d\n', size(ListFace, 1));
    Header{12, 1} = sprintf('property list uchar int vertex_index\n');
    Header{13, 1} = sprintf('end_header\n');

    fprintf('\b\b\b\b\b\b\b\n');
    fprintf('- Saving results\n\n');
    function_saving_ply_file(ListVertex, ListFace, Header, filename_save);
end