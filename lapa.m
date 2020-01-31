gridSize = input('Please enter a grid size (length of rows and columns): ');
BCcase = input('Select case 1 or case 2: ');

grid = zeros(gridSize);
x = linspace(1,gridSize,gridSize);
x = meshgrid(x);
y = linspace(1,gridSize,gridSize);
y = meshgrid(y);
y = transpose(y);

if(BCcase==1)
    grid(:,1) = 1;
elseif(BCcase==2)
    grid(:,1) = 1;
    grid(:,gridSize) = 1;
end

f1 = figure(1);
movegui(f1,'west')
surf(x,y,grid)
pause(0.01)

f2 = figure(2);
movegui(f2,'east')

satisfied = 0;
maxIter = 1000000;
iter = 0;

tempGrid = grid;
lastNorm = gridSize - 1;

while(satisfied==0)
    iter = iter + 1;
    TmnP1 = circshift(grid,[0 -1]);
    TmM1n = circshift(grid,[1 0]);
    TmnM1 = circshift(grid,[0 1]);
    TmP1n = circshift(grid,[-1 0]);
    
    %E Field
    [eFieldX,eFieldY] = gradient(grid);
    figure(2)
    quiver(x,y,-eFieldX,-eFieldY);
    
    
    tempGrid(2:lastNorm,2:lastNorm) = (1/4)*(TmnP1(2:lastNorm,2:lastNorm) + TmM1n(2:lastNorm,2:lastNorm) + TmnM1(2:lastNorm,2:lastNorm) + TmP1n(2:lastNorm,2:lastNorm));
    
    if(BCcase==1)
        tempGrid(2:lastNorm,1) = (1/3)*(TmnP1(2:lastNorm,1) + TmM1n(2:lastNorm,1) + TmP1n(2:lastNorm,1));
        tempGrid(2:lastNorm,gridSize) = (1/3)*(TmM1n(2:lastNorm,gridSize) + TmnM1(2:lastNorm,gridSize) + TmP1n(2:lastNorm,gridSize));
        tempGrid(1,2:lastNorm) = (1/3)*(TmnP1(1,2:lastNorm) + TmP1n(1,2:lastNorm) + TmnM1(1,2:lastNorm));
        tempGrid(gridSize,2:lastNorm) = (1/3)*(TmnP1(gridSize,2:lastNorm) + TmM1n(gridSize,2:lastNorm) + TmnM1(gridSize,2:lastNorm));
        tempGrid(:,1) = 1;
        tempGrid(:,gridSize) = 0;
    elseif(BCcase==2)
        tempGrid(:,1) = 1;
        tempGrid(:,gridSize) = 1;
        tempGrid(1,2:lastNorm) = 0;
        tempGrid(gridSize,2:lastNorm) = 0;
    end
    
    delta = tempGrid - grid;
    check = max(max(delta));
    
    
    if(check == 0)
        satisfied = 1;
    elseif(iter == maxIter)
        satisfied = 1;
    end
    
    grid = tempGrid;
    figure(1)
    surf(x,y,grid)
    pause(0.01)      
end