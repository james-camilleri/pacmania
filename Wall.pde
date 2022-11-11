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
}
