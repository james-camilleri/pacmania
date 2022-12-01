import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

class Ghost extends Agent {
  Ghost(Grid _grid, CellIndex start) {
    super(_grid, start);
    speed = 3;
  }
  
  protected void updateTarget() {
    CellIndex lastTarget = target;
    
    ArrayList<CellIndex> targetCells = grid.getAdjacentCells(lastTarget);
    
    // Prefer maintaining the current direction.
    // If that's not possible, pick a direction at random.
    if (currentDirection != null && random(1) > 0.5) {
      Optional<CellIndex> sameDirectionCell = grid.getAdjacentCell(lastTarget, currentDirection);
      
      if (sameDirectionCell.isPresent()) {
        setTarget(sameDirectionCell.get());
        return;
      }
    }
    
    setTarget(targetCells.get(int(random(targetCells.size()))));
  }
  
  protected void drawAgent() {
    fill(255, 30, 30, 255);
    noStroke();
    sphere(cellSize / 4);
  }
}
