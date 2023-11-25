function h_lagrange = interpolacja_lagrange(delta_T, h, T_interpolacja)
    n = length(delta_T);
    h_lagrange = zeros(size(T_interpolacja));
    for i = 1:n
        phi = ones(size(T_interpolacja));
        for j = 1:n
            if j ~= i
                phi = phi .* (T_interpolacja - delta_T(j)) / (delta_T(i) - delta_T(j));
            end
        end
        h_lagrange = h_lagrange + h(i) * phi;
    end
end
