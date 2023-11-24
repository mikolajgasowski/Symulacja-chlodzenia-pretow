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
% disp(oblicz_blad_interpolacji(h, h_lagrange));


%% Interpolacja Newton
% % wyniki dla interpolacji lagrange i newtona sa identyczne
% h_newton = interpolacja_newton(delta_T, h, T_interpolacja);
% subplot(4,1,3);
% plot(T_interpolacja, h_newton);
% grid on;
% title('Interpolacja Newtona');
% xlab = xlabel('\Delta T [^{\circ}C]');
% ylab = ylabel('h [W*m^{-2}]');
% 

%% Aproksymacja metodą najmniejszych kwadratów
% dla stopni wielomianów od 6 do 11 wartosci wychodza poza skale,
% dopasowujemy wielomianami do 5 stopnia analizujac blad aproksymacji =>
% najmniejszy blad jest dla stopnia 5
% bledy_aproksymacji = zeros(1,length(delta_T));
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
delta_T_rownoodlegle = podzial_wezlow(delta_T, h);
%% Interpolacja metodą splajnów
h_rownoodlegle = [178.0, 177.0, 176.0, 173.2, 170.3, 166.7, 160.0, 165.8, 169.0, 171.5, 174.0, 175.25, 176.5, 177.75, 179.0];
h_splajn = splajn(delta_T_rownoodlegle, h_rownoodlegle, T_interpolacja);
figure(1)
subplot(4,1,4)
plot(T_interpolacja, h_splajn);
grid on;
title('Interpolacja Lagrange');
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

figure(4)
subplot(4,1,4)
plot(delta_T_rownoodlegle, h_rownoodlegle, '-o');
hold on;
plot(T_interpolacja, h_splajn);
grid on;
title('Interpolacja Lagrange');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');


%% Funkcje
function h_lagrange = interpolacja_lagrange(delta_T, h, T_interpolacja)
    n = length(delta_T);
    h_lagrange = zeros(size(T_interpolacja));
    for i = 1:n
        phi = ones(size(T_interpolacja));
        for j = 1:n
            if j ~= i
                phi = phi .* (T_interpolacja - delta_T(j)) / (delta_T(i) - delta_T(j));
            end
        end
        h_lagrange = h_lagrange + h(i) * phi;
    end
end

function h_newton = interpolacja_newton(delta_T, h, T_interpolacja)
    n = length(delta_T);
    h_newton = zeros(size(T_interpolacja));
    wspolczynniki = ilorazy_roznicowe(delta_T, h);
    for i = 1:n
        term = wspolczynniki(i);
        for j = 1:i-1
            term = term .* (T_interpolacja - delta_T(j));
        end
        h_newton = h_newton + term;
    end
end

function wspolczynniki = ilorazy_roznicowe(delta_T, h)
    n = length(delta_T);
    wspolczynniki = h;
    for j = 2:n
        for i = n:-1:j
            wspolczynniki(i) = (wspolczynniki(i) - wspolczynniki(i-1)) / (delta_T(i) - delta_T(i-j+1));
        end
    end
end

function [h_kwadraty, blad_aproksymacji] = least_squares_interpolation(delta_T, h, T_interpolacja, n)
    A = zeros(n + 1, n + 1);
    B = zeros(n + 1, 1);
    for i = 1:n + 1
        for j = i:n+i
            A(i, j-i+1) = sum(delta_T.^(j-1));
        end
        B(i) = sum(h .* delta_T.^(i-1));
    end
    X = A \ B;
    
    h_kwadraty = zeros(size(T_interpolacja));
    for i = 1:length(T_interpolacja)
        h_kwadraty(i) = 0;
        for j = 1:n+1
            h_kwadraty(i) = h_kwadraty(i) + X(j) * T_interpolacja(i)^(j-1);
        end
    end

    blad_aproksymacji = sqrt(sum((h - polyval(flip(X), delta_T)).^2) / length(delta_T));
end

function blad_interpolacji = oblicz_blad_interpolacji(h_pomiarowe, h_interpolowane)
    blad_interpolacji = sqrt(sum((h_pomiarowe - h_interpolowane).^2) / length(h_pomiarowe));
end

function delta_T_rownoodlegle = podzial_wezlow(delta_T, h)
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

function y_splajn = splajn(delta_T_rownoodlegle, h_rownoodlegle, T_interpolacja)
    alfa = -0.02;
    beta = 0.01;

    n = length(delta_T_rownoodlegle);
    h = delta_T_rownoodlegle(2) - delta_T_rownoodlegle(1);
    
    % macierz A
    A = diag(4 * ones(1, n)) + diag(ones(1, n - 1), 1) + diag(ones(1, n - 1), -1);
    A(1,2) = 2;
    A(end, end-1) = 2;

    % macierz Y
    h_rownoodlegle(1) = h_rownoodlegle(1) + alfa * h / 3;
    h_rownoodlegle(end) = h_rownoodlegle(end) - beta * h / 3;
    
    % wspolczynniki C
    c = A\h_rownoodlegle';
    c_1 = c(1) - alfa * h/3;
    c_n1 = c(end-1) + beta * h/3;
    c = [c_1, c', c_n1];
   
    % obliczanie S3(x) na podstawie wyznaczonych fi_i
    wezly_rownoodlegle = delta_T_rownoodlegle(1)-h:h:delta_T_rownoodlegle(end)+h;
    f = zeros(n+2, length(T_interpolacja));
    f2 = zeros(n+2, length(T_interpolacja));
    
    % podstawianie do phi
    for i = 1:n+2
        f(i,:) = phi(T_interpolacja, wezly_rownoodlegle(i), h);
        f2(i,:) = c(i) * f(i,:);
    end
    y_splajn = sum(f2,1);

end

function f = phi(X, wezel, h)
    w = wezel + (-2:2)*h;
    f1 = @(x) (x-w(1))^3;
    f2 = @(x) (x-w(1))^3 - 4*(x-w(2))^3;
    f3 = @(x) (w(5)-x)^3 - 4*(w(4)-x)^3;
    f4 = @(x) (w(5)-x)^3;
    f = zeros(1,length(X));
    licznik = 1;
    for x=X
        if x >= w(1) && x <= w(2)
            f(licznik) = f1(x);
        elseif x >= w(2) && x <= w(3)
            f(licznik) = f2(x);
        elseif x >= w(3) && x <= w(4)
            f(licznik) = f3(x);
        elseif x >= w(4) && x <= w(5)
            f(licznik) = f4(x);
        else
            f(licznik) = 0;
        end
        f(licznik) = 1/(h^3) * f(licznik);
        licznik = licznik + 1;
    end
end