% oceniamy wrazliwosc modelu na parametr h
% przebiegi temperatur na kilku przypadkach
% szereg obliczen, nie duzo kodu
clc, clear, close all;
%% Dane
% dane pomiarowe wspolczynnika h
delta_T = [-1500, -1000, -300, -50, -1, 1, 20, 50, 200, 400, 1000, 2000];
h = [178, 176, 168, 161, 160, 160, 160.2, 161, 165, 168, 174, 179];

% węzły równoodległe i odpowiadające im h   
delta_T_rownoodlegle = podzial_wezlow(delta_T);
h_rownoodlegle = [178.0, 177.0, 176.0, 173.2, 170.3, 166.7, 160.0, 165.8, 169.0, 171.5, 174.0, 175.25, 176.5, 177.75, 179.0];

% pobieranie wartosci z tabeli 
pomiary_plik = 'Eksperymenty pomiarowe.xlsx';
arkusz = 1;
pomiary = readmatrix(pomiary_plik, 'Sheet', arkusz);
Nr_pomiaru = pomiary(:, 1);
Tb_p0 = pomiary(:,2);
Tw_p0 = pomiary(:,3);
mw_p = pomiary(:, 4);
t_p = pomiary(:, 5);
Tb_p = pomiary(:, 6);
Tw_p = pomiary(:, 7);

% parametry startowe
A = 0.0109;
mb = 0.2;
mw = 2.5;
cb = 3.85;
cw = 4.1813;
Tb = 1200;
Tw = 25;
k = 0.1;
t = 0:k:3;
T_0 = [Tb; Tw];

% oblicznie roznicy temperatur
roznica_temperatur = Tb_p0 - Tw_p0;

% wyznaczenie współczynnika h = (delta T) dla interpolacji i aproksymacji
h_lagrange = interpolacja_lagrange(delta_T, h, roznica_temperatur);
h_kwadraty = aproksymacja_kwadraty(delta_T, h, roznica_temperatur, 5);
h_splajny = splajn(delta_T_rownoodlegle, h_rownoodlegle, roznica_temperatur');

% wyznaczenie wartości końcowych uzyskanych z metody Eulera złożonej
T_lagrange_END = zeros(2, length(Nr_pomiaru));
T_kwadraty = zeros(2, length(Nr_pomiaru));
T_splajny = zeros(2, length(Nr_pomiaru));

% sgtitle('Symulacja rozkładu temperatury - wrażliwość modelu na metodę')

% symulacja rozkładu temperatury - badanie wrażliwości modelu na metodę
% interpolacji Lagrange'a
figure(1)
for i=1:length(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h_lagrange(i), A, mb, cb); dTw_dt(T(1), T(2), h_lagrange(i), A, mw, cw)];
    [t_ez, T_ez] = euler_zlozony(T_0, t_e, f_e, k);
    T_lagrange_END(:, i) = T_ez(1:2, end);
    plot(t_ez, T_ez);
    hold on;
end
title('Rozkład temperatury z wyznaczonym współczynnikiem h - Lagrange')
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [^{\circ}C]');

% symulacja rozkładu temperatury - badanie wrażliwości modelu na metodę
% aproksymacji najmniejszych kwadratów
figure(2)
for i=1:length(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h_kwadraty(i), A, mb, cb); dTw_dt(T(1), T(2), h_kwadraty(i), A, mw, cw)];
    [t_ez, T_ez] = euler_zlozony(T_0, t_e, f_e, k);
    T_kwadraty(:, i) = T_ez(1:2, end);
    plot(t_ez, T_ez);
    hold on;
end
title('Rozkład temperatury z wyznaczonym współczynnikiem h - aproksymacja')
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [^{\circ}C]');

% symulacja rozkładu temperatury - badanie wrażliwości modelu na metodę
% interpolacji splajnami
figure(3)
for i=1:length(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h_splajny(i), A, mb, cb); dTw_dt(T(1), T(2), h_splajny(i), A, mw, cw)];
    [t_ez, T_ez] = euler_zlozony(T_0, t_e, f_e, k);
        T_splajny(:, i) = T_ez(end, 1:2);

    plot(t_ez, T_ez);
    hold on;
end
title('Rozkład temperatury z wyznaczonym współczynnikiem h - funkcje sklejane')
% title("Interpolacja metodą funkcji sklejanych")
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [^{\circ}C]');
%% Wyświetlanie tabeli
Nr_pomiaru = (1:size(Nr_pomiaru, 1))';
tableData = table(Nr_pomiaru, Tb_p0, Tw_p0, mw_p, t_p, Tb_p, Tw_p, roznica_temperatur, h_lagrange, h_kwadraty, h_splajny', 'VariableNames', {'Nr_pomiaru', 'Tb(0)', 'Tw(0)', 'Mw', 't', 'Tb(t)', 'Tw(t)', 'Różnica temperatur', 'h_lagrange', 'h_kwadrat', 'h_splajny'});
fig = uifigure('Position', [100, 100, 1250, 260]);
uit = uitable(fig, 'Data', tableData, 'ColumnName', tableData.Properties.VariableNames, 'Position', [0, 0, 1250, 260]);
y = uistyle('BackgroundColor', [1, 1, 0.7]);
r = uistyle('BackgroundColor', [1, 0.7, 0.7]);
b = uistyle('BackgroundColor', [0.7, 0.7, 1]);
g = uistyle('BackgroundColor', [0.7, 1, 0.7]);
addStyle(uit, y, 'column', 8);
addStyle(uit, r, 'column', 9);
addStyle(uit, b, 'column', 10);
addStyle(uit, g, 'column', 11);