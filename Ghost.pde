import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

class Ghost extends Agent {
  float hue = random(150, 255);
  
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
    noStroke();
    
    colorMode(HSB);
    for (int i = 0; i < 50; i++) {
      fill(hue * random(0.9, 1.2), 200, 200, 50);
      
      pushMatrix();
      rotateX(random(TWO_PI));
      rotateY(random(TWO_PI));
      rotateZ(random(TWO_PI));
      translate(random( -(cellSize / 5),(cellSize / 5)), 0, 0);
      sphere(cellSize / 30);
      popMatrix();
    }
    colorMode(RGB);
  }
  
  protected void updateVisitedCellColour() {
    grid.cells[target.x][target.y][target.z].updateColour(hue, 5);
  }
}
