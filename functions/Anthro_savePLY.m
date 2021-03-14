function Anthro_savePLY(V, F, filename_save)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 17 Sep 2015
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code may not work if PLY has different structure of header
    %% save PLY file
    
    if size(F, 2) == 3
        F = F - 1;
        F = [ones(size(F, 1), 1)*3, F];
    end
    
    if size(V, 2) == 3
        hasTexture = false;
    elseif size(V, 2) == 6
        hasTexture = true;
    else
        % need to retrun error message
    end

    sizeV = size(V, 1);
    sizeF = size(F, 1);
    Header = Anthro_savePLY_getHeader(sizeV, sizeF, hasTexture);
    
    fid = fopen(filename_save, 'w');
        for i = 1:size(Header, 1)
            fprintf(fid, '%s', Header{i, 1});
        end
        for i = 1:size(V, 1)
            if size(V, 2) == 3
                fprintf(fid, '%f %f %f\n', V(i, 1), V(i, 2), V(i, 3));
            elseif size(V, 2) == 6
                fprintf(fid, '%f %f %f %d %d %d\n', V(i, 1), V(i, 2), V(i, 3), V(i, 4), V(i, 5), V(i, 6));
            end
        end
        for i = 1:size(F, 1)
            fprintf(fid, '%d %d %d %d\n', F(i, 1), F(i, 2), F(i, 3), F(i, 4));
        end
    fclose(fid);