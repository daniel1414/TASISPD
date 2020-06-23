function [wgniecenie, rdza, przeciek, bateria] = skan_ziemia(poprz_wg, poprz_rdza, poprz_bateria, SREDNICA)
    % wgniecenie    
    r_w = rand();
    if (poprz_wg == 0 && r_w > 0.98)
        wgniecenie = 1;
    elseif (poprz_wg > 0)
        if(r_w > poprz_wg / 20)
            wgniecenie = poprz_wg + 1;
        else
            wgniecenie = 0;
        end
    else
        wgniecenie = 0;
    end
    % rdza
    r_r = rand();
    if(poprz_rdza == 0 && r_r > 0.99)
        rdza = 1;
    elseif (poprz_rdza > 0)
        if(r_r > poprz_rdza / 3000)
            rdza = poprz_rdza + 1;
        else
            rdza = 0;
        end
    else
        rdza = 0;
    end
    % przeciek
    r_p = rand();
    if (r_p > 0.99 || (r_p > 0.8 && wgniecenie))
        przeciek = 1;
    else
        przeciek = 0;
    end
    % straty energii
    bateria = poprz_bateria - SREDNICA*0.05;
end