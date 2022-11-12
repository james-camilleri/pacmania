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
  
  @Override
  public boolean equals(Object cell) {
    return((CellIndex)cell).x == x && ((CellIndex)cell).y == y && ((CellIndex)cell).z == z;
  }
  
  @Override
  public int hashCode() {
    return this.toString().hashCode();
  }
}
