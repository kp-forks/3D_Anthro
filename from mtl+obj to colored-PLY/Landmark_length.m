

[filename] = uigetfile('*.asc', 'Select the rawdata');
LM = textread(filename);


for t=1:4
    for i=(6*t-5):(6*t)
        for j=(6*t-5):(6*t)
            length_points(i,j) = norm(LM(i, :) - LM(j, :));
        end
    end
end

Table = [];
p = 1;

for t=1:4
    for i=(6*t-5):(6*t)
        for j=(i+1):(6*t)
            Table(p,1) = length_points(i,j);
            p = p+1;
        end
    end
end
