import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.function.Predicate;

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

    cells = new Cell[width][height][depth];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          cells[x][y][z] = new Cell(scale);
        }
      }
    }

    generateMazeData();
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
  private void generateMazeData() {
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

      Wall wallToRemove = Wall.between(processedNeighbour, frontierCell);
      cells[processedNeighbour.x][processedNeighbour.y][processedNeighbour.z].removeWall(wallToRemove);
      cells[frontierCell.x][frontierCell.y][frontierCell.z].removeWall(wallToRemove.opposite());

      processedForMaze[frontierCell.x][frontierCell.y][frontierCell.z] = true;
      toBeProcessed.addAll(getAdjacentCells(frontierCell, processedForMaze, Status.UNPROCESSED));
    }
  }

  // TODO: We're getting empty arrays from this occasionally, which shouldn't happen.
  ArrayList<CellIndex> getAdjacentCells(CellIndex cell) {
    ArrayList<CellIndex> adjacent = getAllAdjacentCells(cell);
    adjacent.removeIf(
      adjacentCell -> cells[adjacentCell.x][adjacentCell.y][adjacentCell.z]
        .walls
        .containsKey(Wall.between(cell, adjacentCell))
    );

    return adjacent;
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

enum Status {
  PROCESSED,
  UNPROCESSED
}
