import java.util.Map;
import java.util.HashMap;

final float SPEED = 5;

class Pacman {
  Grid grid;
  int cellSize;
  PVector position;
  CellIndex target;
  Direction currentDirection;
  Map<PathSegment, Integer> paths;
  
  Pacman(Grid _grid, CellIndex start) {
    grid = _grid;
    cellSize = grid.scale;
    paths = new HashMap<PathSegment, Integer>();
    position = new PVector((float) start.x,(float) start.y,(float) start.z);
    target = start;
    grid.cells[target.x][target.y][target.z].visit();
  }
  
  private void setTarget(CellIndex newTarget) {
    CellIndex previousTarget = target;
    target = newTarget;
    
    PathSegment path = new PathSegment(previousTarget, newTarget);
    paths.merge(path, Integer.valueOf(1),(currentCount, one) -> currentCount + one);
    
    currentDirection = Direction.between(newTarget, previousTarget);
  }
  
  private void updateTarget() {
    CellIndex lastTarget = target;
    
    ArrayList<CellIndex> targetCells = grid.getAdjacentCells(lastTarget);
    
    ArrayList<CellIndex> unvisitedTargetCells = (ArrayList<CellIndex>)targetCells.clone();
    unvisitedTargetCells.removeIf(cell -> grid.cells[cell.x][cell.y][cell.z].visited);
    
    if (unvisitedTargetCells.size() > 0) {
      setTarget(unvisitedTargetCells.get(int(random(unvisitedTargetCells.size()))));
      return;
    }
    
    // If there are no unvisited adjacent cells,
    // prefer maintaining the current direction.
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
  
  void move() {
    if (
      position.x == (target.x * cellSize) && 
      position.y == (target.y * cellSize) && 
      position.z == (target.z * cellSize)
     ) {
      grid.cells[target.x][target.y][target.z].visit();
      grid.unvistedCells.remove(new KdTree.XYZPoint(target.x, target.y, target.z));
      if (grid.unvistedCells.size() == 0) {
        return;
      }
      
      updateTarget();
    }
    
    PVector targetVector = new PVector(target.x * cellSize, target.y * cellSize, target.z * cellSize);
    PVector direction = PVector.sub(targetVector, position);
    direction.normalize();
    
    float distance = min(PVector.dist(targetVector, position), SPEED);
    position.add(direction.mult(distance));
  }
  
  void drawPath() {
    pushMatrix();
    // Translate to centre of cell.
    translate(cellSize / 2, cellSize / 2, cellSize / 2);
    
    colorMode(HSB);
    paths.forEach((path, count) -> {
      stroke(count * 5, 255, 255);
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
    popMatrix();
  }
  
  void draw() {
    pushMatrix();
    // Translate to centre of cell.
    translate(cellSize / 2, cellSize / 2, cellSize / 2);
    translate(position.x, position.y, position.z);
    
    fill(255, 255, 0, 255);
    noStroke();
    sphere(cellSize / 4);
    
    popMatrix();
    
    drawPath();
  }
}
