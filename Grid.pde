class Grid {
  int size;
  int width;
  int height;
  int depth;
  int scale;
  Cell[][][] cells;
  
  
  Grid(int _size, int _scale) {
    size = _size;
    scale = _scale;
    
    // Set these separately so we can debug in smaller subsections if necessary.
    width = size;
    height = size;
    depth = size;
    
    cells = new Cell[size][size][size];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          cells[x][y][z] = new Cell(scale);
        }
      }
    }
  }
  
  void draw() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          pushMatrix();
          translate(x * scale, y * scale, z * scale);
          // println(x * scale + ", " + y * scale + ", " + z * scale);
          cells[x][y][z].draw();
          popMatrix();
        }
      }
    }
  }
}
