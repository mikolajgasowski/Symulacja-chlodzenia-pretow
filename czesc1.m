clc, clear, close all;
%% Dane
h = 160;
A = 0.0109;
mb = 0.2;
mw = 2.5;
cb = 3.85;
cw = 4.1813;
Tb = 1200;
Tw = 25;
k = 0.1;
t = 0:k:3;

f = @(t, T) [dTb_dt(T(1), T(2), h, A, mb, cb); dTw_dt(T(1), T(2), h, A, mw, cw)];
T_0 = [1200; 25];

%% Rozwiązywanie równań różniczokwych na podstawie wzoru matematycznego
[t_ode23, T_ode23] = ode23(f, t, T_0);
[t_ode45, T_ode45] = ode45(f, t, T_0);
[t_euler, T_euler] = euler_prosty(T_0, t, f, k);
[t_euler_zlozony, T_euler_zlozony] = euler_zlozony(T_0, t, f, k);
%% Rozwiązywanie równań różniczkowych na podstawie pomiarów
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
T_p0 = [Tb_p0, Tw_p0];

% wyznaczanie wartosci koncowych Tb, Tw dla kazdej z metod
euler_prosty_END = zeros(2, size(Nr_pomiaru, 2));
euler_zlozony_END = zeros(2, size(Nr_pomiaru, 2));
ode45_END = zeros(size(Nr_pomiaru, 2), 2);

figure(1)
% for i = 1:1
for i = 1:size(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h, A, mb, cb); dTw_dt(T(1), T(2), h, A, mw_p(i), cw)];
    [t_ez, T_ez] = euler_zlozony(T_p0(i,:), t_e, f_e, k);
    [t_ep, T_ep] = euler_prosty(T_p0(i,:), t_e, f_e, k);
    [t_eod, T_od] = ode45(f_e, t_e, T_p0(i,:));
    euler_prosty_END(:, i) = T_ep(1:2, end);
    euler_zlozony_END(:, i) = T_ez(1:2, end);
    ode45_END(i, :) = T_od(end, 1:2);
    plot(t_ep, T_ep);
    hold on;
end   
title("Euler prosty")
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [C]');


figure(2)
% for i = 1:1
for i = 1:size(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h, A, mb, cb); dTw_dt(T(1), T(2), h, A, mw_p(i), cw)];
    [t_ez, T_ez] = euler_zlozony(T_p0(i,:), t_e, f_e, k);
    [t_ep, T_ep] = euler_prosty(T_p0(i,:), t_e, f_e, k);
    [t_eod, T_od] = ode45(f_e, t_e, T_p0(i,:));
    euler_prosty_END(:, i) = T_ep(1:2, end);
    euler_zlozony_END(:, i) = T_ez(1:2, end);
    ode45_END(i, :) = T_od(end, 1:2);
    plot(t_ez, T_ez);
    hold on;
end   

title("Euler zlozony")
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [C]');

figure(3)
% for i = 1:1
for i = 1:size(Nr_pomiaru)
    t_e = 0:k:t_p(i);
    f_e = @(t, T) [dTb_dt(T(1), T(2), h, A, mb, cb); dTw_dt(T(1), T(2), h, A, mw_p(i), cw)];
    [t_ez, T_ez] = euler_zlozony(T_p0(i,:), t_e, f_e, k);
    [t_ep, T_ep] = euler_prosty(T_p0(i,:), t_e, f_e, k);
    [t_eod, T_eod] = ode45(f_e, t_e, T_p0(i,:));
    euler_prosty_END(:, i) = T_ep(1:2, end);
    euler_zlozony_END(:, i) = T_ez(1:2, end);
    ode45_END(i, :) = T_eod(end, 1:2);
    plot(t_eod, T_eod);
    hold on;
end   

title("ode45  ")
grid on;
xlabel('Czas [t]');
ylabel('Temperatura [C]');

