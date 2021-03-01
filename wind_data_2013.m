load ndbc_2013
if strcmpi(month,'5')
    p_start = 1;
    U       = ndbc_45005_2013(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'6')
    p_start = 24*31+1;
    U       = ndbc_45005_2013(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'7')
    p_start = 24*31+24*30+1;
    U       = ndbc_45005_2013(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'8')
    p_start = 24*31+24*30+24*31+1;
    U       = ndbc_45005_2013(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'9')
    p_start = 24*31+24*30+24*31+24*31+1;
    U       = ndbc_45005_2013(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'10')
    p_start = 24*31+24*30+24*31+24*31+24*30+1;
    U       = ndbc_45005_2013(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_45005_2013(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
end
Uoriginal = U;