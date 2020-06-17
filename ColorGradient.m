%taken from internet, creates gradient between two colors

% % ORIGINAL
% % create a default color map ranging from red to light pink
% length = 5;
% red = [1, 0, 0];
% pink = [255, 192, 203]/255;
% colors_p = [linspace(red(1),pink(1),length)', linspace(red(2),pink(2),length)', linspace(red(3),pink(3),length)'];

% ADAPTED
% create a default color map ranging from red to light pink
length = 4;
c1 = [255   0 255]./255;
c2 = [ 0 255 255]./255;
colors = [linspace(c1(1),c2(1),length)', linspace(c1(2),c2(2),length)', linspace(c1(3),c2(3),length)']

figure(1)

for i= 1:length
    x=[i (1+i)];
    y=[i (1+i)];
    p=plot(x,y);
    p.LineWidth=15;
    p.Color=colors(i,:);
    p.DisplayName=['Color ' num2str(i)];
    
    hold on
    
end

set(gca, 'YLim', [1,max(y)]);
set(gca, 'XLim', [1,max(y)]);
legend show;
legend('Location','northwest');