%test meshSubdivision
v = [0 0 0;1 0 0;0 1 0];
f = [1 2 3];

patch('vertices',v,'faces',f,'facecolor','none')
 
for n = 1:4
    [v,f] = meshSubdivision(v,f);
end

figure
patch('vertices',v,'faces',f,'facecolor','none')
