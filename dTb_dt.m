function dTb = dTb_dt(Tb, Tw, h, A, mb, cb)
    dTb = (Tw - Tb) * (h * A) / (mb * cb);
end