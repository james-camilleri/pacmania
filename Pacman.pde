import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

class Pacman extends Agent {
  Pacman(Grid _grid, CellIndex start) {
    super(_grid, start);
    super.canVisit = true;
    super.drawPath = true;
  }
  
  protected void updateTarget() {
    CellIndex lastTarget = target;
    
    ArrayList<CellIndex> targetCells = grid.getAdjacentCells(lastTarget);
    ArrayList<CellIndex> unvisitedTargetCells = (ArrayList<CellIndex>)targetCells.clone();
    unvisitedTargetCells.removeIf(cell -> grid.cells[cell.x][cell.y][cell.z].visited);
    
    if (unvisitedTargetCells.size() > 0) {
      setTarget(unvisitedTargetCells.get(int(random(unvisitedTargetCells.size()))));
      route = null;
      return;
    }
    
    // If there are no adjacent cells and we're already on a fixed route, follow that route.
    if (route != null) {
      setTarget(route.removeLast());
      if (route.size() == 0) {
        route = null;
      }
      
      return;
    }
    
    // If there's no route, create a new one to the nearest unvisted cell.
    CellIndex end = findClosestUnvistedCell(lastTarget);
    route = grid.getPathBetweenCells(lastTarget, end);
    setTarget(route.removeLast());
  }
  
  protected void drawAgent() {
    fill(255, 255, 0, 255);
    noStroke();
    sphere(cellSize / 4);
  }
}
