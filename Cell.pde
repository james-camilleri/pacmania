import java.util.Map;
import java.util.HashMap;

class Cell {
  float size;
  Map<Wall, float[]> walls;
  boolean visited = false;
  boolean hasCoin = true;
  // float coinSize = random(1, 4);
  float coinSize = 3;
  
  Cell(float _size) {
    size = _size;
    walls = generateWalls();
  }
  
  private Map<Wall, float[]> generateWalls() {
    Map<Wall, float[]> walls = new HashMap<Wall, float[]>(6, 0.1);
    
    // Walls are all the same size, and offset,
    // all we need to store is the rotations (x, y)
    // for looping through when drawing.
    // The "default" wall is in the "down" position.
    walls.put(Wall.RIGHT, new float[]{ 0, radians( -90) });
    walls.put(Wall.FRONT, new float[]{ radians(90), 0 });
    walls.put(Wall.BACK, new float[]{ radians( -90), 0 });
    walls.put(Wall.LEFT, new float[]{ 0, radians(90) });
    walls.put(Wall.UP, new float[]{ radians(180), 0 });
    walls.put(Wall.DOWN, new float[]{ 0, 0 });
    
    return walls;
  }
  
  void removeWall(Wall wall) {
    walls.remove(wall);
  }
  
  void visit() {
    visited = true;
    hasCoin = false;
  }
  
  void draw() {
    // Not sure if we need this, but there are occlusion errors without it.
    hint(DISABLE_DEPTH_TEST);
    
    // Translate to centre of cell.
    translate(size / 2, size / 2, size / 2);
    
    drawWalls();
    
    if (!visited) {
      noStroke();
      fill(255, 0, 0, 255);
      
      // coinSize = coinSize >= 3 ? 1 : coinSize + 0.1;
      sphere(coinSize);
    }
  }
  
  void drawWalls() {
    walls.values().forEach(wall -> {
      stroke(255, 127, 0, 100);
      fill(255, 255, 255, 10);
      
      pushMatrix();
      rotateX(wall[0]);
      rotateY(wall[1]);
      translate(0, 0, size / - 2);
      box(size, size, 1);
      popMatrix();
    });
  }
}
