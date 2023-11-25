function h_newton = interpolacja_newton(delta_T, h, T_interpolacja)
    n = length(delta_T);
    h_newton = zeros(size(T_interpolacja));
    wspolczynniki = ilorazy_roznicowe(delta_T, h);
    for i = 1:n
        term = wspolczynniki(i);
        for j = 1:i-1
            term = term .* (T_interpolacja - delta_T(j));
        end
        h_newton = h_newton + term;
    end
end