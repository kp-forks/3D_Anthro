function LMs = Anthro3D_readLandmarksFromIGES(filename)
% this code needs to be tested for different IGES formats
    fid = fopen(filename);
        clear tmp
        fseek(fid, 0, 'eof');
        fileSize = ftell(fid);
        frewind(fid);
        tmp = fread(fid, fileSize, 'uint8');
        numLines = sum(tmp == 10);
    fclose(fid);
    
    flag = 0;
    fid = fopen(filename);
        cnt = 1;
        for i = 1:numLines
            if flag == 0
                clear tmp
                tmp = fgets(fid);
                tmp = strsplit(tmp, {',', ';'});
                if str2double(tmp{1}) == 116
                    LMs(cnt, 1) = str2double(tmp{2}(1:end-2));
                    LMs(cnt, 2) = str2double(tmp{3}(1:end-2));
                    if isnan(str2double(tmp{4}(1:end-2)))
                        tmp = fgets(fid);
                        tmp = strsplit(tmp, {',', ';'});
                        LMs(cnt, 3) = str2double(tmp{1}(1:end-2));
                        cnt = cnt + 1;
                        flag = 1;
                    else
                        LMs(cnt, 3) = str2double(tmp{4}(1:end-2));
                        cnt = cnt + 1;
                    end
                end
            else
                flag = 0;
            end
        end
    fclose(fid);
    assert(~isempty(LMs), sprintf('There are no landmarks saved in IGES file. Filename: %s', filename))