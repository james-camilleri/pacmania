import java.util.ArrayDeque;
import java.util.Deque;
import java.util.function.Predicate;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

final boolean EXTERNAL_WALLS = false;

class Grid {
  int size;
  int width;
  int height;
  int depth;
  int scale;
  Cell[][][] cells;
  KdTree unvistedCells;

  // This needs to be here because Processing actually
  // converts all this into an inner class.
  float visitedId;

  Grid(int _size, int _scale) {
    size = _size;
    scale = _scale;

    // Set these separately so we can debug in smaller subsections if necessary.
    width = size;
    height = size;
    depth = size;

    cells = new Cell[width][height][depth];
    List<KdTree.XYZPoint> cellIndices = new ArrayList<KdTree.XYZPoint>();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          cells[x][y][z] = new Cell(scale);

          if (!EXTERNAL_WALLS) {
            removeExternalWalls(cells[x][y][z], new CellIndex(x, y, z));
          }

          cellIndices.add(new KdTree.XYZPoint(x, y, z));
        }
      }
    }

    unvistedCells = new KdTree(cellIndices);

    generateMaze();
  }

  private void removeExternalWalls(Cell cell, CellIndex index) {
    if (index.x == 0) { cell.removeWall(Direction.LEFT); }
    if (index.x == width - 1) { cell.removeWall(Direction.RIGHT); }
    if (index.y == 0) { cell.removeWall(Direction.FRONT); }
    if (index.y == height - 1) { cell.removeWall(Direction.BACK); }
    if (index.z == 0) { cell.removeWall(Direction.DOWN); }
    if (index.z == depth - 1) { cell.removeWall(Direction.UP); }
  }

  private CellIndex getRandomIndex() {
    return new CellIndex(int(random(width)), int(random(height)), int(random(depth)));
  }

  // There's no easy way to do this in Java without writing our own data
  // structure, so we need to do this ugly conversion to an array every time.
  private CellIndex getRandomCellFromSet(Set<CellIndex> set) {
    CellIndex[] array = set.toArray(new CellIndex[0]);
    return array[int(random(array.length))];
  }

  private ArrayList<CellIndex> getAllAdjacentCells(CellIndex index) {
    ArrayList<CellIndex> adjacent = new ArrayList<CellIndex>();

    int x = index.x;
    int y = index.y;
    int z = index.z;

    if (index.x != 0) { adjacent.add(new CellIndex(x - 1, y, z)); }
    if (index.x != width - 1) { adjacent.add(new CellIndex(x + 1, y, z)); }
    if (index.y != 0) { adjacent.add(new CellIndex(x, y - 1, z)); }
    if (index.y != height - 1) { adjacent.add(new CellIndex(x, y + 1, z)); }
    if (index.z != 0) { adjacent.add(new CellIndex(x, y, z - 1)); }
    if (index.z != depth - 1) { adjacent.add(new CellIndex(x, y, z + 1)); }

    return adjacent;
  }

  private ArrayList<CellIndex> getAdjacentCells(CellIndex index, boolean[][][] processedForMaze, Status status) {
    ArrayList<CellIndex> adjacent = getAllAdjacentCells(index);
    Predicate<CellIndex> filter = status == status.PROCESSED
    ? cell -> !processedForMaze[cell.x][cell.y][cell.z]
    : cell -> processedForMaze[cell.x][cell.y][cell.z];

    adjacent.removeIf(filter);

    return adjacent;
  }

  // Implements Prim's algorithm for random maze generation in 3 dimensions.
  private void generateMaze() {
    boolean[][][] processedForMaze = new boolean[width][height][depth];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          processedForMaze[x][y][z] = false;
        }
      }
    }

    CellIndex start = getRandomIndex();
    processedForMaze[start.x][start.y][start.z] = true;

    Set<CellIndex> toBeProcessed = new HashSet<CellIndex>(getAllAdjacentCells(start));

    while(toBeProcessed.size() > 0) {
      CellIndex frontierCell = getRandomCellFromSet(toBeProcessed);
      toBeProcessed.remove(frontierCell);

      List<CellIndex> adjacentCells = getAdjacentCells(frontierCell, processedForMaze, Status.PROCESSED);
      CellIndex processedNeighbour = adjacentCells.get(int(random(adjacentCells.size())));

      Direction wallToRemove = Direction.between(processedNeighbour, frontierCell);
      cells[processedNeighbour.x][processedNeighbour.y][processedNeighbour.z].removeWall(wallToRemove);
      cells[frontierCell.x][frontierCell.y][frontierCell.z].removeWall(wallToRemove.opposite());

      processedForMaze[frontierCell.x][frontierCell.y][frontierCell.z] = true;
      toBeProcessed.addAll(getAdjacentCells(frontierCell, processedForMaze, Status.UNPROCESSED));
    }
  }

  ArrayList<CellIndex> getAdjacentCells(CellIndex cell) {
    ArrayList<CellIndex> adjacent = getAllAdjacentCells(cell);
    adjacent.removeIf(
      adjacentCell ->
        cells[cell.x][cell.y][cell.z]
          .walls
          .containsKey(Direction.between(cell, adjacentCell))
    );

    return adjacent;
  }

  Optional<CellIndex> getAdjacentCell(CellIndex cell, Direction direction) {
    ArrayList<CellIndex> adjacent = getAdjacentCells(cell);
    adjacent.removeIf(adjacentCell -> Direction.between(cell, adjacentCell) == direction);

    return adjacent.size() == 0 ? Optional.empty() : Optional.of(adjacent.get(0));
  }

  Deque<CellIndex> getPathBetweenCells(CellIndex start, CellIndex end) {
    Deque<CellIndex> path = new ArrayDeque<CellIndex>();
    CellIndex nextCellIndex = start;

    // Generate a new random ID to mark the cells as visited.
    float _visitedId = random(1);
    while(_visitedId == visitedId) {
      _visitedId = random(1);
    }
    visitedId = _visitedId;

    while (!nextCellIndex.equals(end)) {
      if (cells[nextCellIndex.x][nextCellIndex.y][nextCellIndex.z].searchVisitId != visitedId) {
        cells[nextCellIndex.x][nextCellIndex.y][nextCellIndex.z].searchVisitId = visitedId;
        path.addFirst(nextCellIndex);
      }

      List<CellIndex> adjacentCells = getAdjacentCells(nextCellIndex);
      adjacentCells.removeIf(
        cellIndex -> cells[cellIndex.x][cellIndex.y][cellIndex.z].searchVisitId == visitedId
      );

      if (adjacentCells.size() == 0) {
        path.removeFirst();
        nextCellIndex = path.peekFirst();

        continue;
      }

      nextCellIndex = adjacentCells.get(0);
    }

    path.addFirst(nextCellIndex);

    // Remove the starting cell from the path.
    path.removeLast();
    return path;
  }

  void debugXY() {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        var cell = cells[x][y][0];
        var fill = cell.searchVisitId == visitedId ? "X" : " ";
        print("[" + fill + "]");
      }
      println();
    }
    println();
  }

  void draw() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          pushMatrix();
          translate(x * scale, y * scale, z * scale);
          cells[x][y][z].draw();
          popMatrix();
        }
      }
    }
  }
}

enum Status {
  PROCESSED,
  UNPROCESSED
}
