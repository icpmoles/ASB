time = 10;

tr = zeros(1,10);

for i = 0.1:0.5:20
    l = length(tr);
    for k = 1:time
        tr(l+k) = i;
    end
end