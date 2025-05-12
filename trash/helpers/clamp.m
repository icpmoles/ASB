function [output] = clamp(val,bound)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 output = max(min(bound,val),-bound);
end

