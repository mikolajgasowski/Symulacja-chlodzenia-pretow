function f = phi(X, wezel, h)
    w = wezel + (-2:2)*h;
    f1 = @(x) (x-w(1))^3;
    f2 = @(x) (x-w(1))^3 - 4*(x-w(2))^3;
    f3 = @(x) (w(5)-x)^3 - 4*(w(4)-x)^3;
    f4 = @(x) (w(5)-x)^3;
    f = zeros(1,length(X));
    licznik = 1;
    for x=X
        if x >= w(1) && x <= w(2)
            f(licznik) = f1(x);
        elseif x >= w(2) && x <= w(3)
            f(licznik) = f2(x);
        elseif x >= w(3) && x <= w(4)
            f(licznik) = f3(x);
        elseif x >= w(4) && x <= w(5)
            f(licznik) = f4(x);
        else
            f(licznik) = 0;
        end
        f(licznik) = 1/(h^3) * f(licznik);
        licznik = licznik + 1;
    end
end
