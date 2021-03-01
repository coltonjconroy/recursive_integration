%--------------------------------------------------------------------
% calculate significant wave height from recursive wind interpolation
%--------------------------------------------------------------------
figs    = 'on';
misfit  = 'on';
t_inner = 0.002;
%p_offset = 0.72; % there's a temporal offset between calcs and observations
days    = 31;     % that will change for a given data set bc of the number of 
DT      = 3600;   % cascades used (a cascade removes time from the data set).
N_bins  = DT/dt;
n_bins  = days/DT;
ig = isnan(total_d(:,Jnode));
ds = mean(total_d(ig == 0,Jnode));
read_wvht_period;
if strcmpi(month,'8')
    load buoy_45005_hs
    Hs = hs_45005;
end
%---------------------
% initialize variables
%---------------------
NT = length(Uo(:,1));
En = zeros(NT*nrk,1);
tn = zeros(NT*nrk,1);
Un = zeros(NT*nrk,1);
Fn = zeros(NT*nrk,1);
cg = zeros(NT*nrk,1);
KE = zeros(NT*nrk,1);
qn = zeros(NT,1);
Tn = zeros(NT,1);
wvht_avg = zeros(length(wvht(:,1)),1);
tavg = zeros(size(wvht_avg));
%-------------------------------------------
% Calculate energy (variance), frequency,
% group velocity of water surface
%-------------------------------------------
t = 0; time = 0;
k = 0; lsum = 0;
atime = 0;
kk = 0; ii = 0;
for n = 0:NT-1
    t = 0;
    for irk = 1:nrk     % interior time interval evaluations 
        k = k + 1;
        t = t + crk(irk)*dt; % local kernel time in each RK stage
        if t < 5.0e-6
            t = t_inner;
        end
        En(k) = E(t,Uo(n+1,Jnode),q(n+1,Jnode),g);
        Un(k) = U10(t,Uo(n+1,Jnode),q(n+1,Jnode),g);
        En(k) = (En(k)*Un(k)^4/g^2);
        Fn(k) = Fm(t,Uo(n+1,Jnode),q(n+1,Jnode),g);
        Fn(k) = Fn(k)*g/Un(k);
        cg(k) = g/(2*pi*Fn(k));
        KE(k) = (cg(k)/Fn(k))^2;
        tn(k) = time + t;
    end
    qn(n+1) = q(n+1,Jnode);
    Tn(n+1) = time;
    time = time + dt;
end
%---------------------------------
% average data over hourly periods
%---------------------------------
H_bins = floor(length(En)/(N_bins*nrk));
k = 0; wvht_avg = zeros(size(H_bins)); 
wvpd_avg = zeros(size(H_bins));
De_bins = floor(H_bins/length(De));
H = zeros(size(H_bins));
jj = 1; 
kk = 0;
for i = 1:H_bins 
    kk = kk + 1;
    l_sum = 0;
    w_sum = 0;
    for j = 1:N_bins*nrk
        k = k+1;
        l_sum = l_sum + En(k);
        w_sum = w_sum + En(k)*Fn(k)^2;
    end
    wvht_avg(i) = l_sum/(N_bins*nrk);    
    wvpd_avg(i) = w_sum/(N_bins*nrk);
    if kk < De_bins
        if jj <= length(De)
            H(i) = 1/De(jj);
        else
            H(i) = 1/De(jj-1);
        end
    else
        H(i) = 1/De(jj);
        jj = jj + 1; 
        kk = 0;
    end
end
%----------------------------------------------------
% calculate signifcant wave height and average period
%----------------------------------------------------
%wvpd_avg = De.*(wvht_avg./wvpd_avg).^(1./De) + 1/(3-De);
wvht_avg = 4*(wvht_avg).^(H);
read_wvht_period
%----------------------------------------------------
% plot data vs observations
%----------------------------------------------------
if strcmpi(figs,'on')
    figure
    offset = 0;
    t_plot = zeros(size(wvht_avg)); t_plot(1) = offset*dt/86400;
    for j = 1:length(t_plot)-1
        t_plot(j+1) = t_plot(j) + DT/86400;
    end
    plot(t_plot+p_offset,wvht_avg,'r'); hold on;
    plot(t_plot,Hs(1:end-1),'k');
    ylabel('significant wave height (m)','FontSize',13,'Interpreter','Latex')
    xlabel('time (days)','FontSize',13,'Interpreter','Latex')
    title('Significant Wave height (m)','FontSize',14,'Interpreter','Latex')
    legend('Recursive integration','Observational data','Interpreter','Latex')
    axis([0 31 0 max(wvht_avg)+.5])
end
%-------------------------------------------------------------
% calculate mean, std, R, RMSE of calculations to observations
%-------------------------------------------------------------
if strcmpi(misfit,'on')
    offset1 = 18; offset2 = 16;
    Hs_n = Hs(offset1:end); wvht_avg_n = wvht_avg(1:end-offset2);
    clear Hs wvht_avg
    Hs = Hs_n;
    wvht_avg = wvht_avg_n;
    data_NaN = isnan(Hs);
    id = find(data_NaN == 0);
    l_id = length(id);
    Hs_mean = mean(Hs(id))
    Hsh_mean = mean(wvht_avg(id))
    std_Hs  = sqrt(sum((Hs(id) - Hs_mean).^2)/(l_id-1))
    std_Hsh = sqrt(sum((wvht_avg(id) - Hsh_mean).^2)/(l_id-1))
    Cx = Hs(id) - Hs_mean; Cy = wvht_avg(id) - Hsh_mean; %Cy = Cy';wvht_avg = wvht_avg';
    % if strcmpi(month,'8')
    %     Cy = Cy';
    %     Hs_avg = Hs_avg';
    % end
    Cxy = sum(Cx.*Cy)/l_id;
    R  = Cxy/(std_Hs*std_Hsh)
    SE = std_Hsh/(sqrt(l_id))
    RMSE = sqrt(sum((Hs(id) - wvht_avg(id)).^2)/(l_id))
end