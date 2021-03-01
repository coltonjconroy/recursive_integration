if strcmpi(year,'2012_44065')
    load ndbc_buoy_44065.txt
    p_strt = 24*31+24*29+24*31+24*30+1;
    if strcmpi(month,'5')
        
    elseif strcmpi(month,'6')
        
    elseif strcmpi(month,'7')
        
    elseif strcmpi(month,'8')
        
    elseif strcmpi(month,'9')
        
    elseif strcmpi(month,'10')
        p_start = 24*31+24*30+24*31+24*31+24*30+p_strt;
        wvht       = ndbc_buoy_44065(p_start:(p_start+31*24),9);
        ubad    = find(wvht == 99.0);
        wvht(ubad) = (wvht(ubad+1)+wvht(ubad-1))./2;
        dpd = ndbc_buoy_44065(p_start:(p_start+31*24),6);
        tbad    = find(dpd == 99.0);
        dpd(tbad) = (dpd(tbad+1)+dpd(tbad-1))./2;
        wvpd = ndbc_buoy_44065(p_start:(p_start+31*24),10);
        wbad = find(wvpd == 99.0);
        wvpd(wbad) = (wvpd(wbad+1)+wvpd(wbad-1))./2;
        awvpd = ndbc_buoy_44065(p_start:(p_start+31*24),11);
        awbad = find(awvpd == 99.0);
        awvpd(wbad) = (awvpd(wbad+1)+awvpd(wbad-1))./2;
        N  = 24*31;
        Lw = N+1; % # of mixing nodes
        data_dt = 60;
        Hs = wvht(1:end-1);
    end
elseif strcmpi(year,'2005_42001')
    load ndbc_gulf_42001.txt
    p_strt = 1; 
    if strcmpi(month,'8')
        p_start = 24*31+24*30+24*31+p_strt+24*31+24*28+24*31+24*30;
        wvht    = ndbc_gulf_42001(p_start:(p_start+31*24),9);
        ubad    = find(wvht == 99.0);
        wvht(ubad) = (wvht(ubad+1)+wvht(ubad-1))./2;
        dpd = ndbc_gulf_42001(p_start:(p_start+31*24),6);
        tbad    = find(dpd == 99.0);
        dpd(tbad) = (dpd(tbad+1)+dpd(tbad-1))./2;
        wvpd = ndbc_gulf_42001(p_start:(p_start+31*24),10);
        wbad = find(wvpd == 99.0);
        wvpd(wbad) = (wvpd(wbad+1)+wvpd(wbad-1))./2;
        awvpd = ndbc_gulf_42001(p_start:(p_start+31*24),11);
        awbad = find(awvpd == 99.0);
        awvpd(wbad) = (awvpd(wbad+1)+awvpd(wbad-1))./2;
        N  = 24*31;
        Lw = N+1; % # of mixing nodes
        data_dt = 60;
    end
elseif strcmpi(year,'2011')
    load NDBC_45005_2011.txt
    if strcmpi(month,'8')
        p_start = 24*31+24*30+24*31+1;
        wvht    = NDBC_45005_2011(p_start:(p_start+31*24),9);
        ubad    = find(wvht == 99.0);
        wvht(ubad) = (wvht(ubad+1)+wvht(ubad-1))./2;
        dpd = NDBC_45005_2011(p_start:(p_start+31*24),6);
        tbad    = find(dpd == 99.0);
        dpd(tbad) = (dpd(tbad+1)+dpd(tbad-1))./2;
        wvpd = NDBC_45005_2011(p_start:(p_start+31*24),10);
        wbad = find(wvpd == 99.0);
        wvpd(wbad) = (wvpd(wbad+1)+wvpd(wbad-1))./2;
        awvpd = NDBC_45005_2011(p_start:(p_start+31*24),11);
        awbad = find(awvpd == 99.0);
        awvpd(wbad) = (awvpd(wbad+1)+awvpd(wbad-1))./2;
        N  = 24*31;
        Lw = N+1; % # of mixing nodes
        data_dt = 60;
    elseif strcmpi(month,'7')
        p_start = 24*31+24*30+1;
        wvht    = NDBC_45005_2011(p_start:(p_start+31*24),9);
        ubad    = find(wvht == 99.0);
        wvht(ubad) = (wvht(ubad+1)+wvht(ubad-1))./2;
        dpd = NDBC_45005_2011(p_start:(p_start+31*24),6);
        tbad    = find(dpd == 99.0);
        dpd(tbad) = (dpd(tbad+1)+dpd(tbad-1))./2;
        wvpd = NDBC_45005_2011(p_start:(p_start+31*24),10);
        wbad = find(wvpd == 99.0);
        wvpd(wbad) = (wvpd(wbad+1)+wvpd(wbad-1))./2;
        awvpd = NDBC_45005_2011(p_start:(p_start+31*24),11);
        awbad = find(awvpd == 99.0);
        awvpd(wbad) =(awvpd(wbad+1)+awvpd(wbad-1))./2;
        N  = 24*31;
        Lw = N+1; % # of mixing nodes
        data_dt = 60;
        Hs = wvht(1:end-1);
    end
end
