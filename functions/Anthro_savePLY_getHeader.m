function Header = Anthro_savePLY_getHeader(sizeV, sizeF, hasTexture)

    if hasTexture
        Header{1, 1}  = sprintf('ply\n');
        Header{2, 1}  = sprintf('format ascii 1.0\n');
        Header{3, 1}  = sprintf('comment github.com/HandongHCI/3D_Anthro\n');
        Header{4, 1}  = sprintf('element vertex %d\n', sizeV);
        Header{5, 1}  = sprintf('property float x\n');
        Header{6, 1}  = sprintf('property float y\n');
        Header{7, 1}  = sprintf('property float z\n');
        Header{8, 1}  = sprintf('property uchar red\n');
        Header{9, 1}  = sprintf('property uchar green\n');
        Header{10, 1} = sprintf('property uchar blue\n');
        Header{11, 1} = sprintf('element face %d\n', sizeF);
        Header{12, 1} = sprintf('property list uchar int vertex_index\n');
        Header{13, 1} = sprintf('end_header\n');
    else
        Header{1, 1}  = sprintf('ply\n');
        Header{2, 1}  = sprintf('format ascii 1.0\n');
        Header{3, 1}  = sprintf('comment github.com/HandongHCI/3D_Anthro\n');
        Header{4, 1}  = sprintf('element vertex %d\n', sizeV);
        Header{5, 1}  = sprintf('property float x\n');
        Header{6, 1}  = sprintf('property float y\n');
        Header{7, 1}  = sprintf('property float z\n');
        Header{8, 1} = sprintf('element face %d\n', sizeF);
        Header{9, 1} = sprintf('property list uchar int vertex_index\n');
        Header{10, 1} = sprintf('end_header\n');
    end