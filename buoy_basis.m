% 1 - Find the elements where the buoys are located
% 2 - Compute local(DG) buoy coordinates using transformation
% 3 - Compute mapping & basis functions for local buoy coordinates
buoy_elems = zeros(nbuoys,1);
for i = 1 : nbuoys
    for n = 1 : nelems
        enodes = ELEMS(n).nodes;
        XV = [NODES(enodes(1)).x; NODES(enodes(2)).x; NODES(enodes(3)).x];
        YV = [NODES(enodes(1)).y; NODES(enodes(2)).y; NODES(enodes(3)).y];
        if inpolygon(buoy_x(i), buoy_y(i),XV,YV) == 1
            buoy_elems(i) = n;
            bL1 = 1/ELEMS(n).area * (ELEMS(n).y31 * (buoy_x(i)-0.5*(XV(2)+XV(3))) + ...
                      ELEMS(n).x13 * (buoy_y(i)-0.5*(YV(2) + YV(3))));
            bL2 = 1/ELEMS(n).area * (ELEMS(n).y12 * (buoy_x(i)-0.5*(XV(2)+XV(3))) + ...
                      ELEMS(n).x21 * (buoy_y(i)-0.5*(YV(2) + YV(3))));
            THETA(i).mapbuoy = [-0.5*(bL1+bL2), 0.5*(1+bL1), 0.5*(1+bL2)];
            THETA(i).buoybasis = triangle_basis(p,bL1,bL2);
        end
    end
end