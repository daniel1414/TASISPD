function [bateria] = ruch_woda(poprz_bateria, glebokosc)
    bateria = poprz_bateria - glebokosc * 0.005;
end