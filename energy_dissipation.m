ld = 5e-6;  % inner cut-off
eT = zeros(Lw-1,nnodes);
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
        Ef = 1/2*(Uo(j,i)*(g*dt/Uo(j,i))^(q(j,i))-1)^2;
        Ei = 1/2*(Uo(j,i)*(g*ld/Uo(j,i))^(q(j,i))-1)^2;
        ei(j,i) = -(Ef - Ei)/(dt);
    end
    if strcmpi(type,'single')
        break
    elseif strcmpi(type,'triple')
        if i == 3
            break
        end
    end
end