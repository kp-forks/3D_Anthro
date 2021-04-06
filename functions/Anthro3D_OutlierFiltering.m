function data_filtered = Anthro3D_OutlierFiltering(data, direction)
    data_filtered = data;
    for i = 1:size(data_filtered, direction)
        data_filtered(find(data_filtered(:, i) < nanmean(data(:,i))-nanstd(data(:,i)*3)), i)=NaN;
        data_filtered(find(data_filtered(:, i) > nanmean(data(:,i))+nanstd(data(:,i)*3)), i)=NaN;
    end