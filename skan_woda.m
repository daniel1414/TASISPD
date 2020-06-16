%Kopia tej drugiej
function [porosty, rdza, przeciek, bateria] = skan_woda(poprz_wg, poprz_rdza, poprz_bateria, glebokosc)
    % porosty    
    r_w = rand();
    if (poprz_wg == 0 && r_w > 0.94)
        porosty = 1;
    elseif (poprz_wg > 0 && r_w > 0.10)
            if(poprz_wg<35*r_w)
                porosty = poprz_wg*log(poprz_wg*4.5);
            else
                porosty = poprz_wg/log(poprz_wg*12);
                if(porosty<1) 
                    porosty = 0;
                end
            end
        else
        porosty = 0;
    end

    % rdza
    r_r = rand();
    rdza = 0;
    if(porosty == 0 && r_r > 0.99)
        rdza = 1;
    end
    if(porosty > 5 && r_r > 0.85)
        rdza = 1;
    end
    if(porosty > 11 && r_r > 0.60)
        rdza = 1;  
    end
    if(porosty > 22 && r_r > 0.40)
        rdza = 1;
    end
    % przeciek
    r_p = rand();
    przeciek = 0;
    if (rdza == 1 && r_p > 0.75)
        przeciek = 1;
    end
    if (rdza == 1 && poprz_rdza == 1 && r_p > 0.45)
        przeciek = 1;
    end
    % straty energii
    if(przeciek == 1)
    	bateria = poprz_bateria - glebokosc*0.1;
    else
        bateria = poprz_bateria - glebokosc*0.02; 
    end
    
end