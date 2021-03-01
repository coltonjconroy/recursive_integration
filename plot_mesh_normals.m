% Plot the normals & buoy locations
trimesh(CONN,XNODES,YNODES); hold on
for i = 1 : length(EDGES)    
    x1 = NODES(EDGES(i).nodes(1)).x; x2 = NODES(EDGES(i).nodes(2)).x;
    y1 = NODES(EDGES(i).nodes(1)).y; y2 = NODES(EDGES(i).nodes(2)).y;
    nx = [1/2*(x1+x2), 1/2*(x1+x2) + 200*EDGES(i).normal(1)]; 
    ny = [1/2*(y1+y2), 1/2*(y1+y2) + 200*EDGES(i).normal(2)]; 
    plot3(nx,ny,[0,0],'b'); 
end
daspect([1 1 1])
scatter(buoy_x,buoy_y,120,'r','p','filled')