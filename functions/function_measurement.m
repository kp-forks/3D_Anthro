function measurements = function_measurement(ListFace, ListVertex, landmark, subject_name, visualization)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 30 May 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code is illustrated for some facial measurement.
    
    %% visualization of 3D face
    if visualization == 1
        f = figure(1);
%             set(f, 'Name', filename_3D_scan);
            set(f, 'position', [100 200 600 600]);
        %     set(f, 'MenuBar', 'none');
        %     set(f, 'ToolBar', 'none');

            h1 = trisurf(ListFace, ListVertex(:, 1), ListVertex(:, 2), ListVertex(:, 3));
                set(h1, 'FaceColor',[1 0.88 0.77])
                set(h1, 'EdgeColor', 'none');
                set(h1, 'facealpha',0.5);

                view(2);
                axis equal;
                light('Position', [3 5 7], 'Style', 'infinite');
                lighting gouraud;
                material dull;

        %% visualization of landmarks
            hold on
            h2 = plot3(landmark{:, 1}, landmark{:, 2}, landmark{:, 3}, 'k.');
                set(h2, 'color', 'b', 'markersize', 10)
            global h3
            h3 = plot3(landmark{:, 1}, landmark{:, 2}, landmark{:, 3}, 'k.');
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
    % NOTE, each colomn X, Y, and Z dimension presents 1, 2, and 3, respectively

    % The variable 'data' can be read from a file for your own measurement

    data = {'Face Length',          'sellion',      'promentale',   [2];
            'Lower Face Length',    'subnasale',    'promentale',   [2];
            'Nose Length',          'sellion',      'subnasale',    [2];
            'Nasal Bridge Length',  'sellion',      'pronasale',    [2:3];
            'Face Width',           'zygion L',     'zygion R',     [1];
            'Nose Width',           'nasal ala L',  'nasal ala R',  [1];
            'Nasal Root Breadth',   'dacryon L',    'dacryon R',    [1];
            'Lip Width',            'cheilion L',   'cheilion R',   [1];
            'Bitragion Breadth',    'tragion L',    'tragion R',    [1];
            'Nose Protrusion',      'subnasale',    'pronasale',    [3];
            };

    for i = 1:size(data, 1)
        measurements = measure(measurements, landmark, subject_name, data(i, :), visualization);
    end
    
function measurements = measure(measurements, landmark, subject_name, data, visualization)
    global h3
    point(1, :) = landmark{data{2}, :};
    point(2, :) = landmark{data{3}, :};
    result_T = table(norm(point(1, data{4}) - point(2, data{4})));
    result_T.Properties.VariableNames = {subject_name};
    result_T.Properties.RowNames = {data{1}};
    measurements = [measurements; result_T];
    if visualization == 1
        delete(h3);
        h3 = plot3(point(:, 1), point(:, 2), point(:, 3), 'k-', 'LineWidth', 3);
        drawnow;
        pause(0.5);
    end