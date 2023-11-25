function dTw = dTw_dt(Tb, Tw, h, A, mw, cw)
    dTw = (Tb - Tw) * (h * A) / (mw * cw);
end