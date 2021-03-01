function f = write_wind_input(U,q,To,r,quad,dt)

nregions = length(U(:,1));
%nnodes   = length(U(1,:));
nnodes = 1;
fid = fopen('wind_wave_input.txt','w');
fprintf(fid,'%s\n','wind input');
fprintf(fid,'%-8.0f %8.0f %16.10e\n',[nregions nnodes dt]);
i = 751;
%for i = 1:nnodes
    for j = 1:nregions
        fprintf(fid,'%-8.0f %16.10e %16.10e %16.10e %16.10e %-8.0f\n',...
                [i real(U(j,i)) real(q(j,i)) real(To(j,i)) real(r(j,i)) quad(j,i)]);
        
    end
%end

f = fclose('all');