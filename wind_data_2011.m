load NDBC_45005_2011.txt
if strcmpi(month,'5')
    p_start = 1;
    U       = NDBC_45005_2011(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'6')
    p_start = 24*31+1;
    U       = NDBC_45005_2011(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'7')
    p_start = 24*31+24*30+1;
    U       = NDBC_45005_2011(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    Tavg    = NDBC_45005_2011(p_start:(p_start+31*24),11);
    Tbad    = find(Tavg == 99.00);
    Tavg(Tbad) = NaN;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'8')
    p_start = 24*31+24*30+24*31+1;
    U       = NDBC_45005_2011(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    Tavg    = NDBC_45005_2011(p_start:(p_start+31*24),11);
    Tbad    = find(Tavg == 99.00);
    Tavg(Tbad) = NaN;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'9')
    p_start = 24*31+24*30+24*31+24*31+1;
    U       = NDBC_45005_2011(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'10')
    p_start = 24*31+24*30+24*31+24*31+24*30+1;
    U       = NDBC_45005_2011(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = NDBC_45005_2011(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    Hs      = NDBC_45005_2011(p_start:(p_start+31*24),9);
    Hbad    = find(Hs == 99.00);
    Hs(Hbad)= NaN;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
end
Uoriginal = U;