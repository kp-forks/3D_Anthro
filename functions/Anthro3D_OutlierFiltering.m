function data_filtered = Anthro3D_OutlierFiltering(data, direction, SD)
    data_filtered = data;
    for i = 1:size(data_filtered, direction)
        data_filtered(find(data_filtered(:, i) < nanmean(data(:,i))-nanstd(data(:,i)*SD)), i)=NaN;
        data_filtered(find(data_filtered(:, i) > nanmean(data(:,i))+nanstd(data(:,i)*SD)), i)=NaN;
    end