class Cell {
  float size;
  boolean visited = false;
  boolean hasCoin = true;
  float coinSize = random(1, 4);
  
  Cell(float _size) {
    size = _size;
  }
  
  void visit() {
    visited = true;
    hasCoin = false;
  }
  
  void draw() {
    // Translate to centre of cell.
    translate(size / 2, size / 2, size / 2);
    
    if (!visited) {
      stroke(255, 255, 0);
      // coinSize = coinSize >= 3 ? 1 : coinSize + 0.1;
      sphere(coinSize);
    }
  }
}
