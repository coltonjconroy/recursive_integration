%**************************************************************************
%
%                turbulence cascades - total dissipation 
%                     Written by Colton J. Conroy
%                               @ APAM
%                               4/4/17
%     
%**************************************************************************
for i = 1:nnodes
    if strcmpi(type,'single')
        i = Jnode;
    elseif strcmpi(type,'triple')
        if i == 1
            i = nodes(1);
        elseif i == 2
            i = nodes(2);
        else
            i = nodes(3);
        end
    end
    for j = 1:Lw-1
        k = j;
        for n = ncascades:-1:2
            n_index = Uparent(k,i,n);
            total_d(j,i) = total_d(j,i) + Udiss(n_index,i,n-1);
            k = n_index;
        end
    end
    if strcmpi(type,'single')
        break
    elseif strcmpi(type,'triple')
        if i == 3
            break
        end
    end
end
%--------------------------
%
% Determination of weights 
%      Colton J. Conroy
%           3/9/18
%
%--------------------------
ki = 3; dL = 2^(ncascades);
for j = 3:length(Uoriginal)-1
    kf = ki + (dL-1);
    Diss_wts(j,:)   = ((Uoriginal(j))^(2)./((Unew(ki:kf)-ncascades).^(2)));
    Diss_wts_e(j,:) = ((Uoriginal(j))^(3)./((Unew(ki:kf)-ncascades).^(3)));
    ki = kf+1;
end
sum_p = 0; sum_pe = 0;
for j = 3:length(Uoriginal)-1
    sum_p  = sum_p  + sum(Diss_wts(j,:));
    sum_pe = sum_pe + sum(Diss_wts_e(j,:));
end
wts_total = zeros(size(Unew)); wts_total_e = zeros(size(Unew));
k = 0;
for j = 3:length(Uoriginal)-1
    for i = 1:dL
        k = k + 1;
        wts_total(k) = Diss_wts(j,i);
        wts_total_e(k) = Diss_wts_e(j,i);
    end
end
% moments
nmoments = 20;
qq = 0:nmoments;
tau = zeros(length(qq),1);
xi  = zeros(length(qq),1);
De  = 0; 
for j = 1:length(wts_total)
    for i = 0:length(qq)-1
        tau(i+1) = tau(i+1) + wts_total_e(j)^i;
         xi(i+1) =  xi(i+1) + wts_total(j)^(i/2);    
    end
    if wts_total(j) == 0
        wts_total(j) = 5e-6;
    else
        De = De + wts_total(j)*log2(wts_total(j));

    end
end
De  = De/length(wts_total);
De  = 3 - 3*De;                   % embedding space is E = 3; 
m   = 1; e = 5.0; qcrit = 5.0;    % note there is a shift of 2 on E (E = e-2) where e = 5 bc of spectral space)
tau = tau./length(wts_total);     % see Multifractal measures for the geophysicist (Mandelbrot)
xx  = log2(tau)./(qq'-1);
tau = (3/e)*log2(tau)-m*(qq'-1);
xi  = xi./length(wts_total);
xi  = (3/e)*log2(xi)-m*(qq'-1);
xi  = qq'./3 - xi;                 
sigma = (xi + 2)/qcrit;            % shift of 2
Dq = (sigma)./(qq'-1) + sigma(1);  % constant is from dissipation bc nonconservative
%---------------------------
% plots for determining ld_1
%---------------------------
%--------------------------------------------------------------------------
% tau figure (the second zero is qcrit and should equal 5, if not need to change ld_1). 
%--------------------------------------------------------------------------
plot(xi,tau,'k')
grid on
xlabel('moment (n)','FontSize',13,'Interpreter','Latex')
ylabel('$\tau(n)$','FontSize',13,'Interpreter','Latex')
title('Exponent function of the moments, $\tau$','FontSize',14,'Interpreter','Latex')
%--------------------------
% structure function figure
%--------------------------
openfig('structure_function_2011_avg.fig')
hold on;
plot(qq,sigma,'r')