function wspolczynniki = ilorazy_roznicowe(delta_T, h)
    n = length(delta_T);
    wspolczynniki = h;
    for j = 2:n
        for i = n:-1:j
            wspolczynniki(i) = (wspolczynniki(i) - wspolczynniki(i-1)) / (delta_T(i) - delta_T(i-j+1));
        end
    end
end