% Name  : A function to inject label noise
% Author: Jakramate Bootkrajang
% Input : y           = true label {1,...n} representation
%         targetClass = {0,1,2....} s.t. 0 is symmetric NoiseRateing
%         NoiseRate   = (0,1)
% Output: yz          = noisy label  {1,...n} representation
%         fp          = flip indicator vector


function [yz, fd] = injectLabelNoise(y, g)

y   = castLabel(y,2);
CLS = length(unique(y));
fd  =  ones(size(y))*-1;
yz  = y;

% sampling some numbers
for i=1:CLS
    for j=1:CLS
        prob    = rand(size(y));    
        idx     = find((y==i) & (prob <= g(i,j)));
        yz(idx) = j;
        fd(idx) = fd(idx) * -1;
    end
end




