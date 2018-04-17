clc
clear
close all

%% setting

run_BBW_W_generation = 1; % 0 for run BBW weights generation, if no BBW weights was generated
run_registration = 0;     % 0 for run BBW & ICP algorithm, if no registration was conducted (in case of run_registration = 1, a preacquired data will be loaded and analyzed by PCA)
run_PCA = 0;              % 0 for run PCA analysis

num_PC = 4; % choosen by researcher
num_participants = 30;
num_landmark = 24;

filename_template = sprintf('template_average_size_s80_less_vertex.ply');
filename_template_LM = sprintf('template_average_size_s80_landmark.asc');

[template_V, template_F, template_F_backup, template_HEADER] = function_loading_ply_file(filename_template);
[template_LM(:, 1), template_LM(:, 2), template_LM(:, 3)] = textread(filename_template_LM,  '%f %f %f');

load('DB_all_landmarks.mat');

%% generation of BBW weights
    %%% Copyright - BBW algorithm %%%
    % This is a script that demos computing Bounded Biharmonic Weights automatically for a 2D shape.
    % This file and any included files (unless otherwise noted) are copyright Alec Jacobson. Email jacobson@inf.ethz.ch if you have questions
    % Copyright 2011, Alec Jacobson (jacobson@inf.ethz.ch)
    % NOTE: Please contact Alec Jacobson, jacobson@inf.ethz.ch before using this code outside of an informal setting, i.e. for comparisons.

    % Compute boundary conditions
    if run_BBW_W_generation == 0 % run BBW if run_BBW == 0
        [b,bc] = bbw_boundary_conditions(template_V,template_F,template_LM);
        % Compute weights
        W = bbw_biharmonic_bounded(template_V,template_F,b,bc,'quad'); % matlab quadratic programming solver
        % Normalize weights
        W = W./repmat(sum(W,2),1,size(W,2));
        save('template_W.mat', 'W');
    else
        load('template_W.mat');
    end
    
    %%% [need to add weight visualizatoin code here]
%     Fig = trisurf(F, V(:,1), V(:,2), zeros(size(v,1),1), 'FaceColor', 'interp');
%     set(Fig, 'CData', W(:, iP); % iP???

%% main
if run_registration == 0 % Run if this is the first trial for the analysis. Then, this will make some output data in 'output' folders.
    for p = 1:num_participants
        clc
        p
    
        filename_target = sprintf('sample_source_3D\\%03d.ply', p);
        [target_V, target_F, target_F_backup, target_HEADER] = function_loading_ply_file(filename_target);
        target_V = target_V(:, 1:3);

        for i = 1:num_landmark
            target_LM(i, 1) = landmark_DB(p, (i-1)*3+1);
            target_LM(i, 2) = landmark_DB(p, (i-1)*3+2);
            target_LM(i, 3) = landmark_DB(p, (i-1)*3+3);
        end
    
        %% Step 1. global registration using landmark based on BBW
        Diff = target_LM - template_LM;

        % Deform mesh via controls
        % Display mesh and control points and allow user to interactively deform mesh and view weight visualizations
        % Commented out are examples of how to call "simple_deform.m" with various options
        % simple_deform(V,F,C,W) % interactively deform point controls
        template_V_morphed1 = bbw_simple_deform(template_V,template_F,template_LM,W,Diff);

        % save the results of global registration using landmark based on BBW
        filename_save = sprintf('output1_by_bbw\\%03d.ply', p);
        function_saving_ply_file(template_V_morphed1, template_F_backup, template_HEADER, filename_save);
    
        %% Step 2. local optimzation using non-rigid ICP
        iterations = 20; % number of iterations; usually between 10 en 30
        flag_prealligndata = 1;
            %  0 if the data still need to be roughly alligned
            %  1 if the data is already alligned (manual or landmark based)
        figureOn = 0;
            %  0 for figure off
            %  1 for figure on
        template_V_morphed2 = ICP_nonrigidICP(target_V,template_V_morphed1,target_F,template_F,iterations,flag_prealligndata, figureOn);
        
        % save the results of local optimzation using non-rigid ICP
        filename_save = sprintf('output2_by_ICP\\%03d.ply', p);
        function_saving_ply_file(template_V_morphed2, template_F_backup, template_HEADER, filename_save);

        % following vertex will not be used in PCA
        clearList = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;19;20;22;25;26;27;29;33;35;36;40;47;49;52;56;61;72;79;81;84;87;91;98;102;103;113;114;116;119;123;126;134;136;142;144;146;150;156;157;159;169;171;182;186;190;193;199;205;209;213;214;224;232;233;240;253;254;267;273;284;294;300;318;324;345;346;352;365;367;373;384;405;422;437;445;446;463;477;491;498;509;514;530;531;535;555;575;577;579;608;611;613;628;632;652;655;658;664;677;679;682;685;694;695;701;708;718;721;724;735;742;744;745;752;753;759;770;773;777;779;787;792;794;803;804;808;810;814;821;822;823;828;830;834;840;841;843;847;850;853;859;861;862;863;868;875;876;877;879;880;881;882;884;885;886;887;888;889;890;891;892;893;894;895;896;897;898;899;900;901;902;903;904;905;906;907;908;909;910;911;912;913;914;915;916;917;918;919;920;921;922;42;71;99;120;594;793;820;852;864;878;18;21;28;31;32;38;54;74;769;813;854;873;883];
    
        for v = 1:length(clearList)
            template_V_morphed2(clearList(v), :) = [0, 0, 0];
            template_F(template_F(:, 1) == clearList(v), :) = [];
            template_F(template_F(:, 2) == clearList(v), :) = [];
            template_F(template_F(:, 3) == clearList(v), :) = [];
        end
    
        %% visualization    
