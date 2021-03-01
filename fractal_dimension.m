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
dtw = 60;
T   = (N-1)*dtw*60; % total time 
dt  = dtw*60;       % global time step
deltat = [3600 1800 900 450 225 112.50]; 
Nsamples = length(deltat);
%-------------------------------------------------
% variation method to calculate fractal dimension
%-------------------------------------------------
V = zeros(Nsamples,1);
for i = 1:Nsamples                   % loop over samples
    dlt = deltat(i)/6;               % local time step
    NTw = floor(dt/deltat(i));       % number of wind time steps
    NT  = floor(T/deltat(i))-1;      % number of local time steps
    k = 1; j = 0; t = 0; time = 0;
    for n = 0:NT                     % loop over month of data
        j  = j+1;
        lt = t:dlt:(t+deltat(i));
        if strcmpi(itype,'power')
            if q(k,Jnode) < 0    % measure jumps (separation, i.e., dissipation)
                lt(1) = 1e-7;
            end
            local_U = Uo(k,Jnode).*(g*lt./Uo(k,Jnode)).^(q(k,Jnode));
        else
            local_U = interp1([t, t+deltat(i)],[U(k), U(k+1)],lt);
        end
        sup_U   = max(local_U);
        inf_U   = min(local_U);
        V(i) = V(i) + (sup_U - inf_U)*deltat(i);
        t = t + deltat(i);
        if j == NTw
            k = k+1;
            j = 0;
            t = 0;
        end
        time = time + deltat(i);
        if time >= 2585244-3600
            break
        end
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
