function plotResults(A, B, fig, T)
figure(fig)

% yFrozen = data(1,:);
% yMoved = data(2,:);
% yAvgDist = data(3,:);
% yMaxDist = data(4,:);
% yH = data(5,:);
% yAvgConf = data(6,:);

x=1:size(A,2);

extraInputs = {'interpreter','latex','fontsize',18};

AxesH = axes('Xlim', [1,size(A,2)], 'XTick', 1:1:size(A,2), 'NextPlot', 'add');

%t = title('ICL, ICF, Simple Comparison');
t=title(T);
%xlabel('Point Cloud ID',extraInputs{:})
%ylabel('Execution Time (Seconds)',extraInputs{:})
xlabel('',extraInputs{:})
ylabel('',extraInputs{:})

lgd = legend;
lgd.FontSize = 14;

%{
y = ylabel('Total Flight Distance (Cells)');
vf = 1.125; % vertical factor. Adjust manually
dy = .55; % horizontal offset. Adjust manually
tpos = get(t, 'Position');
theight = tpos(2);
ypos = get(t, 'Position');
set(y, 'Position', [ypos(1)+dy tpos(2)*1.02 ypos(3)], 'Rotation', 0)
%}

extraInputs = {'Helvetica','latex','fontsize',18};

grid on;

%{
plot(x,yICF,'-bo','LineWidth', 2.5,'DisplayName','ICF')
hold on 
plot(x,yICL,'--mx','LineWidth', 2.5,'DisplayName','ICL')
hold on 
%plot(x,simple,'--cx') 
%}

plot(x,A,'-b+','LineWidth', 2.5,'DisplayName','A')
hold on 
plot(x,B,'--mx','LineWidth', 2.5,'DisplayName','B')
% hold on 
% plot(x,yAvgDist,'--ko','LineWidth', 2.5,'DisplayName','AvgDist') 
hold off



end