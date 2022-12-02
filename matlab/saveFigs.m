FolderName = './figs';   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = FigHandle.Number;
  s=sprintf('./figs/fig%d.jpg', FigName);
  saveas(FigHandle, s);
end
