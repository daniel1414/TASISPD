% model robota sprawdzaj¹cego stan rur w kopalniach ropy naftowej i gazu
% ziemnego
close all;
ZIELONY = 0;
ZOLTY = 1;
CZERWONY = 2;

BATERIA_LED_GRANICA_ZOLTY = 30;
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
        bateria_wyk = bateria;
        % poprzedni stan rury
        wgniecenie = zeros(1, DLUGOSC);
        rdza = zeros(1, DLUGOSC);
        przeciek = zeros(1, DLUGOSC);
        for i=1:DLUGOSC % sprawdza ka¿dy cm
            % skanujemy
            if(bateria(i) > 10)
                [wgniecenie(i+1), rdza(i+1), przeciek(i+1), bateria(i+1)] = skan_ziemia(wgniecenie(i), rdza(i), bateria(i), SREDNICA);
            else
                bateria(i+1) = bateria(i);
                % podlaczamy ladowarkê i pracuje dalej
                PODLACZONY = 1;
            end
            % ustawiamy LED informuj¹cego o poziomie baterii
            BATERIA_LED = stan_baterii(bateria(i), BATERIA_LED_GRANICA_ZOLTY, BATERIA_LED_GRANICA_CZERWONY);
            % idziemy dalej
            if (bateria(i) > 10)
                bateria(i+1) = ruch_ziemia(bateria(i), SREDNICA);
            else
                bateria(i+1) = bateria(i);
                % podlaczamy ladowarkê i pracuje dalej
                PODLACZONY = 1;
            end
            % ustawiamy LED informuj¹cego o poziomie baterii
            BATERIA_LED = stan_baterii(bateria(i), BATERIA_LED_GRANICA_ZOLTY, BATERIA_LED_GRANICA_CZERWONY);
            % ³adowanie baterii
            if (PODLACZONY == 1)
                bateria(i+1) = bateria(i) + 2;
                if(bateria(i+1) > 100)
                    bateria(i+1) = 100;
                    %odlaczamy ³adowanie dla dobra baterii
                    PODLACZONY = 0;
                end
            end
            %informacja do wykresu
            bateria_wyk(i+1) = bateria(i+1);
        end
        % saturacja wykresów
        wgniecenie = saturate(wgniecenie);
        rdza = saturate(rdza);
        % wizualizacje
        figure(1);
        subplot(2,2,1); hold on;
        set(gca, 'XLim', [0 DLUGOSC], 'YLim', [0 110]);
        title('bateria %');
        xlabel('dlugosc rury [cm]');
        subplot(2,2,2);
        wg_anim = animatedline('Color', 'black');
        set(gca, 'XLim', [0 DLUGOSC], 'YLim', [-0.5 1.5]);
        title('wgniecenia');
        xlabel('dlugosc rury [cm]');
        subplot(2,2,3);
        rdza_anim = animatedline('Color', '#D95319');
        set(gca, 'XLim', [0 DLUGOSC], 'YLim', [-0.5 1.5]);
        title('rdza');
        xlabel('dlugosc rury [cm]');
        subplot(2,2,4);
        prz_anim = animatedline('Color', 'blue');
        set(gca, 'XLim', [0 DLUGOSC], 'YLim', [-0.5 1.5]);
        title('przecieki');
        xlabel('dlugosc rury [cm]');
        for i=1:DLUGOSC
            subplot(2,2,1);
            if(bateria_wyk(i) > BATERIA_LED_GRANICA_ZOLTY)
                plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'green')
            elseif(bateria_wyk(i) > BATERIA_LED_GRANICA_CZERWONY)
                plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'yellow')
            else
                plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'red')
            end
            addpoints(bat_anim, i, bateria_wyk(i))
            subplot(2,2,2);
            addpoints(wg_anim, i, wgniecenie(i));
            subplot(2,2,3)
            addpoints(rdza_anim, i, rdza(i));
            subplot(2,2,4);
            addpoints(prz_anim, i, przeciek(i));
            drawnow;
        end
    otherwise
end
