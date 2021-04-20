function [registered,targetV,targetF]=ICP_nonrigidICPv2(targetV,templateV,targetF,templateF,iterations,flag_prealligndata, figureOn, weight, scaling, reflection)
    % INPUT
    % -target: vertices of target mesh; n*3 array of xyz coordinates
    % -source: vertices of source mesh; n*3 array of xyz coordinates
    % -Ft: faces of target mesh; n*3 array
    % -Fs: faces of source mesh; n*3 array
    % -iterations: number of iterations; usually between 10 en 30
    % -flag_prealligndata: 0 or 1.  
        %  0 if the data still need to be roughly alligned
        %  1 if the data is already alligned (manual or landmark based)


    % OUTPUT
    % -registered: registered source vertices on target mesh. Faces are not affected and remain the same is before the registration (Fs). 

    %EXAMPLE

    % EXAMPLE 1 demonstrates full allignement and registration of two complete
    % meshes
    % load EXAMPLE1.mat
    % [registered]=nonrigidICPv2(targetV,sourceV,targetF,sourceF,10,0);


    %EXAMPLE 2 demonstrates registration of two incomplete meshes
    % load EXAMPLE2.mat
    % [registered]=nonrigidICPv2(targetV,sourceV,targetF,sourceF,10,1);

    if nargin < 6
        error('Wrong number of input arguments')
    elseif nargin == 6
        figureOn = 0;
        weight(1:size(templateV,1), 1) = 0.5;
        scaling = 0;
        reflection = 0;
    end



    tic
    clf
    %remove duplicate vertices

    [targetV, ~, indexn] =  unique(targetV, 'rows');
    targetF = indexn(targetF);


    %assesment of meshes quality and simplification/improvement
    % disp('Remeshing and simplification target Mesh');
    [cutoff, ~] = ICP_definecutoff( templateV, templateF );

    [Indices_edgesS]=ICP_detectedges(templateV,templateF);
    [Indices_edgesT]=ICP_detectedges(targetV,targetF);

    if isempty(Indices_edgesS)==0
%        disp('Warning: Source mesh presents free edges. ');
       if flag_prealligndata == 0
           error('Source Mesh presents free edges. Preallignement can not reliably be executed') 
       end
    end

    if isempty(Indices_edgesT)==0
%        disp('Warning: Target mesh presents free edges. ');
       if flag_prealligndata == 0
           error('Target mesh presents free edges. Preallignement can not reliably be executed') 
       end
    end

    %initial allignment and scaling
%     disp('Rigid allignement source and target mesh');

    if flag_prealligndata==1
        [~,templateV,~]=ICP_rigidICP(targetV,templateV,1,Indices_edgesS,Indices_edgesT);
    else
        [~,templateV,~]=ICP_rigidICP(targetV,templateV,0,Indices_edgesS,Indices_edgesT);
    end

    %plot of the meshes
    if figureOn == 1
        h=trisurf(templateF,templateV(:,1),templateV(:,2),templateV(:,3),0.3,'Edgecolor','none');
        hold
        light
        lighting phong;
        set(gca, 'visible', 'off')
        set(gcf,'Color',[1 1 1])
        view(2)
        set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
        tttt=trisurf(targetF,targetV(:,1),targetV(:,2),targetV(:,3),'Facecolor','m','Edgecolor','none');
        alpha(0.6)
    end

    [p]=size(templateV,1);

    xlimm=min(templateV(:,1));
    xlimM=max(templateV(:,1));
    Lx=abs(xlimM-xlimm);
    ylimm=min(templateV(:,2));
    ylimM=max(templateV(:,2));
    Ly=abs(ylimM-ylimm);
    zlimm=min(templateV(:,3));
    zlimM=max(templateV(:,3));
    Lz=abs(zlimM-zlimm);
    [minL]=min([Lx Ly Lz]);

