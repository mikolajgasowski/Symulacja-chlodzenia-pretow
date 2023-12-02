function I = izolacja(mw, Tb, T_oczekiwane)
    I = [];
    for i = 1:length(mw)-1
        if (Tb(i) - T_oczekiwane) * (Tb(i+1) - T_oczekiwane) < 0
           I = [I; [mw(i), mw(i+1)]];
        end
    end
end
