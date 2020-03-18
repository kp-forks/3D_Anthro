function function_saving_stl_file(ListVertex, ListFace_backup, filename_save)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 11 Sep 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code may not work if PLY has different structure of header
    %% save PLY file
    
    T = ListFace_backup;
    P = ListVertex;
    
    TR = triangulation(T, P);
    for ti = 1:size(T, 1)
        FN(ti, :) = faceNormal(TR, ti);
    end
    
    fid = fopen(filename_save, 'w');
        fprintf(fid, 'solid Default.stl\n');
        for i = 1:size(T, 1)
            fprintf(fid, '\tfacet normal\t%f\t%f\t%f\n', FN(i, 1), FN(i, 2), FN(i, 3));
            fprintf(fid, '\t\touter loop\n');
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', P(T(i, 1), 1), P(T(i, 1), 2), P(T(i, 1), 3));
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', P(T(i, 2), 1), P(T(i, 2), 2), P(T(i, 2), 3));
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', P(T(i, 3), 1), P(T(i, 3), 2), P(T(i, 3), 3));
            fprintf(fid, '\t\tendloop\n');
            fprintf(fid, '\tendfacet\n');
        end
        fprintf(fid, 'endsolid');
    fclose(fid);