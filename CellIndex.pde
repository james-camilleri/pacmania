class CellIndex {
  int x;
  int y;
  int z;
  
  CellIndex(int _x, int _y, int _z) {
    x = _x;
    y = _y;
    z = _z;
  }
  
  public String toString() {
    return "[" + x + ", " + y + ", " + z + "]";
  }
}
