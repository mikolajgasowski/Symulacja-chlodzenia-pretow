clc, clear, close all;
%% Dane
delta_T = [-1500, -1000, -300, -50, -1, 1, 20, 50, 200, 400, 1000, 2000];
h = [178, 176, 168, 161, 160, 160, 160.2, 161, 165, 168, 174, 179];
T_interpolacja = -1500:2000;

%% Wyświetlenie danych pomiarowych
figure(1);
subplot(4,1,1);
plot(delta_T, h, 'o-');
grid on;
title('Wyświetlenie danych pomiarowych');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
%% Interpolacja Lagrange
h_lagrange = interpolacja_lagrange(delta_T, h, T_interpolacja);
figure(1)
subplot(4,1,2);
plot(T_interpolacja, h_lagrange);
grid on;
title('Interpolacja Lagrange');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
%% Interpolacja Newton
% % wyniki dla interpolacji lagrange i newtona sa identyczne
% h_newton = interpolacja_newton(delta_T, h, T_interpolacja);
% subplot(4,1,3);
% plot(T_interpolacja, h_newton);
% grid on;
% title('Interpolacja Newtona');
% xlab = xlabel('\Delta T [^{\circ}C]');
% ylab = ylabel('h [W*m^{-2}]');
%% Aproksymacja metodą najmniejszych kwadratów
    % dla stopni wielomianów od 5 do 11 wartosci wychodza poza skale,
    % dopasowujemy wielomianami do 4 stopnia analizujac blad aproksymacji =>
    % najmniejszy blad jest dla stopnia 4
bledy_aproksymacji=[];
for n = 1:4
    [~, blad_aproksymacji] = least_squares_interpolation(delta_T, h, T_interpolacja, n);
    bledy_aproksymacji(1,n) = blad_aproksymacji;
end
[min_blad, n_blad] = min(bledy_aproksymacji);
[h_kwadraty, ~] = least_squares_interpolation(delta_T, h, T_interpolacja, n_blad);

figure(1)
subplot(4,1,3);
plot(T_interpolacja, h_kwadraty);
title(['Aproksymacja metodą najmniejszych kwadratów - stopień: ' num2str(n_blad)]);
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
grid on;

%% Wyznaczanie węzłów równoodległych metodą graficzną
delta_T_rownoodlegle = podzial_wezlow_wykres(delta_T, h);
%% Interpolacja metodą splajnów
h_rownoodlegle = [178.0, 177.0, 176.0, 173.2, 170.3, 166.7, 160.0, 165.8, 169.0, 171.5, 174.0, 175.25, 176.5, 177.75, 179.0];
h_splajn = splajn(delta_T_rownoodlegle, h_rownoodlegle, T_interpolacja);
figure(1)
subplot(4,1,4)
plot(T_interpolacja, h_splajn);
grid on;
title('Interpolacja funkcjami sklejanymi');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
%% Porównanie na jednym wykresie wartości interpolowanych z danymi pomiarowymi
figure(3)
subplot(4,1,1)
plot(delta_T, h, 'o-');
grid on;
title('Wyświetlenie danych pomiarowych');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
ylim([min(h) max(h)]);

figure(3)
subplot(4,1,2);
plot(delta_T, h, '-o');
hold on;
plot(T_interpolacja, h_lagrange);
grid on;
title('Interpolacja Lagrange');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
ylim([min(h) max(h)]);

figure(3)
subplot(4,1,3);
plot(delta_T, h, '-o');
hold on;
plot(T_interpolacja, h_kwadraty);
title(['Aproksymacja metodą najmniejszych kwadratów - stopień: ' num2str(n_blad)]);
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');
grid on;

figure(3)
subplot(4,1,4)
plot(delta_T_rownoodlegle, h_rownoodlegle, '-o');
hold on;
plot(T_interpolacja, h_splajn);
grid on;
title('Interpolacja funkcjami sklejanymi');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');


blad_bezwzgledny_lagrange = abs(h_splajn - h_lagrange);
blad_bezwzgledny_aproksymacja = abs(h_splajn - h_kwadraty);
sredni_blad_lagrange = mean(blad_bezwzgledny_lagrange);
sredni_blad_aproksymacja = mean(blad_bezwzgledny_aproksymacja)











