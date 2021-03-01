load ndbc_gulf_42001.txt
p_strt = 1;
if strcmpi(month,'1')
    p_start = p_strt;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'2')
    p_start = p_strt+24*31;
    U       = ndbc_gulf_42001(p_start:(p_start+28*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+28*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*28;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'3')
    p_start = p_strt+24*31+24*28;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'4')
    p_start = p_strt+24*31+24*28+24*31;
    U       = ndbc_gulf_42001(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'5')
    p_start = p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'6')
    p_start = 24*31+p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'7')
    p_start = 24*31+24*30+p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'8')
    p_start = 24*31+24*30+24*31+p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'9')
    p_start = 24*31+24*30+24*31+24*31+p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+30*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+30*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*30;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
elseif strcmpi(month,'10')
    p_start = 24*31+24*30+24*31+24*31+24*30+p_strt+24*31+24*28+24*31+24*30;
    U       = ndbc_gulf_42001(p_start:(p_start+31*24),7);
    ubad    = find(U == 99.0);
    U(ubad) = U(ubad+1)+U(ubad-1)./2;
    theta_w = ndbc_gulf_42001(p_start:(p_start+31*24),6);
    tbad    = find(theta_w == 99.0);
    theta_w(tbad) = theta_w(tbad+1)+theta_w(tbad-1)./2;
    N  = 24*31;
    Lw = N+1; % # of mixing nodes
    data_dt = 60;
end
Uoriginal = U;