function [t_euler_zlozony, T_euler_zlozony] = euler_zlozony(T, t, f, h)
    n = length(t);
    T_euler_zlozony = zeros(2, n);
    T_euler_zlozony(:, 1) = T;
    for i = 2:n
        T_euler_zlozony(:, i) = T_euler_zlozony(:, i - 1) + h * f(t(i - 1) + h/2, T_euler_zlozony(:, i - 1) + (h/2) * f(t(i - 1), T_euler_zlozony(:, i - 1)));
%       T_euler_zlozony(:, i) = T_euler_zlozony(:, i - 1) + h * f(t(i - 1), T_euler_zlozony(:, i - 1)) + (h/2) * f(t(i - 1), T_euler_zlozony(:, i - 1));
    end
    t_euler_zlozony = t;
end
