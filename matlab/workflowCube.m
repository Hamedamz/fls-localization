addpath cli/;

confidenceType = Prompt("Select confidence method:", {"Signal Strength", "Confidence M", "Confidence X", "Random"}, 2).getUserInput();
weightType = confidenceType;
clear = 1;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration", "Hybrid", "DistAngle", "DistAngleAvg", "LoGlo"}, 4).getUserInput();
distType = 1;
addAngleError = -Prompt("Add error to angle estimation?", {"Yes", "No"}, 2).getUserInput() + 2;
freezePolicy = Prompt("When to freeze an FLS?", {"Don't freeze", "After each movement", "When it wants to move with a zero vector"}, 2).getUserInput();
swarmEnabled = -Prompt("Enable swarm?", {"Yes", "No"}, 1).getUserInput() + 2;
if swarmEnabled
    swarmPolicy = Prompt("How should a swarm move?", {"Only one FLS in a swarm may move in a round", "Each swarm member moves using the first recieved vector"}, 1).getUserInput();
else
    swarmPolicy = 0;
end
concurrentPolicy = Prompt("Which neighbors should remain stationay when an FLS is localizing?", {"All el neighbors", "Only the most confident neighbor"}, 1).getUserInput();

removeAlpha = 0;
alpha = 5;
angleError = 0;

crm = Prompt("Adjust communication range?", {"Yes", "No"}, 2).getUserInput();

if crm == 1
    crm = Prompt("Input the multiplier for communication range?", {}, 1).getDirectInput();
    crm = str2double(crm);
else
    crm = 0;
end


fixN = Prompt("Assign k nearest neighbors?", {"Yes", "No"}, 1).getUserInput();

if fixN == 1
    fixN = Prompt("Input the minimum number of neighbors?", {}, 1).getDirectInput();
    fixN = str2double(fixN);
else
    fixN = 0;
end


meregeAER = 1;
breakSwarms = 1;
t = 5;
rounds = 100;
regular = 1;

flsCubes = {};
flsSwarms = {};
plt = zeros(27, rounds);
maxR = 0;

% CF = cpab10;
fixN = 7;
physical = 0;


for N=1:1
if regular
%     p = pngToPtcld("./assets/teapot.png");
    switch N
        case 1
        p = readPtcld("./assets/PointClouds/pt1609.454.ptcld", -1);
        case 2
            p = readPtcld("./assets/PointClouds/pt1608.758.ptcld", -1);
        case 3
            p = readPtcld("./assets/PointClouds/pt1625.760.ptcld", -1);
        case 4
            p = readPtcld("./assets/PointClouds/pt1620.997.ptcld", -1);
        case 5
            p = readPtcld("./assets/PointClouds/pt1617.1197.ptcld", -1);
        case 6
            p = readPtcld("./assets/PointClouds/pt1630.1562.ptcld", -1);
        case 7
            p = readPtcld("./assets/PointClouds/pt1619.1727.ptcld", -1);
    end
    OT = OcTree(p.', 'minSize', 0, 'binCapacity', 150, 'style', 'weighted');
    cubeCount = OT.BinCount;
else
    cubeCount = size(CF{1}.cubes,2);
end

% dispatch cubes
numCubes = 0;
cubeSizes = [];
for i=1:cubeCount
    if regular
        p = OT.Points(find(OT.PointBins==i),:);
        p = p.';
        if size(p,2) == 0
            continue;
        end
        numCubes = numCubes + 1;
        cubeSizes(numCubes) = size(p,2);
    else
        points = [CF{1}.vertexList{CF{1}.cubes(i).assignedVertices}];
        if size(points,2) == 0
            continue;
        end
        numCubes = numCubes + 1;
        n = CF{1}.cubes(i).numVertices;
        p = zeros(3,n);
        for j=1:n
            p(1,j) = points(j*7-6);
            p(2,j) = points(j*7-5);
            p(3,j) = points(j*7-4);
        end
    end

    [flss] = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, p, physical, 0, removeAlpha, concurrentPolicy, crm, fixN, i-1);
    flsCubes{numCubes} = flss;
end

terminateCube = zeros(length(flsCubes));

allFlss = [flsCubes{:}];


h = plotScreen([allFlss.el], 'red', N);
gifName = sprintf('gif/relicCube%d.gif', N);

for j=1:t
    
    for q=1:rounds
        for i=1:numCubes
            cube = flsCubes{i};
            if isempty(cube)
                continue;
            end
            if ~terminateCube(i)
                terminate = relicNRound(cube, 1, N, j, i); % experiment, try, cube
                terminateCube(i) = terminate;
            end
        end

        updateScreen(h, [allFlss.el]);
        exportgraphics(gcf,gifName,'Append',true);
    end
    

    for i=1:numCubes
        flsSwarms{i} = {};

        % put flss of the cube in one swarm
        for k=1:length(cube)
            flsSwarms{i}{k} = cube(k).swarm.members;
            cube(1).swarm.addMember(cube(k));
            cube(k).swarm.addMember(cube(1));
        end
    end
    

    main3(allFlss, 100, j);

    for i=1:numCubes
        cube = flsCubes{i};
        for k=1:length(cube)
            if breakSwarms
                cube(k).swarm.members = [];
            else
                cube(k).swarm.members = flsSwarms{i}{k};
            end
        end
    end
end

txt=sprintf("num cubes: %d\ncapcity: %d (min:%d avg:%.1f max:%d)\n", numCubes, ceil(OT.Properties.binCapacity), max(cubeSizes), mean(cubeSizes), min(cubeSizes));

annotation('textbox',[.0 .7 .3 .3],'String',txt,'EdgeColor','none');

saveFigs(N);
end