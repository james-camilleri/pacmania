import java.util.Map;
import java.util.HashMap;

class Cell {
  float size;
  Map<Direction, float[]> walls;
  boolean visited = false;
  boolean hasCoin = true;
  // float coinSize = random(1, 4);
  float coinSize = 3;
  int opacity = 0;
  
  // We need to mark cells as visited for our Depth-First Search. In order to
  // avoid cloning the entire grid and/or resetting an additional flag on each
  // one (Java objects are linked by reference so we'll always have reference
  // to the same cell), pick a random number and use that to mark the visited
  // status of the current search.
  float searchVisitId = 0;
  
  Cell(float _size) {
    size = _size;
    walls = generateWalls();
  }
  
  private Map<Direction, float[]> generateWalls() {
    Map<Direction, float[]> walls = new HashMap<Direction, float[]>(6, 0.1);
    
    // Walls are all the same size, and offset,
    // all we need to store is the rotations (x, y)
    // for looping through when drawing.
    // The "default" wall is in the "down" position.
    walls.put(Direction.RIGHT, new float[]{ 0, radians( -90) });
    walls.put(Direction.FRONT, new float[]{ radians( -90), 0 });
    walls.put(Direction.BACK, new float[]{ radians(90), 0 });
    walls.put(Direction.LEFT, new float[]{ 0, radians(90) });
    walls.put(Direction.UP, new float[]{ radians(180), 0 });
    walls.put(Direction.DOWN, new float[]{ 0, 0 });
    
    return walls;
  }
  
  void removeWall(Direction wall) {
    walls.remove(wall);
  }
  
  void visit() {
    visited = true;
    hasCoin = false;
    opacity += 5;
  }
  
  void draw() {
    // Not sure if we need this, but there are occlusion errors without it.
    hint(DISABLE_DEPTH_TEST);
    
    // Translate to centre of cell.
    translate(size / 2, size / 2, size / 2);
    
    drawWalls();
    drawFill();
    
    if (!visited) {
      noStroke();
      fill(255, 0, 0, 255);
      
      // coinSize = coinSize >= 3 ? 1 : coinSize + 0.1;
      sphere(coinSize);
    }
  }
  
  void drawWalls() {
    walls.values().forEach(wall -> {
      stroke(255, 127, 0, 10);
      // noStroke();
      fill(255, 255, 255, 5);
      
      pushMatrix();
      rotateX(wall[0]);
      rotateY(wall[1]);
      translate(0, 0, size / - 2);
      box(size, size, 1);
      popMatrix();
    });
  }
  
  void drawFill() {
    // fill(255, 127, 0, opacity);
    noFill();
    noStroke();
    box(size, size, size);
  }
}
