clc, clear, close all
%% Dane
% dane pomiarowe wspolczynnika h
delta_T = [-1500, -1000, -300, -50, -1, 1, 20, 50, 200, 400, 1000, 2000];

% węzły równoodległe i odpowiadające im h   
delta_T_rownoodlegle = podzial_wezlow(delta_T);
h_rownoodlegle = [178.0, 177.0, 176.0, 173.2, 170.3, 166.7, 160.0, 165.8, 169.0, 171.5, 174.0, 175.25, 176.5, 177.75, 179.0];

% parametry startowe
A = 0.0109;
mb = 0.25;
cb = 0.29;
cw = 4.1813;
Tb = 1200;
Tw = 25;
T_0 = [Tb; Tw];
roznica_temperatur = abs(Tb - Tw);
h_splajny = splajn(delta_T_rownoodlegle, h_rownoodlegle, roznica_temperatur');
krok = 0.01;
T_oczekiwane = 125;
t_oczekiwane = 0.7;
%% Izolacja pierwiastków
mw_izolacja = 0:krok:1;
Tb_izolacja = temperatura_preta(mw_izolacja, T_0, h_splajny, A, mb, cb, cw, t_oczekiwane, krok);
przedzial_izolacji = izolacja(mw_izolacja, Tb_izolacja, T_oczekiwane);

figure(1)
plot(mw_izolacja, Tb_izolacja);
hold on; 
x_values = [przedzial_izolacji(1), przedzial_izolacji(2), przedzial_izolacji(2), przedzial_izolacji(1)];
y_values = [0, 0, max(Tb_izolacja), max(Tb_izolacja)];
patch(x_values, y_values, 'blue', 'FaceAlpha', 0.4, 'EdgeColor', 'none');
grid on;
xlabel('Masa oleju chłodzącego [kg]');
ylabel('Temperatura [C]');
title('Charakterystyka temperatury pręta od masy oleju chłodzącego po 0.7 sekundy');

%% Znalezienie pierwiastka metoda Newtona-Raphsona
dokladnosc = 1e-5;
f_mw = @(mw) temperatura_preta(mw, T_0, h_splajny, A, mb, cb, cw, t_oczekiwane, krok) - T_oczekiwane;
f_prim_mw = @(mw) (f_mw(mw+krok)-f_mw(mw))/krok;
mw_znalezione = newton_raphson(f_mw, f_prim_mw, przedzial_izolacji, dokladnosc);
scatter(mw_znalezione, T_oczekiwane, 'filled');
legend("Temperatura pręta", "Przedział izolacji", "Znaleziony pierwiastek");

%% symulacja dla wyznaczonego mw
t_s = 0:krok:0.7;
f_s = @(t, T) [dTb_dt(T(1), T(2), h_splajny, A, mb, cb); dTw_dt(T(1), T(2), h_splajny, A, mw_znalezione, cw)];
[t_ez, T_ez] = euler_zlozony(T_0, t_s, f_s, krok);

figure(2)
plot(t_ez, T_ez);
grid on;
xlabel('Czas [t]')
ylabel('Temperatura [C]');
legend('Temperatura pręta', 'Temperatura oleju chłodzącego');
title("Symulacja przebiegów temperatury pręta i oleju chłodzącego dla mw = 0.1864 [kg]");

