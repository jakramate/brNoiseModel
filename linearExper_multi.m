% =========================================================================
% A wrapper experiment script for the bayesian robust Logistic Regression algorithm
% =========================================================================

% start with nice & clean workspace
clear
close all

rng(204,'twister'); % fixing the random seed


ITER      = 10;      % Inner loop, corresponds to experiment repetitions
EXP_RANGE = 1:3;     % Outer loop, corresponds to variation of data characteristics


es_mlr   = zeros(length(EXP_RANGE),ITER);
es_rmlr  = es_mlr;
es_brmlr = es_mlr;

md_rmlr  = es_mlr;   % for storing matrix distances
md_brmlr = es_mlr;

for i=1:length(EXP_RANGE)
    
    [x, y, ff, xx, tt, dd] = genData(3*EXP_RANGE(i), 10, 700, 10, 1.5,'gen');
    
    
    % data preprocessing
    [DPnt, DIM] = size(x);
    TrPnt       = floor(0.9*DPnt);  % less data seems problematic for rlr
    CLS         = length(unique(y));
    [x, ~]      = standardise(x,x);
    
    if ~isempty(intersect(0, unique(y)))
        y = y + 1;
    end
    
    for j = 1:ITER
        
        perm = randperm(DPnt);
        tr = perm(1:TrPnt);
        ts = perm(TrPnt+1:end);
        
        Xt = x(tr,:);   % training set
        Xs = x(ts,:);   % test set
        yt = y(tr,:);   % training labels
        ys = y(ts,:);   % test labels
        
        
        % adding label noise
        tg = randn(CLS,CLS);
        tg(tg<0) = 0;
        tg = tg + eye(CLS)*((3+CLS)/(10+CLS))*CLS;
        tg = tg./repmat(sum(tg,2),1,CLS);  % inject some noise
        
        fprintf('average noise rate %.2f\n', (CLS-sum(diag(tg)))/CLS);
        
        [yz, fdz] = injectLabelNoise(yt, tg);
        
        winit = randn(DIM+1,CLS)*1e-3; % for mlr
        g = ones(CLS) + eye(CLS)*50;
        g = g./repmat(sum(g,2),1,CLS);
        
        
        % mlr
        options.maxIter = 100;
        options.estG = false;
        options.breg = false;
        options.regFunc = 'noreg';
        options.verbose = false;
        [w, ~, ~] = rmlr(winit, eye(CLS), addbias(Xt), yz, options);
        [~, ~, es_mlr(i,j)] = evalmLR(addbias(Xs), ys, w, g, false);
        
        
        % rmlr
        options.estG = true;
        options.breg = false;
        options.regFunc = 'noreg';
        options.verbose = false;
        [w, g2, llh2] = rmlr(winit, g, addbias(Xt), yz, options);
        [~, ~, es_rmlr(i,j)] = evalmLR(addbias(Xs), ys, w, g2, false);
        
        md_rmlr(i,j) = matrixdiff(g2,tg);  % measure matrix distance sum.sum.abs(-)
        
        % Bayesian rmlr
        options.estG = true;
        options.breg = true;
        options.regFunc = 'noreg';
        options.verbose = false;
        [w, g3, llh3] = rmlr(winit, g, addbias(Xt), yz, options);
        [~, ~, es_brmlr(i,j)] = evalmLR(addbias(Xs), ys, w, g3, false);
        
        md_brmlr(i,j) = matrixdiff(g3,tg);
        
        fprintf('mlr %.4f, rmlr %.4f, brmlr %.4f\n', es_mlr(i,j), es_rmlr(i,j), es_brmlr(i,j));
        
    end
    
    fprintf('[mean] mlr %.4f, rmlr %.4f, brmlr %.4f\n', mean(es_mlr(i,:)), mean(es_rmlr(i,:)), mean(es_brmlr(i,:)));
    
    
end


% % saving graphs and results
% filename = 'vary_k_nr20.mat';
% figname = 'vary_k_nr20';
% figtitle = '# dimension=10, # instances=700, # epochs=100, Noise=20%';
% figxlabel = 'Data Classes (K)';
%
% % saving data
% save(filename);  % saving raw data
figtitle= 'brlr';
figxlabel='data';
% generating 3 models graphs
graphFactory('mean', ITER, 3*EXP_RANGE, figtitle, figxlabel,'Generalisation Error (%)','',...
    es_mlr'.*100,'LR',...
    es_rmlr'.*100,'rLR',...
    es_brmlr'.*100,'brLR');
%saveas(gcf, figname, 'epsc');  % saving figure

close;
% plotting matrix distances
bar([mean(md_rmlr,2) mean(md_brmlr, 2)]);
hLegend = legend('rLR','brLR', 'location','best');
hXLabel = xlabel(figxlabel); xticklabels(3*EXP_RANGE);
hYLabel = ylabel('$\sum_{jk}|\omega_{jk}-\hat{\omega}_{jk}|$','interpreter','latex');
set( gca                       , ...
    'FontName'   , 'Helvetica' , ...
    'Fontsize'   , 20          );
set([hXLabel, hYLabel] , ...
    'FontName'   , 'Helvetica');
set(hLegend                    , ...
    'FontSize'   , 20          );
set([hXLabel, hYLabel]         , ...
    'FontSize'   , 20          );
%saveas(gcf, strcat(figname,'md'), 'epsc');
