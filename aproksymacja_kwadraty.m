function [h_kwadraty, blad_aproksymacji] = aproksymacja_kwadraty(delta_T, h, T_interpolacja, n)
    A = zeros(n + 1, n + 1);
    B = zeros(n + 1, 1);
    for i = 1:n + 1
        for j = i:n+i
            A(i, j-i+1) = sum(delta_T.^(j-1));
        end
        B(i) = sum(h .* delta_T.^(i-1));
    end
    X = A \ B;
    
    h_kwadraty = zeros(size(T_interpolacja));
    for i = 1:length(T_interpolacja)
        h_kwadraty(i) = 0;
        for j = 1:n+1
            h_kwadraty(i) = h_kwadraty(i) + X(j) * T_interpolacja(i)^(j-1);
        end
    end

    blad_aproksymacji = sqrt(sum((h - polyval(flip(X), delta_T)).^2) / length(delta_T));
end