function delta_T_rownoodlegle = podzial_wezlow(delta_T)
    zakres = max(delta_T) - min(delta_T);
    ilosc_wezlow = 15;
    krok = zakres ./ (ilosc_wezlow - 1);
    delta_T_rownoodlegle = min(delta_T):krok:max(delta_T);
end