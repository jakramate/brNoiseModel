function ret = posteriorYHat(x, w, gamma, varargin)

if nargin < 5
    w_type = size(w, 2);
    
    if (w_type == 1)
        prob = sigmoid(x * w);
        prob = [1-prob  prob]';
        ret  = gamma' * prob  ;
    else
        ret  = softmax(x * w) * gamma;
    end
    
else
    g12 = varargin{1};
    g21 = varargin{2};
    
    prob = sigmoid(x * w);
    prob = [1-prob prob]';
    
    for i=1:size(x,1)
        gamma = [1-g12(i) g12(i);g21(i) 1-g21(i)];
        ret(:,i) = gamma' * prob(:,i);
    end
    
    
end


