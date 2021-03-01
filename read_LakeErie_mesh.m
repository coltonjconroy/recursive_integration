%***********************************************************************
%
%  This program reads in a fort.14 file
%
%***********************************************************************

% Open fort.14 file (read only)

fid = fopen('lake_erie_Donelan.14','r');

% Read in grid name

AGRID = fgetl(fid);

% Read in the number of elements and the number of grid points

Nelems = fscanf(fid,'%i',1);
Nnodes = fscanf(fid,'%i',1);

% Read in node numbers and coordinates

XNODES = zeros(Nnodes,1);
YNODES = zeros(Nnodes,1);
Z = zeros(Nnodes,1);
for i = 1 : Nnodes
    NODES(i,:) = (fscanf(fid,'%g',4))';
    XNODES(i) = NODES(i,2);
    YNODES(i) = NODES(i,3);
    Z(i) = NODES(i,4);
end

% Read in the element connectivity table

CONN = zeros(Nelems,3);
for j = 1 : Nelems
    ELEMENTS = (fscanf(fid,'%i',5))';
    CONN(j,:) = ELEMENTS(3:5);    
end

% Read in the number of elevation specified boundary forcing segments

%NOPE  = fscanf(fid,'%i',1);
%NOPET = fgetl(fid); 

% Read in the total number of elevation specified boundary nodes 

%NETA  = fscanf(fid,'%i',1);
%NETAT = fgetl(fid); 

% Loop over all the elevation specified boundary segements

%ii = 1;
%for k = 1:NOPE
%    NVDLL(k)  = fscanf(fid,'%i',1);    
%    NVDLLT    = fgetl(fid);
%    for i=1:NVDLL(k)
%        NBDV(k,i) = fscanf(fid,'%i',1);        
%        XBND(ii) = X(NBDV(k,i));
%        YBND(ii) = Y(NBDV(k,i));
%        ii = ii + 1;
%    end
%end

% Read in the number of normal flow specified boundary segments

%NBOU  = fscanf(fid,'%i',1);
%NBOUT = fgetl(fid); 

% Read in the total number of normal flow specified boundary nodes 

%NVEL  = fscanf(fid,'%i',1);
%NVELT = fgetl(fid); 

% Loop over all the normal flow specified boundary segments

%for k=1:NBOU
%     NVELL(k)  = fscanf(fid,'%i',1);    
%     IBTYPE(k) = fscanf(fid,'%i',1);    
%     NVELLT    = fgetl(fid);
%     for i=1:NVELL(k)
%         NBVV(k,i) = fscanf(fid,'%i',1);    
%         XBND(ii) = X(NBVV(k,i));
%         YBND(ii) = Y(NBVV(k,i));
%         COORDS(k).x(i) = XBND(ii);
%         COORDS(k).y(i) = YBND(ii);
%         ii = ii + 1;
%     end
% end

%fclose(fid)