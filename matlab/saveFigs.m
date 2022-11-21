FolderName = './figs';   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  s=sprintf('./figs/fig%d.jpg', iFig);
  saveas(FigHandle, s);
end

% https://docs.google.com/presentation/d/16SekQjgqeR-YO95KRU49CXiBvl7aWfwLhwe1GV46iR4/edit?usp=sharing