%% Wykresy na podstawie wzoru matematycznego
figure(4)
subplot(2, 2, 1);
plot(t_ode23, T_ode23);
title('Rozwiązanie układów równań różniczkowych - ODE23');
xlabel('Czas [t]');
ylabel('Temperatura [C]');
legend('Temperatura pręta', 'Temperatura oleju chłodzącego');
grid on;

subplot(2, 2, 2);
plot(t_ode45, T_ode45);
title('Rozwiązanie układów równań różniczkowych - ODE45');
xlabel('Czas [t]');
ylabel('Temperatura [C]');
legend('Temperatura pręta', 'Temperatura oleju chłodzącego');
grid on;

subplot(2, 2, 3);
plot(t_euler, T_euler);
title('Rozwiązanie układów równań różniczkowych - Euler prosty');
xlabel('Czas [t]');
ylabel('Temperatura [C]');
legend('Temperatura pręta', 'Temperatura oleju chłodzącego');
grid on;

subplot(2, 2, 4);
plot(t_euler_zlozony, T_euler_zlozony);
title('Rozwiązanie układów równań różniczkowych - Euler złożony');
xlabel('Czas [t]');
ylabel('Temperatura [C]');
legend('Temperatura pręta', 'Temperatura oleju chłodzącego');
grid on;

%% Wyświetlanie tabeli
Nr_pomiaru = (1:size(Nr_pomiaru, 1))';
tableData = table(Nr_pomiaru, Tb_p0, Tw_p0, mw_p, t_p, Tb_p, Tw_p, euler_prosty_END(1,:)', euler_prosty_END(2,:)', euler_zlozony_END(1,:)', euler_zlozony_END(2,:)', ode45_END(:,1),ode45_END(:,2), 'VariableNames', {'Nr_pomiaru', 'Tb(0)', 'Tw(0)', 'Mw', 't', 'Tb(t)', 'Tw(t)', 'Tb(t) euler prosty', 'Tw(t) euler prosty', 'Tb(t) euler złożony', 'Tw(t) euler złożony', 'Tb(t) ODE45', 'Tw(t) ODE45'});
fig = uifigure('Position', [100, 100, 1250, 250]);
uit = uitable(fig, 'Data', tableData, 'ColumnName', tableData.Properties.VariableNames, 'Position', [0, 0, 1250, 250]);
s = uistyle('BackgroundColor', 'yellow');
y = uistyle('BackgroundColor', 'red');
addStyle(uit, y, 'column', 6:7);
addStyle(uit, s, 'column', 8:13);
%% Funkcje
function dTb = dTb_dt(Tb, Tw, h, A, mb, cb)
    dTb = (Tw - Tb) * (h * A) / (mb * cb);
end

function dTw = dTw_dt(Tb, Tw, h, A, mw, cw)
    dTw = (Tb - Tw) * (h * A) / (mw * cw);
end

function [t_euler, T_euler] = euler_prosty(T, t, f, h)
    n = length(t);
    T_euler = zeros(2, n);
    T_euler(:, 1) = T;
    for i = 2:n
        T_euler(:, i) = T_euler(:, i - 1) + h * f(t(i - 1), T_euler(:, i - 1));
    end
    t_euler = t;
end

function [t_euler_zlozony, T_euler_zlozony] = euler_zlozony(T, t, f, h)
    n = length(t);
    T_euler_zlozony = zeros(2, n);
    T_euler_zlozony(:, 1) = T;
    for i = 2:n
        T_euler_zlozony(:, i) = T_euler_zlozony(:, i - 1) + h * f(t(i - 1) + h/2, T_euler_zlozony(:, i - 1) + (h/2) * f(t(i - 1), T_euler_zlozony(:, i - 1)));
%         T_euler_zlozony(:, i) = T_euler_zlozony(:, i - 1) + h * f(t(i - 1), T_euler_zlozony(:, i - 1)) + (h/2) * f(t(i - 1), T_euler_zlozony(:, i - 1));
    end
    t_euler_zlozony = t;
end



