function [Prealligned_template,Prealligned_target,transformtarget ]=Preall(target,template)

% This function performs a first and rough pre-alligment of the data as starting position for the iterative allignment and scaling procedure

% Initial positioning of the data is based on alligning the coordinates of the objects -which are assumed to be close/similar in shape- following principal component analysis

[COEFF,Prealligned_template] = pca(template);

[COEFF,Prealligned_target] = pca(target);

% the direction of the axes is than evaluated and corrected if necesarry.
Maxtarget=max(Prealligned_template)-min(Prealligned_template);
Maxtemplate=max(Prealligned_target)-min(Prealligned_target);
D=Maxtarget./Maxtemplate;
D=[D(1,1) 0 0;0 D(1,2) 0; 0 0 D(1,3)];
RTY=Prealligned_template*D;

load ICP_R
for i=1:8
    T=R{1,i};
    T=RTY*T;
    [bb DD]=knnsearch(T,Prealligned_target);
    MM(i,1)=sum(DD);
end

[M I]=min(MM);
 T=R{1,I};
 Prealligned_template=Prealligned_template*T;
 
 [d,Z,transformtarget] = procrustes(target,Prealligned_target);