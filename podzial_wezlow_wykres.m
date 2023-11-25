function delta_T_rownoodlegle = podzial_wezlow_wykres(delta_T, h)
    zakres = max(delta_T) - min(delta_T);
    ilosc_wezlow = 15;
    krok = zakres ./ (ilosc_wezlow - 1);
    delta_T_rownoodlegle = min(delta_T):krok:max(delta_T);
    disp('Liczba węzłów:');
    disp(ilosc_wezlow);
    disp('Odstęp między węzłami:');
    disp(krok);
    disp('Węzły:');
    disp(delta_T_rownoodlegle);
    figure()
    plot(delta_T, h, '-o');
    xlim([min(delta_T), max(delta_T)]);
    for i=1:length(delta_T_rownoodlegle)
        hold on;
        xline(delta_T_rownoodlegle(i), 'Label', ['X = ' num2str(delta_T_rownoodlegle(i))])
    end
    title('Wykres potrzebny do wyznaczenia metodą graficzną węzłów równoodległych')
    xlab = xlabel('\Delta T [^{\circ}C]');
    ylab = ylabel('h [W*m^{-2}]');
    grid on;
    yticks(min(h):0.5:max(h)); 
    ytickformat('%.1f'); 
end