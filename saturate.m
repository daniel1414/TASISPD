function [out] = saturate(org)
out = zeros(size(org));
    for i=1:size(org, 2)
        if(org(i) > 0)
            out(i) = 1;
        elseif(org(i) == 0)
            out(i) = 0;
        end
    end
end