%     % General deformation
%     % disp('General deformation');
%     kernel1=1.5:-(0.5/iterations):1;
%     kernel2=2.1:(0.3/iterations):2.4;
%     for i =1:iterations
%         nrseedingpoints=round(10^(kernel2(1,i)));
%         lengthseeding=minL/(nrseedingpoints^(1/3));
%         xseeding=xlimm:lengthseeding:xlimM;
%         yseeding=ylimm:lengthseeding:ylimM;
%         zseeding=zlimm:lengthseeding:zlimM;
%         seedingmatrix=zeros(length(xseeding)*length(yseeding)*length(zseeding),3);
%         seedingmatrix(:,3)=repmat(zseeding',length(xseeding)*length(yseeding),1);
%         tempy=repmat(yseeding,length(zseeding),1);
%         tempy=reshape(tempy,~(size(tempy)),1);
% %         tempy=reshape(tempy,numel(tempy),1);
%         seedingmatrix(:,2)=repmat(tempy,length(xseeding),1);
%         tempx=repmat(xseeding,length(zseeding)*length(yseeding),1);
%         seedingmatrix(:,1)=reshape(tempx,~(size(tempy)),1);
%         [idx,~]=knnsearch(seedingmatrix,templateV);
%         tempidx=unique(idx);
%         tempseed=seedingmatrix(tempidx,:);
%         seedingmatrix=tempseed;
%         [q]=length(seedingmatrix );
% 
%         IDX1=[];
%         IDX2=[];
%         [IDX1(:,1),IDX1(:,2)]=knnsearch(targetV,templateV);
%         [IDX2(:,1),IDX2(:,2)]=knnsearch(templateV,targetV);
%         IDX1(:,3)=1:length(templateV(:,1));
%         IDX2(:,3)=1:length(targetV(:,1));
% 
% 
%         [~,ia]=setdiff(IDX1(:,1),Indices_edgesT);
%         IDX1=IDX1(ia,:);
% 
%         [~,ia]=setdiff(IDX2(:,1),Indices_edgesS);
%         IDX2=IDX2(ia,:);
% 
% 
%         sourcePartial=templateV(IDX1(:,3),:);
%         targetPartial=targetV(IDX2(:,3),:);
% 
%          [IDXS,~] = knnsearch(targetPartial,sourcePartial);
%          [IDXT,~] = knnsearch(sourcePartial,targetPartial);
% 
%     %      [ppartial]=size(sourcepartial,1);
% 
%           D = pdist2(sourcePartial,seedingmatrix);
% 
%           gamma=1/(2*(mean(mean(D)))^kernel1(1,i));
%           DatasetTemplate=vertcat(sourcePartial,sourcePartial(IDXT,:));
% 
%         DatasetTarget=vertcat(targetPartial(IDXS,:),targetPartial);
%         DatasetTemplate2=vertcat(D,D(IDXT,:));
%         vectors=DatasetTarget-DatasetTemplate;
%         [r]=size(vectors,1);
% 
% 
%         % define radial basis width for deformation points
%         %gaussian
%         tempy1=exp(-gamma*(DatasetTemplate2.^2));
% 
%         tempy2=zeros(3*r,3*q);
%         tempy2(1:r,1:q)=tempy1;
%         tempy2(r+1:2*r,q+1:2*q)=tempy1;
%         tempy2(2*r+1:3*r,2*q+1:3*q)=tempy1;
% 
%         %solve optimal deformation directions with regularisation term      
%         %regularisation
%         lambda=0.001;
%         ppi=((tempy2.'*tempy2)+lambda*eye(3*q))\(tempy2.');
% 
% 
%         modes=ppi*reshape(vectors,3*r,1);
% 
%         D2 = pdist2(templateV,seedingmatrix);
%         gamma2=1/(2*(mean(mean(D2)))^kernel1(1,i));
% 
% 
%         tempyfull1=exp(-gamma2*(D2.^2));
%         tempyfull2=zeros(3*p,3*q);
%         tempyfull2(1:p,1:q)=tempyfull1;
%         tempyfull2(p+1:2*p,q+1:2*q)=tempyfull1;
%         tempyfull2(2*p+1:3*p,2*q+1:3*q)=tempyfull1;
% 
%         test2=tempyfull2*modes;
%         test2=reshape(test2,size(test2,1)/3,3);
%         %deforme source mesh
%         templateV=templateV+test2;
% 
%         [~,templateV,~]=ICP_rigidICP(targetV,templateV,1,Indices_edgesS,Indices_edgesT);
%         if figureOn == 1
%             delete(h)
%             h=trisurf(templateF,templateV(:,1),templateV(:,2),templateV(:,3),'FaceColor','y','Edgecolor','none');
%             alpha(0.6)
% %             pause (0.1)
%         end
%     end



    % local deformation
%     disp('Local optimization');
    % arraymap = repmat(cell(1),p,1);
    kk=12+iterations;

    if figureOn == 1
        delete(tttt)
        tttt=trisurf(targetF,targetV(:,1),targetV(:,2),targetV(:,3),'Facecolor','m','Edgecolor','none');
        drawnow;
    end

    TR = triangulation(targetF,targetV); 
    normalsT = vertexNormal(TR).*cutoff;

    %define local mesh relation
    TRS = triangulation(templateF,templateV); 
    normalsS=vertexNormal(TRS).*cutoff;
    [IDXsource,Dsource]=knnsearch(horzcat(templateV,normalsS),horzcat(templateV,normalsS),'K',kk);

    % check normal direction
    [IDXcheck,~]=knnsearch(targetV,templateV);
    testpos=sum(sum((normalsS-normalsT(IDXcheck,:)).^2,2));
    testneg=sum(sum((normalsS+normalsT(IDXcheck,:)).^2,2));
    if testneg<testpos
        normalsT=-normalsT;
        targetF(:,4)=targetF(:,2);
        targetF(:,2)=[];
    end



    for ddd=1:iterations
        k=kk-ddd;
        tic

        TRS = triangulation(templateF,templateV); 
        normalsS=vertexNormal(TRS).*cutoff;


        sumD=sum(Dsource(:,1:k),2);
        sumD2=repmat(sumD,1,k);
        sumD3=sumD2-Dsource(:,1:k);
        sumD2=sumD2*(k-1);
        weights=sumD3./sumD2;

        [IDXtarget,Dtarget]=knnsearch(horzcat(targetV,normalsT),horzcat(templateV,normalsS),'K',3);
        pp1=size(targetV,1);

        %correct for holes in target
        if isempty(Indices_edgesT)==0

            correctionfortargetholes1=find(ismember(IDXtarget(:,1),Indices_edgesT));
            targetV=[targetV;templateV(correctionfortargetholes1,:)];
            IDXtarget(correctionfortargetholes1,1)=pp1+(1:size(correctionfortargetholes1,1))';
            Dtarget(correctionfortargetholes1,1)=0.00001;

            correctionfortargetholes2=find(ismember(IDXtarget(:,2),Indices_edgesT));
            pp=size(targetV,1);
            targetV=[targetV;templateV(correctionfortargetholes2,:)];
            IDXtarget(correctionfortargetholes2,2)=pp+(1:size(correctionfortargetholes2,1))';
            Dtarget(correctionfortargetholes2,2)=0.00001;

            correctionfortargetholes3=find(ismember(IDXtarget(:,3),Indices_edgesT));
            pp=size(targetV,1);
            targetV=[targetV;templateV(correctionfortargetholes3,:)];
            IDXtarget(correctionfortargetholes3,3)=pp+(1:size(correctionfortargetholes3,1))';
            Dtarget(correctionfortargetholes3,3)=0.00001;

        end


        summD=sum(Dtarget,2);
        summD2=repmat(summD,1,3);
        summD3=summD2-Dtarget;
        weightsm=summD3./(summD2*2);
        Targettempset=horzcat(weightsm(:,1).*targetV(IDXtarget(:,1),1),weightsm(:,1).*targetV(IDXtarget(:,1),2),weightsm(:,1).*targetV(IDXtarget(:,1),3))+horzcat(weightsm(:,2).*targetV(IDXtarget(:,2),1),weightsm(:,2).*targetV(IDXtarget(:,2),2),weightsm(:,2).*targetV(IDXtarget(:,2),3))+horzcat(weightsm(:,3).*targetV(IDXtarget(:,3),1),weightsm(:,3).*targetV(IDXtarget(:,3),2),weightsm(:,3).*targetV(IDXtarget(:,3),3));

        targetV=targetV(1:pp1,:);

        arraymap=cell(size(templateV,1),1);

        for i=1:size(templateV,1)
            sourceset=templateV(IDXsource(i,1:k)',:);
            targetset=Targettempset(IDXsource(i,1:k)',:);
            [~,~,arraymap{i,1}]=procrustes(targetset,sourceset,'scaling',scaling,'reflection',reflection);

        end
        templateV_approx=templateV;
        for i=1:size(templateV,1)
            for ggg=1:k
                templateVtemp(ggg,:)=weights(i,ggg)*(arraymap{IDXsource(i,ggg),1}.b*templateV(i,:)*arraymap{IDXsource(i,ggg),1}.T+arraymap{IDXsource(i,ggg),1}.c(1,:));
            end
            templateV(i,:)=sum(templateVtemp(1:k,:));
        end

%         templateV=templateV_approx+0.5*(templateV-templateV_approx);
        templateV = templateV_approx + (templateV-templateV_approx) .* weight;

%         toc
        if figureOn == 1
            delete(h)
            h=trisurf(templateF,templateV(:,1),templateV(:,2),templateV(:,3),'FaceColor','y','Edgecolor','none');   
            drawnow;
%             pause (0.1)
        end

    end

    registered=templateV;