public enum Wall {
  FRONT,
  RIGHT,
  BACK,
  LEFT,
  UP,
  DOWN;
  
  public Wall opposite() {
    switch(this) {
      case FRONT : return BACK;
        case RIGHT : return LEFT;
        case BACK : return FRONT;
        case LEFT : return RIGHT;
        case UP : return DOWN;
        case DOWN : return UP;
        
        // This should never happen.
        default : return FRONT;
    }
  }
  
  public static Wall between(CellIndex cellA, CellIndex cellB) {
    if (cellA.x == cellB.x + 1) return LEFT;
    if (cellA.x == cellB.x - 1) return RIGHT;
    if (cellA.y == cellB.y + 1) return BACK;
    if (cellA.y == cellB.y - 1) return FRONT;
    if (cellA.z == cellB.z + 1) return DOWN;
    if (cellA.z == cellB.z - 1) return UP;
    
    throw new RuntimeException("Cell is not adjacent.");
  }
}
