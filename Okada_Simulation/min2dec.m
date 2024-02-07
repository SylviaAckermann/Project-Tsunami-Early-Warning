function [output] = min2dec(a,b,c)
%UNTITLED Summary of this function goes here
%   input: Latitude or Longitude in degrees and minutes
%          e.g. 48°56'57"N as a = 48, b = 56, c = 57
%   output: Latitude or Longitude in decimals e.g. 48.9492
output = a + b*1/60 + c*1/(60^2);
end