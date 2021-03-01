%**************************************************************************
%
%          Calculate th fractal dimension of the wind (magnitude)
%        Based on the assumption that wind is of the form (locally),
%                          U = Uo(gt/Uo)^q,
%                   where Uo = Uo(x,t) and q = (x,t).
%             Calculation is based on the variational method.
%                     Written by Colton J. Conroy
%                               @ APAM
%                               2/09/16
%     
%**************************************************************************
% constants
%----------
itype = 'power';
g = 9.81;  fig = 'on';  
dtn = 60;
dtw = 10;
dt_samples = length(cg_f(:,1));
T   = nregions*dtw*60; % total time 
dt  = dtw*60;       % global time step
%deltat = [600 300 200 150 75 37.5]; 
deltat = [600 300 200 150 60];
Nsamples = length(deltat);
%-------------------------------------------------
% variation method to calculate fractal dimension
%-------------------------------------------------
V = zeros(Nsamples,1);
for i = 1:Nsamples                   % loop over samples
    %dlt = deltat(i)/6;               % local time step
    NTw = floor(dt/deltat(i));       % number of wind time steps
    NT  = floor(T/deltat(i))-1;      % number of local time steps
    k = 1; j = 0; t = 0; time = 0; li = 1; lf = 0;
    for n = 0:NT                     % loop over month of data
        lt = floor(deltat(i)/dtn);
        lf = lf + lt;
        j  = j+1;
        if k == 1
            anchor = 0;   % bc of boundary effect
            if cg_f(1,k) == inf 
                cg_f(1,k) = 0;
            elseif cg_f(2,k) == inf
                cg_f(2,k) = 0;
            end
        else
            anchor = cg_f(10,k); % bc nonanalytic use
        end                       % a centered anchor
        max_l = max(cg_f(li:lf,k));
        min_l = min(cg_f(li:lf,k));
        sup_U = max(max_l,anchor);
        if sup_U > 100
            keyboard
        end
        inf_U = min(min_l,anchor);
        V(i) = V(i) + (sup_U - inf_U)*deltat(i);
        li = li + lt;
        if j == NTw
            k = k+1;
            li = 1;
            lf = 0;
            j = 0;
            t = 0;
        end
    end
    time = time + deltat(i);
    if time >= 2585244-3600
        break
    end
end
%-------------------
% fractal dimension
%-------------------
epsilon     = deltat./2;
e_length    = (1./epsilon)';
oscillation = (e_length.^2).*V;
lin_regress = polyfit(log(e_length),log(oscillation),1);
fractal_D   = lin_regress(1)
%------
% plot
%------
if strcmpi(fig,'on')
    scatter(log(e_length), log(oscillation))
    xlabel('$\log \frac{1}{\epsilon}$','FontSize',13,'FontWeight','demi','Interpreter','latex');
    ylabel('$\log \left(\frac{1}{\epsilon^2}V\left(\epsilon,f\right)\right)$','FontSize',13,'FontWeight','demi','Interpreter','latex')
    title('Fractal dimension of wind interpolation','FontSize',13,'FontWeight','demi','Interpreter','latex')
end
