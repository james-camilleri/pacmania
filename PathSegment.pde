import java.util.Arrays;

class PathSegment {
  CellIndex start;
  CellIndex end;

  PathSegment(CellIndex _start, CellIndex _end) {
    start = _start;
    end = _end;
  }

  public String toString() {
    String[] points = { start.toString(), end.toString() };
    Arrays.sort(points);
    return points[0].toString() + points[1].toString();
  }

  @Override
  public boolean equals(Object path) {
    return (
      (
        (PathSegment)path).start.toString().equals(start.toString()) &&
        ((PathSegment)path).end.toString().equals(end.toString())
      ) || (
        ((PathSegment)path).end.toString().equals(start.toString()) &&
        ((PathSegment)path).start.toString().equals(end.toString())
      );
  }

  @Override
  public int hashCode() {
    return this.toString().hashCode();
  }
}
