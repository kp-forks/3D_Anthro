function [templateV] = ICP_nonrigidICP(targetV, templateV, targetF, templateF, iterations, flag_prealligndata, figureOn, rigidICP, weight)

% INPUT
% - target: vertices of target mesh; n * 3 array of xyz coordinates
% - template: vertices of template mesh; m * 3 array of xyz coordinates

% - Ft: faces of target mesh; j * 3 array
% - Fs: faces of template mesh; k * 3 array

% - iterations: number of iterations; usually between 10 and 30
% - flag_prealligndata: 0 or 1.  
    %  0 if the data still need to be roughly alligned
    %  1 if the data is already alligned (manual or landmark based)
% - weight: m * 1 (if weight is not defined, default value is 0.5)
    % 0 < weight < 1
    % smaller value: rigidity is high
    % larger value: rigidity is low
    

% OUTPUT
% -registered: registered template vertices on target mesh. Faces are not affected and remain the same is before the registration (Fs). 

if nargin < 8
    error('Wrong number of input arguments')
elseif nargin == 8
    weight(1:size(templateV, 1),1) = 0.5;
end



tic
clf
%assesment of meshes quality and simplification/improvement
disp(' ');
disp('<starting ICP algorithm>');
% disp('Remeshing and simplification target Mesh');


[cutoff, ~] = ICP_definecutoff( templateV, templateF );


[Indices_edgesS] = ICP_detectedges(templateV, templateF);
[Indices_edgesT] = ICP_detectedges(targetV, targetF);

if isempty(Indices_edgesS) == 0
   disp('Warning: template mesh presents free edges. ');
   if flag_prealligndata == 0
       error('template Mesh presents free edges. Preallignement can not reliably be executed') 
   end
end

if isempty(Indices_edgesT) == 0
   disp('Warning: Target mesh presents free edges. ');
   if flag_prealligndata == 0
       error('Target mesh presents free edges. Preallignement can not reliably be executed') 
   end
end

if rigidICP == 1
    %initial allignment and scaling
    disp('Rigid allignement');

    if flag_prealligndata == 1
        [~, templateV, ~] = ICP_rigidICP(targetV, templateV, 1, Indices_edgesT, Indices_edgesS);
    else
        [~, templateV, ~] = ICP_rigidICP(targetV, templateV, 0, Indices_edgesT, Indices_edgesS);
    end
end

if figureOn == 1
    %plot of the meshes
    figure(99)
        h = trisurf(templateF, templateV(:, 1), templateV(:, 2), templateV(:, 3), 0.3, 'Edgecolor', 'none');
        hold on
        light
        lighting phong;
        set(gca, 'visible', 'off')
        set(gcf, 'Color', [1 1 1])
        view(2)
        set(gca, 'DataAspectRatio', [1 1 1], 'PlotBoxAspectRatio', [1 1 1]);
        tttt = trisurf(targetF, targetV(:, 1), targetV(:, 2), targetV(:, 3), 'Facecolor', 'm', 'Edgecolor', 'none');
        alpha(0.6)
end

[p] = size(templateV, 1);

