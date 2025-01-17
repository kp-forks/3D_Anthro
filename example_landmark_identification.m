function landmark_identified = example_landmark_identification(ListFace, ListVertex, landmark, visualization)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 19 Feb 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code is illustrated for a face measurement with 20 specified landmarks
    % A customized algorithm is required for a different landmark set
    
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
            h = plot3(landmark(:, 1), landmark(:, 2), landmark(:, 3), 'k.');
                set(h, 'color', 'b', 'markersize', 10)
    end

    %% table generation
    temp = zeros(size(landmark));
    landmark_identified = table(temp(:, 1), temp(:, 2), temp(:, 3));
        variables = {'x'  'y'  'z'};
        rows = {'glabella'
             'sellion'
             'rhinion'
             'dacryon L'
             'dacryon R'
             'alare L'
             'alare R'
             'pronasale'
             'nasal ala L'
             'nasal ala R'
             'subnasale'
             'zygion L'
             'zygion R'
             'tragion L'
             'tragion R'
             'cheilion L'
             'cheilion R'
             'supramentale'
             'promentale'
             'menton'};
        landmark_identified.Properties.VariableNames = variables;
        landmark_identified.Properties.RowNames = rows;


    %% landmark identification
    % Current landmarks are not identified. Landmarks will be identified step by step based on locational relationship among the landmarks.

    landmark = sortrows(landmark, -2); % Y sorting (decrease order)

    % step 1. glabella: the heighest landmark (max value in Y)
        name = 'glabella';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [19, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 2. sellion: the heighest landmark (now sellion is the heighest because glabella was deleted in the list of landmark)
        name = 'sellion';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [18, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 3. menton: the lowest landmark
        name = 'menton';
        landmark = sortrows(landmark, 2); % Y sorting (increase order)
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [17, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 4. promentale: the lowest landmark (now sellion is the heighest because menton was deleted in the list of landmark)
        name = 'promentale';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [16, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 5. supramentale: the lowest landmark (now sellion is the heighest because menton promentlae was deleted in the list of landmark)
        name = 'supramentale';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [15, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 6. cheilion: two lowest landmarks
        temp = landmark(1:2, :); % extract two lowest landmarks
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = [13, 3])

        name = 'cheilion R';
        landmark_identified{name, :} = temp(temp(:, 1) < 0, :); % if X value of temp is smaller than 0, the landmark is right cheilion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'cheilion L';
        landmark_identified{name, :} = temp(temp(:, 1) > 0, :); % if X value of temp is greater than 0, the landmark is right cheilion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 7. right tragion and zygion 
        landmark = sortrows(landmark, 1); % Z sorting (increase order)
        temp = landmark(1:2, :); % extract two right landmarks
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = [11, 3])

        name = 'tragion R';
        landmark_identified{name, :} = temp(temp(:, 3) == min(temp(:, 3)), :); % if Z value of temp is greatest (most frontal point), the landmark is tragion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'zygion R';
        landmark_identified{name, :} = temp(temp(:, 3) == max(temp(:, 3)), :); % if Z value of temp is smallest (most reaest point), the landmark is zygion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 8. left tragion and zygion
        landmark = sortrows(landmark, -1); % Z sorting (decrease order)
        temp = landmark(1:2, :); % extract two left landmarks
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = [9, 3])

        name = 'tragion L';
        landmark_identified{name, :} = temp(temp(:, 3) == min(temp(:, 3)), :); % if Z value of temp is greatest (most frontal point), the landmark is tragion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'zygion L';
        landmark_identified{name, :} = temp(temp(:, 3) == max(temp(:, 3)), :); % if Z value of temp is smallest (most reaest point), the landmark is zygion
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 9. nasal root landmarks: two heighest landmarks
        landmark = sortrows(landmark, -2); % Y sorting (decrease order)
        temp = landmark(1:2, :); % extract two heigheset landmarks
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = [7, 3])

        name = 'dacryon R';
        landmark_identified{name, :} = temp(temp(:, 1) == min(temp(:, 1)), :); % if X value of temp is the smallest, the landmark is right dacryon
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'dacryon L';
        landmark_identified{name, :} = temp(temp(:, 1) == max(temp(:, 1)), :); % if X value of temp is the greatest, the landmark is right dacryon
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 10. rhinion: the heighest landmark
        name = 'rhinion';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [6, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 11. pronasale: the most protruded landmark
        landmark = sortrows(landmark, -3); % Z sorting (decrease order)
        name = 'pronasale';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [5, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 12. subnasale: the lowest landmark in the list
        landmark = sortrows(landmark, 2); % Y sorting (increase order)
        name = 'subnasale';
        landmark_identified{name, :} = landmark(1, :);
        landmark(1, :) = []; % delete identified landmark (now size(landmark) = [4, 3])
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 13. alare landmarks
        landmark = sortrows(landmark, -2); % Y sorting (decrease order)
        temp = landmark(1:2, :); % extract two heighest landmarks
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = [2, 3])

        name = 'alare R';
        landmark_identified{name, :} = temp(temp(:, 1) == min(temp(:, 1)), :); % if X value of temp is the smallest, the landmark is right alare
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'alare L';
        landmark_identified{name, :} = temp(temp(:, 1) == max(temp(:, 1)), :); % if X value of temp is the greatest, the landmark is left alare
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end

    % step 14. nasal ala landmarks    
        name = 'nasal ala R';
        landmark_identified{name, :} = landmark(landmark(:, 1) == min(landmark(:, 1)), :); % if X value of temp is the smallest, the landmark is right nasal ala
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end
        name = 'nasal ala L';
        landmark_identified{name, :} = landmark(landmark(:, 1) == max(landmark(:, 1)), :); % if X value of temp is the greatest, the landmark is left nasal ala
        landmark(1:2, :) = []; % delete identified landmark (now size(landmark) = NaN)
            if visualization == 1
                text(landmark_identified{name, 1}, landmark_identified{name, 2}, landmark_identified{name, 3}, name); pause(0.5); drawnow;
            end