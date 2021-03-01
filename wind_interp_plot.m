j = Jnode;
if strcmpi(wind_fig,'on')
    if strcmpi(data_type,'initial')
        U  = sqrt(Uw(j,:).^2 + Vw(j,:).^2);
    end
    for k = 0:Lw-2
        tplot = 1e-5:dt/100:dt;
        if k == 0
            uend = 0;
            offset_m = sum(60./2.^(1:ncascades))*60*2.60;
        else
            uend = splot(end);
        end
        if strcmpi(w_fig,'g_avg')
            splot = Uo(k+1,j).*(g.*tplot./Uo(k+1,j)).^(real(q(k+1,j))) ...
                - (ncascades+1) + total_d(k+1,j);
            splot(1) = uend;
        else
            splot = Uo(k+1,j).*(g.*tplot./Uo(k+1,j)).^(real(q(k+1,j))) ...
                - 1;
            splot(1) = uend;
            offset_m = 0;
        end
        hold on
        %plot((tplot+k*dt)/86400,uplot,'r','LineWidth',3)
        if strcmpi(w_fig,'g_avg')
            
        else
            Tplot = dt*k+dt/2; Tplot = Tplot/86400;
            plot(Tplot,U(k+2),'bo',...
                'LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',8)
            hold on
        end
        plot((tplot+k*dt+offset_m)/86400,splot,'r','LineWidth',1.5);
    end
    xlabel('time (days)','FontSize',13,'FontWeight','demi','Interpreter','latex');
    ylabel('Wind speed (m/s)','FontSize',13,'FontWeight','demi','Interpreter','latex')
    %legend('Average','Interpolant','Location','NorthEast')
    title('Hyperbolic interpolation, $~~\left|\left|\mathbf{u}\right|\right|=\left|\left|\mathbf{u}_0\right|\right|\left(g\frac{t}{\left|\left|\mathbf{u}_0\right|\right|}\right)^q$','FontSize',13,'FontWeight','demi','Interpreter','latex')
    axis([0.0, 31.5, -1, max(U)+1])
    if strcmpi(w_fig,'g_avg')
        Tplot = 1:1:length(Uoriginal); Tplot = Tplot/24;
        plot(Tplot,Uoriginal,'bo',...
            'LineWidth',2,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor',[.49 1 .63],...
            'MarkerSize',8)
    end
end

if strcmpi(direction_fig,'on')
    Tavg = zeros(Lw,1);
    for k = 0:Lw-2
        if strcmpi(wind_type,'dgwave')
            if Uw(j,k+2) == 0
                Tr = pi/2;
            else
                Tr = atan(abs(Vw(j,k+2))/abs(Uw(j,k+2)));
            end
        else
            Tr = theta_w(k+2)-1*ncascades;
        end
        Tavg(k+1) = Tr;
        tplot = 3.5e-2:dt/100:dt;
        if k == 0
            uend = 0;
        else
            uend = splot(end);
        end
        splot = real(To(k+1,j).*(Tref(j).*tplot./To(k+1,j)).^(real(r(k+1,j))))-(ncascades+1);
        splot(1) = uend;
        
        %plot((tplot+k*dt)/86400,uplot,'r','LineWidth',3)
        %hold on
        Tplot = dt*k+dt/2; Tplot = Tplot/86400;
         plot(Tplot,Tavg(k+1),'bo',...
             'LineWidth',2,...
             'MarkerEdgeColor','b',...
             'MarkerFaceColor',[.49 1 .63],...
             'MarkerSize',9)
        hold on
        plot((tplot+k*dt)/86400,splot,'r','LineWidth',3);
    end
    xlabel('time (days)','FontSize',13,'FontWeight','demi','Interpreter','latex');
    ylabel('Wind direction (rad)','FontSize',13,'FontWeight','demi','Interpreter','latex')
    legend('Average','Interpolant','Location','NorthEast')
    title('Wind inpterpolation, $~~\theta=\theta_0\left(\frac{\omega_T}{\theta_0}t\right)^\Upsilon$','FontSize',13,'FontWeight','demi','Interpreter','latex')
    axis([0.0, 31.5, -0.75, max(Tavg)+.75])
end

if strcmpi(dg_fig,'on')
    j = 2070; % element to plot solution (buoy1 = 2070, buoy2 = 1667, buoy3 = 1428)
    t = 0; time = 0; jj = 0; buoy1 = zeros(NT,1); buoy2 = zeros(NT,1);
    k = 1; buoy3 = zeros(NT,1);
    for n = 0:NT
        jj = jj + 1;
        for irk = 1:nrk
            t = t + crk(irk)*deltat;
            RHS_theta_plot
            buoy1(n+1) = theta0(1,j,1);
            %---
            % wind index
            %---
            if jj == NTw
                k = k+1;
                t = 0;
                jj = 0;
            end
            %---
            % update global time
            %---
            time = time + deltat;
        end
    end
end
if strcmpi(diss_fig,'on')
    if strcmpi(diss_fig_type,'total')
        for k = 0:Lw-2
            tplot = 1e-5:dt/100:dt;
            if k == 0
                offset_m = sum(60./2.^(1:ncascades))*60;
            else
                uend = splot(end);
            end
            splot = ones(size(tplot));
            splot = total_d(k+1)*splot;
            if k > 0
                splot(1) = uend;
            end
            hold on
            plot((tplot+k*dt+offset_m)/86400,splot,'r','LineWidth',1.5);
        end
    else
        for n = 1:ncascades
            Lw = ln_casc(n);
            for k = 0:Lw-2
                tplot = 1e-5:dt_n(n)/100:dt_n(n);
                if k == 0
                    offset_m = sum(60./2.^(1:ncascades))*60;
                else
                    uend = splot(end);
                end
                splot = ones(size(tplot));
                splot = Udiss(k+1,n)*splot;
                if k > 0
                    splot(1) = uend;
                end
                hold on
                plot((tplot+k*dt_n(n)+offset_m)/86400,splot,'LineWidth',1.5,'Color',[n/ncascades .2 1/n]);
            end
        end
    end
    
    xlabel('time (days)','FontSize',13,'FontWeight','demi','Interpreter','latex');
    ylabel('Velocity dissipated to mean flow (m/s)','FontSize',13,'FontWeight','demi','Interpreter','latex')
    %legend('Average','Interpolant','Location','NorthEast')
    title('Turbulent cascade dissipation','FontSize',13,'FontWeight','demi','Interpreter','latex')
    %axis([0.0, 31.5, -1, max(U)+1])
end