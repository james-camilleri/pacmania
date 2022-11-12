final float SPEED = 5;

class Pacman {
  Grid grid;
  int cellSize;
  PVector position;
  CellIndex target;
  
  Pacman(Grid _grid, CellIndex start) {
    grid = _grid;
    cellSize = grid.scale;
    position = new PVector((float) start.x,(float) start.y,(float) start.z);
    target = start;
    grid.cells[target.x][target.y][target.z].visit();
  }
  
  private void updateTarget() {
    ArrayList<CellIndex> accessibleCells = grid.getAdjacentCells(target);
    target = accessibleCells.get(int(random(accessibleCells.size())));
  }
  
  void move() {
    if (
      position.x == (target.x * cellSize) && 
      position.y == (target.y * cellSize) && 
      position.z == (target.z * cellSize)
     ){
      updateTarget();
      grid.cells[target.x][target.y][target.z].visit();
    }
    
    PVector targetVector = new PVector(target.x * cellSize, target.y * cellSize, target.z * cellSize);
    PVector direction = PVector.sub(targetVector, position);
    direction.normalize();
    
    float distance = min(PVector.dist(targetVector, position), SPEED);
    position.add(direction.mult(distance));
  }
  
  void draw() {
    pushMatrix();
    // Translate to centre of cell.
    translate(cellSize / 2, cellSize / 2, cellSize / 2);
    translate(position.x, position.y, position.z);
    
    fill(255, 255, 0, 255);
    sphere(cellSize / 4);
    
    popMatrix();
  }
}
