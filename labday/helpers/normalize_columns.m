function [normatr] = normalize_columns(matr)
%NORMALIZE_COLUMNS Summary of this function goes here
%   Detailed explanation goes here
if size(matr,1) == size(matr,2)
    normatr = zeros(size(matr,1),size(matr,1));
    for c = 1:size(matr,1)
        n = norm(matr(:,c));
        normatr(:,c) = matr(:,c)/n;
    end

else
    errorf("Matrix is not squared")
end
end

