function y_splajn = splajn(delta_T_rownoodlegle, h_rownoodlegle, T_interpolacja)
    alfa = -0.02;
    beta = 0.01;

    n = length(delta_T_rownoodlegle);
    h = delta_T_rownoodlegle(2) - delta_T_rownoodlegle(1);
    
    A = diag(4 * ones(1, n)) + diag(ones(1, n - 1), 1) + diag(ones(1, n - 1), -1);
    A(1,2) = 2;
    A(end, end-1) = 2;

    h_rownoodlegle(1) = h_rownoodlegle(1) + alfa * h / 3;
    h_rownoodlegle(end) = h_rownoodlegle(end) - beta * h / 3;
    
    c = A\h_rownoodlegle';
    c_1 = c(1) - alfa * h/3;
    c_n1 = c(end-1) + beta * h/3;
    c = [c_1, c', c_n1];
   
    wezly_rownoodlegle = delta_T_rownoodlegle(1)-h:h:delta_T_rownoodlegle(end)+h;
    f = zeros(n+2, length(T_interpolacja));
    f2 = zeros(n+2, length(T_interpolacja));
    
    for i = 1:n+2
        f(i,:) = phi(T_interpolacja, wezly_rownoodlegle(i), h);
        f2(i,:) = c(i) * f(i,:);
    end
    y_splajn = sum(f2,1);

end