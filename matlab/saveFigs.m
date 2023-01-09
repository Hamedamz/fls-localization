function saveFigs(N, map)
FolderName = './figs';   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = FigHandle.Number;
  s=sprintf('./figs/fig%d-%d-%s.jpg', N, FigName, map(FigName));
  saveas(FigHandle, s);
end

end

