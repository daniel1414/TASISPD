close all;
bateria = BATERIA_MAX;
bateria_wyk = bateria;
porosty = zeros(1, DLUGOSC); % porosty powoduj¹ rdze, wykryte mog¹ byæ usuniete
rdza = zeros(1, DLUGOSC); % rdza przecieki
przeciek = zeros(1, DLUGOSC);
for i=1:DLUGOSC %dlugosc to glebokosc
    if(bateria(i) > 20+mod(i,20))
        [porosty(i+1), rdza(i+1), przeciek(i+1), bateria(i)] = skan_woda(porosty(i), rdza(i), bateria(i), i);
    end
    % idziemy dalej
    if (bateria(i) > 20+mod(i,20))
        bateria(i+1) = ruch_woda(bateria(i), i); 
    else
        bateria(i+1) = bateria(i)-mod(DLUGOSC,20);
        % idzie do ladowarki pod³¹cza przewód i pracuje dalej
        PODLACZONY = 1;
        PODLACZONY_t(i) = PODLACZONY;

    end
    % ustawiamy LED informuj¹cego o poziomie baterii
    BATERIA_LED = stan_baterii(bateria(i), BATERIA_LED_GRANICA_ZOLTY, BATERIA_LED_GRANICA_CZERWONY);
    % ³adowanie baterii
    if (PODLACZONY == 1)
        bateria(i+1) = bateria(i) + 8-(i/DLUGOSC)*4;
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
% rdza = saturate(rdza);
% wizualizacje
figure(1);
subplot(2,2,1); hold on;
set(gca, 'XLim', [0 DLUGOSC], 'YLim', [0 110]);
title('bateria %');
xlabel('glebokosc rury [cm]');
% plot(1:499, PODLACZONY_t*10, 'Color', 'blue');
subplot(2,2,2);
wg_anim = animatedline('Color', 'black');
set(gca, 'XLim', [0 DLUGOSC]);
% , 'YLim', [-0.5 1.5]
title('porosty');
xlabel('glebokosc rury [cm]');
subplot(2,2,3);
rdza_anim = animatedline('Color', '#D95319');
set(gca, 'XLim', [0 DLUGOSC], 'YLim', [-0.5 1.5]);
title('rdza');
xlabel('glebokosc rury [cm]');
subplot(2,2,4);
prz_anim = animatedline('Color', 'blue');
set(gca, 'XLim', [0 DLUGOSC], 'YLim', [-0.5 1.5]);
title('przecieki');
xlabel('dlugosc rury [cm]');
for i=1:DLUGOSC
    subplot(2,2,1);
    hold on;
    
    if(bateria_wyk(i) > BATERIA_LED_GRANICA_ZOLTY)
        plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'green')
    elseif(bateria_wyk(i) > BATERIA_LED_GRANICA_CZERWONY)
        plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'yellow')
    else
        plot([i, i+1], [bateria(i), bateria(i+1)], 'Color', 'red')
    end
    
    hold off;
%             addpoints(bat_anim, i, bateria_wyk(i))
    subplot(2,2,2);
    addpoints(wg_anim, i, porosty(i));
    subplot(2,2,3)
    addpoints(rdza_anim, i, rdza(i));
    subplot(2,2,4);
    addpoints(prz_anim, i, przeciek(i));
    drawnow;
end