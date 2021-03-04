function [] = graphFactory(METHOD, ITER, EXP_RANGE, TITLE, XLABEL, YLABEL, XTICKL, varargin)

%if (ITER == 1)
%    error('Please run at least 2 repetitions');
%end

% fire up a blank canvas
figure('position',[0 0 800 600]); hold on;
% plot error bar, without any athestics
x = EXP_RANGE;

for k = 1:2:size(varargin,2)    
    i     = mod(k,2) + floor(k/2);
    err   = varargin{k};    
    if strcmp(METHOD,'mean')
        hE(i) = errorbar(x, mean(err(1:ITER,:)), std(err(1:ITER,:))/sqrt(ITER))  ;    
    else
        %hE(i) = errorbar(x, median(err(1:ITER,:)), std(err(1:ITER,:)))  ;            
        hE(i) = plot(x,err(1:ITER,:));
    end
    
    set(hE(i)                                , ...
        'LineStyle'       , style(i)         , ...
        'LineWidth'       , 3.5              , ...
        'Color'           , getcolor(i)      , ...
        'Marker'          , marker(i)        , ...
        'MarkerSize'      , 15                , ...
        'MarkerEdgeColor' , getcolor(i)      , ...
        'MarkerFaceColor' , [ 1  1  1]  )    ;
    
    modelName{i} = varargin{k+1};
    

    
end

% add legend and labels
hTitle  = title (TITLE);
hXLabel = xlabel(XLABEL);
hYLabel = ylabel(YLABEL);

% add legend
hLegend = legend(hE, modelName, 'location', 'Best');

% adjust font and tick properties
set( gca                       , ...
    'FontName'   , 'Helvetica' , ...
    'Fontsize'   , 20          );
set([hTitle, hXLabel, hYLabel] , ...
    'FontName'   , 'Helvetica');
set(hLegend                    , ...
    'FontSize'   , 20          );
set([hXLabel, hYLabel]         , ...
    'FontSize'   , 20          );
set( hTitle                    , ...
    'FontSize'   , 20          , ...
    'FontWeight' , 'bold'      );

% set(gca, ...
%   'Box'         , 'off'     , ...
%   'TickDir'     , 'out'     , ...
%   'TickLength'  , [.02 .02] , ...
%   'XMinorTick'  , 'off'      , ...
%   'YMinorTick'  , 'on'      , ...
%   'YGrid'       , 'on'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'YTick'       , 0:0.1:0.5   , ...
%   'XTick'       , 1:length(XTICKL), ...
%   'LineWidth'   , 2.0       , ...
%   'xTickLabel'  , XTICKL);
  %'xTick'       , [0.5 0.8 1 3 5]);
  

% this gives more control compared to 'axis tight'
%xlim([min(x) max(x)]);
%ylim([0 0.5]);
axis tight;

function ret = getcolor(i)
switch i 
    case 1
        ret = colorPalette('RoyalBlue');
    case 2
        ret = colorPalette('Crimson');
        
    case 3
        ret = colorPalette('Green');
    case 4
        ret = colorPalette('Black'); 
        
    case 5
        ret = colorPalette('DarkOrange');
    case 6
        ret = colorPalette('DimGrey');
    otherwise
        ret = colorPalette('Amethyst');
end

function ret = style(i)
switch i 
    case 1
        ret = '-.';
    case 2
        ret = '--';
    case 3
        ret = '-';
    case 4
        ret = '-.';
    case 5
        ret = '--';     
    case 6
        ret = '-.';
    otherwise
        ret = '--';
end

function ret = marker(i)
switch i 
    case 1
        ret = 'hexagram';
    case 2
        ret = '^';
    case 3
        ret = 's';
    case 4
        ret = 'v';
    case 5
        ret = 'd';  
    case 6
        ret = '*';
    otherwise
        ret = 's';
end
