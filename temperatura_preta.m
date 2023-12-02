function T = temperatura_preta(mw, T_0, h_rownoodlegle, A, mb, cb, cw, t_k, krok)
    T = zeros(1,length(mw));
    for i=1:length(mw)
        t = 0:krok:t_k;
        f_e = @(t, T) [dTb_dt(T(1), T(2), h_rownoodlegle, A, mb, cb); 
                        dTw_dt(T(1), T(2), h_rownoodlegle, A, mw(i), cw)];
        [~, y_out] = euler_zlozony(T_0, t, f_e, krok);
        T(i) = y_out(2,end);
    end
end