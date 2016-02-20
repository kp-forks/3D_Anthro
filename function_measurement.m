function measurements = function_measurement(ListFace, ListVertex, landmark, subject_name, visualization)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 20 Feb 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code is illustrated for a few facial measurement.
    
    %% visualization of 3D face
    if visualization == 1
        f = figure(1);
%             set(f, 'Name', filename_3D_scan);
            set(f, 'position', [100 200 600 600]);
        %     set(f, 'MenuBar', 'none');
        %     set(f, 'ToolBar', 'none');

            h = trisurf(ListFace, ListVertex(:, 1), ListVertex(:, 2), ListVertex(:, 3));
                set(h, 'FaceColor',[1 0.88 0.77])
                set(h, 'EdgeColor', 'none');
                set(h, 'facealpha',0.5);

                view(2);
                axis equal;
                light('Position', [3 5 7], 'Style', 'infinite');
                lighting gouraud;
                material dull;

        %% visualization of landmarks
            hold on
            h = plot3(landmark{:, 1}, landmark{:, 2}, landmark{:, 3}, 'k.');
                set(h, 'color', 'b', 'markersize', 10)
    end

    measurements = table(zeros(0,1));
    measurements.Properties.VariableNames = {subject_name};
    %% measurement
    % variable 'data' consists of
    % (1) dimension name,
    % (2) landmark 1,
    % (3) landmark 2, and
    % (4) measurement direction (e.g., if measurement direction = [1], 
    % then a measurement will be calculated using only X dimension
    % values of the measurement direction can be [1], [2], [3], [1:2], [2:3], [1:2:3], or [1:3]
    % NOTE, colomn of X, Y, and Z dimension is 1, 2, and 3 in landmark variable, respectively

    % The variable 'data' can be read from a file for your own measurement

    data = {'FaceLength',   'sellion',      'promentale',   [2];
            'FaceWidth',    'zygion L',     'zygion R',     [1]};

    for i = 1:size(data, 1)
        measurements = measure(measurements, landmark, subject_name, data(i, :));
    end
    
function measurements = measure(measurements, landmark, subject_name, data)
    result_T = table(norm(landmark{data{2}, data{4}} - landmark{data{3}, data{4}}));
    result_T.Properties.VariableNames = {subject_name};
    result_T.Properties.RowNames = {data{1}};
    measurements = [measurements; result_T];
%     if visualization == 1
%     end