function Anthro3D_saveSTL(V, F, filename_save)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 11 Sep 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code may not work if PLY has different structure of header
    %% save PLY file
        
    TR = triangulation(F, V);
    FN = faceNormal(TR);
%     FN(size(F,1), 3) = NaN;
%     for i = 1:size(F, 1)
%         FN(i, :) = faceNormal(TR, i);
%     end
    
    fid = fopen(filename_save, 'w');
        fprintf(fid, 'solid Default.stl\n');
        for i = 1:size(F, 1)
            fprintf(fid, '\tfacet normal\t%f\t%f\t%f\n', FN(i, 1), FN(i, 2), FN(i, 3));
            fprintf(fid, '\t\touter loop\n');
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', V(F(i, 1), 1), V(F(i, 1), 2), V(F(i, 1), 3));
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', V(F(i, 2), 1), V(F(i, 2), 2), V(F(i, 2), 3));
            fprintf(fid, '\t\t\tvertex\t%f\t%f\t%f\n', V(F(i, 3), 1), V(F(i, 3), 2), V(F(i, 3), 3));
            fprintf(fid, '\t\tendloop\n');
            fprintf(fid, '\tendfacet\n');
        end
        fprintf(fid, 'endsolid');
    fclose(fid);