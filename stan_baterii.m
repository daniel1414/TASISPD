function [stan] = stan_baterii(bateria, zolty_granica, czerwony_granica)
    if (bateria < zolty_granica)
        stan = 1;
    elseif (bateria < czerwony_granica)
        stan = 2;
    else
        stan = 0;
    end
end