%         hold off
%         h1 = trisurf(template_F, template_V_morphed2(:, 1), template_V_morphed2(:, 2), template_V_morphed2(:, 3));
%             set(h1, 'FaceColor', [1 0.88 0.77])
%             set(h1, 'EdgeColor', [0 0 0]);
%             axis equal;
%             axis ([-80 80 -140 60 -40 40]);
%             view(2);
%             light('Position', [3 5 7], 'Style', 'infinite');
%             lighting gouraud;
%             material dull;
%         hold on
%             plot3(target_LM(:, 1), target_LM(:, 2), target_LM(:, 3), '.y', 'markersize', 15); % landmarks

        %% save the results of the registration in one matrix file
        template_V_morphed2(template_V_morphed2(:, 1) == 0, :) = [];
        for i = 1:size(template_V_morphed2, 1)
            all_vertex(p, (i-1)*3+1) = template_V_morphed2(i, 1);
            all_vertex(p, (i-1)*3+2) = template_V_morphed2(i, 2);
            all_vertex(p, (i-1)*3+3) = template_V_morphed2(i, 3);
        end
        save('DB_all_vertex.mat', 'all_vertex');
    end
else
    clc
    % just load the saved data (all_vertex) without conducting the registration procedure
    load('DB_all_vertex.mat'); % DB_all_vertex includes the registered template data of all 336 participants
end

%% Step 3. PCA
L_name = num2cell(zeros(1, size(all_vertex, 2)));
for i = 1:size(all_vertex, 1)/3
    L_name((i-1)*3+1) = {sprintf('L%dx', i)};
    L_name((i-1)*3+2) = {sprintf('L%dy', i)};
    L_name((i-1)*3+3) = {sprintf('L%dz', i)};
end

if run_PCA == 0
    [PCA_COEFF, PCA_SCORE, PCA_eigenvalue, PCA_tsquare, PCA_explained, PCA_mu] = pca(all_vertex, 'Algorithm', 'eig', 'Centered', true, 'Algorithm', 'svd');
    save('DB_PCA_COEFF_30.mat', 'PCA_COEFF');
    save('DB_PCA_SCORE_30.mat', 'PCA_SCORE');
    save('DB_PCA_eigenvalue_30.mat', 'PCA_eigenvalue');
    save('DB_PCA_tsquare_30.mat', 'PCA_tsquare');
    save('DB_PCA_explained_30.mat', 'PCA_explained');
    save('DB_PCA_mu_30.mat', 'PCA_mu');
else % load PCA restuls preanalyzed with all 336 participants
    load('DB_PCA_COEFF.mat');
    load('DB_PCA_SCORE.mat');
    load('DB_PCA_eigenvalue.mat');
    load('DB_PCA_tsquare.mat');
    load('DB_PCA_explained.mat');
    load('DB_PCA_mu.mat');
end

% cumsum(PCA_eigenvalue)./sum(PCA_eigenvalue);

% figure(1);
% % F1 = biplot(PCA_COEFF(:, 1:2), 'Scores', PCA_SCORE(:, 1:2), 'VarLabels', L_name,  'Color', [0 .625 0.6], 'Marker', 'O', 'MarkerEdgeColor', [.5 .5 .5]);
% F1 = biplot(PCA_COEFF(:, 1:2), 'Scores', PCA_SCORE(:, 1:2), 'Color', [0 .625 0.6], 'Marker', 'O', 'MarkerEdgeColor', [.5 .5 .5]);
% xlabel('Principal component 1', 'FontSize', 15);
% ylabel('Principal component 2', 'FontSize', 15);
% set(findall(F1, 'type', 'text'), 'FontSize', 13);
% axis([-.1 .1 -.1 .1]);
% 
% figure(2);
% plot(PCA_SCORE(:, 1), PCA_SCORE(:, 2), '+');
% 
figure(3);
pareto(PCA_eigenvalue);
xlabel('Principal Component');
ylabel('Eigenvalue');

figure(4);
pareto(PCA_explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)');


for i = 1:size(all_vertex, 2)/3
    default_position(i, 1) = PCA_mu((i-1)*3+1);
    default_position(i, 2) = PCA_mu((i-1)*3+2);
    default_position(i, 3) = PCA_mu((i-1)*3+3);
    for k = 1:num_PC
        PC_eigenvector(k, i, 1) = PCA_COEFF((i-1)*3+1, k);
        PC_eigenvector(k, i, 2) = PCA_COEFF((i-1)*3+2, k);
        PC_eigenvector(k, i, 3) = PCA_COEFF((i-1)*3+3, k);
    end
end

for k = 1:num_PC
    for i = 1:size(all_vertex, 2)/3
        for j = 1:3
            % -3SD
            moved_position1(k, i, j) = default_position(i, j) + PC_eigenvector(k, i, j)*-30*std(all_vertex(:, (i-1)*3+j));
            % +3SD
            moved_position2(k, i, j) = default_position(i, j) + PC_eigenvector(k, i, j)*+30*std(all_vertex(:, (i-1)*3+j));
        end
    end
%     if moved_position1(k, 10, 1) < moved_position2(k, 10, 1)
%         temp = moved_position1(k, :, :);
%         moved_position1(k, :, :) = moved_position2(k, :, :);
%         moved_position2(k, :, :) = temp;
%     end
end

for PC = 1:num_PC
    figure(10+PC);
    plot3(default_position(:,1), default_position(:,2), default_position(:,3), 'k.');
    view(2);
    axis equal;
    hold on
    for i = 1:size(all_vertex, 2)/3
        l = [moved_position1(PC, i, :); moved_position2(PC, i, :)];
        plot3(l(:, 1), l(:, 2), l(:, 3), '-r');
    end
end