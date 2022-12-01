import java.util.Deque;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;

final float SPEED = 5;

abstract class Agent {
  Grid grid;
  int cellSize;
  PVector position;
  CellIndex target;
  Deque<CellIndex> route;
  Direction currentDirection;
  Map<PathSegment, Integer> paths;

  boolean canVisit = false;
  boolean drawPath = false;

  Agent(Grid _grid, CellIndex start) {
    grid = _grid;
    cellSize = grid.scale;
    position = new PVector((float)start.x, (float)start.y, (float)start.z);
    target = start;
    paths = new HashMap<PathSegment, Integer>();
    grid.cells[target.x][target.y][target.z].visit();
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

    currentDirection = Direction.between(newTarget, previousTarget);
  }

  protected void updateTarget() {
    CellIndex lastTarget = target;

    ArrayList<CellIndex> targetCells = grid.getAdjacentCells(lastTarget);
    ArrayList<CellIndex> unvisitedTargetCells = (ArrayList<CellIndex>)targetCells.clone();
    unvisitedTargetCells.removeIf(cell -> grid.cells[cell.x][cell.y][cell.z].visited);

    if (unvisitedTargetCells.size() > 0) {
      setTarget(unvisitedTargetCells.get(int(random(unvisitedTargetCells.size()))));
      route = null;
      return;
    }

    // If there are no adjacent cells and we're already on a fixed route, follow that route.
    if (route != null) {
      setTarget(route.removeLast());
      if (route.size() == 0) {
        route = null;
      }

      return;
    }

    // If there's no route, create a new one to the nearest unvisted cell.
    CellIndex end = findClosestUnvistedCell(lastTarget);
    route = grid.getPathBetweenCells(lastTarget, end);
    setTarget(route.removeLast());

    // If there are no unvisited adjacent cells,
    // prefer maintaining the current direction.
    // If that's not possible, pick a direction at random.
    // if (currentDirection != null && random(1) > 0.5) {
    //   Optional<CellIndex> sameDirectionCell = grid.getAdjacentCell(lastTarget, currentDirection);

    //   if (sameDirectionCell.isPresent()) {
    //     setTarget(sameDirectionCell.get());
    //     return;
    //   }
    // }

    // setTarget(targetCells.get(int(random(targetCells.size()))));
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

      if (grid.unvistedCells.size() == 0) {
        return;
      }

      updateTarget();
    }

    PVector targetVector = new PVector(target.x * cellSize, target.y * cellSize, target.z * cellSize);
    PVector direction = PVector.sub(targetVector, position);
    direction.normalize();

    float distance = min(PVector.dist(targetVector, position), SPEED);
    position.add(direction.mult(distance));
  }

  void drawPath() {
    pushMatrix();
    // Translate to centre of cell.
    translate(cellSize / 2, cellSize / 2, cellSize / 2);

    colorMode(HSB);
    paths.forEach((path, count) -> {
      stroke(count * 10, 255, 255);
      strokeWeight(3);
      line(
        path.start.x * cellSize,
        path.start.y * cellSize,
        path.start.z * cellSize,
        path.end.x * cellSize,
        path.end.y * cellSize,
        path.end.z * cellSize
      );
      strokeWeight(1);
    });
    colorMode(RGB);

    popMatrix();
  }

  protected void drawAgent() {
    throw new RuntimeException("`drawAgent` must be overridden by a base class.");
  }

  void draw() {
    // Translate to centre of cell.
    pushMatrix();
    translate(cellSize / 2, cellSize / 2, cellSize / 2);
    translate(position.x, position.y, position.z);
    drawAgent();
    popMatrix();

    if (drawPath) {
      drawPath();
    }
  }
}
