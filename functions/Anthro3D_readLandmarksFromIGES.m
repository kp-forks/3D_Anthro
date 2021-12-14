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
                    tmp = filtering(tmp);
                    LMs(cnt, 1) = str2double(tmp{2});
                    LMs(cnt, 2) = str2double(tmp{3});
                    if isnan(str2double(tmp{4}))
                        tmp = fgets(fid);
                        tmp = strsplit(tmp, {',', ';'});
                        for j = 1:length(tmp{1})
                            if isnan(str2double(tmp{1}(j))) && ...
                               ~strcmp(tmp{1}(j), '-') && ...
                               ~strcmp(tmp{1}(j), '.')
                                tmp{1} = tmp{1}(1:j-1);
                                break;
                            end
                        end
                        LMs(cnt, 3) = str2double(tmp{1});
                        cnt = cnt + 1;
                        flag = 1;
                    else
                        LMs(cnt, 3) = str2double(tmp{4});
                        cnt = cnt + 1;
                    end
                end
            else
                flag = 0;
            end
        end
    fclose(fid);
    assert(~isempty(LMs), sprintf('There are no landmarks saved in IGES file. Filename: %s', filename))

function tmp = filtering(tmp)
    for i = 2:size(tmp, 2)
        if strcmp(tmp{end}, '.')
            tmp{i} = tmp{i}(1:end-1);
        else
            for j = 1:length(tmp{i})
                if isnan(str2double(tmp{i}(j))) && ...
                   ~strcmp(tmp{i}(j), '-') && ...
                   ~strcmp(tmp{i}(j), '.')
                    tmp{i} = tmp{i}(1:j-1);
                    break;
                end
            end
        end
    end