%
% Calculate q statistics for turbulence
%
if ncascades < 3
    tf = length(q(:,Jnode))
elseif ncascades == 3
    tf = length(q(1:end-4,Jnode))
elseif ncascades == 4
    tf = length(q(1:end-8,Jnode))
elseif ncascades == 5
    tf = length(q(1:end-20,Jnode))
elseif ncascades == 6
    tf = length(q(1:end-35,Jnode))
end

max_q = max(q(1:tf,Jnode))
min_q = min(q(1:tf,Jnode))
rms_q = rms(q(1:tf,Jnode))
var_q = var(q(1:tf,Jnode))
std_q = std(q(1:tf,Jnode))
sum_q = sum(q(1:tf,Jnode))

qp = abs(q(1:tf,Jnode));
avg_qp = mean(qp)
std_qp = std(qp)
var_qp = var(qp)
sum_qp = sum(qp)

l_q_p   = find(q(1:tf,Jnode) > 1.0e-2);
num_q_p = length(l_q_p)
sum_q_p = sum(q(l_q_p,Jnode))

density_p = num_q_p/tf

l_q_m   = find(q(1:tf,Jnode) < -1.0e-2);
num_q_m = length(l_q_m)
sum_q_m = sum(q(l_q_m,Jnode))

density_m = num_q_m/tf

density_o = 1 - density_p - density_m

q_density = (abs(sum_q_p) + abs(sum_q_m))/sum(qp)
if ncascades == 4
    l_dn = ld_i
end