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
subplot(4,1,2);
plot(T_interpolacja, h_lagrange);
grid on;
title('Wyświetlenie interpolacji Lagrange');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');

%% Interpolacja Newton
h_newton = interpolacja_newton(delta_T, h, T_interpolacja);
subplot(4,1,3);
plot(T_interpolacja, h_newton);
grid on;
title('Wyświetlenie interpolacji Newtona');
xlab = xlabel('\Delta T [^{\circ}C]');
ylab = ylabel('h [W*m^{-2}]');


%% Brudnopis
% %aproksymacja lub interpolacja w celu wykorzystania w symulacji
% Tb_0 = 1200;
% Tw_0 = 25;
% %zaimplemenowac trzy algorytmy pozwalajace znalezc przyblizenie
% %wspolczynnika przewodnictwa cieplnego na podstawie danych z tabeli i
% %wykorzystac te przyblizenia w symulacji
% % * dowolnie wybrany algorytm interpolacji wielomianowej (np. Lagrange,
% % Newton, itp.)
% 

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
    wspolczynniki = ilorazy_roznicowe(delta_T, h);
    h_newton = zeros(size(T_interpolacja));
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