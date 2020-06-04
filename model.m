% model robota sprawdzaj¹cego stan rur w kopalniach ropy naftowej i gazu
% ziemnego
close all;
ZIELONY = 0;
ZOLTY = 1;
CZERWONY = 2;

BATERIA_LED_GRANICA_ZOLTY = 20;
BATERIA_LED_GRANICA_CZERWONY = 10; 

BATERIA_MAX = 100; % %
BATERIA_LED = ZIELONY; % dioda alarmuj¹ca o roz³adowaniu baterii
SREDNICA = 20; % cm
DLUGOSC = 500; % cm

WODA = 0;
LAD = 1;
POWIETRZE = 2;
PODLACZONY = 0; % czy robot jest pod³¹czony kablem do ³adowania - wp³ywa na to, czy robot siê mo¿e roz³adowaæ podczas pracy

SRODOWISKO = LAD;

switch SRODOWISKO
    case WODA
        % Mariusz
    case LAD
        % Daniel
        bateria = BATERIA_MAX;
        % poprzedni stan rury
        wgniecenie = zeros(1, DLUGOSC);
        rdza = zeros(1, DLUGOSC);
        przeciek = zeros(1, DLUGOSC);
        for i=1:DLUGOSC % sprawdza ka¿dy cm
            % skanujemy
            if(BATERIA_LED ~= BATERIA_LED_GRANICA_CZERWONY)
                [wgniecenie(i+1), rdza(i+1), przeciek(i+1), bateria(i+1)] = skan_ziemia(wgniecenie(i), rdza(i), bateria(i), SREDNICA);
            end
            % ustawiamy LED informuj¹cego o poziomie baterii
            BATERIA_LED = stan_baterii(bateria(i), BATERIA_LED_GRANICA_ZOLTY, BATERIA_LED_GRANICA_CZERWONY);
            % idziemy dalej
            if (BATERIA_LED ~= BATERIA_LED_GRANICA_CZERWONY)
                bateria(i+1) = ruch_ziemia(bateria(i));
            end
            % ustawiamy LED informuj¹cego o poziomie baterii
            BATERIA_LED = stan_baterii(bateria(i), BATERIA_LED_GRANICA_ZOLTY, BATERIA_LED_GRANICA_CZERWONY);
            if (PODLACZONY == 1)
                bateria(i+1) = bateria(i) + 10;
            end
        end
        figure; % wykres wgniecen
        plot(wgniecenie, 'black');
        figure; %wykres rdzy
        plot(rdza, 'Color', '#D95319');
        figure; %wykres przecieków
        plot(przeciek, 'bo')
    otherwise
end
