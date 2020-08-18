function function_saving_ply_file(ListVertex, ListFace, HEADER, filename_save)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 17 Sep 2015
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code may not work if PLY has different structure of header
    %% save PLY file
    
    if size(ListFace, 2) == 3
        ListFace = ListFace - 1;
        ListFace = [ones(size(ListFace, 1), 1)*3, ListFace];
    end
    
    if isempty(HEADER)
        if size(ListVertex, 2) == 3
            isTexture = false;
        elseif size(ListVertex, 2) == 6
            isTexture = true;
        else
            % need to retrun error message
        end
        
        sizeV = size(ListVertex, 1);
        sizeF = size(ListFace, 1);
        HEADER = function_getHeader(sizeV, sizeF, isTexture);
    end
    
    fid = fopen(filename_save, 'w');
        for i = 1:size(HEADER, 1)
            fprintf(fid, '%s', HEADER{i, 1});
        end
        for i = 1:size(ListVertex, 1)
            if size(ListVertex, 2) == 3
                fprintf(fid, '%f %f %f\n', ListVertex(i, 1), ListVertex(i, 2), ListVertex(i, 3));
            elseif size(ListVertex, 2) == 6
                fprintf(fid, '%f %f %f %d %d %d\n', ListVertex(i, 1), ListVertex(i, 2), ListVertex(i, 3), ListVertex(i, 4), ListVertex(i, 5), ListVertex(i, 6));
            end
        end
        for i = 1:size(ListFace, 1)
            fprintf(fid, '%d %d %d %d\n', ListFace(i, 1), ListFace(i, 2), ListFace(i, 3), ListFace(i, 4));
        end
    fclose(fid);