% General deformation
% disp('General deformation');
% kernel1 = 2:-(0.5/iterations):1.5;
% kernel2 = 1.4:(0.6/iterations):2;
% for i  = 1:iterations
% nrseedingpoints = round(10^(kernel2(1, i)));
%     IDX1 = [];
%     IDX2 = [];
%     [IDX1(:, 1), IDX1(:, 2)] = knnsearch(targetV, templateV);
%     [IDX2(:, 1), IDX2(:, 2)] = knnsearch(templateV, targetV);
%     IDX1(:, 3) = 1:length(templateV(:, 1));
%     IDX2(:, 3) = 1:length(targetV(:, 1));
% 
%    
%     [C, ia] = setdiff(IDX1(:, 1), Indices_edgesT);
%     IDX1 = IDX1(ia, :);
% 
%     [C, ia] = setdiff(IDX2(:, 1), Indices_edgesS);
%     IDX2 = IDX2(ia, :);
% 
%     
%     templatepartial = templateV(IDX1(:, 3), :);
%     targetpartial = targetV(IDX2(:, 3), :);
%     
%      [IDXS, dS] = knnsearch(targetpartial, templatepartial);
%      [IDXT, dT] = knnsearch(templatepartial, targetpartial);
%     
%      [ppartial] = size(templatepartial, 1);
%         idx = unique(round((ppartial-1) * rand(nrseedingpoints, 1)) + 1);
%         temp = templatepartial(idx, :);
%         [q] = size(idx, 1);
%      D = pdist2(templatepartial, temp);
%     
%     gamma = 1/(2 * (mean(mean(D)))^kernel1(1, i));
%     Datasettemplate = vertcat(templatepartial, templatepartial(IDXT, :));
% 
%     Datasettarget = vertcat(targetpartial(IDXS, :), targetpartial);
%     Datasettemplate2 = vertcat(D, D(IDXT, :));
%     vectors = Datasettarget-Datasettemplate;
%     [r] = size(vectors, 1);
% 
%     % define radial basis width for deformation points
%    
%     tempy1 = exp(-gamma * (Datasettemplate2.^2));
% 
%     tempy2 = zeros(3 * r, 3 * q);
%     tempy2(1:r, 1:q) = tempy1;
%     tempy2(r + 1:2 * r, q + 1:2 * q) = tempy1;
%     tempy2(2 * r + 1:3 * r, 2 * q + 1:3 * q) = tempy1;
% 
%     %solve optimal deformation directions
%     ppi = pinv(tempy2);
%     modes = ppi * reshape(vectors, 3 * r, 1);
%     
%      D2 = pdist2(templateV, temp);
%     gamma2 = 1/(2 * (mean(mean(D2)))^kernel1(1, i));
%     
% 
%     tempyfull1 = exp(-gamma2 * (D2.^2));
%     tempyfull2 = zeros(3 * p, 3 * q);
%     tempyfull2(1:p, 1:q) = tempyfull1;
%     tempyfull2(p + 1:2 * p, q + 1:2 * q) = tempyfull1;
%     tempyfull2(2 * p + 1:3 * p, 2 * q + 1:3 * q) = tempyfull1;
% 
%     test2 = tempyfull2 * modes;
%     test2 = reshape(test2, size(test2, 1)/3, 3);
%     %deforme template mesh
%     templateV = templateV + test2;
%     
%      [~, templateV, ~] = rigidICP(targetV, templateV, 1, Indices_edgesS, Indices_edgesT);
%      if figureOn == 1
%         delete(h)
%         h = trisurf(templateF, templateV(:, 1), templateV(:, 2), templateV(:, 3), 'FaceColor', 'y', 'Edgecolor', 'none');
%         alpha(0.6)
%      end
%     
% end
    

% local deformation
disp('Local optimization');
arraymap = repmat(cell(1), p, 1);
kk = 12 + iterations;

if figureOn == 1
    figure(99)
    delete(tttt)
    tttt = trisurf(targetF, targetV(:, 1), targetV(:, 2), targetV(:, 3), 'Facecolor', 'm', 'Edgecolor', 'none');
    drawnow;
end

TR = triangulation(targetF, targetV); 
normalsT = vertexNormal(TR) .* cutoff;

%define local mesh relation
TRS = triangulation(templateF, templateV); 
normalsS = vertexNormal(TRS) .* cutoff;
[IDXtemplate, Dtemplate] = knnsearch(horzcat(templateV, normalsS), horzcat(templateV, normalsS), 'K', kk);

% check normal direction
[IDXcheck, ~] = knnsearch(targetV, templateV);
testpos = sum(sum((normalsS-normalsT(IDXcheck, :)).^2, 2));
testneg = sum(sum((normalsS + normalsT(IDXcheck, :)).^2, 2));
if testneg<testpos
    normalsT = -normalsT;
