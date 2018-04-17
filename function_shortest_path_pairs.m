function curve = function_shortest_path_pairs(links, LMs, V, sparsematrix)
    curve = [];
    for i = 1:length(links)-1
        curve = [curve; function_shortest_path(LMs(links(i), :), LMs(links(i+1), :), V, sparsematrix, 'Dijkstra')];
    end
    
    curve = unique(curve, 'rows', 'stable');