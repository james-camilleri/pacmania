import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

class Pacman extends Agent {
  Ghost[] ghosts;
  
  Pacman(Grid _grid, CellIndex start, Ghost[] _ghosts) {
    super(_grid, start);
    super.canVisit = true;
    super.drawPath = true;
    ghosts = _ghosts;
  }
  
  private boolean cellHasGhost(CellIndex cell) {
    for (int i = 0; i < ghosts.length; i++) {
      PVector position = ghosts[i].position;
      
      if (
        abs(cell.x * cellSize - position.x) < cellSize && 
        abs(cell.y * cellSize - position.y) < cellSize && 
        abs(cell.z * cellSize - position.z) < cellSize
       ) {
        return true;
      }
    }
    
    return false;
  }
  
  private CellIndex getGhostFreeCell(CellIndex currentCell) {
    ArrayList<CellIndex> adjacentCells = grid.getAdjacentCells(currentCell);
    CellIndex nearestFreeCell = adjacentCells.remove(0);
    
    //A ghost!
    //https://media.giphy.com/media/eJMFU5vwuicHspZERF/giphy.gif
    while(cellHasGhost(nearestFreeCell) && adjacentCells.size() > 0) {
      nearestFreeCell = adjacentCells.remove(0);
    }
    
    // If all possible targets have ghosts in them, stay put.
    if (cellHasGhost(nearestFreeCell)) {
      nearestFreeCell = currentCell;
    }
    
    return nearestFreeCell;
  }
  
  protected void updateTarget() {
    CellIndex lastTarget = target;
    
    ArrayList<CellIndex> targetCells = grid.getAdjacentCells(lastTarget);
    ArrayList<CellIndex> unvisitedTargetCells = (ArrayList<CellIndex>)targetCells.clone();
    unvisitedTargetCells.removeIf(cell -> grid.cells[cell.x][cell.y][cell.z].visited);
    
    if (unvisitedTargetCells.size() > 0) {
      route = null;
      CellIndex nextTarget = unvisitedTargetCells.get(int(random(unvisitedTargetCells.size())));
      
      if (cellHasGhost(nextTarget)) {
        nextTarget = getGhostFreeCell(lastTarget);
      }
      
      setTarget(nextTarget);
      return;
    }
    
    // If there's no route, create a new one to the nearest unvisted cell.
    if (route == null) {
      CellIndex end = findClosestUnvistedCell(lastTarget);
      route = grid.getPathBetweenCells(lastTarget, end);
    }
    
    // Follow the current route.
    CellIndex nextTarget = route.peekLast();
    
    if (cellHasGhost(nextTarget)) {
      nextTarget = getGhostFreeCell(lastTarget);
      route = null;
    } else {
      route.removeLast();
      
      if (route.size() == 0) {
        route = null;
      }
    }
    
    setTarget(nextTarget);
  }
  
  protected void drawPath() {
    colorMode(HSB);
    paths.forEach((path, count) -> {
      stroke(count * 10, 255, 255);
      strokeWeight(3);
      line(
        path.start.x * cellSize,
        path.start.y * cellSize,
        path.start.z * cellSize,
        path.end.x * cellSize,
        path.end.y * cellSize,
        path.end.z * cellSize
       );
      strokeWeight(1);
    });
    colorMode(RGB);
  }
  
  protected void drawAgent() {
    fill(255, 255, 0, 255);
    noStroke();
    sphere(cellSize / 4);
  }
}
