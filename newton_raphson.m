function mw = newton_raphson(f, f_prim, przedzial, d)
    a = przedzial(1);
    b = przedzial(2);
    if f(a)*f_prim(a)>0
        mw = a;
    elseif f(b)*f_prim(b)>0
        mw = b;
    end
    while abs(f(mw)) > d
        mw = mw - (f(mw)/f_prim(mw));
    end
end