%     targetF(:, 4) = targetF(:, 2);
%     targetF(:, 2) = [];
end


    
for ddd = 1:iterations
    fprintf('%d / %d\n', ddd, iterations);
    
    k = kk - ddd;
    tic

    TRS = triangulation(templateF, templateV); 
    normalsS = vertexNormal(TRS) .* cutoff;


    sumD = sum(Dtemplate(:, 1:k), 2);
    sumD2 = repmat(sumD, 1, k);
    sumD3 = sumD2 - Dtemplate(:, 1:k);
    sumD2 = sumD2 * (k-1);
    weights = sumD3 ./ sumD2;

    [IDXtarget, Dtarget] = knnsearch(horzcat(targetV, normalsT), horzcat(templateV, normalsS), 'K', 3);
    pp1 = size(targetV, 1);
    
    %correct for holes in target
    if isempty(Indices_edgesT) == 0
        correctionfortargetholes1 = find(ismember(IDXtarget(:, 1), Indices_edgesT));
        targetV = [targetV;templateV(correctionfortargetholes1, :)];
        IDXtarget(correctionfortargetholes1, 1) = pp1 + (1:size(correctionfortargetholes1, 1))';
        Dtarget(correctionfortargetholes1, 1) = 0.00001;

        correctionfortargetholes2 = find(ismember(IDXtarget(:, 2), Indices_edgesT));
        pp = size(targetV, 1);
        targetV = [targetV;templateV(correctionfortargetholes2, :)];
        IDXtarget(correctionfortargetholes2, 2) = pp + (1:size(correctionfortargetholes2, 1))';
        Dtarget(correctionfortargetholes2, 2) = 0.00001;

        correctionfortargetholes3 = find(ismember(IDXtarget(:, 3), Indices_edgesT));

        targetV = [targetV;templateV(correctionfortargetholes3, :)];
        IDXtarget(correctionfortargetholes3, 3) = pp + (1:size(correctionfortargetholes3, 1))';
        Dtarget(correctionfortargetholes3, 3) = 0.00001;
    end

    summD = sum(Dtarget, 2);
    summD2 = repmat(summD, 1, 3);
    summD3 = summD2-Dtarget;
    weightSum = summD3./(summD2 * 2);
    TargetTempSet = horzcat(weightSum(:, 1).* targetV(IDXtarget(:, 1), 1), weightSum(:, 1).* targetV(IDXtarget(:, 1), 2), weightSum(:, 1).* targetV(IDXtarget(:, 1), 3)) + horzcat(weightSum(:, 2).* targetV(IDXtarget(:, 2), 1), weightSum(:, 2).* targetV(IDXtarget(:, 2), 2), weightSum(:, 2).* targetV(IDXtarget(:, 2), 3)) + horzcat(weightSum(:, 3).* targetV(IDXtarget(:, 3), 1), weightSum(:, 3).* targetV(IDXtarget(:, 3), 2), weightSum(:, 3).* targetV(IDXtarget(:, 3), 3));

    targetV = targetV(1:pp1, :);

    for i = 1:size(templateV, 1)
        templateSet = templateV(IDXtemplate(i, 1:k)', :);
        targetSet = TargetTempSet(IDXtemplate(i, 1:k)', :);
        [~, ~, arraymap{i, 1}] = procrustes(targetSet, templateSet, 'scaling', 0, 'reflection', 0);
    end
    templateV_approx = templateV;
    templateV_temp = zeros(size(templateV, 1), 3);
    for i = 1:size(templateV, 1)
        for ggg = 1:k
            templateV_temp(ggg, :) = weights(i, ggg) * (arraymap{IDXtemplate(i, ggg), 1}.b * templateV(i, :) * arraymap{IDXtemplate(i, ggg), 1}.T + arraymap{IDXtemplate(i, ggg), 1}.c(1, :));
        end
        templateV(i, :) = sum(templateV_temp(1:k, :));
    end
    templateV = templateV_approx + (templateV-templateV_approx) .* weight;

    % toc
    if figureOn == 1
        figure(99)
        delete(h)
        h = trisurf(templateF, templateV(:, 1), templateV(:, 2), templateV(:, 3), 'FaceColor', 'y', 'Edgecolor', 'none');   
        drawnow;
    end

end