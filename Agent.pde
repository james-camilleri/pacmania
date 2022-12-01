import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

abstract class Agent {
  Grid grid;
  int cellSize;
  PVector position;
  CellIndex target;
  float speed;
  Deque<CellIndex> route;
  Direction currentDirection;
  Map<PathSegment, Integer> paths;

  boolean canVisit = false;
  boolean drawPath = false;

  Agent(Grid _grid, CellIndex start) {
    grid = _grid;
    cellSize = grid.scale;
    position = new PVector(start.x * cellSize, start.y * cellSize, start.z * cellSize);
    target = start;
    speed = 5;
    paths = new HashMap<PathSegment, Integer>();

    if (canVisit) {
      grid.cells[target.x][target.y][target.z].visit();
    }
  }

  protected CellIndex findClosestUnvistedCell(CellIndex currentPosition) {
    Collection<KdTree.XYZPoint> closestUnvisted = grid
      .unvistedCells
      .nearestNeighbourSearch(1, new KdTree.XYZPoint(
        currentPosition.x,
        currentPosition.y,
        currentPosition.z
      ));

    KdTree.XYZPoint point = closestUnvisted.toArray(new KdTree.XYZPoint[1])[int(random(0, closestUnvisted.size()))];
    return new CellIndex((int)point.x, (int)point.y, (int)point.z);
  }

  protected void setTarget(CellIndex newTarget) {
    CellIndex previousTarget = target;
    target = newTarget;

    PathSegment path = new PathSegment(previousTarget, newTarget);
    paths.merge(path, Integer.valueOf(1),(currentCount, one) -> currentCount + one);

    currentDirection = previousTarget.equals(newTarget)
      ? currentDirection
      : Direction.between(newTarget, previousTarget);
  }

  protected void updateTarget() {
    throw new RuntimeException("`updateTarget` must be overridden by a base class.");
  }

  protected void updateVisitedCellColour() {
    throw new RuntimeException("`updateVisitedCellColour` must be overridden by a base class.");
  }

  void move() {
    if (
      position.x == (target.x * cellSize) &&
      position.y == (target.y * cellSize) &&
      position.z == (target.z * cellSize)
     ){
      if (canVisit) {
        grid.cells[target.x][target.y][target.z].visit();
        grid.unvistedCells.remove(new KdTree.XYZPoint(target.x, target.y, target.z));
      }

      updateVisitedCellColour();

      if (grid.unvistedCells.size() == 0) {
        return;
      }

      updateTarget();
    }

    PVector targetVector = new PVector(target.x * cellSize, target.y * cellSize, target.z * cellSize);
    PVector direction = PVector.sub(targetVector, position);
    direction.normalize();

    float distance = min(PVector.dist(targetVector, position), speed);
    position.add(direction.mult(distance));
  }

  protected void drawAgent() {
    throw new RuntimeException("`drawAgent` must be overridden by a base class.");
  }

  protected void drawPath() {
    throw new RuntimeException("`drawPath` must be overridden by a base class.");
  }

  void draw() {
    pushMatrix();
    // Translate to centre of cell.
    translate(cellSize / 2, cellSize / 2, cellSize / 2);

    pushMatrix();
    translate(position.x, position.y, position.z);
    drawAgent();
    popMatrix();

    if (drawPath) {
      drawPath();
    }

    popMatrix();
  }
}
