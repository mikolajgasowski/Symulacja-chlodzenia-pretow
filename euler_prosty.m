function [t_euler, T_euler] = euler_prosty(T, t, f, h)
    n = length(t);
    T_euler = zeros(2, n);
    T_euler(:, 1) = T;
    for i = 2:n
        T_euler(:, i) = T_euler(:, i - 1) + h * f(t(i - 1), T_euler(:, i - 1));
    end
    t_euler = t;
end