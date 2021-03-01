%-----------------------
% Domain Discretization
%-----------------------
read_LakeErie_mesh                      % Read in mesh information
% Conversion from lat/lon to x/y
R = 6378206.4;                          % Constants for lat/lon conversion
CPPLON = -81.2*pi/180;
CPPLAT =  42.2*pi/180;
% Lake Erie Buoys [45005 45132 45142]
buoy_lon = [-82.3980; -81.2200; -79.2900];          % buoy coordinates
buoy_lat = [41.6770; 42.4700; 42.7400];
nbuoys = length(buoy_lat);                          % # of buoys
% Convert lat/lon to meters 
XNODES = R*(pi/180*XNODES - CPPLON)*cos(CPPLAT);
YNODES = R*(pi/180*YNODES);
buoy_x = R*(pi/180*buoy_lon - CPPLON)*cos(CPPLAT);  % buoy locations
buoy_y = R*(pi/180*buoy_lat);  
% Mesh info
rep = TriRep(CONN,XNODES,YNODES); 
[EDGES,ELEMS,NODES] = DG_meshData(rep); 
nelems = length(rep.Triangulation);
nnodes = numel(NODES);
nedges = numel(EDGES);
%-----------------------------------------
% buoy basis (calculates solution at buoys
%-----------------------------------------
buoy_basis
%------------------
% plot normal check
%------------------
if strcmpi(mesh_fig,'on')
    plot_mesh_normals
end